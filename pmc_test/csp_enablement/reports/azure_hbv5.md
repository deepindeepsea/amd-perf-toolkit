# PMC Enablement Report — Azure Turin shapes

_Generated 2026-05-25 17:42 UTC from `csp_matrix.json`_

**Instance class:** HBv5 / Dasv6 (EPYC Turin)  
**Hypervisor:** Hyper-V  
**Vendor contact:** Azure HPC / Azure Compute partner team  
**Scope:** Public Turin PPR (C1_pub_050) — 223 (event, umask) tuples

## Headline

| Status | Count | % of public PPR | Notes |
|---|---:|---:|---|
| **Supported (verified non-zero)** | 0 | 0% | tuples that program AND produce signal |
| **BLOCKED by hypervisor** | **0** | 0% | works on BM, silently returns zero on this CSP — gap to escalate |
| Zero-no-signal | 0 | 0% | event legal, our workloads didn't exercise it |
| Untested | 223 | 100% | per-bit umask not yet probed |

BM-Turin reference: 75 supported / 34 no-signal / 114 untested.
This CSP exposes **0% of BM-verified events** to guest workloads.

## Events Supported (Verified Non-Zero)

## Severity Legend

- **P0** — Required for AMD's BRH Pipeline-Utilization (top-down) model. Blocking these breaks tier-1 performance methodology.
- **P1** — Used by upstream OSS tooling (PerfSpect, Linux perf metric groups, RHEL/Ubuntu pmu-tools). Blocking these breaks community observability.
- **P2** — Documented in the public PPR but not on the critical path of any known major tool. Lower priority.

## State Legend

- **Y** — Programmable AND returns non-zero on at least one well-known workload
- **B** — Programmable on bare metal but returns 0 on this CSP (hypervisor filter)
- **Z** — Programmable but our workload mix didn't trigger it (no information)
- **?** — Not yet probed in the current sweep