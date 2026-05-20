# amd-perf-toolkit

Workload-agnostic AMD CPU performance analysis toolkit using Linux `perf stat` — pipeline utilization, CCD topology, L2 cache, branch prediction, and effective boost frequency. No PerfSpect installation required.

Targets AMD Zen4 (EPYC Genoa) and Zen5 (EPYC Turin) bare-metal and EC2 instances (M7A, M8A).

---

## Scripts

| Script | Output | Purpose |
|--------|--------|---------|
| `amd_pipeline_metrics.sh` | Terminal | Human-readable pipeline + CCD report |
| `amd_perf_html_report.py` | HTML | PerfSpect-style report with Chart.js visualizations |
| `amd_perf_excel_report.py` | Excel (.xlsx) | Netflix PerfSpect benchmark profile format |
| `amd_cpu_placement.py` | Terminal / JSON | CPU core placement and CCD topology monitor |

---

## Quick Start

```bash
# Terminal report — wrap any workload
./amd_pipeline_metrics.sh "openssl speed -elapsed aes-256-cbc"
./amd_pipeline_metrics.sh "dd if=/dev/zero of=/dev/null bs=1M count=1000"

# HTML report
python3 amd_perf_html_report.py "openssl speed md5" report.html
# Open report.html in any browser

# CCD topology — standalone
python3 amd_cpu_placement.py -- openssl speed -elapsed aes-256-cbc
python3 amd_cpu_placement.py --json -- ./my_benchmark   # JSON output
python3 amd_cpu_placement.py --pid 12345               # attach to running process
```

---

## What It Measures

### Pipeline Utilization (AMD dispatch slot model — 6 slots/cycle)

| Metric | Description |
|--------|-------------|
| Frontend Bound % | CPU waiting for instructions (fetch/decode stalls) |
| Backend Bound % | CPU waiting on execution units or memory |
| Bad Speculation % | Slots wasted on ops that don't retire (mispredictions) |
| Retiring % | Slots doing useful work — higher is better |

Backend is further subdivided into **Memory Bound** (load stalls) and **CPU Bound** (execution unit stalls).

### CPU Frequency & Utilization

Effective boost frequency derived from `cpu-cycles / task-clock` — the actual running frequency during the workload, not the static base clock from lscpu.

### CCD Topology & Core Placement

Tracks which CPU cores the workload uses during execution, maps them to CCD chiplets, and detects cross-CCD execution:

- **Peak parallel CPUs** — true thread-level parallelism
- **Unique cores seen** — includes OS context-switch migrations (a single-threaded workload may touch several cores over its lifetime without ever using more than one at a time)
- **Cross-CCD detection** — each AMD EPYC CCD has 8 cores sharing one 32 MB L3; cross-CCD execution introduces ~100 ns cache-to-cache latency

Topology source priority: `lstopo` (hwloc, most accurate) → sysfs `die_id` (reliable on Zen3+).

### Branch Prediction & IPC

Branch misprediction rate against AMD's TAGE predictor, and Instructions Per Cycle.

### L2 Cache

Data and instruction cache hit rates. AMD Zen4/5 has 1 MB L2 per core (vs Intel 256–512 KB).

---

## Confirmed Working Events (AMD Zen4 / Zen5 bare-metal)

```
# Pipeline
de_no_dispatch_per_slot.no_ops_from_frontend
de_no_dispatch_per_slot.backend_stalls
de_src_op_disp.all
ex_ret_ops
ls_not_halted_cyc

# Backend breakdown
ex_no_retire.load_not_complete
ex_no_retire.not_complete

# Branch
ex_ret_brn_misp
ex_ret_brn
cpu-cycles
instructions

# L2
l2_cache_req_stat.dc_hit_in_l2
l2_cache_req_stat.ls_rd_blk_c
l2_cache_req_stat.ic_fill_miss
l2_cache_req_stat.ic_hit_in_l2
```

> **Note:** `l3_lookup_state.*` events are not supported on all systems.

---

## Requirements

- Linux with `perf` installed (`perf stat -j` support)
- Python 3.8+
- `perf_event_paranoid` ≤ 1 (`sudo sysctl -w kernel.perf_event_paranoid=1`)
- For Excel output: `pip install openpyxl`
- For CCD topology: `lstopo` (hwloc, optional but recommended) or Zen3+ sysfs

---

## Reference Files

| File | Contents |
|------|----------|
| `perfspect_genoa_metrics.json` | Complete Genoa metric formulas from Intel PerfSpect |
| `AMD_OFFICIAL_PMC_EVENTS.md` | AMD Table 26 event codes (Family 19h) |
| `AMD_PMC_REGISTER_REFERENCE.md` | PMC register format reference |
| `amd_metric_groups.yaml` | PerfSpect AMD metric group structure |

---

## Architecture Notes

- Uses AMD's **6-slot dispatch model**, not Intel's 4-wide TopDown methodology
- Symbolic event names via `perf stat` (not raw hex masks)
- `perf stat -j` for JSON output → reliable Python parsing
- Effective frequency from `cpu-cycles / (task-clock_ms × 1e6)` — no MSR or root access required
- CPU utilization from `task-clock` metric-value ("CPUs utilized" float emitted by perf)

---

## Tested On

- AMD EPYC 9684X (Zen4, Genoa) — bare-metal
- AMD EPYC 9754 (Zen4, Genoa) — EC2 M7A
- AMD EPYC 9R14 (Zen5, Turin) — EC2 M8A
