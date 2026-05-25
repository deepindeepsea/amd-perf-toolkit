# amd-perf-toolkit

Workload-agnostic AMD EPYC performance analysis toolkit — pipeline utilization, CCD topology, L2 cache, branch prediction, effective boost frequency, multi-agent performance advisor, and live cloud pricing. No PerfSpect installation required.

Targets AMD Zen4 (EPYC Genoa) and Zen5 (EPYC Turin) on bare-metal and cloud (AWS M7A/M8A, GCP C4D/N2D, Azure ECads).

---

## Scripts

| Script | Output | Purpose |
|--------|--------|---------|
| `amd_pipeline_metrics.sh` | Terminal | Human-readable pipeline + CCD report |
| `amd_perf_html_report.py` | HTML | PerfSpect-style report with Chart.js visualizations |
| `amd_perf_excel_report.py` | Excel (.xlsx) | Netflix PerfSpect benchmark profile format |
| `amd_cpu_placement.py` | Terminal / JSON | CPU core placement and CCD topology monitor |
| `cloud_context.py` | Terminal / JSON | PPL-aware cloud context (CSP, PPL limit, Feff ratio) |
| `epyc_advisor.py` | Terminal / PPTX | Multi-agent performance advisor (routes to NABU agents) |
| `chip_compare.py` | Terminal / JSON | Live cloud instance pricing via Vantage Instances API |

---

## Quick Start

### Profiling a workload (bare-metal or cloud VM)

```bash
# Terminal report — wrap any workload
./amd_pipeline_metrics.sh "openssl speed -elapsed aes-256-cbc"
./amd_pipeline_metrics.sh "dd if=/dev/zero of=/dev/null bs=1M count=1000"

# Emulate cloud PPL limits in report output
./amd_pipeline_metrics.sh --emulate aws m7a.48xlarge "openssl speed aes-256-cbc"
./amd_pipeline_metrics.sh --emulate gcp c4d-standard-96 "stream"

# HTML report
python3 amd_perf_html_report.py "openssl speed md5" report.html

# CCD topology monitor
python3 amd_cpu_placement.py -- openssl speed -elapsed aes-256-cbc
python3 amd_cpu_placement.py --json -- ./my_benchmark
python3 amd_cpu_placement.py --pid 12345
```

### Live cloud pricing (Vantage Instances API)

```bash
# Single instance — on-demand, spot, reserved pricing
python3 chip_compare.py --instance m7a.large --region us-east-1
python3 chip_compare.py --instance m8a.48xlarge --region us-east-1
python3 chip_compare.py --gcp --instance n2d-standard-96 --region us-central1
python3 chip_compare.py --azure --instance Standard_D96as_v5 --region eastus

# Side-by-side comparison (sorted by on-demand price)
python3 chip_compare.py --compare m7a.48xlarge,m6i.48xlarge,c7a.48xlarge --region us-east-1
python3 chip_compare.py --compare m8a.48xlarge,m7a.48xlarge,r7a.48xlarge --region us-east-2

# All instances in an AMD family
python3 chip_compare.py --amd-family m7a --region us-east-1
python3 chip_compare.py --amd-family c7a --region us-west-2

# JSON output for scripting
python3 chip_compare.py --instance m7a.large --region us-east-1 --json
python3 chip_compare.py --compare m7a.large,m6i.large --region us-east-1 --json

# Import as module
from chip_compare import get_price, get_instance_details, compare_instances
price = get_price("aws", "m7a.large", "us-east-1")
print(price["on_demand"], price["spot_avg"])
```

### Multi-agent performance advisor

```bash
# Ask any performance question — routes to the right NABU agents automatically
python3 epyc_advisor.py "Which cloud provider has the best OpenSSL on 64 cores?"
python3 epyc_advisor.py "Why is my M7a throughput lower than expected?"
python3 epyc_advisor.py "What perf events should I capture for a Redis benchmark?"
python3 epyc_advisor.py "How does AMD Turin compare to Intel SPR on Redis?"
python3 epyc_advisor.py "Should I use M8A or C4D for memory-bound HPC?"

# Force a category
python3 epyc_advisor.py --category optimization "Tune NUMA binding for 192-core VM"
python3 epyc_advisor.py --category competitive "AMD vs Graviton3 on memory bandwidth"

# Generate a slide deck (on-demand — AMD dark theme)
python3 epyc_advisor.py --pptx "Compare M8A vs C4D for Redis throughput"
python3 epyc_advisor.py --pptx --output-dir ~/slides "AMD Turin cloud benchmarks"

# Interactive mode
python3 epyc_advisor.py --interactive

# List all categories and example questions
python3 epyc_advisor.py --list-categories
```

