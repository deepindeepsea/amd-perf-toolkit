#!/usr/bin/env bash
# run_on_genoa.sh — single-shot driver for the PMC test harness.
# Usage:   ./run_on_genoa.sh [mode]
#   mode = programmability | sanity | bounds | metrics | ccd-scale | ppr-extras | all (default)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
MODE="${1:-all}"

echo "[$(date -u +%H:%M:%S)] host=$(uname -n)  ncpu=$(nproc)"
echo "[$(date -u +%H:%M:%S)] kernel=$(uname -r)  perf=$(perf --version 2>/dev/null | head -1 || echo MISSING)"
[[ -r /proc/cpuinfo ]] && grep -m1 "^model name" /proc/cpuinfo

# Check perf perms (paranoid kernels block PMC opens to non-root)
PE=$(cat /proc/sys/kernel/perf_event_paranoid 2>/dev/null || echo 99)
if (( PE > 1 )); then
  echo "WARN: perf_event_paranoid=$PE — many PMC events will be blocked." >&2
  echo "      Run as root, or:  sudo sysctl -w kernel.perf_event_paranoid=-1" >&2
fi

# Python deps
python3 -c "import yaml" 2>/dev/null || pip install --user pyyaml || pip install --break-system-packages pyyaml

# Build microbenchmarks
( cd "$HERE/workloads" && make -s ) || { echo "FAIL: microbench build"; exit 2; }

# Tools we'd like (best-effort install)
for pkg in stress-ng linux-tools-common ; do
  command -v "${pkg%%-*}" >/dev/null 2>&1 || true
done

mkdir -p "$HERE/results"
python3 "$HERE/run_pmc_tests.py" --mode "$MODE" --out "$HERE/results"

echo
echo "Latest HTML:    $(ls -1t $HERE/results/*_report.html  | head -1)"
echo "Latest summary: $(ls -1t $HERE/results/*_summary.json | head -1)"
