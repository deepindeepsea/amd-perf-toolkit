#!/bin/bash

# AMD Pipeline Metrics Analysis
# Displays human-readable metrics like PerfSpect
# Supports cloud context via --emulate CSP INSTANCE_TYPE
#
# Usage:
#   ./amd_pipeline_metrics.sh "workload command"
#   ./amd_pipeline_metrics.sh "workload command" --emulate aws m8a.8xlarge
#   ./amd_pipeline_metrics.sh "workload command" --emulate gcp c4d-standard-16

WORKLOAD=""
EMULATE_CSP=""
EMULATE_INSTANCE=""
PARSE_EMULATE=0

for arg in "$@"; do
    if [ "$PARSE_EMULATE" -eq 1 ]; then
        EMULATE_CSP="$arg"; PARSE_EMULATE=2
    elif [ "$PARSE_EMULATE" -eq 2 ]; then
        EMULATE_INSTANCE="$arg"; PARSE_EMULATE=3
    elif [ "$arg" = "--emulate" ]; then
        PARSE_EMULATE=1
    elif [ "$PARSE_EMULATE" -eq 0 ]; then
        WORKLOAD="$WORKLOAD $arg"
    fi
done
WORKLOAD="${WORKLOAD## }"
WORKLOAD="${WORKLOAD:-sleep 2}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---- Cloud context (detect or emulate) --------------------------------------
CLOUD_CTX_PY="${SCRIPT_DIR}/cloud_context.py"
CLOUD_JSON=""
CLOUD_PMC_SUPPORT="core"
CLOUD_FEFF_MIN="0"
CLOUD_SMT="false"
CLOUD_DETERMINISTIC="true"
CLOUD_PPL="0"
CLOUD_NUMA_CROSSING="false"
CLOUD_TOPO_VIS="correct"
CLOUD_EMULATED="false"
CLOUD_CSP="unknown"

if [ -f "$CLOUD_CTX_PY" ]; then
    if [ -n "$EMULATE_CSP" ] && [ -n "$EMULATE_INSTANCE" ]; then
        CLOUD_JSON=$(python3 "$CLOUD_CTX_PY" --emulate "$EMULATE_CSP" "$EMULATE_INSTANCE" --json 2>/dev/null)
    else
        CLOUD_JSON=$(python3 "$CLOUD_CTX_PY" --json 2>/dev/null)
    fi

    if [ -n "$CLOUD_JSON" ]; then
        CLOUD_PMC_SUPPORT=$(echo "$CLOUD_JSON" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('pmc_support','core'))")
        CLOUD_FEFF_MIN=$(echo "$CLOUD_JSON"    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('feff_expected_min_ghz',0))")
        CLOUD_SMT=$(echo "$CLOUD_JSON"         | python3 -c "import sys,json; d=json.load(sys.stdin); print(str(d.get('smt_enabled',False)).lower())")
        CLOUD_PPL=$(echo "$CLOUD_JSON"         | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('ppl_watts',0))")
        CLOUD_NUMA_CROSSING=$(echo "$CLOUD_JSON" | python3 -c "import sys,json; d=json.load(sys.stdin); print(str(d.get('is_numa_crossing',False)).lower())")
        CLOUD_TOPO_VIS=$(echo "$CLOUD_JSON"    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('topology_vis','correct'))")
        CLOUD_EMULATED=$(echo "$CLOUD_JSON"    | python3 -c "import sys,json; d=json.load(sys.stdin); print(str(d.get('emulated',False)).lower())")
        CLOUD_CSP=$(echo "$CLOUD_JSON"         | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('csp','unknown'))")
    fi

    # Print human-readable banner
    if [ -n "$EMULATE_CSP" ] && [ -n "$EMULATE_INSTANCE" ]; then
        python3 "$CLOUD_CTX_PY" --emulate "$EMULATE_CSP" "$EMULATE_INSTANCE" 2>/dev/null
    else
        python3 "$CLOUD_CTX_PY" 2>/dev/null
    fi
    echo ""
fi

if [ "$CLOUD_PMC_SUPPORT" = "none" ]; then
    echo "WARNING: PMC SUPPORT NONE -- perf stat events will return zero on this cloud instance."
    echo "Oracle Cloud VMs do not expose performance counters."
    echo "Run on bare metal for accurate profiling."
    echo ""
fi

# ---- CPU info ----------------------------------------------------------------
CPU_MODEL=$(lscpu | grep 'Model name' | head -1 | cut -d: -f2 | xargs | sed 's/  */ /g')
TOTAL_CORES=$(nproc)

echo "=== AMD Performance Analysis ==="
echo "CPU:          $CPU_MODEL"
echo "Total Cores:  $TOTAL_CORES"
echo "Workload:     $WORKLOAD"
if [ -n "$EMULATE_CSP" ]; then
    echo "Context:      EMULATING $EMULATE_CSP $EMULATE_INSTANCE"
fi
echo ""

# ---- perf event collection --------------------------------------------------
collect_group() {
    local events="$1"
    local workload="$2"

    # Redirect workload stdout to /dev/null so it doesn't pollute perf JSON output.
    # perf stat writes JSON counters to stderr; we capture only that via 2>&1 on a subshell.
    { perf stat -j -e "$events" -- $workload > /dev/null; } 2>&1 \
        | grep '"event"' \
        | python3 -c "
import sys, json
results = {}
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        obj = json.loads(line)
        event = obj.get('event', '').strip()
        val   = obj.get('counter-value', '0').replace(',','').strip()
        mval  = obj.get('metric-value', '')
        results[event] = float(val) if val and val not in ['<not counted>', '<not supported>'] else 0.0
        if mval and mval not in ['<not counted>', '<not supported>', '']:
            try:
                results[event + '__metric'] = float(str(mval).replace(',',''))
                results[event + '__unit']   = 0.0
            except:
                pass
    except:
        pass
for k, v in results.items():
    print(f'{k}={v}')
" 2>/dev/null
}

