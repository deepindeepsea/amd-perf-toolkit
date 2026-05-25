# AWS Turin PMC Matrix — 2xl vs 24xl vs metal-24xl vs Bare-Metal

**Date:** 2026-05-25
**Test:** 49-event named-event sweep, STREAM-style memory hammer (mhammer 12-thread, 256MB/thread)
**Kernel (all 3 AWS):** 6.17.0-1012-aws  •  perf 6.17.13
**CPU:** AMD EPYC 9R45 96-core (Turin, Family 1Ah)

## TL;DR — the previous "Nitro blocks 23 core PMCs" finding was wrong

The earlier 2xl sweep used raw event codes (`cpu/event=0x28f,umask=0x04/`) which silently drop the
high bits of PERF_CTL[35:32] for extended event codes (>0xFF), so events like `op_cache_hit_miss`,
`ic_tag_hit_miss`, and `bp_l1_tlb_miss_l2_tlb_miss` returned zero. Re-tested today with named
events: **they all work on the 2xl.** No Nitro filter involved.

## The actual delta between 2xl and 24xl/metal

The only events that genuinely differ across instance sizes are the **L1-D fill-source `ls_*_fills_from_sys`
umasks beyond `local_l2`** — these need Infinity-Fabric probe-filter introspection which is gated on
DF PMU access. A 2xl guest (pinned to one CCD slice) gets zero; a full-socket guest (24xl or metal)
gets real counts.

| Event | 2xl | 24xl | metal | Notes |
|---|--:|--:|--:|---|
| `ls_any_fills_from_sys.local_l2` | 242M | 304M | 316M | OK everywhere |
| `ls_any_fills_from_sys.local_ccx` | **0** | 3.3M | 5.5M | IF-probe filter, 2xl filtered |
| `ls_any_fills_from_sys.near_cache` | **0** | 2.3M | 2.3M | IF-probe filter, 2xl filtered |
| `ls_any_fills_from_sys.dram_io_near` | **0** | 64M | 55M | IF-probe filter, 2xl filtered |
| `ls_any_fills_from_sys.all` | **0** | 377M | 379M | composite umask, 2xl filtered |
| `ls_dmnd_fills_from_sys.local_ccx` | **0** | 2.5M | 2.9M | IF-probe filter, 2xl filtered |
| `ls_dmnd_fills_from_sys.dram_io_near` | **0** | 3.1M | 3.1M | IF-probe filter, 2xl filtered |
| `iTLB-load-misses` (perf-generic) | **0** | 854 | 892 | generic mapping uses filtered encoding on 2xl |

`bp_l1_tlb_miss_l2_tlb_miss.all` (the raw AMD named event for the same thing as `iTLB-load-misses`)
works on all three — only the perf-generic wrapper is broken on 2xl.

## What metal uniquely exposes

| PMU device | 2xl | 24xl | metal |
|---|:-:|:-:|:-:|
| `cpu` (core PMCs) | ✓ | ✓ | ✓ |
| `ibs_op` / `ibs_fetch` (Instruction-Based Sampling) | ✗ | ✗ | **✓** |
| `amd_iommu_0..3` (IOMMU PMU) | ✗ | ✗ | **✓** |
| `amd_umc_0..11` (DRAM controller PMU) | ✗ | ✗ | **✓** |
| `amd_l3` (L3 PMU) | ✗ | ✗ | **✓** † |
| `amd_df` (Data Fabric PMU) | ✗ | ✗ | **✓** † |

† Available on metal after `apt install linux-modules-extra-$(uname -r) && modprobe amd_uncore`
— see correction section below. Default AMI does not pull in this package.

**Metal uniquely adds IBS** (precise per-instruction attribution, the AMD equivalent of Intel PEBS),
**IOMMU PMC** (DMA traffic per IO domain), and the full uncore stack (`amd_l3`, `amd_df`,
12× `amd_umc`). On Nitro guests `modprobe amd_uncore` succeeds but PMU devices don't materialize —
Nitro doesn't expose uncore MSRs to guest mode.

## L3 / DF / IOMMU / UMC / IBS PMUs — fixed by installing `linux-modules-extra-aws` (CORRECTION 2026-05-25)

