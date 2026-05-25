#!/bin/bash
# start_run3_and_optimizations.sh - Complete the systematic testing
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"
AWS_PROFILE="m8a"

echo "=== AWS M8A Run 3 + Optimization Testing $(date) ==="

# Function to wait for Run 2 completion
wait_for_run2() {
    echo "Waiting for Run 2 to complete..."
    while true; do
        ACTIVE_PROCS=$(timeout 10s ssh -i "$KEY" -o StrictHostKeyChecking=no \
            -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
            ubuntu@$INSTANCE "pgrep -f 'benchmark_ccd_sweep|puma|wrk' | wc -l" 2>/dev/null || echo "0")

        if [ "$ACTIVE_PROCS" -eq 0 ]; then
            echo "✓ Run 2 completed at $(date)"
            break
        fi

        echo "  Run 2 still active ($ACTIVE_PROCS processes), waiting..."
        sleep 15
    done
}

# Function to execute test run
execute_test() {
    local test_name="$1"
    local env_setup="$2"
    local ccd_config="$3"

    echo "============================================================"
    echo "  $test_name Test: $(date)"
    echo "  Environment: $env_setup"
    echo "  CCDs: $ccd_config"
    echo "============================================================"

    timeout 600s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && export PATH=\$HOME/.local/share/gem/ruby/3.2.0/bin:\$PATH && $env_setup DURATION=60 TOOLKIT_DIR=\$PWD ./benchmark_ccd_sweep.sh '$ccd_config' > ${test_name,,}_test.log 2>&1" || {
        echo "ERROR: $test_name test failed"
        return 1
    }

    echo "✓ $test_name test completed"
    sleep 10
}

# Main execution
main() {
    # Wait for Run 2 to finish
    wait_for_run2

    # Collect Run 2 results
    echo "=== Collecting Run 2 Results ==="
    timeout 20s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && echo 'Run 2 log size:' && wc -l ccd_sweep_run2.log && echo 'HTML reports:' && find results/sweep_20260524_030346/ -name '*.html' 2>/dev/null | wc -l"

    # Execute Run 3 (baseline confirmation)
    execute_test "RUN3" "" "1 2 4 8"

    # Execute optimization tests
    execute_test "YJIT" "export RUBY_YJIT_ENABLE=1 &&" "1 2 4 8"
    execute_test "JEMALLOC" "export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 &&" "1 2 4 8"
    execute_test "OPTIMIZED" "export RUBY_YJIT_ENABLE=1 && export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 &&" "1 2 4 8"

    # Final results collection
    echo ""
    echo "=== COMPREHENSIVE TESTING COMPLETE ==="
    timeout 30s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && echo 'All test logs:' && ls -la *test.log *.log 2>/dev/null && echo 'Total HTML reports generated:' && find results/ -name '*.html' 2>/dev/null | wc -l"

    echo "Comprehensive testing completed at $(date)"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    export PATH=~/.local/bin:$PATH
    export AWS_PROFILE=m8a
    main "$@"
fi