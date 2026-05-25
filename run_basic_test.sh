#!/bin/bash
# run_basic_test.sh - Basic CPU utilization test for M8A Rails optimization
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"
AWS_PROFILE="m8a"

echo "=== M8A Basic CPU Utilization Test $(date) ==="

# Function to run test on remote
run_basic_test() {
    timeout 180s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE 'bash -s' << 'EOF'

cd bench_app
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

echo "=== Basic Performance Test ==="

# Kill existing processes
pkill -f puma 2>/dev/null || echo "No puma to kill"
pkill -f wrk 2>/dev/null || echo "No wrk to kill"

# Set optimization environment (Genoa-X recipe)
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export WEB_CONCURRENCY=8

echo "Environment:"
echo "  YJIT enabled: $RUBY_YJIT_ENABLE"
echo "  jemalloc loaded: $(echo $LD_PRELOAD | grep jemalloc && echo 'YES' || echo 'NO')"
echo "  Arena max: $MALLOC_ARENA_MAX"

# Start Rails with CCD pinning
echo "Starting Puma on CCD 0 (cores 0-7)..."
taskset -c 0-7 bundle exec puma -e production -b tcp://0.0.0.0:3000 --preload &
PUMA_PID=$!
echo "Puma started with PID: $PUMA_PID"

sleep 5

# Test connectivity
echo "Testing Rails response:"
RESPONSE=$(curl -s -w "%{http_code}:%{time_total}" http://localhost:3000/ 2>/dev/null || echo "FAILED")
echo "Response: $RESPONSE"

# Show process info
echo "Puma processes and CPU affinity:"
for pid in $(pgrep puma); do
    echo "PID $pid on CPU: $(taskset -p $pid 2>/dev/null | awk '{print $6}' || echo 'unknown')"
done

# Quick load test
echo "Running 30-second load test..."
cd ~/wrk
timeout 35s ./wrk -t 8 -c 200 -d 30s --latency http://localhost:3000/ > /tmp/wrk_basic_test.log 2>&1 &
WRK_PID=$!

# Monitor CPU during first 15 seconds
echo "CPU monitoring during load test:"
for i in {1..5}; do
    sleep 3
    CPU_LINE=$(top -bn1 | grep "Cpu(s)" | head -1)
    echo "  $i: $CPU_LINE"
done

# Wait for test completion
wait $WRK_PID 2>/dev/null || echo "wrk test completed"

echo "Load test results:"
cat /tmp/wrk_basic_test.log

# Final system state
echo "Final process status:"
ps aux | grep -E "(puma|wrk)" | grep -v grep || echo "No processes running"

# Clean up
pkill -f puma 2>/dev/null || echo "Puma stopped"

EOF
}

# Execute test
main() {
    export PATH=~/.local/bin:$PATH
    export AWS_PROFILE=m8a
    run_basic_test
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi