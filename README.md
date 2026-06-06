# amd-perf-toolkit

Workload-agnostic AMD EPYC performance analysis toolkit — pipeline utilization, CCD topology, L2 cache, branch prediction, effective boost frequency, and live cloud pricing. No PerfSpect installation required.

Targets AMD Zen4 (EPYC Genoa) and Zen5 (EPYC Turin) on bare-metal and cloud (AWS M7A/M8A, GCP C4D/N2D, Azure ECads).

---

## Scripts

| Script | Output | Purpose |
|--------|--------|---------|
| `amd_topdown.py` | Terminal / SQLite | Top-down (TMA) profiler with always-on memory-hierarchy counters — collect / list / query / compare runs |
| `amd_pipeline_metrics.sh` | Terminal | Human-readable pipeline + CCD report |
| `amd_perf_html_report.py` | HTML | PerfSpect-style report with Chart.js visualizations |
| `amd_perf_excel_report.py` | Excel (.xlsx) | Netflix PerfSpect benchmark profile format |
| `amd_cpu_placement.py` | Terminal / JSON | CPU core placement and CCD topology monitor |
| `cloud_context.py` | Terminal / JSON | PPL-aware cloud context (CSP, PPL limit, Feff ratio) |
| `chip_compare.py` | Terminal / JSON | Live cloud instance pricing via Vantage Instances API |

---

## Quick Start

### Top-down profiler with memory-hierarchy counters (`amd_topdown.py`)

`amd_topdown.py` runs the AMD 6-slot Top-down Microarchitecture Analysis (TMA)
funnel **and** an always-on memory-hierarchy block (L1D / L2 / dTLB, best-effort
L3) on every collect. Runs are stored in a SQLite database so you can list them,
view a single funnel, or compare any two side by side. See `MEMORY_HIERARCHY.md`
for what each counter means and how to read it.

| Subcommand | What it does |
|---|---|
| `collect` | Attach to a running process (or system-wide) for N seconds, store one run, print its run ID |
| `list` | List stored runs (run ID, label, timestamp) |
| `query` | Show the funnel + memory-hierarchy panel for one run (select by `--label`) |
| `compare` | Show two runs side by side (`compare <run_a_id> <run_b_id>`) |
| `export` | Dump one or more runs to a portable JSON file (self-describing: host, CPU, metrics, labels) |
| `import` | Load runs from an `export` JSON into a store (idempotent; `--new-id` to avoid ID clashes) |

The database location is set with `TOPDOWN_DB_PATH` (defaults to a temp path).
Use the same value for every command so they share one store.

#### How `collect` works

`collect` does **not** launch your workload — it attaches to one that is already
running. Start your benchmark in another shell, then point `collect` at it by
process name with `--process` (it resolves the PID for you); if the name is not
found it falls back to system-wide collection. Each `collect` prints a line like:

```
  ✓ Saved run cc1cb38067c0  (30.2s)  Labels: {'thp': 'never', ...}
```

That 12-character hex string is the **run ID** — that is where IDs like
`cc1cb38067c0` and `0d63019dd85d` come from. You pass two of them to `compare`.
You can always re-list them later with `list`.

#### `--process` vs `--cpu` — which scope to use

`collect` can attach the counters two different ways, and the right one depends
on whether your workload is **one multithreaded process** or **several separate
processes**:

- **`--process NAME`** resolves the name with `pgrep -x` and attaches `perf -p`
  to a single PID. That PID **and all of its threads** are counted while they run
  (the kernel saves/restores the counts across context switches and follows the
  threads across cores). This is correct for **one multithreaded process**.
  Caveat: if several processes share the name, `--process` attaches to only the
  **first** PID — the others are not counted. `collect` now prints a warning when
  it sees more than one match.
- **`--cpu LIST`** (e.g. `-C 0-7`) attaches `perf -C` to a fixed set of cores and
  counts **everything that runs on those cores, regardless of process** (and
  regardless of whether your task is context-switched out). This is the right mode
  for **multiple separate processes**, or any time you want a clean per-core view.
  Pin the work first (e.g. `taskset -c 0-7 ...`).

Quick way to tell which you have:

```bash
pgrep -x mybench          # one PID -> single process; several PIDs -> multiple processes
cat /proc/<pid>/status | grep Threads   # thread count of a single process
ps -eLf | grep mybench    # PID repeats with different LWP = one process, many threads
```

Rule of thumb: if `pgrep -x` returns more than one PID, prefer `--cpu 0-7` over
`--process`.


