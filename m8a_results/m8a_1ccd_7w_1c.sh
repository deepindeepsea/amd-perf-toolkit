#!/bin/bash -l
# Single-CCD test on M8A: 7 Puma workers on cores 0-6, wrk on core 7
# Emulates an 8-vCPU instance shape (~m8a.2xlarge equivalent)
# Uses login shell so rbenv shims (bundle, ruby) are on PATH
LOG=/tmp/m8a_1ccd_7w_1c.log
exec > >(tee -a $LOG) 2>&1

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init - bash 2>/dev/null)" || true

echo ">>> START $(date)"
cd ~/bench_app || exit 1

pkill -9 -f puma 2>/dev/null
pkill -9 -f wrk 2>/dev/null
sleep 2

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RUBY_YJIT_ENABLE=1
export WEB_CONCURRENCY=7
export RAILS_MAX_THREADS=1
export RAILS_ENV=production
export SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || openssl rand -hex 32)

echo "ruby: $(ruby -v)"
echo "bundle: $(bundle -v)"
echo "Starting Puma: 7 workers on cores 0-6 (CCD0), wrk reserved core 7"

taskset -c 0-6 bundle exec puma -e production -p 3000 -w 7 -t 1 --preload &
PUMA_PID=$!

echo "Waiting for Puma..."
for i in $(seq 1 30); do
  if curl -sf http://127.0.0.1:3000/health > /dev/null 2>&1 \
     || curl -sf http://127.0.0.1:3000/ > /dev/null 2>&1; then
    echo "Puma ready after ${i}s"; break
  fi
  sleep 1
done

curl -s http://127.0.0.1:3000/ -o /tmp/sample.html
echo "Sample response length: $(wc -c </tmp/sample.html) bytes"

echo "--- warmup ---"
taskset -c 7 ~/wrk/wrk -t1 -c50 -d5s http://127.0.0.1:3000/ > /dev/null 2>&1

for C in 50 100 200 400; do
  echo ""
  echo "=== wrk -t1 -c$C -d30s (core 7, server on CCD0 cores 0-6) ==="
  taskset -c 7 ~/wrk/wrk -t1 -c$C -d30s --latency http://127.0.0.1:3000/
done

kill -9 $PUMA_PID 2>/dev/null
pkill -9 -f puma 2>/dev/null
echo ">>> DONE $(date)"
