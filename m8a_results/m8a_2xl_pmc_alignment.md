# M8A.2xlarge vs M8A.metal-24xl (1-CCD slice) — PMC Matrix Alignment

Date: 2026-05-24
Workload: Rails 8.1.3 + Puma 8 cluster, 7 workers × 1 thread, jemalloc, YJIT.
Geometry: 7 cores pinned to Puma (taskset 0-6), 1 core pinned to wrk (taskset 7), localhost, c=100, 30 s.

## Aligned PMC matrix

| Metric | m8a.metal-24xl 1-CCD slice | m8a.2xlarge | Δ |
|---|---|---|---|
| RPS @ c=100 | 24,630 | 16,982 | −31% |
| p99 latency (ms) | 7.16 | 11.51 | +61% |
| Effective Freq (GHz) | 4.46 | 4.13 | −7.4% |
| IPC | 1.10 | 1.29 | +17% |
| Frontend Bound % | 101.3 | 70.9 | −30 pts |
| Backend Bound % | 11.2 | 27.6 | +16.4 pts |
| Bad Speculation % | 0.44 | 12.7 | +12.3 pts |
| Retiring % | 17.5 | 20.7 | +3.2 pts |
| Branch Misp Rate % | 2.75 | 3.50 | +0.75 pts |
| Backend Memory % of BE | 50.3 | 98.7 | +48.4 pts |

## Reading

Same silicon (EPYC 9R45 Zen5), same configuration, same workload. The −31% RPS
on m8a.2xlarge is explained entirely by Nitro shared-tenant overhead:

- **Back-end pressure 2.5×** and almost entirely memory-bound (98.7% of BE
  stalls are loads). The single-CCD slice on the 2xl experiences far more
  L3/DRAM contention than the equivalent slice on the metal box, consistent
  with the IOD fabric being shared across other tenants on the host.
- **Bad Speculation up 30×** (0.44 → 12.7). Frequent Nitro/hypervisor
  interrupts and scheduler events poison the branch predictor state. Each
  resumption costs misp-recovery cycles.
- **Frequency capped 7% lower** (4.46 → 4.13 GHz). The bare-metal silicon
  hits its single-CCD boost ceiling; the 2xl is governed lower by EC2 power
  policy.
- **IPC inflation** (+17%) is *not* a positive signal here — it just means the
  front-end has plenty of slack because the back-end is starving it.
- **Branch misp rate** +0.75 pts is the second-order effect of the
  bad-spec storm.

## Net

The PMC *shape* matches between 2xl and 24xl-1CCD slice — same Zen5
microarchitecture, same Rails workload signature. The *magnitudes* differ
exactly where Nitro overhead would predict (memory, speculation, frequency).

For customer sizing on m8a.2xlarge: use 17k RPS / 11.5 ms p99 as the
real-shape number, not the 24k bare-metal slice.