#### Worked example — THP off vs THP on (A/B)

This reproduces the comparison in `MEMORY_HIERARCHY.md`. The workload is a 2 GiB
single-thread random pointer chase pinned to one CCD (cores 0–7). Run A is with
transparent huge pages disabled, run B with them enabled.

```bash
export TOPDOWN_DB_PATH=$PWD/data.db

# ---- Run A: THP = never ---------------------------------------------------
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'
taskset -c 0-7 ./your_microbench &          # start workload in background
python3 amd_topdown.py collect \
    --process your_microbench --duration 30 \
    --label thp=never --label workload=mb2g_ccd1_mem
#   ✓ Saved run cc1cb38067c0   <-- this is run A's ID (yours will differ)
kill %1

# ---- Run B: THP = always --------------------------------------------------
sudo sh -c 'echo always > /sys/kernel/mm/transparent_hugepage/enabled'
taskset -c 0-7 ./your_microbench &
python3 amd_topdown.py collect \
    --process your_microbench --duration 30 \
    --label thp=always --label workload=mb2g_ccd1_mem
#   ✓ Saved run 0d63019dd85d   <-- this is run B's ID (yours will differ)
kill %1

# ---- Inspect ---------------------------------------------------------------
python3 amd_topdown.py list                 # re-list both run IDs any time

# Single-run funnel + memory walls (select by label):
python3 amd_topdown.py query \
    --label thp=never --label workload=mb2g_ccd1_mem --funnel

# Side-by-side compare — paste the two run IDs printed above:
python3 amd_topdown.py compare cc1cb38067c0 0d63019dd85d
```

The TMA funnel stays flat (~99% `Backend_Bound → Memory_Bound`) across both runs
because the workload is DRAM-latency-bound by construction. The win shows up only
in the memory-hierarchy block: dTLB page-table walks collapse and reloads shift
almost entirely onto huge pages. That blind-spot is exactly why the
memory-hierarchy counters exist.

### Sharing runs across machines (`export` / `import`)

Every run row is fully self-describing — it carries its own host, CPU model, CPU
family, metrics, labels, and raw event counts — so a run collected on one box can
be moved to another and compared without re-collecting. Use this to gather runs
from several cloud instances or lab boxes into one place.

```bash
# On each machine: export one or more runs to a portable JSON file
python3 amd_topdown.py export 4e971ffd5c6c -o genoa.json
python3 amd_topdown.py export <id1> <id2> -o many.json    # several runs, one file
python3 amd_topdown.py export <id> --db /path/to/data.db  # read from a specific store
python3 amd_topdown.py export <id>                        # no -o => JSON to stdout

# Copy the JSON files to one machine (scp/rsync/etc.), then import them
python3 amd_topdown.py import genoa.json turin.json genoax.json
#   ✓ imported run 4e971ffd5c6c  (ruby-942e, fam 25)
#   ✓ imported run 7a4e7cd7529e  (purico-f1d3, fam 26)
#   ✓ imported run 3823cae3d3b6  (host-ruby-de91, fam 25)
#   Imported 3 run(s).
```

`import` is idempotent: it preserves the original run ID, host, CPU, and timestamp
(`INSERT OR REPLACE`), so re-importing the same file just overwrites in place. Pass
`--new-id` to assign a fresh ID instead — useful when two machines happen to share
an ID, or when you want to keep a run twice. Both `export` and `import` accept
`--db PATH` to target a specific store instead of `$TOPDOWN_DB_PATH`.

#### Comparing runs that live in different databases

You don't have to consolidate at all — `compare` can pull each run from a
different store:

```bash
# Both runs from one shared store
python3 amd_topdown.py compare <id_a> <id_b> --db /path/to/all.db

# Each run from its own store (no consolidation needed)
python3 amd_topdown.py compare <id_a> <id_b> \
    --db-a /path/to/genoa.db --db-b /path/to/turin.db
```

`--db` sets the store for both runs; `--db-a` / `--db-b` override it per side.
`list` also accepts `--db` so you can inspect any store without exporting
`TOPDOWN_DB_PATH`.

### Cross-box snapshot — identical workload on three EPYC generations

Same workload, unchanged across all three boxes: one CCD loaded with

```bash
taskset -c 0-7 openssl speed -multi 8 -seconds 45 aes-256-cbc      # 8 procs, cores 0-7
python3 amd_topdown.py collect -C 0-7 -d 25 \
    --label workload=openssl-speed-aes256cbc --label scope=ccd0_cores0-7 --label multi=8
```

