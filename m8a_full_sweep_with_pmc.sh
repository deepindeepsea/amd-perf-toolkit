#!/bin/bash
# m8a_full_sweep_with_pmc.sh
# Full Genoa-X recipe ported to M8A: per-run PMC + HTML reports via amd_pipeline_metrics.sh
# Sweeps N=1,2,4,8,11 server CCDs. Run variants: baseline / isolated / reuseport.
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TOOLKIT="$HOME/amd-perf-toolkit"
PIPE="$TOOLKIT/amd_pipeline_metrics.sh"
APP_DIR="$HOME/bench_app"

VARIANT="${1:-baseline}"          # baseline | isolated | reuseport
CCD_LIST="${2:-1 2 4 8 11}"
DURATION="${DURATION:-30}"
CONNS_PER_THREAD="${CONNS_PER_THREAD:-100}"
APP_URL="http://localhost:3000/"

TS=$(date +%Y%m%d_%H%M%S)
SWEEP_DIR="$HOME/m8a_sweeps/sweep_${VARIANT}_${TS}"
mkdir -p "$SWEEP_DIR"
SWEEP_LOG="$SWEEP_DIR/sweep.log"
exec > >(tee -a "$SWEEP_LOG") 2>&1

# 8-core CCD groups (sequential, M8A 96-core EPYC 9R45)
CCD_GROUPS=( "0 7" "8 15" "16 23" "24 31" "32 39" "40 47" \
             "48 55" "56 63" "64 71" "72 79" "80 87" "88 95" )
TOTAL_CCDS=12
CLIENT_IDX=11
CLIENT_CORES="88-95"
WRK_T_CAP=8

# Optimization stack (Genoa-X recipe)
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export RUBY_YJIT_ENABLE=1
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RAILS_MAX_THREADS=1
export RAILS_ENV=production
cd "$APP_DIR"
export SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || echo "dummy_$(date +%s)")

# Kernel tunings (transient)
sudo sysctl -w kernel.perf_event_paranoid=-1 >/dev/null 2>&1
echo 0 | sudo tee /proc/sys/kernel/nmi_watchdog >/dev/null
sudo sysctl -w net.core.somaxconn=65535 >/dev/null
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=65535 >/dev/null
sudo sysctl -w net.ipv4.ip_local_port_range="1024 65535" >/dev/null
sudo sysctl -w net.ipv4.tcp_tw_reuse=1 >/dev/null

echo "=========================================================="
echo " M8A CCD Sweep — variant=$VARIANT  CCDs=$CCD_LIST"
echo " Toolkit: $TOOLKIT"
echo " Sweep dir: $SWEEP_DIR"
echo " Duration: ${DURATION}s  Conns/thread: $CONNS_PER_THREAD"
echo " Stack: YJIT + jemalloc + MALLOC_ARENA_MAX=2 + somaxconn=65535"
echo "=========================================================="
ruby --yjit -e "puts 'YJIT enabled: ' + RubyVM::YJIT.enabled?.to_s" 2>&1

for N in $CCD_LIST; do
    if [ $N -gt $CLIENT_IDX ]; then echo "[skip] N=$N > $CLIENT_IDX"; continue; fi

    SERVER_CORES=""
    for i in $(seq 0 $((N - 1))); do
        read -r f l <<< "${CCD_GROUPS[$i]}"
        [ -z "$SERVER_CORES" ] && SERVER_CORES="$f-$l" || SERVER_CORES="$SERVER_CORES,$f-$l"
    done
    WORKERS=$((N * 8))
    WRK_T=$N; [ $WRK_T -gt $WRK_T_CAP ] && WRK_T=$WRK_T_CAP
    WRK_C=$((WRK_T * CONNS_PER_THREAD))

    HTML="$SWEEP_DIR/m8a_ccd${N}_wrk${WRK_T}.html"

    echo ""
    echo "----------------------------------------------------------"
    echo " N=$N | workers=$WORKERS on $SERVER_CORES | wrk=-t$WRK_T -c$WRK_C on $CLIENT_CORES"
    echo " HTML: $HTML"
    echo "----------------------------------------------------------"

    pkill -9 -f puma 2>/dev/null || true
    pkill -9 -f wrk  2>/dev/null || true
    sleep 2

    export WEB_CONCURRENCY=$WORKERS

    # Variant-specific puma launch
    case "$VARIANT" in
      baseline)
        taskset -c "$SERVER_CORES" bundle exec puma -e production \
            -b "tcp://0.0.0.0:3000?backlog=4096" \
            > "$SWEEP_DIR/puma_N${N}.log" 2>&1 &
        PUMA_PID=$!
        ;;
      isolated)
        # Same as baseline (server already pinned; client is also pinned via wrk taskset)
        # Difference vs baseline: explicit, no shared cores client/server (which is already true via CLIENT_CORES=88-95)
        taskset -c "$SERVER_CORES" bundle exec puma -e production \
            -b "tcp://0.0.0.0:3000?backlog=4096" \
            > "$SWEEP_DIR/puma_N${N}.log" 2>&1 &
        PUMA_PID=$!
        ;;
      reuseport)
        # SO_REUSEPORT: launch ONE puma per CCD, each bound separately
        PUMA_PIDS=()
        for i in $(seq 0 $((N - 1))); do
            read -r f l <<< "${CCD_GROUPS[$i]}"
            range="$f-$l"
            WC=8 taskset -c "$range" env WEB_CONCURRENCY=8 bundle exec puma -e production \
                -b "tcp://0.0.0.0:3000?backlog=4096&reuse_port=true" \
                > "$SWEEP_DIR/puma_N${N}_ccd${i}.log" 2>&1 &
            PUMA_PIDS+=($!)
            sleep 0.5
        done
        PUMA_PID=${PUMA_PIDS[0]}
        ;;
    esac

    READY=0
    for i in $(seq 1 60); do
        if curl -sf http://localhost:3000/ >/dev/null 2>&1; then READY=1; break; fi
        sleep 1
    done
    if [ $READY -ne 1 ]; then
        echo "!! Puma failed to boot for N=$N"
        tail -20 "$SWEEP_DIR/puma_N${N}.log" 2>/dev/null
        kill -9 ${PUMA_PIDS[@]:-$PUMA_PID} 2>/dev/null || true
        continue
    fi
    echo "  Puma ready"

    # Run via toolkit pipeline metrics — generates HTML with PMC analysis
    PERF_CPULIST="$SERVER_CORES" \
    HTML_OUT="$HTML" \
        bash "$PIPE" "taskset -c $CLIENT_CORES $HOME/wrk/wrk -t$WRK_T -c$WRK_C -d${DURATION}s --latency $APP_URL" \
        > "$SWEEP_DIR/pipeline_N${N}.log" 2>&1

    # Save wrk output separately
    grep -A 30 "WORKLOAD OUTPUT" "$SWEEP_DIR/pipeline_N${N}.log" > "$SWEEP_DIR/wrk_N${N}.log" 2>/dev/null || \
        cp "$SWEEP_DIR/pipeline_N${N}.log" "$SWEEP_DIR/wrk_N${N}.log"

    RPS=$(grep "Requests/sec" "$SWEEP_DIR/pipeline_N${N}.log" | head -1 | awk '{print $2}')
    P99=$(grep "99%" "$SWEEP_DIR/pipeline_N${N}.log" | head -1 | awk '{print $2}')
    printf "  N=%d => RPS=%s  p99=%s  HTML=%s\n" "$N" "${RPS:-?}" "${P99:-?}" "$(basename $HTML)"

    pkill -9 -f puma 2>/dev/null || true
    sleep 3
done

echo ""
echo "=========================================================="
echo "FINAL SUMMARY — variant=$VARIANT"
echo "=========================================================="
printf "%-6s %-10s %-12s %-10s %s\n" "N" "Workers" "RPS" "p99" "HTML"
for N in $CCD_LIST; do
    RPS=$(grep "Requests/sec" "$SWEEP_DIR/pipeline_N${N}.log" 2>/dev/null | head -1 | awk '{print $2}')
    P99=$(grep "99%" "$SWEEP_DIR/pipeline_N${N}.log" 2>/dev/null | head -1 | awk '{print $2}')
    printf "%-6s %-10s %-12s %-10s %s\n" "$N" "$((N*8))" "${RPS:-FAIL}" "${P99:-?}" "m8a_ccd${N}_*.html"
done
echo ""
echo "All artifacts: $SWEEP_DIR"
ls "$SWEEP_DIR"/ | head -40