declare -A E

# Parse a perf stat -j output file into the E[] associative array.
# Called once after the single collection run.
parse_perf_output() {
    local perf_file="$1"
    while IFS='=' read -r key val; do
        [[ -z "$key" || "$key" =~ ^[[:space:]]*$ ]] && continue
        E["$key"]="$val"
    done < <(
        grep '"event"' "$perf_file" | python3 -c "
import sys, json
results = {}
for line in sys.stdin:
    line = line.strip()
    if not line: continue
    try:
        obj = json.loads(line)
        event = obj.get('event', '').strip()
        val   = obj.get('counter-value', '0').replace(',','').strip()
        mval  = obj.get('metric-value', '')
        unit  = obj.get('unit', '').strip()
        if not event: continue
        results[event] = float(val) if val and val not in ['<not counted>','<not supported>'] else 0.0
        # Capture the unit string so the caller can detect ns vs msec for task-clock
        if unit:
            results[event + '__unit'] = unit  # stored as string, printed quoted
        if mval and mval not in ['<not counted>','<not supported>','']:
            try: results[event + '__metric'] = float(str(mval).replace(',',''))
            except: pass
    except: pass
for k, v in results.items():
    # unit fields are strings; others are floats
    print(f'{k}={v}')
" 2>/dev/null
    )
}

calc() {
    python3 -c "
import sys
try:
    result = eval('$1')
    if isinstance(result, float):
        print(f'{result:.2f}')
    else:
        print(result)
except ZeroDivisionError:
    print('N/A')
except:
    print('N/A')
"
}

calcf() {
    python3 -c "
import sys
try:
    result = eval('$1')
    print(f'{float(result):.${2:-3}f}')
except ZeroDivisionError:
    print('N/A')
except:
    print('N/A')
"
}

sep() { echo "--------------------------------------------------------"; }
hdr() { echo "========================================================"; }

# =============================================================================
# SINGLE COLLECTION PASS — all PMC events in one perf stat run
# perf stat wraps the workload from start to finish.
# CCD topology monitor attaches to the workload PID concurrently.
# Total wall time = workload duration + ~2 s overhead.
# =============================================================================

ALL_EVENTS="\
task-clock,\
cpu-cycles,\
instructions,\
de_no_dispatch_per_slot.no_ops_from_frontend,\
de_no_dispatch_per_slot.backend_stalls,\
de_src_op_disp.all,\
ex_ret_ops,\
ls_not_halted_cyc,\
ex_no_retire.load_not_complete,\
ex_no_retire.not_complete,\
ex_ret_brn_misp,\
ex_ret_brn,\
l2_cache_req_stat.dc_hit_in_l2,\
l2_cache_req_stat.ls_rd_blk_c,\
l2_cache_req_stat.ic_fill_miss,\
l2_cache_req_stat.ic_hit_in_l2"

PERF_OUTPUT=$(mktemp /tmp/amd_perf_XXXXXX.txt)
WL_PID_FILE=$(mktemp /tmp/amd_wlpid_XXXXXX)
PLACEMENT_JSON_TMP=$(mktemp /tmp/amd_placement_XXXXXX.json)

echo "  Collecting PMCs for: $WORKLOAD"
echo "  (runs once — duration = workload runtime)"
echo ""

# Launch perf stat; workload writes its own PID to a file immediately on start
# so CCD monitoring can attach while perf is already running.
{ perf stat -j -e "$ALL_EVENTS" \
    -- bash -c "echo \$\$ > $WL_PID_FILE; exec $WORKLOAD" \
    > /dev/null; } 2>"$PERF_OUTPUT" &
PERF_BG=$!

# Wait up to 2 s for the workload PID to appear, then start CCD monitor
PLACEMENT_PY="${SCRIPT_DIR}/amd_cpu_placement.py"
CCD_BG=""
if [ -f "$PLACEMENT_PY" ]; then
    for _i in $(seq 1 40); do
        [ -s "$WL_PID_FILE" ] && break
        sleep 0.05
    done
    WL_PID=$(cat "$WL_PID_FILE" 2>/dev/null)
    if [ -n "$WL_PID" ] && kill -0 "$WL_PID" 2>/dev/null; then
        python3 "$PLACEMENT_PY" --pid "$WL_PID" --json-file "$PLACEMENT_JSON_TMP" 2>/dev/null &
        CCD_BG=$!
    fi
fi

# ---- turbostat: run concurrently to capture Aperf/Mperf freq + per-core watts ----
# Runs as sudo directly (user must be able to sudo turbostat).
# Killed with sudo pkill after workload finishes.
# Column discovery: probe available columns first; fall back to no --show (all columns).
TURBOSTAT_OUT=$(mktemp /tmp/amd_turbostat_XXXXXX.txt)
TURBOSTAT_ERR=$(mktemp /tmp/amd_turbostat_err_XXXXXX.txt)
TURBOSTAT_BG=""
TURBOSTAT_AVAILABLE=0

