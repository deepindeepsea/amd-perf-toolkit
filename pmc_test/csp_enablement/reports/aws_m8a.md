# PMC Enablement Report — AWS m8a (Turin)

_Generated 2026-05-25 17:42 UTC from `csp_matrix.json`_

**Instance class:** m8a.* (EPYC Turin)  
**Hypervisor:** AWS Nitro  
**Vendor contact:** AWS EC2 support / Annapurna Labs  
**Scope:** Public Turin PPR (C1_pub_050) — 223 (event, umask) tuples

## Headline

| Status | Count | % of public PPR | Notes |
|---|---:|---:|---|
| **Supported (verified non-zero)** | 48 | 22% | tuples that program AND produce signal |
| **BLOCKED by hypervisor** | **28** | 13% | works on BM, silently returns zero on this CSP — gap to escalate |
| Zero-no-signal | 34 | 15% | event legal, our workloads didn't exercise it |
| Untested | 113 | 51% | per-bit umask not yet probed |

BM-Turin reference: 75 supported / 34 no-signal / 114 untested.
This CSP exposes **64% of BM-verified events** to guest workloads.

## Events to Enable (P0/P1 first, then P2)

These tuples are documented in the public BRH PPR and verified on bare-metal Turin, but return zero on this CSP — hypervisor PMC filtering blocks them. Listed by severity.

### P2 — 28 blocked

| PMC | Event | Umask | PPR Name | Used by PerfSpect |
|---|---|---|---|:---:|
| PMCx024 | 0x24 | 0x1 | Bad Status STLI | N |
| PMCx02C | 0x2c | 0x1 | Interrupts Taken | N |
| PMCx043 | 0x43 | 0x10 | Demand Data Cache Fills by Data Source | Y |
| PMCx043 | 0x43 | 0x2 | Demand Data Cache Fills by Data Source | Y |
| PMCx043 | 0x43 | 0x4 | Demand Data Cache Fills by Data Source | Y |
| PMCx043 | 0x43 | 0x40 | Demand Data Cache Fills by Data Source | Y |
| PMCx043 | 0x43 | 0x8 | Demand Data Cache Fills by Data Source | Y |
| PMCx044 | 0x44 | 0x10 | Any Data Cache Fills by Data Source | Y |
| PMCx044 | 0x44 | 0x2 | Any Data Cache Fills by Data Source | Y |
| PMCx044 | 0x44 | 0x4 | Any Data Cache Fills by Data Source | Y |
| PMCx044 | 0x44 | 0x40 | Any Data Cache Fills by Data Source | Y |
| PMCx044 | 0x44 | 0x8 | Any Data Cache Fills by Data Source | Y |
| PMCx04B | 0x4b | 0x1 | Prefetch Instructions Dispatched | N |
| PMCx04B | 0x4b | 0x2 | Prefetch Instructions Dispatched | N |
| PMCx052 | 0x52 | 0x1 | Ineffective Software Prefetches | N |
| PMCx052 | 0x52 | 0x2 | Ineffective Software Prefetches | N |
| PMCx059 | 0x59 | 0x2 | Software Prefetch Data Cache Fills by Data Source | N |
| PMCx059 | 0x59 | 0x4 | Software Prefetch Data Cache Fills by Data Source | N |
| PMCx059 | 0x59 | 0x8 | Software Prefetch Data Cache Fills by Data Source | N |
| PMCx05A | 0x5a | 0x10 | Hardware Prefetch Data Cache Fills by Data Source | N |
| PMCx05A | 0x5a | 0x2 | Hardware Prefetch Data Cache Fills by Data Source | N |
| PMCx05A | 0x5a | 0x4 | Hardware Prefetch Data Cache Fills by Data Source | N |
| PMCx05A | 0x5a | 0x40 | Hardware Prefetch Data Cache Fills by Data Source | N |
| PMCx05A | 0x5a | 0x8 | Hardware Prefetch Data Cache Fills by Data Source | N |
| PMCx085 | 0x85 | 0x2 | L1 ITLB Miss, L2 ITLB Miss | N |
| PMCx0AE | 0xae | 0x10 | Dynamic Tokens Dispatch Stall Cycles 1 | N |
| PMCx0CB | 0xcb | 0x1 | Retired MMX FP Instructions | N |
| PMCx0D6 | 0xd6 | 0x10 | Cycles with no retire | N |

## Events Supported (Verified Non-Zero)

| PMC | PPR Name | Working umasks |
|---|---|---|
| PMCx003 | FP retired SSE and AVX FLOPs | 0x8 |
| PMCx008 | FP uops retired by size | 0x1, 0x2, 0x4, 0x8, 0x10, 0x20 |
| PMCx024 | Bad Status STLI | 0x2 |
| PMCx029 | LS Dispatch | 0x1, 0x2, 0x4 |
| PMCx037 | Store Globally Visible Cancels Due To External Conditions | 0x1 |
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
| PMCx0AF | Dynamic Tokens Dispatch Stall Cycles 2 | 0x1, 0x2, 0x4, 0x20 |
| PMCx0CB | Retired MMX FP Instructions | 0x4 |
| PMCx0D6 | Cycles with no retire | 0x1, 0x2, 0x8 |
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