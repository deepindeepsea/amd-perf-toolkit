#!/bin/bash
# genoa_style_load_test.sh - Match Genoa-X load test methodology
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"

echo "=== Genoa-X Style Load Test (High Traffic) $(date) ==="

timeout 300s ssh -i "$KEY" -o StrictHostKeyChecking=no \
    -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
    ubuntu@$INSTANCE 'bash -s' << 'EOF'

cd bench_app
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo "=== High Traffic Test - Genoa-X Methodology ==="

# Kill existing
pkill -f puma 2>/dev/null || true
pkill -f wrk 2>/dev/null || true
sleep 2

# Full optimization stack (proven recipe)
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export WEB_CONCURRENCY=8

echo "Environment verified:"
echo "  YJIT: $RUBY_YJIT_ENABLE"
echo "  jemalloc: $(echo $LD_PRELOAD | grep jemalloc >/dev/null && echo 'LOADED' || echo 'MISSING')"

# Start server on CCD 0 (cores 0-7)
echo "Starting Puma server on CCD 0 (cores 0-7)..."
taskset -c 0-7 bundle exec puma -e production -b tcp://0.0.0.0:3000 --preload &
SERVER_PID=$!
echo "Server PID: $SERVER_PID"

sleep 4
curl -s http://localhost:3000/ >/dev/null && echo "✓ Server responding" || echo "✗ Server not responding"

echo ""
echo "=== CLIENT-SIDE SCALING TEST ==="
echo "Testing wrk client limitations (Genoa-X found wrk on 1 CCD = bottleneck)"

cd ~/wrk

# Test 1: Light load (baseline)
echo ""
echo "Test 1: Light load (8 threads, 100 connections)"
./wrk -t 8 -c 100 -d 15s http://localhost:3000/ 2>&1 | grep -E "(Running|Latency|Requests/sec)" | head -3

sleep 2

# Test 2: Heavy client load (simulate 2 CCDs worth of client threads)
echo ""
echo "Test 2: Heavy client load (32 threads, 1000 connections)"
echo "         (Simulating 2 CCDs of client traffic - Genoa-X recommendation)"
./wrk -t 32 -c 1000 -d 30s http://localhost:3000/ > /tmp/heavy_test.log 2>&1 &
HEAVY_PID=$!

# Monitor during heavy test
echo "CPU monitoring during heavy test:"
for i in {1..6}; do
    sleep 5
    CPU_INFO=$(top -bn1 | grep "Cpu(s)" | head -1)
    echo "  $((i*5))s: $CPU_INFO"
done

wait $HEAVY_PID 2>/dev/null || true

echo ""
echo "=== HEAVY TEST RESULTS ==="
grep -E "(Running|Latency|Requests/sec|Transfer/sec)" /tmp/heavy_test.log

echo ""
echo "=== CLIENT CPU USAGE ==="
echo "Did we saturate the client? Check if we can push more traffic..."

# Test 3: Maximum client pressure
echo ""
echo "Test 3: Maximum client pressure (48 threads, 2000 connections)"
echo "         (Maximum client load to find server limits)"
./wrk -t 48 -c 2000 -d 20s http://localhost:3000/ > /tmp/max_test.log 2>&1 &
MAX_PID=$!

sleep 10
echo "Peak CPU during maximum load:"
top -bn1 | grep "Cpu(s)" | head -1

wait $MAX_PID 2>/dev/null || true

echo "=== MAXIMUM LOAD RESULTS ==="
grep -E "(Running|Latency|Requests/sec|Transfer/sec)" /tmp/max_test.log

echo ""
echo "=== FINAL ANALYSIS ==="
echo "Server process info:"
ps aux | grep puma | grep -v grep

echo ""
echo "CPU affinity check:"
for pid in $(pgrep puma 2>/dev/null); do
    echo "PID $pid CPU mask: $(taskset -p $pid 2>/dev/null | awk '{print $6}' || echo 'unknown')"
done

# Clean up
pkill -f puma 2>/dev/null || true
echo "Test completed - server stopped"

EOF