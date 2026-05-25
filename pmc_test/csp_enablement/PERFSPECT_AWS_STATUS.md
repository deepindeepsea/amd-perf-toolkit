> # ⚠️ SUPERSEDED — 2026-05-25
>
> This document's classification is **WRONG**. The "58 broken on AWS" count was
> a tooling artifact (raw event codes silently dropping PERF_CTL[35:32] high bits
> for events >0xFF) compounded by the assumption that `amd_uncore.ko` was stripped
> from the AWS kernel. Both are wrong.
>
> **Authoritative replacement:** [`AWS_4WAY_MATRIX.md`](AWS_4WAY_MATRIX.md)
>
> **Corrected headline findings:**
> - Real Nitro core-PMC filter on m8a.2xl is **9 events** (IF-probe-filter family),
>   not 23 or 58. Full-socket guests (m8a.24xl) and bare metal hit none of them.
> - `amd_uncore.ko` ships in `linux-modules-extra-aws` — just `apt-get install
>   linux-modules-extra-$(uname -r) && sudo modprobe amd_uncore`. After that, on
>   **metal**: `amd_l3`, `amd_df`, `amd_iommu_0..3`, `amd_umc_0..11`, `ibs_op`,
>   `ibs_fetch` all appear and work. On **24xl/2xl guests**: module loads but PMU
>   devices don't materialize (Nitro doesn't expose uncore MSRs to guests — that
>   part is a real hypervisor restriction).
> - Always use **named perf events** on Turin, not raw `cpu/event=,umask=/` codes,
>   for any event code above 0xFF.
>
> Everything below this banner is preserved for history but should not be cited.
>
> ---

# PerfSpect Turin Metrics — works on Bare Metal, broken on AWS m8a

**Source of truth:** upstream PerfSpect at `intel/PerfSpect@main`:
- `cmd/metrics/resources/legacy/events/x86_64/AuthenticAMD/turin.txt` (event list)
- `cmd/metrics/resources/legacy/metrics/x86_64/AuthenticAMD/turin.json` (137 metric formulas)

Each PerfSpect metric is classified by cross-referencing every event it touches
against `pmc_test/cross_cpu_results/turin_matrix.csv` (the BM-vs-AWS sweep on
host-ruby-de91 and i-05e90313f50067922).

## Headline

| Status | Count | Meaning |
|---|---:|---|
| **WORKS_ON_AWS** | 42 | every event the metric needs is programmable on m8a |
| **BROKEN_ON_AWS** | 58 | at least one event is Nitro-filtered or routes through the L3/DF PMU |
| **NEEDS_PROBE** | 37 | one or more events haven't been swept yet on m8a |

So of PerfSpect's 137 Turin metrics, **at least 58 are broken on AWS m8a today**
(the 37 unprobed ones are mostly L2 cache umasks I expect will move to WORKS once
swept). Bare metal supports the full 137.

## BROKEN — grouped by why

### Group A — L3 PMU / Data Fabric PMU not exposed in guest (23 metrics)

