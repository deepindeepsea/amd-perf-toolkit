# BRH Turin PMC Parity — PerfSpect vs Public PPR vs Internal PPR

**Sources**
- PerfSpect-Turin: `PerfSpect/.../legacy/events/x86_64/AuthenticAMD/turin.txt` (upstream Intel/Netflix)
- Public PPR: `ppr_BRH_C1_pub_050` (§2.1.16.5 Core + §2.1.16.6 L3)
- Internal PPR: `ppr_BRH_C1_int_050` (`BRH_pmc_core.json`)

**Matching**: every PerfSpect entry is `cpu/event=0xXX[,umask=0xYY]/`.
A PerfSpect tuple matches a PPR catalog iff the event code is documented AND
every set bit in its umask byte is a documented bit of that event. This is the
canonical AMD encoding match (umask bytes are bit-OR of single-bit feature selectors).

---

## Headline

| Metric | Value |
|---|---|
| PerfSpect raw (event, umask) entries | **77** |
| ...matched in Public PPR | 57 (74%) |
| ...matched in Internal PPR | **77 (100%)** |
| PerfSpect distinct event codes | 28 |
| ...in Public PPR | **27 (96%)** |
| ...Internal-only | 1 |
| Public PPR event codes | 81 |
| Internal PPR event codes | 299 |
| **Public ⊂ Internal at event-code level?** | **YES** |
| Public ⊂ Internal at (event, umask) level? | partial — 6 single-bit tuples diverge |

## What the hypothesis test shows

The user's hypothesis: *"PerfSpect / perf subsystem measures what's in the public PPR."*

**Verdict: partially true.**

- At the **event-code level** (28 distinct codes), PerfSpect lives almost entirely
  inside the published surface — 27 of 28 distinct event IDs that PerfSpect uses
  appear in the public PPR. The single hold-out is `0x28F` (Op Cache Hit/Miss).
- At the **(event, umask) level** (77 raw lines), PerfSpect uses 20 entries
  whose umask bit combinations are not documented in the public PPR. Those bits
  are documented only in the internal PPR. AMD publishes the event ID but not
  every umask permutation that perf / PerfSpect rely on.
- Net: PerfSpect ⊄ Public PPR as raw lines, but ⊂ Internal PPR cleanly (100%).

## The 20 "internal-only" PerfSpect entries

Most of these are the **Zen5 slot-account model** (event `0x1A0` family) plus a
few prefetch-aggregate umasks the public PPR collapses to event-only descriptions:

```
event=0x1a0 umask=0x01   de_no_dispatch_per_slot.no_ops_from_frontend
event=0x1a0 umask=0x1e   de_no_dispatch_per_slot.backend_stalls
event=0x1a0 umask=0x60   de_no_dispatch_per_slot.smt_contention
event=0xaa  umask=0x07   de_src_op_disp.all
event=0xd6  umask=0xa2   ex_no_retire.load_not_complete
event=0x96  umask=0x07   ex_ret_brn_stalled
event=0x70  umask=0x1f   l2_pf_hit_l2.all          (composite, all sources)
event=0x71  umask=0x1f   l2_pf_miss_l2_hit_l3.all
event=0x72  umask=0x1f   l2_pf_miss_l2_l3.all
event=0x18e umask=0x18   ic_tag_hit_miss.miss
event=0x18e umask=0x1f   ic_tag_hit_miss.all
event=0x28f umask=0x04   op_cache_hit_miss.miss    (event not in public PPR)
event=0x28f umask=0x07   op_cache_hit_miss.all
event=0x78  umask=0x8f   ls_tlb_flush.all
event=0x78  umask=0x50   ls_tlb_flush.tlbi_asid
```

(`0x1a0` entries appear twice in the source as both `_per_slot` and `_per_cycle`
aliases — that's why the count is 20, not 15.)

## Why this matters for the toolkit

1. **BRH Table 58 (Pipeline Utilization) Zen5 metrics** depend on `0x1A0`
   umasks (`0x01`, `0x1E`, `0x60`) — the slot-account variants. These are
   internal-only at the umask level, which is why the perf-list catalog also
   exposes them as `de_no_dispatch_per_slot.*` mnemonics but the public PPR
   only describes the event in cycle-count terms.
2. **The toolkit's `pipeline_zen4_genoa.yaml`** uses these same `0x1A0`
   mnemonic forms (`de_no_dispatch_per_slot.no_ops_from_frontend`,
   `de_no_dispatch_per_slot.backend_stalls`) — which work on both Zen4
   Genoa (Family 19h) and Zen5 (Family 1Ah) precisely because perf links
   them to event/umask combos that are catalogued internally.
3. The 218 internal-only PMC events (events present in Internal PPR but
   absent from Public PPR) are the unexplored surface area — anything beyond
   the 81 public events is a candidate to ask "is this measurable on Nitro?
   Should the toolkit add it?"

## Cross-platform tap status (combined with prior diff)

| Catalog tier | Total (event, umask) tuples |
|---|---|
| Internal PPR documented | 1,302 |
| Public PPR documented | 223 |
| PerfSpect-Turin tapped | 77 (62 unique) |
| BM Turin verified-non-zero | 497 raw event codes |
| AWS m8a verified-non-zero | 78 distinct tuples |
| AWS m7a (Zen4) verified | (prior matrix) |

## Artifacts

- `pmc_datasets/BRH_public/BRH_pmc_public.json` — parsed public PPR catalog
  (81 core + 3 L3 events, 224 + 15 unit-mask rows)
- `pmc_test/cross_cpu_results/parity_perfspect_pub_int.json` — machine-readable 3-way diff
- `pmc_test/cross_cpu_results/perfspect_vs_ppr_turin_diff.json` — earlier 2-way (PerfSpect vs Internal)
