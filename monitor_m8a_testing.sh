#!/bin/bash
# monitor_m8a_testing.sh - Monitor AWS M8A CCD scaling tests
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"

echo "=== AWS M8A Testing Monitor $(date) ==="
echo "Instance: $INSTANCE"
echo "System: AMD EPYC 9R45 96-core Zen5 Turin"
echo ""

# Check if tests are running
echo "=== Process Status ==="
timeout 10s ssh -i "$KEY" -o StrictHostKeyChecking=no \
  -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
  ubuntu@$INSTANCE "ps aux | grep -E '(benchmark|puma|wrk|rails)' | grep -v grep" 2>/dev/null || echo "No active benchmark processes"

echo ""
echo "=== Results Summary ==="
timeout 10s ssh -i "$KEY" -o StrictHostKeyChecking=no \
  -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
  ubuntu@$INSTANCE "cd rails-benchmark-amd && echo 'Log files:' && ls -la *.log 2>/dev/null || echo 'No logs yet'" 2>/dev/null

echo ""
timeout 10s ssh -i "$KEY" -o StrictHostKeyChecking=no \
  -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
  ubuntu@$INSTANCE "cd rails-benchmark-amd && echo 'Results directories:' && ls -la results/ 2>/dev/null | tail -5" 2>/dev/null

echo ""
echo "=== Latest HTML Reports ==="
timeout 10s ssh -i "$KEY" -o StrictHostKeyChecking=no \
  -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
  ubuntu@$INSTANCE "cd rails-benchmark-amd && find results/ -name '*.html' -newer results/sweep_20260524_025843/sweep.log 2>/dev/null | head -3" 2>/dev/null || echo "No new HTML reports"

echo ""
echo "=== System Performance ==="
timeout 10s ssh -i "$KEY" -o StrictHostKeyChecking=no \
  -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters 'portNumber=%p'" \
  ubuntu@$INSTANCE "uptime && free -h | head -2" 2>/dev/null || echo "System status unavailable"

echo "=== Monitor Complete $(date) ==="