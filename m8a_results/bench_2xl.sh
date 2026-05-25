#!/bin/bash -l
###############################################################################
# Rails Puma Hello World bench — 2xlarge geometry (8 vCPU, 7 Puma + 1 wrk)
#
# Pre-req: setup_rails_bench.sh has been run (creates ~/bench_app and ~/wrk).
#
# Pins:
#   - Puma cluster (7 workers, 1 thread each) → cores 0-6 via taskset
#   - wrk client → core 7 via taskset
#   - LD_PRELOAD jemalloc, MALLOC_ARENA_MAX=2, YJIT enabled
#
# Output: /tmp/bench_2xl_<hostname>.log
# Runtime: ~2.5 min (5s warmup + 4 x 30s steps at c=50,100,200,400)
###############################################################################

set -uo pipefail
LOG=/tmp/bench_2xl_$(hostname).log
exec > >(tee -a "$LOG") 2>&1

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init - bash 2>/dev/null)" || true

echo ">>> START $(date)"
echo "=== instance ==="
TOKEN=$(curl -sX PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 60' 2>/dev/null || echo "")
if [ -n "$TOKEN" ]; then
  curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null
  echo
fi
echo "=== cpu ==="; lscpu | grep -E 'Model name|Socket|Core|Thread|^CPU\(s\)'

cd "$HOME/bench_app" || { echo "FATAL: ~/bench_app missing — run setup first"; exit 1; }
pkill -9 -f puma 2>/dev/null; pkill -9 -f wrk 2>/dev/null; sleep 2

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RUBY_YJIT_ENABLE=1
export WEB_CONCURRENCY=7
export RAILS_MAX_THREADS=1
export RAILS_ENV=production
export SECRET_KEY_BASE
SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || openssl rand -hex 32)
echo "ruby: $(ruby -v)"; echo "bundle: $(bundle -v)"

taskset -c 0-6 bundle exec puma -e production -p 3000 -w 7 -t 1 --preload &
PUMA_PID=$!

for i in $(seq 1 60); do
  curl -sf http://127.0.0.1:3000/ > /dev/null 2>&1 && { echo "Puma ready after ${i}s"; break; }
  sleep 1
done

# warmup
taskset -c 7 "$HOME/wrk/wrk" -t1 -c50 -d5s http://127.0.0.1:3000/ > /dev/null 2>&1

for C in 50 100 200 400; do
  echo "=== wrk -t1 -c$C -d30s ==="
  taskset -c 7 "$HOME/wrk/wrk" -t1 -c$C -d30s --latency http://127.0.0.1:3000/
done

kill -9 $PUMA_PID 2>/dev/null; pkill -9 -f puma 2>/dev/null
echo ">>> DONE $(date)"
