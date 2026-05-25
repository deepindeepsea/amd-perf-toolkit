#!/bin/bash
# generate_final_reports.sh - Generate HTML and Excel reports from all test runs
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"

echo "=== Generating Final Performance Reports $(date) ==="

# Function to generate HTML report for a specific run
generate_html_report() {
    local run_name="$1"
    local results_dir="$2"

    echo "Generating HTML report for $run_name..."

    timeout 120s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && python3 amd_perf_html_report.py 'Comprehensive CCD Scaling Analysis' ${run_name}_comprehensive_report.html --results-dir $results_dir" || {
        echo "Warning: HTML report generation failed for $run_name"
    }
}

# Function to generate Excel comparison report
generate_excel_report() {
    echo "Generating Excel comparison report..."

    timeout 180s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && python3 amd_perf_excel_report.py 'M8A_Turin_CCD_Scaling_Analysis.xlsx' --compare-runs results/sweep_*/" || {
        echo "Warning: Excel report generation failed"
    }
}

# Function to collect all results
collect_results() {
    echo "=== Collecting All Test Results ==="

    timeout 60s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && echo 'Test runs completed:' && ls -la *test.log *.log 2>/dev/null | grep -v nohup && echo 'Results directories:' && ls -la results/ && echo 'HTML reports generated:' && ls -la *report.html *.xlsx 2>/dev/null || echo 'Reports still generating'"
}

# Function to create summary package
create_summary_package() {
    echo "=== Creating Customer Summary Package ==="

    timeout 90s ssh -i "$KEY" -o StrictHostKeyChecking=no \
        -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
        ubuntu@$INSTANCE "cd rails-benchmark-amd && mkdir -p customer_package && cp *.html *.xlsx customer_package/ 2>/dev/null && cp AWS_M8A_SYSTEM_SPECS.md customer_package/ && echo 'Package contents:' && ls -la customer_package/" || {
        echo "Warning: Package creation incomplete"
    }
}

# Main execution
main() {
    # Wait for all tests to complete
    echo "Waiting for comprehensive testing to complete..."
    while pgrep -f "start_run3_and_optimizations" >/dev/null 2>&1; do
        echo "  Testing still in progress, waiting..."
        sleep 30
    done

    sleep 10  # Brief pause after completion

    # Collect results summary
    collect_results

    # Generate reports for key runs
    echo ""
    echo "Generating performance reports..."

    # Generate HTML reports for major test runs
    find /home/ubuntu/rails-benchmark-amd/results/ -name "sweep_*" -type d | while read -r dir; do
        run_name=$(basename "$dir")
        generate_html_report "$run_name" "$dir"
    done

    # Generate Excel comparison
    generate_excel_report

    # Create customer package
    create_summary_package

    # Final summary
    echo ""
    echo "=== FINAL REPORT GENERATION COMPLETE ==="
    echo "Generated at $(date)"
    collect_results
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    export PATH=~/.local/bin:$PATH
    export AWS_PROFILE=m8a
    main "$@"
fi