#!/bin/bash
# m8a_worker_scaling.sh - Scale Puma WEB_CONCURRENCY to lift M8A AWS Nitro RPS.
# Strategy:
#   - Co-location (proven best on M8A)
#   - Heavy wrk load (16 threads, sufficient connections) so client isn't bottleneck
#   - Sweep WEB_CONCURRENCY = 8, 16, 32, 48, 64 keeping all else equal
#   - Measure RPS, p99, CPU usage
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"
export AWS_PROFILE=m8a
export PATH="$HOME/.local/bin:$PATH"

TS=$(date +%Y%m%d_%H%M)
LOG=/sessions/gracious-gallant-archimedes/mnt/outputs/m8a_worker_scaling_${TS}.log

timeout 1500 ssh -i "$KEY" -o StrictHostKeyChecking=no \
    -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters portNumber=%p" \
    ubuntu@$INSTANCE 'bash -s' <<'EOF' | tee "$LOG"

set -e
cd ~/bench_app
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Optimization stack
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RAILS_MAX_THREADS=1

echo "=== Sysctl tune for high concurrency (transient) ==="
sudo sysctl -w net.core.somaxconn=65535 >/dev/null
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=65535 >/dev/null
sudo sysctl -w net.ipv4.ip_local_port_range="1024 65535" >/dev/null
sudo sysctl -w net.ipv4.tcp_tw_reuse=1 >/dev/null
sysctl net.core.somaxconn net.ipv4.tcp_max_syn_backlog net.ipv4.ip_local_port_range net.ipv4.tcp_tw_reuse

run_test () {
  local W=$1
  local THREADS=$2
  local CONNS=$3
  local DUR=$4
  local TAG=$5
  echo ""
  echo "=========================================================="
  echo "TEST $TAG : WEB_CONCURRENCY=$W  wrk -t${THREADS} -c${CONNS} -d${DUR}s"
  echo "=========================================================="

  pkill -9 -f puma 2>/dev/null || true
  pkill -9 -f wrk  2>/dev/null || true
  sleep 2

  export WEB_CONCURRENCY=$W
  bundle exec puma -e production -b "tcp://0.0.0.0:3000?backlog=4096" --preload >/tmp/puma_${TAG}.log 2>&1 &
  PID=$!
  # wait until booted
  for i in $(seq 1 30); do
    if curl -sf http://localhost:3000/ >/dev/null 2>&1; then break; fi
    sleep 1
  done
  if ! curl -sf http://localhost:3000/ >/dev/null; then
    echo "!! Puma failed to boot (W=$W). last log:"
    tail -20 /tmp/puma_${TAG}.log
    return
  fi
  echo "Puma ready (W=$W, PID=$PID)"

  # Quick CPU sample during run
  ( for i in 1 2 3 4 5; do sleep $((DUR/6)); top -bn1 | grep "Cpu(s)" | head -1; done ) >/tmp/cpu_${TAG}.log &

  ~/wrk/wrk -t${THREADS} -c${CONNS} -d${DUR}s http://localhost:3000/ > /tmp/wrk_${TAG}.log 2>&1
  wait

  echo "--- wrk result ---"
  grep -E "Running|Requests/sec|Latency|Transfer/sec|Socket errors|Non-2xx" /tmp/wrk_${TAG}.log || true
  echo "--- p99 ---"
  grep -E "99%" /tmp/wrk_${TAG}.log || true
  echo "--- cpu samples ---"
  cat /tmp/cpu_${TAG}.log

  kill -9 $PID $(pgrep -f puma) 2>/dev/null || true
  sleep 2
}

# Sweep WEB_CONCURRENCY scaling (co-located, no taskset, full machine)
run_test  8  16  800 25 W08_c800
run_test 16  16 1000 25 W16_c1000
run_test 32  24 1600 25 W32_c1600
run_test 48  32 2400 25 W48_c2400
run_test 64  32 3200 25 W64_c3200
run_test 96  48 4800 25 W96_c4800

echo ""
echo "=========================================================="
echo "SUMMARY (RPS per WEB_CONCURRENCY)"
echo "=========================================================="
for TAG in W08_c800 W16_c1000 W32_c1600 W48_c2400 W64_c3200 W96_c4800; do
  RPS=$(grep "Requests/sec" /tmp/wrk_${TAG}.log | awk '{print $2}')
  P99=$(grep "99%" /tmp/wrk_${TAG}.log | tail -1 | awk '{print $2}')
  printf "%-12s  RPS=%-10s  p99=%s\n" "$TAG" "${RPS:-FAIL}" "${P99:-?}"
done

pkill -9 -f puma 2>/dev/null || true
echo "DONE"
EOF
echo "Log saved: $LOG"
