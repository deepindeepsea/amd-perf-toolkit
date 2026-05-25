#!/bin/bash
# ccd_isolation_test.sh - Test CCD isolation: server on CCD0, client on CCD1
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"

echo "=== CCD Isolation Test $(date) ==="
echo "Server: CCD 0 (cores 0-7)"
echo "Client: CCD 1 (cores 8-15)"
echo "Goal: Eliminate CPU/cache competition"

timeout 300s ssh -i "$KEY" -o StrictHostKeyChecking=no \
    -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
    ubuntu@$INSTANCE 'bash -s' << 'EOF'

cd bench_app
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo "=== CCD Isolation Performance Test ==="

# Clean slate
pkill -f puma 2>/dev/null || true
pkill -f wrk 2>/dev/null || true
sleep 2

# Optimization environment
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export WEB_CONCURRENCY=8

echo "Environment: YJIT=$RUBY_YJIT_ENABLE, jemalloc=$(echo $LD_PRELOAD | grep jemalloc >/dev/null && echo 'YES' || echo 'NO')"

echo ""
echo "=== PHASE 1: Current Setup (No Isolation) ==="
echo "Running server and client on same cores (baseline)"

# Baseline: no isolation
bundle exec puma -e production -b tcp://0.0.0.0:3000 --preload &
SERVER_PID=$!
sleep 3

cd ~/wrk
echo "Baseline test: 16 threads, 400 connections, 20 seconds"
./wrk -t 16 -c 400 -d 20s http://localhost:3000/ > /tmp/baseline_test.log 2>&1

echo "Baseline results:"
grep -E "(Running|Latency|Requests/sec)" /tmp/baseline_test.log

# Stop server
kill $SERVER_PID 2>/dev/null || true
sleep 2

echo ""
echo "=== PHASE 2: CCD Isolation ==="
echo "Server: CCD 0 (cores 0-7), Client: CCD 1 (cores 8-15)"

cd ~/bench_app

# Start server on CCD 0
echo "Starting Rails server on CCD 0 (cores 0-7)..."
taskset -c 0-7 bundle exec puma -e production -b tcp://0.0.0.0:3000 --preload &
SERVER_PID=$!
echo "Server PID: $SERVER_PID"
sleep 3

# Verify server is responding
curl -s http://localhost:3000/ >/dev/null && echo "✓ Server responding" || echo "✗ Server failed"

cd ~/wrk

# Test 1: Same load, but isolated
echo ""
echo "Test 1: Same load (16t, 400c) but with CCD isolation"
taskset -c 8-15 ./wrk -t 16 -c 400 -d 20s http://localhost:3000/ > /tmp/isolated_test1.log 2>&1

echo "Isolated test 1 results:"
grep -E "(Running|Latency|Requests/sec)" /tmp/isolated_test1.log

sleep 2

# Test 2: Higher client load (now that we have dedicated CCD)
echo ""
echo "Test 2: Higher load (24t, 800c) with CCD isolation"
taskset -c 8-15 ./wrk -t 24 -c 800 -d 30s http://localhost:3000/ > /tmp/isolated_test2.log 2>&1

echo "Isolated test 2 results:"
grep -E "(Running|Latency|Requests/sec)" /tmp/isolated_test2.log

sleep 2

# Test 3: Maximum client pressure on dedicated CCD
echo ""
echo "Test 3: Maximum load (32t, 1200c) with CCD isolation"
taskset -c 8-15 ./wrk -t 32 -c 1200 -d 30s http://localhost:3000/ > /tmp/isolated_test3.log 2>&1

echo "Isolated test 3 results:"
grep -E "(Running|Latency|Requests/sec)" /tmp/isolated_test3.log

echo ""
echo "=== ANALYSIS ==="

echo "CPU affinity verification:"
for pid in $(pgrep puma 2>/dev/null); do
    echo "Puma PID $pid: $(taskset -p $pid 2>/dev/null | awk '{print $6}' || echo 'unknown')"
done

echo ""
echo "Performance comparison:"
echo "BASELINE (no isolation):"
grep "Requests/sec" /tmp/baseline_test.log | head -1

echo "ISOLATED Test 1 (16t, 400c):"
grep "Requests/sec" /tmp/isolated_test1.log | head -1

echo "ISOLATED Test 2 (24t, 800c):"
grep "Requests/sec" /tmp/isolated_test2.log | head -1

echo "ISOLATED Test 3 (32t, 1200c):"
grep "Requests/sec" /tmp/isolated_test3.log | head -1

echo ""
echo "Latency comparison:"
echo "BASELINE p99:"
grep "99%" /tmp/baseline_test.log | head -1

echo "ISOLATED Test 3 p99:"
grep "99%" /tmp/isolated_test3.log | head -1

# Clean up
kill $SERVER_PID 2>/dev/null || true
echo ""
echo "CCD isolation test completed"

EOF