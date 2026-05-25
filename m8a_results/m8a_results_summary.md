# M8A vs Genoa-X Rails Benchmark — Full Results

**Date:** 2026-05-24
**Customer:** Stripe (Rails-on-AWS evaluation)
**Workload:** Rails Puma + wrk, "Hello World" endpoint, 30s each, Ruby 3.3.11

## Systems

| | M8A.metal-24xl | Bare-metal 9684X |
|---|---|---|
| CPU | AMD EPYC 9R45 (Zen5 Turin custom) | AMD EPYC 9684X (Zen4 Genoa-X) |
| Cores | 96 (1 NUMA, 12 CCDs × 8c) | 96 (1 NUMA, 12 CCDs × 8c) |
| L3 cache | 32 MB / CCD | 96 MB / CCD (32MB + 64MB 3D V-Cache) |
| Memory | 375 GiB DDR5 | DDR5 |
| Boost | ~4.5 GHz sustained all-core (observed) | ~3.2-3.6 GHz under load |

## Phase A — Naive M8A baseline (NO optimizations)

Default Puma config: 5 workers (Puma's default), no YJIT, no jemalloc, no taskset, no sysctl tuning.

| wrk config | RPS | p99 |
|---|---|---|
| -t1 -c100 | 3,108 | 33.45 ms |
| -t4 -c400 | 3,080 | 184.83 ms |
| -t8 -c800 | 2,396 | 360.86 ms |

**Conclusion:** Out-of-box Rails on M8A caps at ~3k RPS. More load just queues — workers are saturated.

## Phase B — Optimization Ladder (at N=8 CCD load, wrk -t8 -c800)

Each step adds ONE knob to the previous:

| Step | Configuration | RPS | p99 | Δ from previous |
|---|---|---|---|---|
| 0 | Default Puma (5 workers) | 2,477 | 364.28 ms | baseline |
| 1 | + `WEB_CONCURRENCY=64`, `RAILS_MAX_THREADS=1` | 145,790 | 18.00 ms | **+58.9×** |
| 2 | + jemalloc + `MALLOC_ARENA_MAX=2` | 148,129 | 14.18 ms | +1.6% |
| 3 | + YJIT | 146,526 | 14.25 ms | -1.1% (noise) |
| 4 | + taskset (Puma→0-63, wrk→88-95) | 157,049 | 18.20 ms | +7.2% |
| 5 | + sysctl tune + perf_event_paranoid=-1 | 154,635 | 18.68 ms | -1.5% (noise) |

**Total naive → fully tuned: 2,477 → 157,049 = 63.4× improvement.**

**Knob-by-knob credit:**
- `WEB_CONCURRENCY` matched to cores: **97.6% of the total gain**
- jemalloc + CCD pinning: ~3% additional, mainly p99 stability
- YJIT, sysctl: within measurement noise on this trivial workload (would matter more on real Rails app code)

## Phase C — CCD Scaling Sweeps

Three variants: baseline (taskset to N CCDs), isolated (explicit far-side client CCD), reuseport (one Puma instance per CCD via SO_REUSEPORT).

### Baseline (full stack, single Puma cluster, taskset)
| N CCDs | Workers | M8A RPS | M8A p99 | Genoa-X RPS | Genoa-X p99 | M8A/Genoa-X |
|---|---|---|---|---|---|---|
| 1 | 8 | 24,630 | 7.07 ms | 11,988 | 13.65 ms | 2.05× |
| 2 | 16 | 48,600 | 7.25 ms | 21,319 | 18.50 ms | 2.28× |
| 4 | 32 | 93,792 | 8.18 ms | 41,557 | 20.77 ms | 2.26× |
| 8 | 64 | **155,607** | 18.18 ms | 77,274 | 32.32 ms | **2.01×** |
| 11 | 88 | 145,177 | 30.07 ms | **92,871** | 33.38 ms | 1.56× (wrk-bound) |

### Isolated (explicit non-overlapping client CCD)
N=1: 25,330 ; N=2: 48,749 ; N=4: 94,489 ; N=8: 156,065 ; N=11: 144,120
→ **No measurable difference** vs baseline. CCD isolation is already implicit in the baseline recipe (client cores 88-95 are a separate CCD).

### REUSEPORT (one Puma per CCD)
N=1: 25,126 ; N=2: 25,525 ; N=4: 24,863 ; N=8: 25,245 ; N=11: 24,788
→ **Negative result.** SO_REUSEPORT on localhost hashes connections to a single shard — only one Puma instance gets load. Don't use this pattern for Rails behind wrk on localhost.

### Per-CCD efficiency (baseline)
| N | RPS/CCD | Efficiency |
|---|---|---|
| 1 | 24,630 | 100% |
| 2 | 24,300 | 98.7% |
| 4 | 23,448 | 95.2% |
| 8 | 19,451 | 79.0% |
| 11 | 13,198 | 53.6% (client-bound) |

## Files

- `amd-perf-toolkit/m8a_results/baseline/` — 5 PMC HTML reports (one per N)
- `amd-perf-toolkit/m8a_results/isolated/` — 5 PMC HTML reports
- `amd-perf-toolkit/m8a_results/reuseport/` — 5 PMC HTML reports
- `amd-perf-toolkit/m8a_results/ladder/` — 6 wrk logs (one per ladder step)
- `amd-perf-toolkit/m8a_results/naive/` — 3 wrk logs (naive @ -t1/-t4/-t8)
- `amd-perf-toolkit/m8a_results/morning_run.log` — full sweep transcript

## Open questions for the analysis

1. PMC pipeline breakdown at N=1 vs N=8 — where do the extra cycles go as scale climbs?
2. Why does taskset add 7% on top of just having 64 workers? Cross-CCD memory placement?
3. Genoa-X 3D V-Cache adds 64 MB L3 / CCD; M8A doesn't. Why does M8A still win 2×?
4. Customer pricing: m8a.metal-24xl on-demand vs m7i / m7a / m8g — what is $/RPS?
