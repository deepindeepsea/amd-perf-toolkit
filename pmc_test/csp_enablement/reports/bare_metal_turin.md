# PMC Enablement Report — Bare-Metal Turin

_Generated 2026-05-25 17:42 UTC from `csp_matrix.json`_

**Instance class:** AMD EPYC 9755 reference  
**Hypervisor:** none  
**Vendor contact:** internal reference  
**Scope:** Public Turin PPR (C1_pub_050) — 223 (event, umask) tuples

## Headline

| Status | Count | % of public PPR | Notes |
|---|---:|---:|---|
| **Supported (verified non-zero)** | 75 | 34% | tuples that program AND produce signal |
| **BLOCKED by hypervisor** | **0** | 0% | works on BM, silently returns zero on this CSP — gap to escalate |
| Zero-no-signal | 34 | 15% | event legal, our workloads didn't exercise it |
| Untested | 114 | 51% | per-bit umask not yet probed |

BM-Turin reference: 75 supported / 34 no-signal / 114 untested.
This CSP exposes **100% of BM-verified events** to guest workloads.

## Events Supported (Verified Non-Zero)

| PMC | PPR Name | Working umasks |
|---|---|---|
| PMCx003 | FP retired SSE and AVX FLOPs | 0x8 |
| PMCx008 | FP uops retired by size | 0x1, 0x2, 0x4, 0x8, 0x10, 0x20 |
| PMCx024 | Bad Status STLI | 0x1, 0x2 |
| PMCx029 | LS Dispatch | 0x1, 0x2, 0x4 |
| PMCx02C | Interrupts Taken | 0x1 |
| PMCx037 | Store Globally Visible Cancels Due To External Conditions | 0x1 |
| PMCx043 | Demand Data Cache Fills by Data Source | 0x1, 0x2, 0x4, 0x8, 0x10, 0x40 |
| PMCx044 | Any Data Cache Fills by Data Source | 0x1, 0x2, 0x4, 0x8, 0x10, 0x40 |
| PMCx045 | L1 DTLB Reloads | 0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x80 |
| PMCx047 | Misaligned Load Flows | 0x1, 0x2 |
| PMCx04B | Prefetch Instructions Dispatched | 0x1, 0x2 |
| PMCx050 | Write Combining Buffer Close | 0x1 |
| PMCx052 | Ineffective Software Prefetches | 0x1, 0x2 |
| PMCx059 | Software Prefetch Data Cache Fills by Data Source | 0x1, 0x2, 0x4, 0x8 |
| PMCx05A | Hardware Prefetch Data Cache Fills by Data Source | 0x1, 0x2, 0x4, 0x8, 0x10, 0x40 |
| PMCx085 | L1 ITLB Miss, L2 ITLB Miss | 0x1, 0x2, 0x8 |
| PMCx094 | ITLB Instruction Fetch Hits | 0x1, 0x2 |
| PMCx09F | BP Redirects | 0x1, 0x2 |
| PMCx0AA | Source of Op Dispatched From Decoder | 0x1, 0x2 |
| PMCx0AE | Dynamic Tokens Dispatch Stall Cycles 1 | 0x1, 0x2, 0x4, 0x10, 0x40 |
| PMCx0AF | Dynamic Tokens Dispatch Stall Cycles 2 | 0x1, 0x2, 0x20 |
| PMCx0CB | Retired MMX FP Instructions | 0x1, 0x4 |
| PMCx0D6 | Cycles with no retire | 0x1, 0x2, 0x8, 0x10 |
| PMCx120 | P0 Freq Cycles not in Halt | 0x1 |

## Severity Legend

- **P0** — Required for AMD's BRH Pipeline-Utilization (top-down) model. Blocking these breaks tier-1 performance methodology.
- **P1** — Used by upstream OSS tooling (PerfSpect, Linux perf metric groups, RHEL/Ubuntu pmu-tools). Blocking these breaks community observability.
- **P2** — Documented in the public PPR but not on the critical path of any known major tool. Lower priority.

## State Legend

- **Y** — Programmable AND returns non-zero on at least one well-known workload
- **B** — Programmable on bare metal but returns 0 on this CSP (hypervisor filter)
- **Z** — Programmable but our workload mix didn't trigger it (no information)
- **?** — Not yet probed in the current sweep