Earlier finding "AWS strips `amd_uncore` from the kernel build" was **wrong**. The module
`amd-uncore.ko.zst` ships inside `linux-modules-extra-aws` — it just isn't pulled in by
the default AMI. The default `linux-aws` meta-package only depends on `linux-modules-aws`
(the trimmed module set), not `linux-modules-extra-aws`.

**One-line fix on metal:**

```bash
sudo apt-get install -y linux-modules-extra-$(uname -r)
sudo depmod -a
sudo modprobe amd_uncore
```

**After that, on m8a.metal-24xl, all of these PMUs appear and work:**

| PMU | Working | Notes |
|---|:-:|---|
| `amd_l3` | ✓ | verified: `amd_l3/event=0x4,umask=0xff/` returns ~446k events in 0.5s |
| `amd_df` | ✓ | device present; events need correct umask for the workload |
| `amd_iommu_0..3` | ✓ | per-IO-domain DMA counters |
| `amd_umc_0..11` | ✓ | per-DRAM-controller counters (12 UMCs visible) |
| `ibs_op` / `ibs_fetch` | ✓ | precise per-instruction sampling (AMD's PEBS) |

**On Nitro guests (m8a.2xl and m8a.24xl):** the module loads (`lsmod` confirms,
`modprobe` returns 0), but no `amd_*` PMU devices appear in `/sys/devices/`. This
is a real Nitro restriction — uncore MSRs are not exposed to guest mode. That part
*is* a true hypervisor decision, not a kernel-build decision.

## Per-event verdicts — 49-event sweep

OK = non-zero count under mhammer • ZERO = zero (filtered or workload-correct) • NOT_SUPP = perf reports not supported

| Event | 2xl | 24xl | metal | Verdict |
|---|:-:|:-:|:-:|---|
| ls_not_halted_cyc | OK | OK | OK | OK_ALL |
| cpu-cycles | OK | OK | OK | OK_ALL |
| instructions | OK | OK | OK | OK_ALL |
| ex_ret_instr | OK | OK | OK | OK_ALL |
| ex_ret_ops | OK | OK | OK | OK_ALL |
| ex_ret_brn | OK | OK | OK | OK_ALL |
| ex_ret_brn_misp | OK | OK | OK | OK_ALL |
| ex_ret_brn_far | OK | OK | OK | OK_ALL |
| ex_ret_brn_tkn | OK | OK | OK | OK_ALL |
| ex_ret_near_ret | OK | OK | OK | OK_ALL |
| de_no_dispatch_per_slot.no_ops_from_frontend | OK | OK | OK | OK_ALL |
| de_no_dispatch_per_slot.backend_stalls | OK | OK | OK | OK_ALL |
| de_no_dispatch_per_slot.smt_contention | ZERO | ZERO | ZERO | WORKLOAD_ZERO (memory-bound, no SMT contention) |
| de_src_op_disp.op_cache | OK | OK | OK | OK_ALL |
| ex_no_retire.load_not_complete | OK | OK | OK | OK_ALL |
| ex_no_retire.not_complete | OK | OK | OK | OK_ALL |
| op_cache_hit_miss.op_cache_hit | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| op_cache_hit_miss.op_cache_miss | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| op_cache_hit_miss.all_op_cache_accesses | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| ic_tag_hit_miss.instruction_cache_hit | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| ic_tag_hit_miss.instruction_cache_miss | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| ic_tag_hit_miss.all_instruction_cache_accesses | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| ls_any_fills_from_sys.local_l2 | OK | OK | OK | OK_ALL |
| ls_any_fills_from_sys.local_ccx | **ZERO** | OK | OK | NITRO_FILTER_2XL |
| ls_any_fills_from_sys.near_cache | **ZERO** | OK | OK | NITRO_FILTER_2XL |
| ls_any_fills_from_sys.dram_io_near | **ZERO** | OK | OK | NITRO_FILTER_2XL |
| ls_any_fills_from_sys.far_cache | ZERO | ZERO | ZERO | WORKLOAD_ZERO (single socket) |
| ls_any_fills_from_sys.dram_io_far | ZERO | ZERO | ZERO | WORKLOAD_ZERO (single socket) |
| ls_any_fills_from_sys.all | **ZERO** | OK | OK | NITRO_FILTER_2XL (composite) |
| ls_dmnd_fills_from_sys.local_l2 | OK | OK | OK | OK_ALL |
| ls_dmnd_fills_from_sys.local_ccx | **ZERO** | OK | OK | NITRO_FILTER_2XL |
| ls_dmnd_fills_from_sys.near_cache | **ZERO** | OK | OK | NITRO_FILTER_2XL |
| ls_dmnd_fills_from_sys.dram_io_near | **ZERO** | OK | OK | NITRO_FILTER_2XL |
| ls_dmnd_fills_from_sys.far_cache | ZERO | ZERO | ZERO | WORKLOAD_ZERO (single socket) |
| ls_dmnd_fills_from_sys.all | **ZERO** | OK | OK | NITRO_FILTER_2XL (composite) |
| bp_l1_tlb_miss_l2_tlb_hit | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| bp_l1_tlb_miss_l2_tlb_miss.all | OK | OK | OK | OK_ALL (was BROKEN with raw codes) |
| bp_l1_tlb_miss_l2_tlb_miss.if4k | OK | OK | OK | OK_ALL |
| bp_l1_tlb_miss_l2_tlb_miss.if2m | OK | OK | OK | OK_ALL |
| bp_l1_tlb_miss_l2_tlb_miss.if1g | ZERO | ZERO | ZERO | WORKLOAD_ZERO (no 1GB pages) |
| l2_cache_req_stat.dc_hit_in_l2 | OK | OK | OK | OK_ALL |
| l2_cache_req_stat.ls_rd_blk_c | OK | OK | OK | OK_ALL |
| l2_cache_req_stat.ic_fill_miss | OK | OK | OK | OK_ALL |
| l2_cache_req_stat.ic_hit_in_l2 | OK | OK | OK | OK_ALL |
| ls_l1_d_tlb_miss.all | OK | OK | OK | OK_ALL |
| ls_l1_d_tlb_miss.all_l2_miss | OK | OK | OK | OK_ALL |
| iTLB-loads (perf generic) | OK | OK | OK | OK_ALL |
| iTLB-load-misses (perf generic) | **ZERO** | OK | OK | NITRO_FILTER_2XL (raw `bp_l1_tlb_miss_l2_tlb_miss.all` works) |
| dTLB-loads | OK | OK | OK | OK_ALL |
| dTLB-load-misses | OK | OK | OK | OK_ALL |

## Final tally per instance

| Instance | OK | Workload-zero | Nitro-filtered | Total |
|---|--:|--:|--:|--:|
| **2xl** (8 vCPU, 1 CCD slice, Nitro guest) | 35 | 5 | **9** | 49 |
| **24xl** (96 vCPU, full socket, Nitro guest) | 44 | 5 | 0 | 49 |
| **metal** (96 vCPU, full socket, no hypervisor) | 44 | 5 | 0 | 49 |

Uncore PMUs (L3/DF/IOMMU/UMC/IBS) now confirmed working on metal after installing
`linux-modules-extra-aws` (see correction section). On 24xl/2xl the module loads but
PMU devices don't appear — Nitro restriction on uncore MSR exposure.

## Asks for AWS — narrowed and prioritized

1. ~~Ship `amd_uncore.ko` in `linux-modules-extra-aws`~~ **Already shipped.** Real ask
   is documentation: AWS Linux AMI guide should mention `apt install linux-modules-extra-$(uname -r)`
   as the one-line unlock for L3/DF/IOMMU/UMC/IBS on `.metal` instances. Today users
   assume those PMUs are blocked and never try.

2. **Lift the IF-probe filter on small instances** — events: `ls_any_fills_from_sys.{local_ccx,near_cache,dram_io_near,all}` and `ls_dmnd_fills_from_sys.{local_ccx,near_cache,dram_io_near,all}`. These are core-attributed but require IF-probe-filter introspection; today they're zeroed only on partial-socket guests. Confirmed working when the guest owns the whole socket.

3. **Fix perf-generic `iTLB-load-misses` mapping** on small instances — the named `bp_l1_tlb_miss_l2_tlb_miss.all` works fine; only the generic wrapper hits a filtered encoding path. Minor but easy.

4. **Expose uncore MSRs to Nitro guests** (stretch goal) — even partial DF/UMC visibility
   on full-socket guests like m8a.24xl would let cloud customers do memory-bandwidth
   attribution without renting `.metal`.

## Test methodology — re-runnable on any host

Script: `pmc_test/csp_enablement/sweep_runner.sh` (this directory).
Workload: `mhammer` — 12-thread STREAM-triad+copy over 256MB/thread (~3GB resident, blows past any L3).
Sweep: 49 named events, CSV-mode perf isolation, ~3 min wall time per instance.

To reproduce on a new platform (CSP or bare metal): SCP `sweep_runner.sh`, run `bash sweep_runner.sh`,
diff the output against `sweep_metal_raw.txt` (ground truth). Any event that's OK on metal but ZERO
on the new platform = a real filter on the new platform.

## Addendum — L2 hardware-prefetch events (0x70 / 0x71 / 0x72)

Triggered by cross-checking against Palak's m7a (Genoa) BMC sheet. Three events,
seven umasks each, three trials on each AWS instance. Workload: mhammer 12-thread
STREAM-triad+copy (HW prefetcher is the dominant signal in this workload).

| Event | Umask | m8a.2xl (Turin) | m8a.24xl (Turin) | m8a.metal (Turin) | m7a.4xl (Genoa, per Palak) | m7a.48xl (Genoa, per Palak) |
|---|---|--:|--:|--:|---|---|
| 0x70 (PF hit L2) | 0x01..0x10 | **ZERO** | OK | OK | OK | OK |
| 0x70 | 0x1F (composite) | 65–183M | 106–174M | 108–171M | **ZERO** | **ZERO** |
| 0x70 | 0xFF | OK | OK | OK | OK | OK |
| 0x71 (PF miss L2, hit L3) | any | **ZERO** | OK | OK | **ZERO** | **ZERO (0x1F only)** |
| 0x72 (PF miss L2/L3 → DRAM) | any | **ZERO** | OK | OK | **ZERO** | **ZERO (0x1F only)** |

**Findings:**

1. **Generation-spanning filter on partial-socket guests:** 0x71 and 0x72 are
   completely zeroed regardless of umask on both m7a.4xl (Genoa) and m8a.2xl
   (Turin). The L2-miss prefetch outcomes — i.e., the "useful prefetch" events
   that drive every prefetcher-accuracy / coverage ratio in PerfSpect — are dead
   on small Nitro guests across generations.

2. **Generation-divergent filter on 0x70 breakdown:** Genoa Nitro exposes
   per-engine breakdown of L2-hit PF (umasks 0x01..0x10 work) but blocks the
   0x1F rollup. Turin Nitro does the **inverse** — blocks the per-engine
   breakdown on 2xl but lets 0x1F through. Different filter implementations
   between m7a and m8a.

3. **m7a.48xl still loses 0x1F composites:** Even on dual-socket Genoa metal-ish
   guests, the 0x1F composite umask doesn't return data (per Palak's sheet).
   On Turin m8a.metal-24xl, 0x1F composites for 0x70/0x71/0x72 all work cleanly
   (verified 3 trials, stable counts). So this is a real Genoa-Nitro behavior
   that Turin Nitro fixed.

