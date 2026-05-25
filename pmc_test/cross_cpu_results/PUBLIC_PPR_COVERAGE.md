# Public PPR Coverage Across Bare-Metal Turin + AWS m8a

**Approach** — Public ⊂ Internal at the event-code level, so the existing
internal-catalog sweep already contains every measurement we need. This
report projects `turin_matrix.csv` onto the public PPR (C1_pub_050) tuple
list — no second sweep was run.

## Coverage Summary — 223 public-PPR (event, umask) tuples

| Class | Count | Share |
|---|---:|---:|
| BOTH (BM + AWS verified non-zero) | **47** | 21% |
| BM_ONLY (Nitro-filtered on AWS) | **28** | 13% |
| AWS_ONLY | 1 | 0% |
| BOTH_ZERO (event legal but workloads didn't hit it) | 34 | 15% |
| UNTESTED (single-bit umasks not in current sweep) | 113 | 51% |

## Headline

- **47 of 223 public PPR tuples (21%) are confirmed cloud-portable** — usable on AWS m8a Nitro.
- **75 of 223 (33.6%) verified on bare-metal Turin** so far.
- **113 untested gap** is single-bit umasks the existing sweep didn't enumerate. They're the tappability frontier — a focused per-bit sweep would close the gap.
- Public PPR at event-code level is `Public ⊂ Internal` cleanly (81 / 299); no public-only mystery events.

## What's cloud-portable from the public PPR (47 tuples / 21 distinct events)

| PMC | PPR Name | Public umasks that work on BM + AWS |
|---|---|---|
| PMCx003 | FP retired SSE and AVX FLOPs | 0x8 |
| PMCx008 | FP uops retired by size | 0x1, 0x2, 0x4, 0x8, 0x10, 0x20 |
| PMCx024 | Bad Status STLI | 0x2 |
| PMCx029 | LS Dispatch | 0x1, 0x2, 0x4 |
| PMCx037 | Store Globally Visible Cancels Due To External | 0x1 |
| PMCx043 | Demand Data Cache Fills by Data Source | 0x1 |
| PMCx044 | Any Data Cache Fills by Data Source | 0x1 |
| PMCx045 | L1 DTLB Reloads | 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80 |
| PMCx047 | Misaligned Load Flows | 0x1, 0x2 |
| PMCx050 | Write Combining Buffer Close | 0x1 |
| PMCx059 | Software Prefetch Data Cache Fills by Data Source | 0x1 |
| PMCx05A | Hardware Prefetch Data Cache Fills by Data Source | 0x1 |
| PMCx085 | L1 ITLB Miss, L2 ITLB Miss | 0x1, 0x8 |
| PMCx094 | ITLB Instruction Fetch Hits | 0x1, 0x2 |
| PMCx09F | BP Redirects | 0x1, 0x2 |
| PMCx0AA | Source of Op Dispatched From Decoder | 0x1, 0x2 |
| PMCx0AE | Dynamic Tokens Dispatch Stall Cycles 1 | 0x1, 0x2, 0x4, 0x40 |
| PMCx0AF | Dynamic Tokens Dispatch Stall Cycles 2 | 0x1, 0x2, 0x20 |
| PMCx0CB | Retired MMX FP Instructions | 0x4 |
| PMCx0D6 | Cycles with no retire | 0x1, 0x2, 0x8 |
| PMCx120 | P0 Freq Cycles not in Halt | 0x1 |

These 47 tuples are the **safe-to-publish-as-AWS-supported** subset of the public PPR — every entry has independent BM + AWS verification.

## Files
- `pmc_test/cross_cpu_results/public_ppr_coverage.csv` — per-tuple row with bm_ok/aws_ok/class
- `pmc_test/cross_cpu_results/public_ppr_coverage.json` — same data + per-event-code summary
- `pmc_datasets/BRH_public/BRH_pmc_public.json` — parsed public-PPR catalog
- `pmc_test/cross_cpu_results/PARITY_PerfSpect_vs_PublicPPR_vs_InternalPPR.md` — 3-way parity report
