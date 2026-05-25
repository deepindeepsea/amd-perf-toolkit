#!/bin/bash
# aggressive_load_test.sh - High traffic load test for M8A
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"

echo "=== Aggressive Load Test $(date) ==="

timeout 240s ssh -i "$KEY" -o StrictHostKeyChecking=no \
    -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
    ubuntu@$INSTANCE 'bash -s' << 'EOF'

cd bench_app
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo "=== High Traffic Load Test ==="

# Kill existing
pkill -f puma 2>/dev/null || true
pkill -f wrk 2>/dev/null || true

# Full optimization stack
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export WEB_CONCURRENCY=8

echo "Starting optimized Puma cluster on CCD 0..."
taskset -c 0-7 bundle exec puma -e production -b tcp://0.0.0.0:3000 --preload &
sleep 3

# Test basic response
curl -s http://localhost:3000/ | head -1

echo "Running AGGRESSIVE load test:"
echo "  - 16 threads (2x normal)"
echo "  - 800 connections (4x normal)"
echo "  - 60 seconds duration"

cd ~/wrk

# High traffic test
./wrk -t 16 -c 800 -d 60s --latency http://localhost:3000/ > /tmp/aggressive_test.log 2>&1 &
WRK_PID=$!

echo "Test running... monitoring CPU:"
for i in {1..12}; do
    sleep 5
    echo -n "$((i*5))s: "
    top -bn1 | grep "Cpu(s)" | awk '{print $2, $4, $6, $8}' | head -1
done

wait $WRK_PID 2>/dev/null || true

echo "=== RESULTS ==="
grep -E "(Running|Latency|Req/Sec|Requests/sec|Transfer/sec)" /tmp/aggressive_test.log

echo "Final CPU state:"
top -bn1 | grep "Cpu(s)" | head -1

# Process info
echo "Puma worker info:"
ps aux | grep puma | grep -v grep | head -5

pkill -f puma 2>/dev/null || true

EOF