Each box's run was `export`ed, `import`ed into one store, and shown exactly as
`amd_topdown.py compare` prints it. Collected core-scoped (`perf -C 0-7`) so all
8 OpenSSL processes on the CCD are counted regardless of which core each lands on.
The run IDs in the output below map to:

- `0c888d2f` — Genoa, EPYC 9654 (Zen4)
- `1dff1171` — Genoa-X, EPYC 9684X (Zen4)
- `d9764b98` — Turin, EPYC 9555 (Zen5)

**Genoa (A) vs Genoa-X (B)** — same generation, effectively identical funnel
(working set fits in cache, so Genoa-X's larger L3 doesn't move the slots):

```text

  Comparing:  A = 0c888d2f (0c888d2f)
              B = 1dff1171 (1dff1171)

  Pipeline Slots (100%)                0c888d2f     1dff1171    Delta
  ─────────────────────────────────────────────────────────────────────────
  Frontend_Bound                  0.9%      0.9%   -0.1%  
  ├── Fetch_Latency               0.4%      0.3%   -0.1%  
  ├── Fetch_Bandwidth             0.6%      0.5%   -0.0%  
  Retiring                       63.3%     63.4%   ++0.1%  
  ├── Light_Operations           62.3%     62.4%   ++0.1%  
  ├── Heavy_Operations            1.0%      1.0%   -0.0%  
  Backend_Bound                  35.8%     35.8%   ++0.1%  
  ├── Memory_Bound                0.2%      0.2%   -0.0%  
  ├── Core_Bound                 35.6%     35.7%   ++0.1%  
  Bad_Speculation                 0.0%      0.0%   ++0.0%  
  ├── Branch_Mispredicts          0.0%      0.0%   ++0.0%  
  ├── Machine_Clears              0.0%      0.0%   ++0.0%  
  ─────────────────────────────────────────────────────────────────────────
  Useful work (Retiring)                63.3%     63.4%   +0.1%
  IPC (instructions/cycle)             3.705     3.710    ×1.00

  Memory Hierarchy (AMD perf counts)
                                 0c888d2f     1dff1171     Factor / Delta
  ─────────────────────────────────────────────────────────────────────────
  L1D fills (misses)                 62.68M       47.83M   ÷1  (B fewer)
  ├── from DRAM                       1.74M        1.20M   ÷1  (B fewer)
  dTLB page-table walks             953.81K      625.38K   ÷2  (B fewer)
  TLB reloads 2M (huge)             772.84K      301.86K   ÷3  (B fewer)
  L2 hit rate (all)                   94.7%        92.7%   -1.9pp
  L2 hit rate (data)                  93.7%        88.3%   -5.4pp
  L3 hit rate                          n/a          n/a    n/a
  dTLB walk rate                      26.4%        49.6%   +23.2pp
  huge-page reload share              34.0%        36.8%   +2.9pp
```

**Genoa (A) vs Turin (B)** — Zen4 vs Zen5; same IPC (3.71), slightly lower
Retiring on Turin, far fewer L1D fills and DRAM fetches:

```text

  Comparing:  A = 0c888d2f (0c888d2f)
              B = d9764b98 (d9764b98)

  Pipeline Slots (100%)                0c888d2f     d9764b98    Delta
  ─────────────────────────────────────────────────────────────────────────
  Frontend_Bound                  0.9%      1.9%   ++0.9%  ← regression
  ├── Fetch_Latency               0.4%      1.9%   ++1.5%  ← regression
  ├── Fetch_Bandwidth             0.6%      0.0%   -0.6%  
  Retiring                       63.3%     60.8%   -2.5%  ← less useful work
  ├── Light_Operations           62.3%     59.9%   -2.4%  
  ├── Heavy_Operations            1.0%      1.0%   -0.0%  
  Backend_Bound                  35.8%     70.6%   ++34.8%  ← regression
  ├── Memory_Bound                0.2%      0.2%   -0.0%  
  ├── Core_Bound                 35.6%     70.4%   ++34.8%  
  Bad_Speculation                 0.0%      0.0%   ++0.0%  
  ├── Branch_Mispredicts          0.0%      0.0%   -0.0%  
  ├── Machine_Clears              0.0%      0.0%   ++0.0%  
  ─────────────────────────────────────────────────────────────────────────
  Useful work (Retiring)                63.3%     60.8%   -2.5%
  IPC (instructions/cycle)             3.705     3.710    ×1.00

  Memory Hierarchy (AMD perf counts)
                                 0c888d2f     d9764b98     Factor / Delta
  ─────────────────────────────────────────────────────────────────────────
  L1D fills (misses)                 62.68M       27.65M   ÷2  (B fewer)
  ├── from DRAM                       1.74M      241.17K   ÷7  (B fewer)
  dTLB page-table walks             953.81K      560.55K   ÷2  (B fewer)
  TLB reloads 2M (huge)             772.84K       82.44K   ÷9  (B fewer)
  L2 hit rate (all)                   94.7%        97.7%   +3.1pp
  L2 hit rate (data)                  93.7%        88.2%   -5.5pp
  L3 hit rate                          n/a          n/a    n/a
  dTLB walk rate                      26.4%        83.9%   +57.5pp
  huge-page reload share              34.0%        50.6%   +16.6pp

  ✗ Regressions in B:
    Frontend_Bound: +0.9%
    ├── Fetch_Latency: +1.5%
    Retiring: -2.5%
    Backend_Bound: +34.8%
```

