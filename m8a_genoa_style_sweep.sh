#!/bin/bash
# m8a_genoa_style_sweep.sh
# Faithful port of Genoa-X benchmark_ccd_sweep.sh recipe to AWS M8A.metal-24xl.
# Sweeps Puma across N server CCDs, reserves last CCD for wrk client.
# WEB_CONCURRENCY = 8 * N (one worker per core), RAILS_MAX_THREADS=1.
set -e

INSTANCE="i-082ca0124af7a18d0"
KEY="/sessions/gracious-gallant-archimedes/mnt/uploads/ruby_pradeepn.pem"
export AWS_PROFILE=m8a
export PATH="$HOME/.local/bin:$PATH"

TS=$(date +%Y%m%d_%H%M)
LOG=/sessions/gracious-gallant-archimedes/mnt/outputs/m8a_sweep_${TS}.log

timeout 1500 ssh -i "$KEY" -o StrictHostKeyChecking=no \
    -o ProxyCommand="aws ssm start-session --target $INSTANCE --document-name AWS-StartSSHSession --parameters portNumber=%p" \
    ubuntu@$INSTANCE 'bash -s' <<'EOF' | tee "$LOG"

set -e
cd ~/bench_app
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Sysctl tune
sudo sysctl -w net.core.somaxconn=65535 >/dev/null
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=65535 >/dev/null
sudo sysctl -w net.ipv4.ip_local_port_range="1024 65535" >/dev/null
sudo sysctl -w net.ipv4.tcp_tw_reuse=1 >/dev/null

# Faithful Genoa-X stack
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RAILS_MAX_THREADS=1
export RAILS_ENV=production
export SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || echo "dummy_$(date +%s)")

# CCD groupings (sequential 8-core blocks, matching prior Genoa-X recipe)
CCD_GROUPS=( "0 7" "8 15" "16 23" "24 31" "32 39" "40 47" \
             "48 55" "56 63" "64 71" "72 79" "80 87" "88 95" )
TOTAL_CCDS=${#CCD_GROUPS[@]}
CLIENT_IDX=$((TOTAL_CCDS - 1))         # last CCD (88-95) reserved for wrk
read -r CLIENT_FIRST CLIENT_LAST <<< "${CCD_GROUPS[$CLIENT_IDX]}"
CLIENT_CORES="${CLIENT_FIRST}-${CLIENT_LAST}"
MAX_N=$CLIENT_IDX                       # 11

DURATION=30
CONNS_PER_THREAD=100
URL="http://localhost:3000/"

mkdir -p ~/m8a_sweep_${TS:-$(date +%s)}
SWEEP_DIR=~/m8a_sweep_$(date +%s)
mkdir -p $SWEEP_DIR
echo "Sweep dir: $SWEEP_DIR"

echo "=== Env ==="
ruby --yjit -e "puts 'YJIT enabled: ' + RubyVM::YJIT.enabled?.to_s" 2>&1 || true
echo "LD_PRELOAD=$LD_PRELOAD"
echo "Client CCD reserved: cores $CLIENT_CORES (wrk threads max = 8)"
echo ""

for N in 1 2 4 8 11; do
  if [ $N -gt $MAX_N ]; then continue; fi
  SERVER_CORES=""
  for i in $(seq 0 $((N - 1))); do
    read -r f l <<< "${CCD_GROUPS[$i]}"
    [ -z "$SERVER_CORES" ] && SERVER_CORES="$f-$l" || SERVER_CORES="$SERVER_CORES,$f-$l"
  done
  WORKERS=$((N * 8))
  WRK_T=$N; [ $WRK_T -gt 8 ] && WRK_T=8
  WRK_C=$((WRK_T * CONNS_PER_THREAD))

  echo ""
  echo "============================================================"
  echo " N=$N CCDs | $WORKERS Puma workers on cores $SERVER_CORES"
  echo " wrk: -t$WRK_T -c$WRK_C -d${DURATION}s on cores $CLIENT_CORES"
  echo "============================================================"

  pkill -9 -f puma 2>/dev/null || true
  pkill -9 -f wrk  2>/dev/null || true
  sleep 2

  export WEB_CONCURRENCY=$WORKERS
  taskset -c "$SERVER_CORES" bundle exec puma -e production \
      -b "tcp://0.0.0.0:3000?backlog=4096" \
      > $SWEEP_DIR/puma_N${N}.log 2>&1 &
  PUMA_PID=$!

  # Boot wait
  READY=0
  for i in $(seq 1 60); do
    if curl -sf http://localhost:3000/ >/dev/null 2>&1; then READY=1; break; fi
    sleep 1
  done
  if [ $READY -ne 1 ]; then
    echo "!! Puma did NOT boot for N=$N — last log:"
    tail -30 $SWEEP_DIR/puma_N${N}.log
    kill -9 $PUMA_PID 2>/dev/null || true
    continue
  fi
  echo "Puma ready (PID=$PUMA_PID, workers=$WORKERS)"

  taskset -c "$CLIENT_CORES" ~/wrk/wrk -t$WRK_T -c$WRK_C -d${DURATION}s --latency $URL \
      > $SWEEP_DIR/wrk_N${N}.log 2>&1

  echo "--- N=$N result ---"
  grep -E "Running|Requests/sec|Latency|Transfer/sec|Socket errors|Non-2xx" $SWEEP_DIR/wrk_N${N}.log | head -10
  echo "--- p99 ---"
  grep -A4 "Latency Distribution" $SWEEP_DIR/wrk_N${N}.log | tail -1

  kill -9 $PUMA_PID 2>/dev/null || pkill -9 -f puma
  sleep 3
done

echo ""
echo "============================================================"
echo "SUMMARY"
echo "============================================================"
printf "%-6s %-10s %-12s %-10s\n" "N_CCDs" "Workers" "RPS" "p99"
for N in 1 2 4 8 11; do
  RPS=$(grep "Requests/sec" $SWEEP_DIR/wrk_N${N}.log 2>/dev/null | awk '{print $2}')
  P99=$(grep -A4 "Latency Distribution" $SWEEP_DIR/wrk_N${N}.log 2>/dev/null | tail -1 | awk '{print $2}')
  printf "%-6s %-10s %-12s %-10s\n" "$N" "$((N*8))" "${RPS:-FAIL}" "${P99:-?}"
done
echo ""
echo "Logs: $SWEEP_DIR"
EOF
echo "Local log: $LOG"