if command -v turbostat &>/dev/null && sudo -n turbostat --version &>/dev/null 2>&1; then
    # Discover which --show columns are available in this turbostat version
    AVAIL_COLS=$(sudo turbostat --list 2>&1 | tr ',' '\n' | tr -d ' ')
    TS_SHOW_COLS=""
    for want in Core CPU Busy% Bzy_MHz Avg_MHz CoreTmp CPU_W Pkg_J PkgWatt SysWatt; do
        if echo "$AVAIL_COLS" | grep -qx "$want"; then
            TS_SHOW_COLS="${TS_SHOW_COLS:+$TS_SHOW_COLS,}$want"
        fi
    done

    if [ -n "$TS_SHOW_COLS" ]; then
        sudo turbostat --interval 1 --quiet --show "$TS_SHOW_COLS" \
            > "$TURBOSTAT_OUT" 2>"$TURBOSTAT_ERR" &
    else
        # Fall back: no column filter — capture everything
        sudo turbostat --interval 1 --quiet \
            > "$TURBOSTAT_OUT" 2>"$TURBOSTAT_ERR" &
    fi
    TURBOSTAT_BG=$!
    TURBOSTAT_AVAILABLE=1
fi

# Wait for perf stat (= workload) to finish
wait "$PERF_BG"
[ -n "$CCD_BG" ] && wait "$CCD_BG" 2>/dev/null

# Stop turbostat: use sudo pkill (turbostat runs as root, only root can signal it)
if [ -n "$TURBOSTAT_BG" ]; then
    sudo pkill -SIGINT turbostat 2>/dev/null || sudo kill "$TURBOSTAT_BG" 2>/dev/null
    wait "$TURBOSTAT_BG" 2>/dev/null
fi
rm -f "$TURBOSTAT_ERR"

# Parse all events from the single perf output file into E[]
parse_perf_output "$PERF_OUTPUT"
rm -f "$PERF_OUTPUT" "$WL_PID_FILE"

# Extract CCD placement results from JSON
PEAK_CPUS="?"; CORES_SEEN="?"; N_CCDS="?"; CROSS_CCD="?"; EXEC_MODE="?"
if [ -f "$PLACEMENT_JSON_TMP" ]; then
    PEAK_CPUS=$(python3 -c "import json; d=json.load(open('$PLACEMENT_JSON_TMP')); print(d.get('peak_parallel_cpus','?'))" 2>/dev/null || echo "?")
    CORES_SEEN=$(python3 -c "import json; d=json.load(open('$PLACEMENT_JSON_TMP')); print(d.get('unique_cores_seen','?'))" 2>/dev/null || echo "?")
    N_CCDS=$(python3 -c "import json; d=json.load(open('$PLACEMENT_JSON_TMP')); print(d.get('n_ccds_used','?'))" 2>/dev/null || echo "?")
    CROSS_CCD=$(python3 -c "import json; d=json.load(open('$PLACEMENT_JSON_TMP')); print('YES' if d.get('cross_ccd_execution') else 'NO')" 2>/dev/null || echo "?")
    EXEC_MODE=$(python3 -c "import json; d=json.load(open('$PLACEMENT_JSON_TMP')); print(d.get('execution_mode','?'))" 2>/dev/null || echo "?")
    rm -f "$PLACEMENT_JSON_TMP"
fi

# =============================================================================
# SECTION 0: CPU FREQUENCY & UTILIZATION
# =============================================================================
hdr
echo "  SECTION 0: CPU Frequency & Utilization"
echo "  Effective values measured during workload execution"
hdr
echo ""

TASK_CLOCK_RAW=${E["task-clock"]:-0}
TASK_CLOCK_UNIT=${E["task-clock__unit"]:-msec}
CPU_CYCLES_S0=${E["cpu-cycles"]:-1}
INSTRS_S0=${E["instructions"]:-0}
CPUS_UTILIZED=${E["task-clock__metric"]:-0}

# Detect task-clock unit: newer perf versions report in nanoseconds (ns/nsec),
# older versions report in milliseconds (msec/ms).
# Formula:
#   ns unit:   cycles / task_clock_ns  = GHz  (cycles/ns = GHz directly)
#   ms unit:   cycles / (task_clock_ms * 1e6) = GHz
# Detect actual unit by magnitude — perf sometimes reports ns but labels unit as "msec".
# If raw value / 1e9 < 3600 (1 hour), it's nanoseconds; otherwise milliseconds.
# cycles/ns = GHz directly; cycles/(ms*1e6) = GHz for ms.
if [[ "$TASK_CLOCK_UNIT" == "ns" || "$TASK_CLOCK_UNIT" == "nsec" ]]; then
    EFF_FREQ_GHZ=$(calcf "($CPU_CYCLES_S0 / $TASK_CLOCK_RAW)" 3)
    TASK_CLOCK_MS=$(calcf "($TASK_CLOCK_RAW / 1e6)" 1)   # ns→ms for display
elif python3 -c "import sys; sys.exit(0 if $TASK_CLOCK_RAW / 1e9 < 3600 else 1)" 2>/dev/null; then
    # Unit field says msec but magnitude is nanoseconds (perf version bug)
    TASK_CLOCK_UNIT="ns(detected)"
    EFF_FREQ_GHZ=$(calcf "($CPU_CYCLES_S0 / $TASK_CLOCK_RAW)" 3)
    TASK_CLOCK_MS=$(calcf "($TASK_CLOCK_RAW / 1e6)" 1)
