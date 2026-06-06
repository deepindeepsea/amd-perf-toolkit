# pmc_test — Genoa/Turin PMC validation harness

Validates AMD Zen4/5 core PMCs against the **PPR** and **PerfSpect** definitions
using a battery of microbenchmarks + known workloads. Runs on bare-metal
EPYC 9684X (96c/12-CCD Genoa-X) and on AWS m7a (Zen4 Genoa) / m8a (Zen5 Turin)
instances via SSM Run Command.

## Quick start (on EPYC 9684X)

```bash
cd amd-perf-toolkit/pmc_test
sudo sysctl -w kernel.perf_event_paranoid=-1   # one-time
./run_on_genoa.sh all
xdg-open results/*_report.html
```

## Quick start (on an AWS m7a / m8a via SSM)

```bash
# from a host with aws-cli + claude-ssm-ruby creds
IID=i-0e413ac968cdef1e2          # m7a.8xlarge / Zen4 Genoa
# IID=i-05e90313f50067922        # m8a.* / Zen5 Turin
aws ssm send-command --region us-west-2 \
  --document-name AWS-RunShellScript --instance-ids $IID \
  --parameters 'commands=["bash /tmp/setup_run.sh"]'   # uses ssm_deploy/setup_run.sh
```

## Modes

| Mode              | What it does |
|-------------------|--------------|
| `programmability` | `perf stat -e <evt> sleep 0.01` for every registered event; fail = kernel doesn't know the event |
| `sanity`          | Each event must be > 0 on its tagged workload |
| `bounds`          | `value/instructions` must be ≤ per-event soft cap (catches counters wildly off in units) |
| `metrics`         | Derived metrics (IPC, branch misp %, frontend/backend bound %, L2 hit rate, MPKI…) must fall inside per-workload bounds |
| `ccd-scale`       | Runs `ccd_pingpong` pinned (a) 1 core CCD0, (b) full CCD0, (c) CCD0+CCD1, and classifies each counter as `linear`, `saturating`, `cross_ccd_only`, `always_zero`, or `irregular` |
| `ppr-extras`      | `sanity` restricted to the 81 events that are in the PPR but **not** in `perfspect_genoa_metrics.json` — these are the ones stock PerfSpect doesn't exercise |
| `all`             | All of the above |

## Workloads (cache / branch / DRAM / cross-CCD coverage)

Each workload tag in `workload_cmd()` (`run_pmc_tests.py`) is tied to a set
of events in `events.yaml` via the `nonzero_on:` field. The bundled
microbenchmarks build automatically from `workloads/Makefile`; the
cache-stress and latency tools are picked up from the host PATH if present.

| Tag             | Source                | Stresses                              | Counters it lights up |
|-----------------|-----------------------|---------------------------------------|------------------------|
| `fp_avx`        | bundled C, AVX2/FMA   | FP/SIMD retire                        | `ex_ret_*`, `fp_*` |
| `branch_random` | bundled C             | Branch misprediction                  | `ex_ret_brn*`, `bp_*` |
| `l2_pressure`   | bundled C             | L1 spills into L2                     | `l2_cache_req_stat.dc_hit_in_l2` |
| `dram_stream`   | bundled C             | > L3 stream — DRAM + HW prefetch      | `l2_pf_*`, `ls_rd_blk*` |
| `tlb_thrash`    | bundled C             | 4K page churn                         | `bp_l1_tlb_*`, `bp_l2_tlb_miss` |
| `syscall_heavy` | bundled C             | Kernel mode-switch / interrupts       | `ex_ret_int`, `ls_int_taken` |
| `ccd_pingpong`  | bundled C, pthread    | False-shared cacheline ping-pong      | cross-CCD probe + `ls_dmnd_fills_from_sys` |
| `stream`        | bundled C (McCalpin)  | DRAM bandwidth (Copy/Scale/Add/Triad) | L1D→L2→L3→DRAM cascade, `de_no_dispatch_per_slot.backend_stalls` |
| `mlc_lat`       | Intel MLC binary      | Idle vs. loaded latency curve         | `all_data_cache_accesses`, `l2_cache_req_stat.*` |
| `mlc_bw`        | Intel MLC binary      | Per-pattern peak BW (rd/wr/2:1/1:1)   | DRAM + L3 |
| `mlc_c2c`       | Intel MLC binary      | Cache-to-cache latency matrix         | Cross-CCD probe — calibrated counterpart to `ccd_pingpong` |
| `stress_cache`  | `stress-ng`           | L3 contention under thread pressure   | DC fill, IC fill, L2 evictions |
| `lmbench`       | `lat_mem_rd`          | Pointer-chase L1→L2→L3→DRAM staircase | All DC events |
| `openssl`       | `openssl speed`       | AES-256-CBC end-to-end                | Default driver for `--mode metrics` |