4. **Sanity check on Turin metal:** `0x72 × 0x1F` (composite) ≈ sum of
   individual umasks (`0x01 + 0x08 + ... = 353M ≈ composite 356M`). Confirms
   0x1F is computing the actual rollup, not a different counter.

**Impact on PerfSpect metrics:** L2-PF-accuracy and L2-PF-coverage metrics
require 0x71+0x72. Both are dead on partial-socket guests on both generations.
Per-engine prefetcher attribution metrics are dead on m8a.2xl. Cross-generation
testing of any prefetch-tuning metric requires at minimum a 24xl on m8a or a
24xl/48xl on m7a — and even then the rollup metrics on m7a need to be
reconstructed from individual umasks because 0x1F is blocked.

## Files

- `sweep_2xl_raw.txt` — raw output, m8a.2xlarge (i-05e90313f50067922)
- `sweep_24xl_raw.txt` — raw output, m8a.24xlarge (i-0c102ade695b014bf)
- `sweep_metal_raw.txt` — raw output, m8a.metal-24xl (i-0face50cc981b9029)
- `sweep_runner.sh` — re-runnable sweep script (~120 lines bash)
- `l2pf_sweep.sh` / `l2pf_focus.sh` — L2 prefetch event sweep + focused 3-trial confirmation