Nitro never exposes the L3 perf-mon unit or the Data Fabric PMU to the guest.
Anything that needs `l3/event=…/` or `df/event=…/` is dead on m8a (and on every
other cloud guest we've heard of so far).

- L3 Cache Accesses PTI / txn
- L3 Cache Misses PTI / txn
- L3 Cache Hits PTI / txn
- Average L3 Cache Read Miss Latency (in ns)
- Total / Read / Write Memory Bandwidth (MB/sec)
- DRAM write bandwidth for local / remote processor (MB/sec)
- Local / Remote socket upstream DMA read bandwidth (MB/sec)
- Local / Remote socket upstream DMA write bandwidth (MB/sec)
- Local / Remote socket inbound bandwidth to the CPU (MB/sec)
- Local / Remote socket outbound bandwidth from the CPU (MB/sec)
- Outbound bandwidth from all links (MB/sec)
- Total CXL Read / Write (MB/sec)

These are the **cross-CCD / cross-socket / DRAM / CXL** metrics. On bare metal
the DF probes them; on a Nitro guest there is no DF PMU at all. *This is the
"counters that exist on BM but not on AWS" intuition you mentioned — most of
them live here.*

### Group B — core PMC event Nitro-filtered (35 metrics)

These metrics use core PMCs that are programmable on bare metal Turin but
return zero on m8a — Nitro's silent filter.

**Op-cache / I-cache miss ratios (2 metrics)** — event `0x28F` (`op_cache_hit_miss`)
is blocked on Nitro:
- Op Cache Fetch Miss Ratio
- Instruction Cache Fetch Miss Ratio

**L1-D fill-source breakdown (24 metrics)** — `ls_any_fills_from_sys` /
`ls_dmnd_fills_from_sys` events `0x44` and `0x43` umasks `0x02`/`0x04`/`0x08`/
`0x10`/`0x40` are filtered. Only `umask=0x01` (local L2 fill) survives.
- L1 / Demand Data Cache Fills from local L3 or different L2 in same CCX (PTI + txn)
- … from another CCX cache in the same NUMA node (PTI + txn)
- … from DRAM or MMIO in the same NUMA node (PTI + txn)
- … from another CCX cache in a different NUMA node (PTI + txn)
- … from Remote Memory or IO (PTI + txn)
- All L1 Data Cache Fills (PTI + txn) — composite umask
- Remote DRAM Reads %

*This is exactly the "cross-CCD counters" you were asking about — the demand
fill-source telemetry. On a 12-CCD bare-metal box those fire constantly when
threads touch each other's L3; on a single-CCD-pinned m8a guest, Nitro filters
them so they read zero regardless of whether traffic happened.*

**ITLB miss telemetry (4 metrics)** — events `0x84` / `0x85`:
- L1 ITLB Misses (PTI + txn)
- L2 ITLB Misses and Instruction Page Walks (PTI + txn)

**TLB flush telemetry (2 metrics)** — event `0x78`:
- All TLBs Flushed (PTI + txn)

**Pipeline Utilization — Backend Bound subtree (3 metrics)** — `0x1A0 umask=0x1E`
is the OR of `0x02|0x04|0x08|0x10`. Three of those four single-bit probes are
BM-only on AWS, so the composite backend_stalls counter is unreliable:
- Pipeline Utilization - Backend Bound (%)
- Pipeline Utilization - Backend Bound - Memory (%)
- Pipeline Utilization - Backend Bound - CPU (%)

**Pipeline Utilization — Bad Speculation Pipeline Restarts (%)** — uses
`ex_ret_brn_stalled` (`0x96 umask=0x07`) which we have not seen non-zero on AWS.

## WORKS_ON_AWS — confirmed (42 metrics)

These run on m8a today (and PerfSpect reports them when you run it there):

- CPU operating frequency (in GHz)
- CPU utilization % (total and kernel-mode)
- CPI, kernel_CPI, cycles per txn, kernel_cycles per txn
- IPC, txn per cycle, giga_instructions_per_sec
- All Data Cache Accesses (PTI + txn)
- L1 / Demand L1 Data Cache Fills from local L2 (PTI + txn)
- L1 DTLB Misses (PTI + txn)
- L2 DTLB Hit (all / 4k / 4k+ / 2M) (PTI + txn)
- L2 DTLB Misses (all / 4k / 4k+ / 2M) (PTI + txn)
- 4KB Page DTLB Activity %
- L2 DTLB Misses and Data Page Walks (PTI + txn)
- Macro-ops Dispatched (PTI + txn)
- Mixed SSE and AVX Stalls (cyc + txn)
- package power (watts) — `power/energy-pkg/` is unfiltered

## NEEDS_PROBE — events not yet swept on m8a (37 metrics)

These mostly use L2 cache composite umasks (`l2_request_g1.all_dc` = `0x60/0xE0`,
`l2_pf_hit_l2.all` = `0x70/0x1F`, etc.) that the existing single-bit sweep didn't
enumerate exhaustively. They are *probably* OK on AWS — the underlying single-bit
results we do have are mostly OK_BOTH — but they need an explicit re-probe to be
sure. Includes:

- L2 cache accesses / misses / hits — most variants
- Branch Misprediction Ratio
- 64B lines written per WCB close
- Macro-ops Retired (PTI + txn)
- **Pipeline Utilization — Frontend Bound, Bad Speculation, SMT Contention, Retiring** subtrees
  — likely OK (`0x1A0/0x01`, `0x1C2/0x00`, `0xC1`, `0x76` are all OK_BOTH in
  the existing sweep; the composite `0x1A0/0x60` smt_contention umask just
  isn't probed yet). Confirm with a targeted re-sweep.

The Pipeline Utilization top-level metrics in this NEEDS_PROBE list are the
ones you've actually seen PerfSpect print on m8a/Ruby — that matches: their
*components* are OK_BOTH at the bit level. The reason they show up here and
not in WORKS is only because PerfSpect uses composite umasks that aren't a
literal row in `turin_matrix.csv`. A short re-sweep would move them to WORKS.

## Files

- `pmc_test/csp_enablement/perfspect_aws_status.csv` — per-metric verdict + reason + event-by-event status
- `pmc_test/cross_cpu_results/turin_matrix.csv` — raw BM-vs-AWS sweep, 838 rows
- `pmc_test/csp_enablement/csp_matrix.csv` — public-PPR-filtered cross-CSP view