else
    EFF_FREQ_GHZ=$(calcf "($CPU_CYCLES_S0 / ($TASK_CLOCK_RAW * 1e6))" 3)
    TASK_CLOCK_MS="$TASK_CLOCK_RAW"
fi

CPU_UTIL_PCT=$(calcf "($CPUS_UTILIZED / $TOTAL_CORES) * 100" 2)
CPUS_UTIL_ABS=$(calcf "$CPUS_UTILIZED" 3)

printf "  %-40s %12s GHz\n" "Eff. Freq (perf cycles/task-clock)"   "$EFF_FREQ_GHZ"
printf "  %-40s %12s CPUs\n" "CPUs Utilized (perf task-clock)"     "$CPUS_UTIL_ABS"
printf "  %-40s %14s%%\n"   "System Util (utilized / $TOTAL_CORES cores)"  "$CPU_UTIL_PCT"
sep
printf "  %-40s %12s ms\n"  "task-clock CPU time"                  "$TASK_CLOCK_MS"
printf "  %-40s %14s\n"     "task-clock unit (raw perf)"           "$TASK_CLOCK_UNIT"
printf "  %-40s %15.0f\n"   "Total Cores on System"                $TOTAL_CORES
echo ""
echo "  Note: System Util = CPUs utilized / all system cores."
echo "        Single-threaded workload on 96-core system = ~1% system util — expected."
echo "        See Section 0a for per-core Busy% (utilization of the active core only)."
echo "        Eff. Freq uses perf cycles/task-clock; Bzy_MHz below is APERF/MPERF cross-check."
echo ""

# =============================================================================
# SECTION 0a: TURBOSTAT — Per-core Aperf/Mperf frequency + power
# Runs concurrently with the workload. Needs sudo.
# Bzy_MHz = frequency only when core is busy (Aperf/Mperf derived).
# This is the same method turbostat-C uses; it is the gold standard for
# measuring effective boost under load on AMD EPYC.
# =============================================================================
hdr
echo "  SECTION 0a: Core Frequency & Power (turbostat — Aperf/Mperf)"
echo "  Bzy_MHz = busy-only frequency (Aperf/Mperf ratio × TSC) — gold standard"
echo "  CPU_W = per-core watts  |  PkgWatt = socket package  |  SysWatt = SoC total"
hdr
echo ""

if [ "$TURBOSTAT_AVAILABLE" -eq 1 ] && [ -s "$TURBOSTAT_OUT" ]; then
    # Parse turbostat output: filter to cores that ran the workload
    # Pass the list of unique cores seen from CCD placement
    python3 -c "
import sys, os

turbostat_file = '$TURBOSTAT_OUT'
cores_seen_str = '$CORES_SEEN'   # e.g. '7' or '0,4,8,12'

# Parse turbostat TSV output; handle multi-interval runs (average across intervals)
# turbostat output has a header line then data lines with blank-line-separated intervals
cols = []
intervals = []  # list of dicts per interval (core -> row)

current_interval = {}
header_found = False
with open(turbostat_file) as f:
    for line in f:
        line = line.rstrip()
        if not line:
            if current_interval:
                intervals.append(current_interval)
                current_interval = {}
            continue
        parts = line.split()
        if parts and parts[0] == 'Core' and not header_found:
            cols = parts
            header_found = True
            continue
        if parts and parts[0] == 'Core' and header_found:
            # New interval header — save previous
            if current_interval:
                intervals.append(current_interval)
            current_interval = {}
            continue
        if not header_found or not parts:
            continue
        try:
            row = dict(zip(cols, parts))
            core_id = row.get('Core', '-')
            cpu_id  = row.get('CPU', '-')
            current_interval[cpu_id] = row
        except Exception:
            pass

if current_interval:
    intervals.append(current_interval)

if not intervals:
    print('  [!] turbostat: no data captured (workload may have finished before first sample)')
    sys.exit(0)

# Merge intervals: average most fields; peak for Bzy_MHz.
# Averaging Bzy_MHz is misleading when a thread migrates: while the thread
# is on another core, this core has Busy%~0 and its Bzy_MHz is meaningless.
# Peak Bzy_MHz = highest frequency seen when the core was actually executing.
PEAK_COLS = {'Bzy_MHz'}

merged = {}
for interval in intervals:
    for cpu_id, row in interval.items():
        if cpu_id not in merged:
            merged[cpu_id] = {k: [] for k in row}
        for k, v in row.items():
            merged[cpu_id][k].append(v)

averaged = {}
for cpu_id, fields in merged.items():
    averaged[cpu_id] = {}
    for k, vals in fields.items():
        try:
            numeric = [float(v) for v in vals]
            if k in PEAK_COLS:
                averaged[cpu_id][k] = max(numeric)
            else:
                averaged[cpu_id][k] = sum(numeric) / len(numeric)
        except ValueError:
            averaged[cpu_id][k] = vals[-1]

# Determine which CPUs ran the workload
# From CCD placement: cores_seen_str may be a count string ('7') or comma list
# Prefer to show all CPUs with Busy% > 5%
busy_cpus = {cpu_id: row for cpu_id, row in averaged.items()
             if float(row.get('Busy%', 0)) > 5.0}

# Find the summary row (Core = '-' or first row which is system summary)
# turbostat puts a summary row at the top of each interval with no Core value
summary_rows = {cpu_id: row for cpu_id, row in averaged.items()
                if str(row.get('Core', '')).strip() == '-' or cpu_id == '-'}