**Question categories routed automatically:**

| Category | Agents Used |
|----------|-------------|
| CSP Rankings & Benchmark Data | Cruncher, EPDW |
| Performance Analysis & Root Cause | Cruncher, EPDW, Playbook |
| Optimization & Tuning Methodology | Playbook |
| Competitive Intelligence | Competitive Intel, Cruncher |
| Cloud Architecture & Instance Selection | Cruncher, EPDW |

### Cloud context (PPL-aware frequency correction)

```bash
# Detect current cloud environment
python3 cloud_context.py

# Emulate a cloud instance context
python3 cloud_context.py --emulate aws m7a.48xlarge
python3 cloud_context.py --emulate gcp n2d-standard-96
python3 cloud_context.py --emulate azure Standard_D96as_v5
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

Effective boost frequency derived from `cpu-cycles / task-clock` — the actual running frequency during the workload, not the static base clock from `lscpu`.

### CCD Topology & Core Placement

Tracks which CPU cores the workload uses during execution, maps them to CCD chiplets, and detects cross-CCD execution:

- **Peak parallel CPUs** — true thread-level parallelism
- **Unique cores seen** — includes OS context-switch migrations
- **Cross-CCD detection** — each AMD EPYC CCD has 8 cores sharing one L3; cross-CCD introduces ~100 ns cache-to-cache latency

### Cloud PPL Correction (cloud_context.py)

Package Power Limit reduces effective frequency on cloud instances:

| CSP | PPL | Feff ratio |
|-----|-----|------------|
| AWS M7A / M8A | 320 W | 0.75 (25% below bare-metal boost) |
| GCP C4D | 400 W | 0.85 |
| Azure HBv4 | 400 W | 0.85 |
| Oracle OCI | 450 W | 0.88 |
| Bare-metal | — | 0.92 |

---

## Confirmed Working Events (AMD Zen4 / Zen5 bare-metal)

```
# Pipeline
de_no_dispatch_per_slot.no_ops_from_frontend
de_no_dispatch_per_slot.backend_stalls
de_src_op_disp.all / ex_ret_ops / ls_not_halted_cyc

# Backend breakdown
ex_no_retire.load_not_complete / ex_no_retire.not_complete

# Branch & IPC
ex_ret_brn_misp / ex_ret_brn / cpu-cycles / instructions

# L2 cache
l2_cache_req_stat.dc_hit_in_l2 / l2_cache_req_stat.ls_rd_blk_c
l2_cache_req_stat.ic_fill_miss / l2_cache_req_stat.ic_hit_in_l2

# Gap events (verified from playbook — add to next perf stat pass)
bp_l1_tlb_miss_l2_tlb_miss.all   # L2 ITLB miss PTI
ls_l1_d_tlb_miss.all             # L2 DTLB miss PTI
l2_request_g1.cacheable_ic_read  # instruction cache pressure
op_cache_hit_miss.op_cache_miss  # op-cache efficiency
ls_bad_status2.stli_other        # store-to-load interlock
```

> `l3_lookup_state.*` events are not supported on all systems — do not use.

---

## Requirements

- Linux with `perf` installed (`perf stat -j` support)
- Python 3.10+
- For Excel output: `pip install openpyxl`
- For CCD topology: `lstopo` (hwloc, optional) or Zen3+ sysfs
- For PPTX generation: `pip install python-pptx`
- For cloud pricing: Python stdlib only (chip_compare.py uses urllib)

### perf_event_paranoid — required before first run

`perf stat` needs access to hardware performance counters. The default Linux
setting on many distros (including Ubuntu 22.04+) blocks this. Check your
current value and set it to `-1` for full bare-metal PMC access:

```bash
# Check current value
cat /proc/sys/kernel/perf_event_paranoid

# Fix for current session
sudo sysctl kernel.perf_event_paranoid=-1

# Fix permanently (survives reboot)
echo 'kernel.perf_event_paranoid = -1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

| Value | Effect |
|-------|--------|
| `-1` | Full access — all PMC events, uncore, NDA events. **Use this on bare-metal perf machines.** |
| `0` | Hardware events allowed; raw/ftrace tracepoints blocked |
| `1` | CPU events blocked; software events (task-clock) allowed |
| `≥ 2` | Kernel profiling blocked |
| `4` | Everything blocked — `perf stat` returns nothing (all counters will show 0) |

If you see all-zero output from `amd_pipeline_metrics.sh`, run `cat /proc/sys/kernel/perf_event_paranoid` first — a value of 2 or higher is almost always the cause.

---

## Reference Files

| File | Contents |
|------|----------|
| `pmc_test/csp_enablement/KNOWLEDGE_BASE.md` | **Master PMC enablement knowledge base** — what works on which CSP / instance tier, per-event diagnosis map, public-vs-NDA PPR rules, S3 workflow |
| `pmc_test/csp_enablement/CLOUD_READINESS_PLAYBOOK.md` | Repeatable protocol for extending the PMC matrix to GCP / Azure / Oracle |
| `pmc_test/csp_enablement/AWS_4WAY_MATRIX.md` | m8a 2xl / 24xl / metal / on-prem sweep + L2-PF cross-generation addendum |
| `EPYC_PERF_KNOWLEDGE.md` | Full AMD EPYC Playbook knowledge base — L/M/H thresholds, perf events, tuning solutions |
| `perfspect_genoa_metrics.json` | Genoa metric formulas from PerfSpect |
| `AMD_OFFICIAL_PMC_EVENTS.md` | AMD Table 26 event codes (Family 19h) |
| `AMD_PMC_REGISTER_REFERENCE.md` | PMC register format reference |
| `amd_metric_groups.yaml` | PerfSpect AMD metric group structure |

## CSP enablement sweeps

Reusable sweep tooling for characterizing PMC support across cloud guests, partial-socket guests, full-socket guests, and bare metal:

| Script | Location | Purpose |
|---|---|---|
| `run_pmc.sh` | `pmc_test/csp_enablement/` + `s3://amd-pmc-toolkit-pradeepn/artifacts/` | Bootstrap wrapper — runs on any EC2 instance, fetches workload + sweep from S3, runs it, uploads result back. Uses IMDSv2 for instance metadata. |
| `sweep_runner.sh` | same | Generic `events.yaml` runner — default sweep |
| `l2pf_sweep.sh` | same | Full 7-umask grid for L2 hardware-prefetch events 0x70/0x71/0x72 |
| `l2pf_focus.sh` | same | 3-trial confirmation on 0x71/0x72 × 0x1F composite umask |
| `mhammer.c` | same | STREAM-style memory hammer (12-thread default) used as workload |

Results land in `s3://amd-pmc-toolkit-pradeepn/results/aws/{instance-type}/{instance-id}/{YYYY-MM-DD}/{sweep}.txt` and persist across instance termination. See `pmc_test/csp_enablement/KNOWLEDGE_BASE.md` for the complete workflow.

---

## NABU Agent IDs (AMD internal)

| Agent | ID | Coverage |
|-------|----|----------|
| EPYC Playbook | `9c936425-8ba1-4c7f-b5fe-dbcd1d8c5f9c` | Architecture, PMC methodology, L/M/H thresholds |
| Cruncher | `f7578702-ce56-4f3d-b746-448c6dd64e00` | AMD-validated cloud benchmark insights |
| EPDW | `6bb60d83-1310-4490-9c34-27b1b4f9f150` | Historical cloud benchmark data warehouse |
| Competitive Intel | `5e4eeb15-370a-448a-8474-0c03a15d994b` | AMD vs Intel/ARM/NVIDIA (restricted) |

---

## Architecture Notes

- Uses AMD's **6-slot dispatch model**, not Intel's 4-wide TopDown methodology
- Symbolic event names via `perf stat` — not raw hex masks
- `perf stat -j` JSON output → reliable Python parsing
- Effective frequency from `cpu-cycles / (task-clock_ms × 1e6)` — no MSR or root access required
- CPU utilization from `task-clock` metric-value ("CPUs utilized" float emitted by perf)

---

## Tested On

- AMD EPYC 9684X (Zen4, Genoa-X, 96-core) — bare-metal
- AMD EPYC 9754 (Zen4, Genoa) — EC2 M7A
- AMD EPYC 9R14 (Zen5, Turin) — EC2 M8A