> **Caveat — Turin Backend_Bound is over-scaled.** Its level-1 funnel sums to
> ~133%, not 100% (`Backend_Bound` 70.6% in its own run), because that metric is
> mis-scaled on Zen5 (family 26 / 1Ah) in this build. So the `Backend_Bound:
> +34.8%` regression line above is a scaling artifact, not a real backend
> difference. Treat **Retiring and IPC** as the reliable cross-generation
> numbers; Genoa and Genoa-X (both Zen4) sum cleanly to ~100%. L3 hit rate reads
> `n/a` on all three (CCX-scope L3 events not captured in the `-C` config).

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

# Gap events (verified — add to next perf stat pass)
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

---

## Complete script reference

Every executable in the repo, grouped by role, with its purpose and how to run
it. The seven tools in the [Scripts](#scripts) table above are the supported,
workload-agnostic core; everything below it is either a deeper analysis tool or a
benchmark/sweep driver used to produce the data sets in this repo.

### Core analysis tools

| Script | Run it | What it does |
|---|---|---|
| `amd_topdown.py` | `TOPDOWN_DB_PATH=runs.db python3 amd_topdown.py collect --process <name> --seconds 30 --label thp=never` | AMD 6-slot Top-down (TMA) funnel **plus** an always-on memory-hierarchy block (L1D / L2 / dTLB, best-effort L3). Stores each run in SQLite; `list` / `query --label <l>` / `compare <idA> <idB>` / `export` / `import` let you keep, view, diff, and move runs between machines. See the [Top-down](#top-down-profiler-with-memory-hierarchy-counters-amd_topdownpy) and [export/import](#sharing-runs-across-machines-export--import) sections above. |
| `amd_pipeline_metrics.sh` | `./amd_pipeline_metrics.sh "openssl speed aes-256-cbc"` | The headline collector. Wraps any workload in `perf stat`, derives the pipeline-utilization funnel, effective boost frequency, L2 / branch / IPC metrics, CCD placement, plus host context (running daemons, notable `dmesg`/microcode lines). `--emulate <csp> <instance>` overlays cloud PPL limits. Emits a metadata JSON consumed by `amd_perf_html_analyze.py`. |
| `amd_perf_html_report.py` | `python3 amd_perf_html_report.py "openssl speed md5" report.html` | Self-contained PerfSpect-style HTML report with sidebar nav, tables, and Chart.js charts. Collects its own `perf stat` pass over the given workload. |
| `amd_perf_html_analyze.py` | invoked by `amd_pipeline_metrics.sh` (`--from-env out.html KEY=val ... METADATA_JSON=$META_JSON`) | The HTML renderer behind the collector. Reads the metadata JSON (`load_meta`) and builds each section (`build_meta_section`), including the Daemons and Kernel-Messages panels. Not normally run by hand. |
| `amd_perf_excel_report.py` | `python3 amd_perf_excel_report.py --workload "openssl speed aes-256-cbc" --label "Genoa" --output report.xlsx` | Netflix/PerfSpect-style `.xlsx` profile. One column per system; `--merge a.json b.json` puts two systems side by side (run with `--json-only` on each box first), or `--workload2/--label2` compares two workloads on one box. |
| `amd_cpu_placement.py` | `python3 amd_cpu_placement.py -- ./my_benchmark` | Tracks every core a workload touches (including scheduler migrations) and maps them to CCDs; reports peak parallel CPUs, unique cores seen, and cross-CCD execution. `--pid <pid>`, `--duration`, `--json`, `--json-file` supported. |
| `cloud_context.py` | `python3 cloud_context.py --emulate aws m8a.8xlarge` | Detects (or emulates) a cloud environment and reports how it changes metric interpretation: PPL -> effective-frequency ceiling, SMT, virtualization stack, PMC availability, NUMA boundary, topology visibility. `--json` for shell parsing; importable as a module. |
| `epyc_advisor.py` | `python3 epyc_advisor.py "Best OpenSSL cloud on 64 cores?"` | Routes a performance question across five categories to the right NABU agents, synthesizes an answer, and optionally builds a PPTX (`--pptx`). `--category`, `--interactive`, `--list-categories`. AMD-internal (needs NABU access). |
| `chip_compare.py` | `python3 chip_compare.py --compare m8a.48xlarge,m7a.48xlarge --region us-east-1` | Live cloud instance pricing/specs (AWS, GCP, Azure) via the Vantage Instances API -- on-demand / spot / reserved. `--instance`, `--amd-family`, `--gcp`, `--azure`, `--json`; importable (`get_price`, `compare_instances`). |

### PMC validation harness (`pmc_test/`)

Validates AMD Zen4/Zen5 core PMCs against the PPR and PerfSpect using a battery
of microbenchmarks. Start here: `pmc_test/README.md`.

| Script | Run it | What it does |
|---|---|---|
| `pmc_test/run_on_genoa.sh` | `./pmc_test/run_on_genoa.sh [all\|programmability\|sanity\|bounds\|metrics\|ccd-scale\|ppr-extras]` | Single-shot driver. Checks `perf_event_paranoid`, installs PyYAML, builds the workloads, and runs the requested mode. |
| `pmc_test/run_pmc_tests.py` | `python3 pmc_test/run_pmc_tests.py --mode sanity` | The main validator -- programmability, sanity (per-subtest nonzero/expect-zero map), bounds, metrics, CCD-scale. Writes `results*/..._summary.json` + an HTML report. |
| `pmc_test/run_pmc_metrics.py` | `python3 pmc_test/run_pmc_metrics.py --min-seconds 30 --workloads fp_avx,branch_random --metrics metrics/table58_pipeline_zen5.yaml` | Evaluates BRH Table 58 pipeline composite metrics from raw `cpu/event=,umask=/` codes (bypasses the perf JSON catalog -- works on Nitro-filtered guests). |
| `pmc_test/run_pmc_long.py` | `python3 pmc_test/run_pmc_long.py --min-seconds 30 --chunk-size 5` | Sanity validation with a guaranteed minimum collection window per perf invocation, eliminating "looked zero because the workload was too short" false negatives. |

#### Microbenchmark workloads (`pmc_test/workloads/`)

Built with `make -C pmc_test/workloads`. Each isolates one part of the pipeline
so a specific counter is forced to fire:

| Binary | Stresses |
|---|---|
| `fp_avx` | FP/SSE/AVX retire pipe |
| `branch_random` | branch mispredictions |
| `l2_pressure` | L1->L2 spill (~512 KB working set) |
| `dram_stream` / `stream` | memory subsystem (working set > L3) |
| `tlb_thrash` | DTLB exhaustion (many distinct 4K pages) |
| `ccd_pingpong` | cross-thread cacheline ping-pong (false sharing) |
| `syscall_heavy` | kernel-side stalls, interrupts, mode switches |

### CSP enablement sweeps (`pmc_test/csp_enablement/`)

Characterizes which PMCs survive on cloud guests vs bare metal. Knowledge base:
`pmc_test/csp_enablement/KNOWLEDGE_BASE.md`; protocol:
`CLOUD_READINESS_PLAYBOOK.md`.

| Script | Run it | What it does |
|---|---|---|
| `run_pmc.sh` | `./run_pmc.sh [sweep_runner]` | Bootstrap wrapper for any EC2 instance -- uses IMDSv2 to tag the run, fetches workload + sweep from S3, runs it, uploads results to `s3://amd-pmc-toolkit-pradeepn/results/aws/...`. |
| `sweep_runner.sh` | `./sweep_runner.sh` | Generic `events.yaml` sweep; self-installs gcc and builds the memory hammer. |
| `l2pf_sweep.sh` | `./l2pf_sweep.sh` | Full 7-umask grid for L2 hardware-prefetch events 0x70/0x71/0x72. |
| `l2pf_focus.sh` | `./l2pf_focus.sh` | 3-trial confirmation run on 0x71/0x72 x 0x1F composite umask. |
| `build_csp_matrix.py` | `python3 build_csp_matrix.py` | Builds the cross-CSP enablement matrix from `public_ppr_coverage.csv`; tags each (event, umask) with a P0/P1/P2 severity and a per-CSP support column. Emits `csp_matrix.{csv,json}`. |
| `render_csp_report.py` | `python3 render_csp_report.py [aws_m8a]` | Renders per-CSP Markdown + HTML enablement reports (shippable as vendor asks) from `csp_matrix.json`. |
| `mhammer.c` | built by the sweeps | STREAM-style multi-threaded memory hammer used as the sweep workload. |

### PMC dataset extractors (`pmc_datasets/`)

Turn AMD PPR sources into diffable per-event JSON/Markdown (`code`, `name`,
`symbolic`, `category`, `description`, `unit_masks[]`).

| Script | Run it | What it does |
|---|---|---|
| `extract_ppr_pdf.py` | `python3 extract_ppr_pdf.py ppr_RS_B2_nda_1.pdf 314 341 Genoa core ./Genoa` | Parses a PPR **PDF** volume/page-range into a core/l3/df dataset. |
| `extract_pprweb.py` | `python3 extract_pprweb.py /path/to/pprweb_root ./BRH BRH` | Parses an AMD **pprweb HTML** build into core + L3 + DF datasets (same schema, so PDF and HTML builds diff cleanly). |

### Benchmark & sweep drivers (AWS M8A Rails study)

These produced the M8A / Genoa-X data sets in `m8a_results/`, `sweep_plots/`, and
the analysis Markdown. Most are SSH-over-SSM wrappers that target a specific lab
EC2 instance (`i-082ca0124af7a18d0`) -- they encode that study's geometry and are
included for reproducibility rather than as general-purpose tools.

| Script | Purpose |
|---|---|
| `m8a_full_sweep_with_pmc.sh` | Full Genoa-X recipe ported to M8A: per-run PMC + HTML via `amd_pipeline_metrics.sh`, sweeps N=1,2,4,8,11 server CCDs across baseline/isolated/reuseport variants. |
| `m8a_genoa_style_sweep.sh` | Faithful port of the Genoa-X `benchmark_ccd_sweep.sh` to M8A.metal-24xl -- Puma across N CCDs, last CCD reserved for the `wrk` client. |
| `m8a_worker_scaling.sh` | Sweeps Puma `WEB_CONCURRENCY` (8->64) under heavy `wrk` load to find the RPS knee on Nitro. |
| `benchmark_ccd_pinned.sh` | Rails benchmark with Puma workers pinned per-CCD: `./benchmark_ccd_pinned.sh [all\|<n>]`. |
| `systematic_m8a_testing.sh` | 3x comprehensive CCD-scaling tests (1/2/4/8 CCDs + YJIT + jemalloc + CCD pinning). |
| `start_run3_and_optimizations.sh` | Completes the systematic run (Run 3 + optimization passes). |
| `aggressive_load_test.sh` / `genoa_style_load_test.sh` | High-traffic load generators matching the Genoa-X methodology. |
| `ccd_isolation_test.sh` | Server on CCD0 (cores 0-7), client on CCD1 (cores 8-15) to measure isolation. |
| `run_basic_test.sh` | Minimal CPU-utilization smoke test for the M8A Rails setup. |
| `monitor_m8a_testing.sh` | Watches an in-flight CCD-scaling test. |
| `setup_client_instance.sh` | Spins up a dedicated `wrk` client instance (c7a.8xlarge). |
| `generate_final_reports.sh` | Generates HTML + Excel reports from all completed runs. |
| `m8a_results/setup_rails_bench.sh` | One-shot, idempotent Rails+Puma+wrk provisioner (rbenv, Ruby 3.3.11, jemalloc). |
| `m8a_results/bench_2xl.sh` / `m8a_1ccd_7w_1c.sh` | 8-vCPU geometry bench (7 Puma cores 0-6, wrk core 7) emulating an m8a.2xlarge shape. |
| `m8a_results/pmc_during_bench.sh` | Captures the Zen5 PMC matrix on the Puma cores for 30 s while `wrk` drives load. |