> **MLC and STREAM are recommended for any cache/DRAM event you can't
> sanity-check with the bundled microbenchmarks.** STREAM at ARRAY_SIZE
> 32 MB vs 96 MB on Genoa-X separates 3D V-Cache (96 MB L3/CCD) from
> base L3 (32 MB) — useful as a Genoa-vs-Genoa-X regression check.


### Workload details

Each bundled microbenchmark is a single self-contained C file under
`workloads/` and takes optional positional arguments so you can resize its
footprint or iteration count. All defaults are chosen so the workload runs for
a few seconds and isolates one part of the core or memory hierarchy.

**`fp_avx`** — `fp_avx [iters]` (default 200M). A tight loop of two
256-bit `_mm256_fmadd_ps` (AVX2 fused multiply-add) operations per iteration,
with no memory traffic at all. It keeps the floating-point/SIMD retire pipe
fully saturated, so it is the cleanest driver for the FP op-retire counters
(`fp_ret_sse_avx_ops`, `fp_pack_ops_retired`, `sse_avx_ops_retired`,
`fp_ops_retired_by_width/type`). Because it is pure ALU work pinned to one
thread, it also doubles as the spinner for SMT-contention experiments: run two
copies on a core's two sibling threads to light up
`de_no_dispatch_per_slot.smt_contention` and `ex_no_retire.thread_not_selected`.

**`branch_random`** — `branch_random [bytes] [passes]` (default 64 MiB, 4
passes). It fills a byte array with deterministic pseudo-random values
(seeded `0xC0FFEE` so runs are repeatable), then walks it taking a
data-dependent branch (`if (a[i] & 1)`) on every element. The branch outcome is
effectively a coin flip, so the predictor mispredicts ~50% of the time —
maximising `ex_ret_brn_misp`, `ex_ret_brn_tkn_misp`,
`ex_ret_near_ret_mispred`, and the front-end redirect/flush counters
(`bp_de_redirect`, `bp_pred_flush`).

**`l2_pressure`** — `l2_pressure [bytes] [passes]` (default 768 KiB, 40000
passes). The working set is sized to overflow the 32 KiB L1-D but stay within
the 1 MiB/core L2 on Zen4/5, and it touches one element per 64-byte cache line.
The result is a stream of L1 misses that all hit in L2, which is exactly what
the L2 demand/hit counters need to see
(`l2_request_g1`, `l2_cache_req_stat.dc_hit_in_l2`, `l2_pf_hit_l2`).

**`dram_stream`** — `dram_stream [MB] [iters]` (default 512 MiB, 5 iters).
The buffer is far larger than the 96 MiB L3/CCD, so a read pass followed by a
write pass (one access per cache line) misses all caches and goes to DRAM,
exercising the demand-fill-from-system and hardware-prefetch paths
(`ls_dmnd_fills_from_sys`, `ls_any_fills_from_sys`, `ls_mab_alloc`,
`l2_cache_req_stat.ls_rd_blk_c`, `ls_hw_pf_dc_fills`).

**`tlb_thrash`** — `tlb_thrash [pages] [passes]` (default 65536 pages = 256
MiB at 4 KiB, 20 passes). It touches exactly one byte on each distinct 4 KiB
page, sweeping far more pages than the DTLB can hold, so nearly every access
forces an L2-TLB lookup and a page-table walk. This is the driver for the
data-TLB miss and tablewalker counters (`ls_l1_d_tlb_miss`, `ls_tablewalker`,
`bp_l1_tlb_miss_l2_tlb_*`). Run it under THP=always to instead light up the
2 MiB huge-page reload counters.

**`syscall_heavy`** — `syscall_heavy [iters]` (default 5M). A tight loop that
calls `clock_gettime(CLOCK_MONOTONIC)` every iteration and `getpid()` every
65536 iterations. The constant kernel entry/exit drives mode switches,
interrupts, and TLB activity on the kernel side
(`ls_int_taken`, `ls_rd_tsc`, `ls_tlb_flush`, `ic_oc_mode_switch`).

**`ccd_pingpong`** — `ccd_pingpong [threads] [iters]` (default 2 threads, 5M
iters). All threads hammer a single shared `atomic_long` counter, so the
cacheline holding it ping-pongs between cores (false sharing). When the threads
are pinned to *different* CCDs this becomes cross-CCD coherence and L3 traffic
that is completely invisible to a single-core or single-CCD run — making it the
key diagnostic for `ls_dmnd_fills_from_sys` (cross-CCD source) plus
`l2_cache_req_stat.ls_rd_blk_c`, `ls_wcb_close_flush`, and `ls_mab_alloc`. This
is also the workload `--mode ccd-scale` pins at 1 core / 1 CCD / 2 CCDs to
classify how each counter scales.

