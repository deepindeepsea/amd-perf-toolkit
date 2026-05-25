# Rails Puma Benchmark — Reproducibility Guide

Replays the M8A.metal-24xl Rails benchmark on any AMD EC2 shape.
Validated on m8a.metal-24xl (us-west-2, Ubuntu 24.04.4, kernel 6.17). Designed
to also run unchanged on **m8a.2xlarge** and **c8a.2xlarge** (1-CCD shapes).

## 0. Provision

```
Instance:   m8a.2xlarge or c8a.2xlarge   (8 vCPUs, Zen5 Turin)
AMI:        Ubuntu 24.04 LTS (server x86_64) — ami-016d360a89daa11ba in us-west-2
Storage:    32 GiB gp3 (Rails app + bundle cache + logs fit easily)
Security:   port 22 inbound from your IP (or use SSM)
Key:        existing ruby_pradeepn.pem
```

## 1. One-shot setup (run on the fresh instance)

```bash
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libreadline-dev zlib1g-dev \
    libsqlite3-dev libffi-dev libyaml-dev libjemalloc2 git curl autoconf bison \
    unzip   # unzip is REQUIRED for wrk's LuaJIT-2.1 build — without it `make` fails

# rbenv + Ruby 3.3.11
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"' >> ~/.bashrc
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$(~/.rbenv/bin/rbenv init - bash)"
rbenv install 3.3.11
rbenv global 3.3.11
gem install bundler -v 4.0.12
gem install rails -v 8.1.3

# wrk
git clone https://github.com/wg/wrk.git ~/wrk
cd ~/wrk && make -j$(nproc) && cd ~

# Rails "Hello World" benchmark app
cd ~
rails new bench_app --skip-test --skip-system-test
cd bench_app
# Replace routes + add HomeController
cat > config/routes.rb << 'EOF'
Rails.application.routes.draw do
  get "/", to: "home#index"
end
EOF
cat > app/controllers/home_controller.rb << 'EOF'
class HomeController < ApplicationController
  def index
    render plain: "Hello World!"
  end
end
EOF
bundle install
RAILS_ENV=production bundle exec rails db:prepare
bundle exec rails assets:precompile RAILS_ENV=production
```

## 2. Sanity check

```bash
cd ~/bench_app
export SECRET_KEY_BASE=$(bundle exec rails secret)
RAILS_ENV=production bundle exec puma -p 3000 -w 1 -t 1 &
sleep 5
curl http://127.0.0.1:3000/        # expect: Hello World!
pkill -9 -f puma
```

## 3. Test script — 2xl shape (8 vCPUs, whole VM)

Save as `~/run_bench_2xl.sh`:

```bash
#!/bin/bash -l
LOG=/tmp/bench_2xl_$(hostname).log
exec > "$LOG" 2>&1
export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init - bash 2>/dev/null)" || true

echo ">>> START $(date)"
echo "=== instance ==="; curl -s http://169.254.169.254/latest/meta-data/instance-type; echo
echo "=== cpu ==="; lscpu | grep -E 'Model name|Socket|Core|Thread|CPU\(s\)'
cd ~/bench_app || exit 1
pkill -9 -f puma 2>/dev/null; pkill -9 -f wrk 2>/dev/null; sleep 2

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RUBY_YJIT_ENABLE=1
export WEB_CONCURRENCY=7        # 7 workers, leave 1 vCPU for wrk
export RAILS_MAX_THREADS=1
export RAILS_ENV=production
export SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || openssl rand -hex 32)
echo "ruby: $(ruby -v)"; echo "bundle: $(bundle -v)"

# 2xl: no taskset needed — pin Puma to cores 0-6, wrk to core 7
taskset -c 0-6 bundle exec puma -e production -p 3000 -w 7 -t 1 --preload &
PUMA_PID=$!

for i in $(seq 1 60); do
  curl -sf http://127.0.0.1:3000/ > /dev/null 2>&1 && { echo "Puma ready after ${i}s"; break; }
  sleep 1
done

# warmup
taskset -c 7 ~/wrk/wrk -t1 -c50 -d5s http://127.0.0.1:3000/ > /dev/null 2>&1

for C in 50 100 200 400; do
  echo "=== wrk -t1 -c$C -d30s ==="
  taskset -c 7 ~/wrk/wrk -t1 -c$C -d30s --latency http://127.0.0.1:3000/
done

kill -9 $PUMA_PID 2>/dev/null; pkill -9 -f puma 2>/dev/null
echo ">>> DONE $(date)"
```

Then:

```bash
chmod +x ~/run_bench_2xl.sh
nohup setsid ~/run_bench_2xl.sh < /dev/null > /tmp/bench.out 2>&1 &
disown
# results: /tmp/bench_2xl_<hostname>.log
```

Total runtime ≈ 2.5 min (5 s warmup + 4 × 30 s steps).

## 4. Expected numbers (from m8a.metal-24xl 1-CCD slice — May 24, 2026)

| Concurrency | RPS | p99 |
|---|---|---|
| c=50 | 23,522 | 3.86 ms |
| c=100 | 22,992 | 7.16 ms |
| c=200 | 22,404 | 13.23 ms |
| c=400 | 22,313 | 29.49 ms |

m8a.2xlarge: expected to match within ±5% (same Zen5 silicon, same 1-CCD slice).
c8a.2xlarge: expected slightly higher peak frequency (compute-optimized binning,
higher all-core boost ceiling, but same uarch) → estimate +5–10% RPS, with the
same p99 shape. **Measurement will confirm.**

## 5. What to compare across runs

Always pull and tabulate:

```bash
grep -E '===|Requests/sec|99%|Latency Distribution|>>> ' /tmp/bench_2xl_*.log
```

Then add a row to `m8a_stripe_customer_brief.html` under the
*"m8a.2xlarge-equivalent shape"* section with the real measured numbers.

## Pitfalls observed during the original run

- **CRLF line endings** from Windows-side editing break bash. Always `dos2unix` or
  write the script directly on the instance (heredoc-from-ssh).
- **bash login shell needed** (`#!/bin/bash -l`) so rbenv shims load — otherwise
  `bundle: not found` under non-interactive SSH.
- **SO_REUSEPORT does not help on localhost** (4-tuple hash collapses).
  Use a single Puma cluster with `WEB_CONCURRENCY` instead.
- **tmux detaches under SSH-over-SSM** if backgrounded incorrectly.
  Use `nohup setsid ... < /dev/null > /tmp/out 2>&1 & disown`.
- **`unzip` is not in default Ubuntu 24.04 server AMI.** The wrk Makefile needs
  it to unpack LuaJIT-2.1 — without unzip you get
  `make: unzip: No such file or directory` and no `wrk` binary is produced, so
  the bench script then fails with `taskset: failed to execute .../wrk`. Always
  apt-install `unzip` before `cd ~/wrk && make`.
- **Puma 8 dropped the `-d` (daemonize) flag.** The sanity-check command must
  background with shell `&`, not `puma -d`. The real bench script already does
  this correctly; only the optional one-liner sanity check needs the change.