# Detect which power/watt column exists (varies by turbostat version)
def get_float(row, *keys):
    for k in keys:
        try:
            v = float(row.get(k, 0))
            if v != 0:
                return v, k
        except: pass
    return 0.0, keys[0]

# Print busy core table
if busy_cpus:
    # Check which per-core power column is available
    sample_row = next(iter(busy_cpus.values()))
    has_cpuw = any(k in sample_row for k in ('CPU_W', 'CoreTmp'))
    if 'CPU_W' in sample_row:
        pwr_col = 'CPU_W'; pwr_lbl = 'CPU_W'
    elif 'CoreTmp' in sample_row:
        pwr_col = 'CoreTmp'; pwr_lbl = 'CoreTmp'
    else:
        pwr_col = None; pwr_lbl = None

    print('  Busy cores (Busy%% > 5%%) -- %d core(s):' % len(busy_cpus))
    hdr_line = '  %5s  %5s  %8s  %11s  %9s' % ('CPU','Core','Busy%avg','Bzy_MHz(pk)','Avg_MHz')
    if pwr_col:
        hdr_line += '  %9s' % pwr_lbl
    print(hdr_line)
    sep_len = 52 + (12 if pwr_col else 0)
    print('  ' + '-'*sep_len)
    for cpu_id in sorted(busy_cpus.keys(), key=lambda x: int(x) if str(x).isdigit() else 0):
        row = busy_cpus[cpu_id]
        busy  = float(row.get('Busy%', 0))
        bzy   = float(row.get('Bzy_MHz', 0))
        avg   = float(row.get('Avg_MHz', 0))
        core  = row.get('Core', '?')
        line  = f'  {cpu_id:>5}  {core:>5}  {busy:>7.1f}%  {bzy:>10.0f}  {avg:>8.0f}'
        if pwr_col:
            try:
                pval = float(row.get(pwr_col, 0))
                if pwr_col == 'CoreTmp':
                    line += f'  {pval:>8.0f} °C'
                else:
                    line += f'  {pval:>8.3f} W'
            except:
                line += f'  {\"N/A\":>9}'
        print(line)
else:
    print('  No cores with Busy% > 5% detected (workload may have been too brief for turbostat sampling).')

# Print package/system summary
print()
# Find package summary row(s): PkgWatt and SysWatt
all_rows_list = list(averaged.values())
pkg_watt = 0.0
sys_watt = 0.0
for row in all_rows_list:
    try:
        pw = float(row.get('PkgWatt', 0))
        if pw > pkg_watt:
            pkg_watt = pw
    except: pass
    try:
        sw = float(row.get('SysWatt', 0))
        if sw > sys_watt:
            sys_watt = sw
    except: pass

if pkg_watt > 0:
    print(f'  Package Power:  {pkg_watt:.1f} W')
if sys_watt > 0:
    print(f'  System (SoC):   {sys_watt:.1f} W')
" 2>/dev/null
else
    if [ "$TURBOSTAT_AVAILABLE" -eq 0 ]; then
        echo "  [--] turbostat not available or sudo access not configured."
        echo "       To enable passwordless sudo for turbostat, run:"
        echo "         echo '$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/turbostat' | sudo tee /etc/sudoers.d/turbostat"
        echo "       Or run the script as root: sudo ./amd_pipeline_metrics.sh \"<cmd>\""
    else
        echo "  [--] turbostat ran but produced no output."
        echo "       Workload may have finished before the first 1-second sample."
        echo "       Try a longer workload (>5 sec) or run: sudo turbostat --interval 1 --quiet"
    fi
fi

