#!/bin/bash
# systematic_m8a_testing.sh - Run comprehensive 3x CCD scaling tests on AWS M8A
#
# Executes 3 complete test runs for consistency as requested by user
# Tests: 1,2,4,8 CCDs with YJIT + jemalloc + CCD pinning optimizations
#
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"
RESULTS_BASE="/home/ubuntu/rails-benchmark-amd/results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== AWS M8A Systematic CCD Scaling Test $(date) ==="
echo "Instance: $INSTANCE (EPYC 9R45 96-core Zen5 Turin)"
echo "Test Plan: 3x runs of CCD scaling (1,2,4,8) + optimizations"
echo "Results: $RESULTS_BASE/systematic_$TIMESTAMP/"
echo ""

# Test configurations
declare -a TEST_CONFIGS=(
    "baseline:1 2 4 8:Standard CCD sweep"
    "yjit:1 2 4 8:YJIT enabled optimization"
    "jemalloc:1 2 4 8:jemalloc memory optimization"
    "optimized:1 2 4 8:YJIT + jemalloc + CCD pinning"
)

# Function to run single test configuration
run_test_config() {
    local config_name="$1"
    local ccd_counts="$2"
    local description="$3"
    local run_number="$4"

    echo "============================================================"
    echo "  Run $run_number: $config_name ($description)"
    echo "  CCDs: $ccd_counts"
    echo "  Time: $(date)"
    echo "============================================================"

    # Set environment based on configuration
    local env_vars=""
    case "$config_name" in
        "yjit")
            env_vars="export RUBY_YJIT_ENABLE=1 &&"
            ;;
        "jemalloc")
            env_vars="export MALLOC_ARENA_MAX=4 && export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 &&"
            ;;
        "optimized")
            env_vars="export RUBY_YJIT_ENABLE=1 && export MALLOC_ARENA_MAX=4 && export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 &&"
            ;;
    esac

    # Execute the test
    timeout 1800s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && $env_vars export TOOLKIT_DIR=\$PWD && ./benchmark_ccd_sweep.sh '$ccd_counts' > systematic_${config_name}_run${run_number}.log 2>&1" || {
            echo "ERROR: Test $config_name run $run_number failed or timed out"
            return 1
        }

    echo "  ✓ Completed: $config_name run $run_number"
    echo ""
}

# Function to collect and analyze results
collect_results() {
    echo "=== Collecting Results for Analysis ==="

    timeout 30s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && echo 'Generated HTML reports:' && find results/ -name '*.html' -newer systematic_baseline_run1.log 2>/dev/null | wc -l && echo 'Log files:' && ls -la systematic_*.log 2>/dev/null | wc -l" || {
            echo "Warning: Could not collect results summary"
        }
}

# Main execution
main() {
    echo "Starting systematic testing at $(date)"

    # Run all test configurations 3 times each
    for run in 1 2 3; do
        echo ""
        echo "###################### TEST RUN $run of 3 ######################"

        for config_line in "${TEST_CONFIGS[@]}"; do
            IFS=':' read -r config_name ccd_counts description <<< "$config_line"
            run_test_config "$config_name" "$ccd_counts" "$description" "$run"

            # Brief pause between configurations
            sleep 10
        done

        echo "✓ Completed all configurations for run $run"
        sleep 30  # Pause between runs
    done

    echo ""
    echo "=== SYSTEMATIC TESTING COMPLETE ==="
    collect_results
    echo "Finished at $(date)"
}

# Execute if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi