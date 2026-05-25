#!/bin/bash -l
###############################################################################
# PMC matrix capture during Rails benchmark — 2xlarge geometry
#
# Captures AMD Zen5 PMC events on Puma cores (0-6) for 30 s while wrk drives
# c=100 load. Output: /tmp/pmc_2xl.log (JSON perf-stat output + wrk summary)
#
# Events captured (validated working on Zen5 EPYC 9R45 under EC2 guest):
#   - cpu-cycles, instructions, task-clock
#   - de_no_dispatch_per_slot.no_ops_from_frontend  (frontend stalls)
#   - de_no_dispatch_per_slot.backend_stalls
#   - de_src_op_disp.all, ex_ret_ops, ls_not_halted_cyc
#   - ex_no_retire.load_not_complete, ex_no_retire.not_complete (mem-bound %)
#   - ex_ret_brn_misp, ex_ret_brn (branch mispred rate)
#   - l2_cache_req_stat.{dc_hit_in_l2, ls_rd_blk_c, ic_fill_miss, ic_hit_in_l2}
#
# Requires: linux-tools-$(uname -r); sudo perf
# Runtime: ~50 s (5s puma + 5s warmup + 5s settle + 30s perf + cleanup)
###############################################################################

set -uo pipefail
LOG=/tmp/pmc_2xl.log
exec > >(tee -a "$LOG") 2>&1

export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
eval "$($HOME/.rbenv/bin/rbenv init - bash 2>/dev/null)" || true

echo ">>> PMC START $(date) on $(hostname)"
echo "=== instance ==="
TOKEN=$(curl -sX PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 60' 2>/dev/null || echo "")
[ -n "$TOKEN" ] && curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null
echo

# perf must be installed
command -v perf >/dev/null || { echo "FATAL: perf not installed — sudo apt install linux-tools-\$(uname -r)"; exit 1; }

cd "$HOME/bench_app" || { echo "FATAL: ~/bench_app missing"; exit 1; }
pkill -9 -f puma 2>/dev/null; pkill -9 -f wrk 2>/dev/null; sleep 2

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
export MALLOC_ARENA_MAX=2
export RUBY_YJIT_ENABLE=1
export WEB_CONCURRENCY=7
export RAILS_MAX_THREADS=1
export RAILS_ENV=production
export SECRET_KEY_BASE
SECRET_KEY_BASE=$(bundle exec rails secret 2>/dev/null || openssl rand -hex 32)

taskset -c 0-6 bundle exec puma -e production -p 3000 -w 7 -t 1 --preload &
PUMA_PID=$!
for i in $(seq 1 60); do
  curl -sf http://127.0.0.1:3000/ > /dev/null 2>&1 && break
  sleep 1
done
echo "Puma ready"

# warmup
taskset -c 7 "$HOME/wrk/wrk" -t1 -c100 -d5s http://127.0.0.1:3000/ > /dev/null 2>&1

echo "=== wrk c=100 d=45s + perf stat 30s on cores 0-6 ==="
taskset -c 7 "$HOME/wrk/wrk" -t1 -c100 -d45s --latency http://127.0.0.1:3000/ > /tmp/wrk_pmc.log &
WRK_PID=$!
sleep 5  # let load stabilize before perf attaches

EVENTS="cpu-cycles,instructions,task-clock,"
EVENTS+="de_no_dispatch_per_slot.no_ops_from_frontend,"
EVENTS+="de_no_dispatch_per_slot.backend_stalls,"
EVENTS+="de_src_op_disp.all,"
EVENTS+="ex_ret_ops,"
EVENTS+="ls_not_halted_cyc,"
EVENTS+="ex_no_retire.load_not_complete,"
EVENTS+="ex_no_retire.not_complete,"
EVENTS+="ex_ret_brn_misp,"
EVENTS+="ex_ret_brn,"
EVENTS+="l2_cache_req_stat.dc_hit_in_l2,"
EVENTS+="l2_cache_req_stat.ls_rd_blk_c,"
EVENTS+="l2_cache_req_stat.ic_fill_miss,"
EVENTS+="l2_cache_req_stat.ic_hit_in_l2"

sudo perf stat -j -e "$EVENTS" -C 0-6 -- sleep 30 2>&1
echo "=== wrk summary ==="
cat /tmp/wrk_pmc.log
wait $WRK_PID 2>/dev/null
kill -9 $PUMA_PID 2>/dev/null; pkill -9 -f puma 2>/dev/null
echo ">>> PMC DONE $(date)"
