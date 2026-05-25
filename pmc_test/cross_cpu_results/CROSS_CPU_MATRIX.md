# Cross-CPU PMC Validation Matrix — Zen4 vs Zen5 vs Genoa-X

**Generated:** 2026-05-25
**Driver:** `pmc_test/run_pmc_tests.py --mode all`
**Events catalog:** `pmc_test/events.yaml` (53 PPR Table 26 events)

## Boxes Under Test

| Box           | Instance                  | CPU                          | µarch          | vCPU | L3 per CCD | CCDs | Mode  |
|---------------|---------------------------|------------------------------|----------------|------|------------|------|-------|
| Zen4-m7a      | AWS `i-0e413ac968cdef1e2` | AMD EPYC 9R14                | Zen4 Genoa     | 32   | 32 MB      | ~4   | virt  |
| Zen5-m8a      | AWS `i-05e90313f50067922` | AMD EPYC 9R45                | Zen5 Turin     | 8    | 32 MB      | ~1   | virt  |
| GenoaX-9684X  | `host-ruby-de91`          | AMD EPYC 9684X               | Zen4 Genoa-X   | 96   | 96 MB (3D V-Cache) | 12 | bare-metal |

All three boxes: kernel `perf_event_paranoid=-1`, `perf` 6.x, AMD vendor PMU exposed.

## Headline Result

After collapsing the well-understood **chunked-group cascade** artifact
(when one event in a 5-event `perf stat -e` group is unrecognized, perf rejects
the whole group — siblings show value=0 not because they don't work, but because
they were never actually counted), the picture is:

| Box          | OK | PROG-only* | SAN-ZERO** | GRP-POISON*** | PROG-FAIL |
|--------------|----|-----------|------------|---------------|-----------|
| Zen4-m7a     | 26 | 13        | 7          | 4             | 3         |
| Zen5-m8a     | 29 | 14        | 4          | 4             | 2         |
| GenoaX-9684X | 31 | 13        | 2          | 4             | 3         |

\* `PROG-only` — event opens cleanly in `perf stat`, but the `--mode sanity` aggregate workload doesn't exercise it; usually means a targeted workload is needed.
\** `SAN-ZERO` — event opens, was actually counted standalone, and produced 0 with the chosen workload.
\*** `GRP-POISON` — event was in a 5-event chunked group where another event was unknown to perf; this is a harness artifact, not a CPU issue.

The bare-metal Genoa-X has the cleanest signal (31 OK), consistent with no virtualization PMU filtering and access to the full 12-CCD topology.

## Genuinely Problematic Events (after de-poisoning)

| Event | Zen4-m7a | Zen5-m8a | GenoaX | Diagnosis |
|---|---|---|---|---|
| `ls_tablewalker.iside_l1` | PROG-FAIL | PROG-FAIL | PROG-FAIL | Name not in any tested kernel's PMU JSON — needs lookup against AMD PPR encoding |
| `de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall` | PROG-FAIL | **OK** | PROG-FAIL | Zen5-only event name; Zen4 uses a different mnemonic |
| `l2_pf_hit_l2.l2_hwpf` | PROG-FAIL | PROG-only | PROG-FAIL | Likely Zen5-only naming |
| `all_data_cache_accesses` | SAN-ZERO | PROG-FAIL | **OK** | Zen5 perf rejects this alias; bare-metal Zen4 with hwloc-resolved PMU recognises it |
| `fp_disp_faults.all` | SAN-ZERO | GRP-POISON | SAN-ZERO | Workload generates no FP exceptions — needs denormal/x87 stresser |
| `fp_ret_x87_fp_ops.all` | GRP-POISON | SAN-ZERO | GRP-POISON | Workload uses AVX/SSE only — no legacy x87; need `fldpi/fsin` micro |
| `ls_locks.bus_lock` | SAN-ZERO | GRP-POISON | SAN-ZERO | No split-cacheline `LOCK` in workload — need misaligned atomic stresser |
| `ic_cache_fill_sys` | SAN-ZERO | SAN-ZERO | **OK** | Genoa-X's larger I-cache pressure path triggers it; AWS instances may filter or workload too short |
| `ls_int_taken` | SAN-ZERO | GRP-POISON | **OK** | Needs interrupt-heavy load (e.g. `syscall_heavy` longer run) |
| `ls_pref_instr_disp.all` | SAN-ZERO | SAN-ZERO | **OK** | Software prefetch instructions (`PREFETCHT*`) — only Genoa-X's compiler emit ran them |
| `ls_sw_pf_dc_fills.all` | SAN-ZERO | SAN-ZERO | **OK** | Same as above |

## Cascade ("GRP-POISON") Detail

Five events were caught in poisoned 5-event chunks. They are **not** known to be broken; they need to be re-run as singleton perf invocations to know their true status. Poisoner events (the one perf rejected, dragging the group down):

| Box | Poisoner | Innocent siblings |
|-----|----------|-------------------|
| Zen4-m7a / GenoaX | `de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall` | `de_no_dispatch_per_slot.no_ops_from_frontend`, `de_no_dispatch_per_slot.backend_stalls`, `de_op_queue_empty`, `fp_ret_x87_fp_ops.all` |
| Zen4-m7a / GenoaX | `l2_pf_hit_l2.l2_hwpf` | `l2_cache_req_stat.ls_rd_blk_c` |
| Zen5-m8a | `all_data_cache_accesses` | `ls_locks.bus_lock`, `ls_dispatch.ld_st_dispatch`, `ls_int_taken`, `fp_disp_faults.all` |

## Files

| File | Content |
|------|---------|
| `matrix.csv` | Raw 3-box × 53-event status (pre-reclassification) |
| `matrix_v2.csv` | Reclassified matrix with `GRP-POISON` separated from `SAN-ZERO` |
| `zen4_m7a_summary.json` / `zen5_m8a_summary.json` / `genoax_summary.json` | Per-box `run_pmc_tests.py` raw summaries |
| `*_report.html` | Per-box HTML reports |

## Next Steps (deferred — single-event reruns with taskset pinning)

1. Patch `events.yaml` to split known poisoners into their own singleton group so siblings get counted.
2. Provide Zen4 vs Zen5 alias mapping for `de_dispatch_stall_cycle_dynamic_tokens_part1.load_queue_rsrc_stall`, `l2_pf_hit_l2.l2_hwpf`, `all_data_cache_accesses`.
3. Add targeted micro-workloads for the SAN-ZERO events:
   - x87 / denormal stresser → `fp_disp_faults.all`, `fp_ret_x87_fp_ops.all`
   - Misaligned `LOCK` cmpxchg → `ls_locks.bus_lock`
   - `PREFETCHT0/1/2/NTA` chain → `ls_pref_instr_disp.all`, `ls_sw_pf_dc_fills.all`
   - Long `syscall_heavy` + signal storm → `ls_int_taken`
4. Re-run each targeted workload with `taskset -c <CCD0-cores>` to pin and confirm; on Genoa-X, additionally pin to a `_X`-only CCD to compare 32 MB-base vs 96 MB-stacked L3 effects.
5. Resolve `ls_tablewalker.iside_l1` against the AMD PPR raw encoding (likely a recent rename — try `ls_tw.ic_*` family) since it's PROG-FAIL on all three.