# Extract max Bzy_MHz across busy cores for use in Section 5 summary
BZY_MHZ_MAX="N/A"
if [ "$TURBOSTAT_AVAILABLE" -eq 1 ] && [ -s "$TURBOSTAT_OUT" ]; then
    BZY_MHZ_MAX=$(python3 -c "
try:
    cols = []
    max_bzy = 0.0
    header_found = False
    with open('$TURBOSTAT_OUT') as f:
        for line in f:
            parts = line.split()
            if not parts: continue
            if parts[0] == 'Core' and not header_found:
                cols = parts; header_found = True; continue
            if not header_found: continue
            row = dict(zip(cols, parts))
            try:
                busy = float(row.get('Busy%', 0))
                bzy  = float(row.get('Bzy_MHz', 0))
                if busy > 5 and bzy > max_bzy:
                    max_bzy = bzy
            except: pass
    print(f'{max_bzy/1000:.3f}' if max_bzy > 0 else 'N/A')
except:
    print('N/A')
" 2>/dev/null)
fi

rm -f "$TURBOSTAT_OUT"
echo ""

# ---- Cloud Feff check -------------------------------------------------------
export _CLOUD_JSON_ENV="$CLOUD_JSON"
export _EFF_GHZ="$EFF_FREQ_GHZ"
export _FEFF_MIN="$CLOUD_FEFF_MIN"

if [ -n "$CLOUD_JSON" ] && [ "$CLOUD_FEFF_MIN" != "0" ] && [ "$EFF_FREQ_GHZ" != "N/A" ]; then
    python3 -c "
import json, sys, os

ctx_json = os.environ.get('_CLOUD_JSON_ENV', '')
try:
    eff_ghz  = float(os.environ.get('_EFF_GHZ', '0'))
    feff_min = float(os.environ.get('_FEFF_MIN', '0'))
    d = json.loads(ctx_json)
    fmax      = d.get('fmax_ghz', 4.0)
    ppl       = d.get('ppl_watts', 0)
    csp       = d.get('csp', 'unknown').upper()
    exp_ratio = d.get('feff_ratio', 0.90)
    exp_pct   = round((1 - exp_ratio) * 100, 1)
    ratio     = eff_ghz / fmax if fmax > 0 else 1.0
    act_pct   = round((1 - ratio) * 100, 1)
    emulated  = d.get('emulated', False)
    tag       = ' [EMULATED]' if emulated else ''

    if ratio < (exp_ratio - 0.05):
        print(f'  [!] FREQ THROTTLE{tag}: Feff {eff_ghz:.3f} GHz = {ratio*100:.1f}% of Fmax ({fmax:.1f} GHz)')
        if ppl > 0:
            print(f'      {csp} PPL {ppl}W => expected floor >={feff_min:.2f} GHz (>={exp_ratio*100:.0f}% of Fmax)')
    elif ppl > 0:
        print(f'  [OK] Feff {eff_ghz:.3f} GHz >= {csp} PPL{tag} floor ({feff_min:.2f} GHz, PPL={ppl}W)')
except Exception:
    pass
" 2>/dev/null
    echo ""
fi

# =============================================================================
# SECTION 0.5: CPU PLACEMENT & CCD TOPOLOGY
# =============================================================================
hdr
echo "  SECTION 0.5: CPU Placement & CCD Topology"
echo "  Which cores ran this workload, and which chiplets?"
hdr

if [ "$CLOUD_TOPO_VIS" = "obfuscated" ]; then
    echo "  [!] TOPOLOGY OBFUSCATED: CSP hides CCD/CCX boundaries on this instance."
    echo "      lstopo may show incorrect shared-L3 groupings. See cloud notes above."
elif [ "$CLOUD_TOPO_VIS" = "unreliable" ]; then
    echo "  [!] TOPOLOGY UNRELIABLE: Non-deterministic stack -- core-to-CCD may vary."
elif [ "$CLOUD_TOPO_VIS" = "none" ]; then
    echo "  [!] TOPOLOGY NOT EXPOSED: CSP does not surface CCD/CCX topology."
fi

if [ "$CLOUD_NUMA_CROSSING" = "true" ]; then
    echo "  [!] NUMA CROSSING: This guest vCPU count spans >1 socket."
    echo "      Cross-socket memory latency (~100 ns) will inflate Backend Memory%."
fi

echo ""

# =============================================================================
# SECTION 1: AMD PIPELINE UTILIZATION
# =============================================================================
hdr
echo "  SECTION 1: AMD Pipeline Utilization (Dispatch Slots)"
echo "  AMD dispatches up to 6 ops per cycle"
if [ "$CLOUD_SMT" = "true" ]; then
    echo "  NOTE: SMT ON -- 6 slots shared between 2 threads."
    echo "        Per-thread metrics reflect 2-thread execution context."
fi
hdr
echo ""

FRONTEND=${E["de_no_dispatch_per_slot.no_ops_from_frontend"]:-0}
BACKEND=${E["de_no_dispatch_per_slot.backend_stalls"]:-0}
DISPATCHED=${E["de_src_op_disp.all"]:-0}
RETIRED=${E["ex_ret_ops"]:-0}
CYCLES=${E["ls_not_halted_cyc"]:-1}

TOTAL_SLOTS=$(calc "$CYCLES * 6")
FRONTEND_PCT=$(calc "($FRONTEND / ($CYCLES * 6)) * 100")
BACKEND_PCT=$(calc "($BACKEND / ($CYCLES * 6)) * 100")
BADSPEC_PCT=$(calc "(($DISPATCHED - $RETIRED) / ($CYCLES * 6)) * 100")
RETIRING_PCT=$(calc "($RETIRED / ($CYCLES * 6)) * 100")

printf "  %-40s %15.0f\n" "Active CPU Cycles"              $CYCLES
printf "  %-40s %15.0f\n" "Total Dispatch Slots (6x)"      $TOTAL_SLOTS
sep
printf "  %-40s %14s%%\n" "Frontend Bound"                  "$FRONTEND_PCT"
printf "    %-38s %15.0f\n" "--- Unused Slots (Frontend)"  $FRONTEND
printf "  %-40s %14s%%\n" "Backend Bound"                   "$BACKEND_PCT"
printf "    %-38s %15.0f\n" "--- Unused Slots (Backend)"   $BACKEND
printf "  %-40s %14s%%\n" "Bad Speculation"                 "$BADSPEC_PCT"
printf "    %-38s %15.0f\n" "--- Dispatched Ops"           $DISPATCHED
printf "    %-38s %15.0f\n" "--- Retired Ops"              $RETIRED
printf "  %-40s %14s%%\n" "Retiring (Useful Work)"          "$RETIRING_PCT"
echo ""

# =============================================================================
# SECTION 2: BACKEND BREAKDOWN
# =============================================================================
hdr
echo "  SECTION 2: Backend Bound Breakdown"
echo "  Memory subsystem vs CPU execution stalls"
hdr
echo ""

LOAD_NOT_COMPLETE=${E["ex_no_retire.load_not_complete"]:-0}
NOT_COMPLETE=${E["ex_no_retire.not_complete"]:-1}
CYCLES2=${E["ls_not_halted_cyc"]:-1}

MEM_RATIO=$(calc "($LOAD_NOT_COMPLETE / $NOT_COMPLETE) * 100")
CPU_RATIO=$(calc "((1 - ($LOAD_NOT_COMPLETE / $NOT_COMPLETE)) * 100)")
BACKEND_MEM_PCT=$(calcf "(($BACKEND / ($CYCLES2 * 6)) * ($LOAD_NOT_COMPLETE / $NOT_COMPLETE)) * 100" 2)
BACKEND_CPU_PCT=$(calcf "(($BACKEND / ($CYCLES2 * 6)) * (1 - ($LOAD_NOT_COMPLETE / $NOT_COMPLETE))) * 100" 2)

printf "  %-40s %14s%%\n" "Backend Memory Bound"     "$BACKEND_MEM_PCT"
printf "    %-38s %14s%%\n" "--- Memory/Load ratio"   "$MEM_RATIO"
printf "  %-40s %14s%%\n" "Backend CPU Bound"        "$BACKEND_CPU_PCT"
printf "    %-38s %14s%%\n" "--- CPU stall ratio"     "$CPU_RATIO"
sep
printf "  %-40s %15.0f\n" "Load-not-complete events"  $LOAD_NOT_COMPLETE
printf "  %-40s %15.0f\n" "Total non-retire events"   $NOT_COMPLETE
echo ""

# Cloud Backend Memory annotation
if [ -n "$CLOUD_JSON" ] && [ "$BACKEND_MEM_PCT" != "N/A" ]; then
    export _BK_MEM="$BACKEND_MEM_PCT"
    python3 -c "
import json, sys, os

ctx_json = os.environ.get('_CLOUD_JSON_ENV', '')
bk_mem   = float(os.environ.get('_BK_MEM', '0'))

try:
    d   = json.loads(ctx_json)
    topo     = d.get('topology_vis', 'correct')
    smt      = d.get('smt_enabled', False)
    numa_x   = d.get('is_numa_crossing', False)
    csp      = d.get('csp', 'unknown').upper()
    family   = d.get('instance_family', '')
    emulated = d.get('emulated', False)
    tag      = ' [EMULATED]' if emulated else ''

    if bk_mem >= 20:
        if topo == 'unreliable':
            print(f'  [!] Backend Memory {bk_mem:.1f}%{tag}: Non-deterministic stack ({csp} {family}).')
            print(f'      May reflect NUMA/CCX misalignment by hypervisor -- not workload pressure.')
        elif numa_x:
            print(f'  [!] Backend Memory {bk_mem:.1f}%{tag}: NUMA boundary crossed on this instance.')
            print(f'      Remote-socket latency (~100 ns) likely contributing to memory-bound stalls.')
        elif smt:
            print(f'  [i] Backend Memory {bk_mem:.1f}%{tag}: SMT on -- sibling thread cache footprint')
            print(f'      may be evicting your L2 working set, inflating this metric.')
except Exception:
    pass
" 2>/dev/null
    echo ""
fi

# =============================================================================
# SECTION 3: BRANCH PREDICTION
# =============================================================================
hdr
echo "  SECTION 3: Branch Prediction"
if [ "$CLOUD_SMT" = "true" ]; then
    echo "  NOTE: SMT ON -- branch predictor shared; misprediction rate may be elevated."
fi
hdr
echo ""

MISP=${E["ex_ret_brn_misp"]:-0}
BRANCHES=${E["ex_ret_brn"]:-1}
CYCLES3=${E["cpu-cycles"]:-1}
INSTRS3=${E["instructions"]:-1}

MISP_RATE=$(calc "($MISP / $BRANCHES) * 100")
IPC=$(calcf "($INSTRS3 / $CYCLES3)" 3)
BRANCH_RATE=$(calc "($BRANCHES / $INSTRS3) * 100")

printf "  %-40s %14s%%\n" "Branch Misprediction Rate"      "$MISP_RATE"
printf "    %-38s %15.0f\n" "--- Mispredicted Branches"    $MISP
printf "    %-38s %15.0f\n" "--- Total Branches Retired"   $BRANCHES
sep
printf "  %-40s %15s\n"   "IPC (Instructions per Cycle)"   "$IPC"
printf "  %-40s %14s%%\n" "Branch Density (branches/instr)" "$BRANCH_RATE"
echo ""

if [ -n "$CLOUD_JSON" ] && [ "$IPC" != "N/A" ] && [ "$CLOUD_SMT" = "true" ]; then
    export _IPC="$IPC"
    python3 -c "
import os
ipc = float(os.environ.get('_IPC', '0'))
emulated = os.environ.get('_CLOUD_JSON_ENV', '{}')
import json
try:
    d = json.loads(emulated)
    tag = ' [EMULATED]' if d.get('emulated') else ''
    print(f'  [i] IPC {ipc:.3f}{tag}: SMT on -- per-thread IPC with sibling thread competing')
    print(f'      for dispatch slots and execution units. Single-thread IPC would be higher.')
except Exception:
    pass
" 2>/dev/null
    echo ""
fi

# =============================================================================
# SECTION 4: L2 CACHE
# =============================================================================
hdr
echo "  SECTION 4: L2 Cache (1 MB per core on Zen4/Zen5)"
if [ "$CLOUD_SMT" = "true" ]; then
    echo "  NOTE: SMT ON -- L2 capacity shared between sibling threads (effective ~512 KB)."
fi
hdr
echo ""

DC_HIT=${E["l2_cache_req_stat.dc_hit_in_l2"]:-0}
DC_MISS=${E["l2_cache_req_stat.ls_rd_blk_c"]:-0}
IC_MISS=${E["l2_cache_req_stat.ic_fill_miss"]:-0}
IC_HIT=${E["l2_cache_req_stat.ic_hit_in_l2"]:-0}

DC_HIT_RATE=$(calc "($DC_HIT / ($DC_HIT + $DC_MISS)) * 100")
IC_HIT_RATE=$(calc "($IC_HIT / ($IC_HIT + $IC_MISS)) * 100")

printf "  %-40s %14s%%\n" "L2 Data Cache Hit Rate"          "$DC_HIT_RATE"
printf "    %-38s %15.0f\n" "--- L2 DC Hits"                $DC_HIT
printf "    %-38s %15.0f\n" "--- L2 DC Misses (->L3/DRAM)" $DC_MISS
sep
printf "  %-40s %14s%%\n" "L2 Instruction Cache Hit Rate"   "$IC_HIT_RATE"
printf "    %-38s %15.0f\n" "--- L2 IC Hits"                $IC_HIT
printf "    %-38s %15.0f\n" "--- L2 IC Misses (->L3)"      $IC_MISS
echo ""

if [ -n "$CLOUD_JSON" ] && [ "$DC_HIT_RATE" != "N/A" ] && [ "$CLOUD_SMT" = "true" ]; then
    export _DC_HIT="$DC_HIT_RATE"
    python3 -c "
import os, json
l2h = float(os.environ.get('_DC_HIT', '100'))
ctx = os.environ.get('_CLOUD_JSON_ENV', '{}')
try:
    d = json.loads(ctx)
    tag = ' [EMULATED]' if d.get('emulated') else ''
    if l2h < 70:
        print(f'  [i] L2 DC Hit {l2h:.1f}%{tag}: SMT on -- sibling thread working set competes')
        print(f'      for L2 capacity. Single-thread hit rate would be higher.')
except Exception:
    pass
" 2>/dev/null
    echo ""
fi

# =============================================================================
# SECTION 5: SUMMARY
# =============================================================================
hdr
echo "  SECTION 5: Summary"
hdr
echo ""
printf "  %-40s %15s\n"   "Workload"                       "$WORKLOAD"
printf "  %-40s %12s GHz\n" "Eff. Freq (perf cycles/task-clock)" "$EFF_FREQ_GHZ"
if [ "$BZY_MHZ_MAX" != "N/A" ]; then
    printf "  %-40s %12s GHz\n" "Bzy_MHz (turbostat APERF/MPERF)"   "$BZY_MHZ_MAX"
else
    printf "  %-40s %15s\n"   "Bzy_MHz (turbostat APERF/MPERF)"     "N/A (no turbostat)"
fi
printf "  %-40s %14s%%\n" "CPU Utilization (system-wide)"   "$CPU_UTIL_PCT"
printf "  %-40s %15s\n"   "IPC"                             "$IPC"
sep
printf "  %-40s %14s%%\n" "Frontend Bound"                  "$FRONTEND_PCT"
printf "  %-40s %14s%%\n" "Backend Bound"                   "$BACKEND_PCT"
printf "    %-38s %14s%%\n" "Backend Memory"               "$BACKEND_MEM_PCT"
printf "    %-38s %14s%%\n" "Backend CPU"                  "$BACKEND_CPU_PCT"
printf "  %-40s %14s%%\n" "Bad Speculation"                 "$BADSPEC_PCT"
printf "  %-40s %14s%%\n" "Retiring (Useful Work)"          "$RETIRING_PCT"
sep
printf "  %-40s %14s%%\n" "Branch Misprediction Rate"       "$MISP_RATE"
printf "  %-40s %14s%%\n" "L2 DC Hit Rate"                  "$DC_HIT_RATE"
printf "  %-40s %14s%%\n" "L2 IC Hit Rate"                  "$IC_HIT_RATE"
sep
printf "  %-40s %15s\n"   "Peak Parallel CPUs"              "$PEAK_CPUS"
printf "  %-40s %15s\n"   "Unique Cores Seen"               "$CORES_SEEN"
printf "  %-40s %15s\n"   "CCDs Used"                       "$N_CCDS"
printf "  %-40s %15s\n"   "Cross-CCD Execution"             "$CROSS_CCD"
printf "  %-40s %15s\n"   "Execution Mode"                  "$EXEC_MODE"

if [ -n "$CLOUD_JSON" ]; then
    sep
    python3 -c "
import json, os
ctx = os.environ.get('_CLOUD_JSON_ENV', '{}')
try:
    d = json.loads(ctx)
    csp      = d.get('csp', 'unknown').upper()
    inst     = d.get('instance_type', '--')
    ppl      = d.get('ppl_watts', 0)
    pmc      = d.get('pmc_support', 'core')
    smt      = d.get('smt_enabled', False)
    emulated = d.get('emulated', False)
    tag      = ' [EMULATED]' if emulated else ''
    pmc_l    = {'full':'Full','core':'Core PMCs only','limited':'Limited','none':'NONE'}[pmc]
    ppl_l    = f'{ppl}W' if ppl else 'unconstrained'
    smt_l    = 'ON' if smt else 'OFF'
    print(f'  Cloud{tag}: {csp} {inst}')
    print(f'  PPL={ppl_l}  SMT={smt_l}  PMC={pmc_l}')
    if pmc == 'none':
        print('  [!] PMC data above is INVALID -- Oracle Cloud has no PMC support.')
except Exception:
    pass
" 2>/dev/null
fi

echo ""
hdr
echo ""