**`stream`** — `stream [MB] [ntimes]` (default 256 MiB, 10 iters). A minimal
McCalpin STREAM with three 64-byte-aligned `double` arrays; it times the Copy,
Scale, Add, and Triad kernels and reports the best (minimum-time) sustained
bandwidth in MB/s for each. It measures real DRAM read+write bandwidth and is
the recommended regression check for separating 3D V-Cache (96 MiB L3/CCD) from
base L3 on Genoa-X by varying the array size.

## Per-test raw output logs

Every `perf stat -j` invocation now writes a full log to
`results/raw/<ts>/<mode>_<workload>__<sha8>.log` containing:
- the exact perf command line,
- wall-clock duration and return code,
- complete perf JSON stream (per-event counter-value lines),
- workload stdout/stderr captured via `stderr=STDOUT`.

This is auditable per-(mode × event-chunk × workload) so you can re-derive
any number in the summary without re-running the test.

## What gets compared

- `events.yaml` — curated event registry, each entry tagged with: workload(s)
  that must drive it > 0, soft per-instruction cap, derived metric
  participation.
- `ppr_vs_perfspect_diff.json` — produced by `pmc_test/build_diff.py`;
  81 PPR-only events are flagged so the HTML report draws an orange border.
- Uncore (DF / L3) PMUs are **deliberately not validated here**; they require
  `amd_uncore` / `amd_l3pmu` drivers and are tracked separately.

## CCD scaling categories

When `mode=ccd-scale` runs the false-sharing `ccd_pingpong` workload at three
thread counts on pinned cores, each counter is classified:

| Class            | Meaning |
|------------------|---------|
| `linear`         | Roughly 8× from 1c → 1 CCD, ~2× from 1 CCD → 2 CCDs. Healthy per-core counter. |
| `saturating`     | Grows from 1c → 1 CCD but ≤ 1.5× from 1 CCD → 2 CCDs. Likely shared resource bottleneck. |
| `cross_ccd_only` | Near-zero intra-CCD, only fires when cores span CCDs. Typical of cross-CCD coherence traffic (e.g. `ls_dmnd_fills_from_sys`). **High-value diagnostic counters.** |
| `always_zero`    | Never increments. Either workload doesn't tag it, kernel multiplexing dropped it, or the event is broken on this stepping. |
| `irregular`      | Increments but doesn't fit linear/saturating/cross-CCD pattern. |

## Output

- `results/<ts>_summary.json` — full machine-readable matrix
- `results/<ts>_report.html`  — pass/fail grid; orange border = PPR-only event
- `results/raw/<ts>/*.log`     — per-invocation perf JSON + workload output

## Files

```
pmc_test/
├── README.md                this file
├── run_on_genoa.sh          one-liner driver (builds, runs, prints links)
├── run_pmc_tests.py         main test driver (402 lines)
├── events.yaml              curated event + metric registry
├── ppr_vs_perfspect_diff.json   81 PPR-only events flagged for the report
├── workloads/               C microbenchmarks + Makefile
│   ├── fp_avx.c             FP/SSE/AVX op retire
│   ├── branch_random.c      branch misprediction
│   ├── l2_pressure.c        working set spills L1 into L2
│   ├── dram_stream.c        > L3 stream — DRAM + prefetch
│   ├── tlb_thrash.c         many 4K pages — TLB miss + tablewalk
│   ├── syscall_heavy.c      kernel-side mode-switch / int_taken
│   ├── ccd_pingpong.c       cross-CCD cacheline ping-pong
│   └── stream.c             McCalpin STREAM (Copy/Scale/Add/Triad) — NEW
├── results/                 timestamped JSON + HTML
├── results/raw/<ts>/        per-invocation perf logs — NEW
└── results_m8a/, results_genoa/   per-host pulled archives
```

## Known fixes in this revision

- **PMC multiplexing starvation** — chunk size reduced from 8 → 5 events to
  keep within the 6 GP counters/core budget; events that previously reported
  zero on short workloads now read correctly.
- **NaN-metrics bug** — `safe_eval()` and `extract_event_names()` now handle
  hyphenated perf event names (`cpu-cycles`, `task-clock`), so IPC and
  related derived metrics no longer come back as `nan`.
- **Zen5 event renames** — `de_dis_dispatch_token_stalls1.load_queue_rsrc_stall`
  → `de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall`;
  `l2_pf_hit_l2.all` → `l2_pf_hit_l2.l2_hwpf` (no `.all` aggregate on Zen5).
- **Per-invocation raw log capture** — all `perf stat -j` output is preserved
  under `results/raw/<ts>/` for auditability.

## Roadmap

- Phase 2 (**done**): SSM-based orchestrator to fan the harness out to AWS
  m7a / m8a instances and diff the per-class outcomes (which events behave
  differently bare-metal vs. virtualised, Zen4 vs Zen5).
- Phase 3: build the cross-instance three-bucket matrix
  (WORKS / OPENS-BUT-ZERO / FAILS-TO-OPEN) per event per host.
- Phase 4: feed validated PPR-only extras back into
  `perfspect_genoa_metrics.json` so PerfSpect picks them up.
