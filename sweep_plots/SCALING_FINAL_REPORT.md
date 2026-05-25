# Rails (Puma + wrk) CCD Scaling — Final Comparative Report

**Host:** AMD EPYC 9684X (96-core Zen4 Genoa-X, 12 CCDs × 8 cores, 96 MB L3 per CCD)
**Workload:** Ruby on Rails `/hello` endpoint via Puma, wrk load generator co-located on dedicated CCDs
**Date:** 2026-05-23
**Sweep:** N ∈ {1, 2, 4, 8, 10} server CCDs across four configurations
**Playbook reference:** AMD EPYC Processor Performance Playbook v1.2 (Feb 2025), §4 (Indicators), §6 (Optimizing L3 Domain Usage)

## 1. Headline numbers

| N | Baseline (rig-fix) | Round A: + jemalloc / MALLOC_ARENA_MAX=2 | Round B: + per-CCD Puma isolation | Round C: + YJIT (Ruby 3.3.11) | C vs Baseline |
|---|---:|---:|---:|---:|---:|
| 1 | 12,005 | 12,402 | 12,400 | **19,649** | **+64%** |
| 2 | 21,331 | 22,021 | 24,699 | **39,022** | **+83%** |
| 4 | 41,296 | 42,751 | 49,383 | **77,288** | **+87%** |
| 8 | 77,157 | 79,789 | 96,151 | **112,999** | **+46%** |
| 10 | 90,115 | 93,195 | 113,281 | **122,582** | **+36%** |

Per-CCD efficiency at N=10 (vs that round's own N=1 baseline):

| Round | RPS @ N=1 | RPS @ N=10 | Per-CCD efficiency |
|---|---:|---:|---:|
| Baseline | 12,005 | 90,115 | 75.1% |
| A: + jemalloc | 12,402 | 93,195 | 75.1% |
| B: + per-CCD isolation | 12,400 | 113,281 | **91.4%** |
| C: + YJIT | 19,649 | 122,582 | 62.4% |

Round B was the inflection point for *scaling*; Round C was the inflection point for *absolute throughput*. The lower per-CCD efficiency in Round C is the expected consequence of a 64% higher single-CCD ceiling — at 19.6k RPS/CCD, the workload runs into client-side and shared-kernel-resource ceilings sooner.

## 2. PMC evidence — does the data agree with the diagnosis?

Selected metrics, captured per-CPU on the active server cores via `perf stat -j`:

| Round | N | IPC | Frontend % | Backend Mem % | Retiring % |
|---|---:|---:|---:|---:|---:|
| Baseline | 1 | 0.952 | 53.6 | 19.6 | 16.5 |
| Baseline | 10 | 0.834 | 52.1 | **23.7** | 14.5 |
| A | 10 | 0.858 | 52.7 | 22.4 | 15.0 |
| B | 10 | **0.937** | 54.1 | **19.4** | 16.3 |
| C | 1 | **1.153** | 67.0 | **8.2** | **19.9** |
| C | 10 | 0.978 | 62.7 | 14.6 | 17.0 |

What the PMCs confirm:

**Round B fixed cross-CCD coherence (the diagnosed bottleneck).** Backend Memory Bound at N=10 dropped from 23.7% → 19.4%, identical to the N=1 floor in Rounds A/B. IPC stayed at 0.937 at N=10 vs 0.834 in baseline — the IPC degradation across N is gone. This is the signature the playbook describes for resolved L3-domain contention: per-CCD metrics that are flat with respect to N.

**Per the playbook's L3 Domain Usage section (§6.1), the high-level indicators for cross-CCX/CCD data sharing are exactly the ones we moved:**
* `Moderate–High % backend_bound_memory` (we had 23.7% → 19.4%)
* IPC degradation across cores in the same workload (we had −12% → −4%)
* Effective frequency drop without thermal throttling (the cores were waiting on cross-CCD coherence misses, not stalled on compute)

The diagnosis was correct: the original scaling loss was *not* a per-CCD cache problem (L2 hit rates were flat throughout) but cross-CCD coherence on shared cachelines + a single shared accept queue serializing connection arrival across all workers.

**Round C exposed where the remaining headroom lives.** YJIT lifted IPC 0.974 → 1.153 (+18% at N=1) and cut Backend Memory Bound roughly in half (18% → 8%). YJIT replaces Ruby's interpreter dispatch (which is data-dependent loads — exactly the loads that show up as backend memory stalls) with native machine code. Retiring % climbed from ~17% to ~20%. This is the playbook's "high frontend_bound + low IPC → consider JIT" recommendation, expressed quantitatively.

Frontend Bound went *up* in Round C from 54% to 67%. That looks counter-intuitive but is correct: with native code retiring faster, the *fraction* of slots waiting on instruction supply (icache, branch redirection, decode width) becomes relatively larger even as absolute stalls shrink. The Retiring % rise (17% → 20%) tells you the pipeline is actually doing more useful work.

## 3. What worked — ranked by lift

| Change | Cumulative lift (N=10) | Per-CCD lift (N=1) | Mechanism |
|---|---:|---:|---|
| Rig fix (wrk on 2 CCDs) | baseline | baseline | Removed client saturation as confounder |
| jemalloc + `MALLOC_ARENA_MAX=2` | +3.4% | +3.3% | Bounded glibc per-thread arenas; less cross-CCD heap walking |
| Per-CCD Puma isolation (one master per CCD, one port per CCD) | **+21.6%** | flat | Eliminated shared listen-socket accept-lock; each CCD owns its own queue |
| YJIT (Ruby 3.3.11) | **+8.2%** on top | **+58%** on top | Replaces interpreter dispatch with native code; halves backend memory stalls |
| **Combined (B+C vs Baseline)** | **+36%** | **+64%** | — |

Round B is the structural fix — it changes how the application uses the CPU topology. Round C is the per-core ceiling change — it makes each CCD intrinsically faster. The two are additive and address different bottlenecks (the playbook's L3 Domain Usage chapter vs the playbook's `frontend_bound`/`retiring%` discussion in §4 Pipeline Utilization).

## 4. What did *not* land as expected

* **jemalloc gave only +3.4% uniformly across N.** The hypothesis was that glibc per-thread arenas were a major source of cross-CCD chatter. The uniform-across-N lift says it's a small per-process win, not a scaling fix. The real cross-CCD contention was the accept queue, not the heap.
* **Puma 8's `?reuseport=true` URI parameter was a no-op on this Puma version.** SO_REUSEPORT support was not in Puma 8.0.1 (verified via `grep reuseport` in the gem source). We achieved the same effect via per-CCD Puma masters on separate ports + parallel wrk processes per port. Future Puma versions with SO_REUSEPORT would let one master cover this.
* **N=10 in Round C is starting to show client saturation again.** Per-CCD efficiency dropped to 62%. With 122k RPS through 10 wrk worker threads, we're at ~12.3k RPS per wrk thread — uncomfortably close to the per-thread ceiling. The split-host phase (dedicated load-gen instance) is required to take this further.

## 5. Recommendations validated for documentation

The combined recipe that should be the documented "fast Rails on EPYC" path:

1. **Use Ruby 3.3+ with `--enable-yjit`.** Compile with `RUBY_CONFIGURE_OPTS=--enable-yjit` (requires `rustc`). Enable per-process with `RUBY_YJIT_ENABLE=1`.
2. **Preload jemalloc with bounded arenas.** `LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 MALLOC_ARENA_MAX=2`.
3. **One Puma master per CCD, each on its own port, pinned with `taskset`.** Until Puma supports SO_REUSEPORT natively, run N independent Puma processes (8 workers each) on ports `3000..3000+N-1`, each `taskset -c <CCD_cores>`. Front with a kernel-aware load balancer or have the client open connections to a port per CCD.
4. **Pin the load generator to dedicated CCD(s).** Reserve at least 2 CCDs for the client at the scale we tested (N up to ~10). For higher N, move the client off-box entirely.
5. **Validate with `perf stat` — Backend Memory % at N should be within ~1pp of N=1.** That's the playbook's L3-domain optimization endpoint. If it grows with N, you still have cross-CCD coherence work to do.

## 6. Next phases (planned)

* **AWS m7a.24xlarge baseline.** Vanilla install of Ruby 3.3.11 + YJIT + jemalloc, repeat the 4-round sweep, compare to bare-metal Genoa-X numbers. Validates that the recipe carries over to cloud VMs that expose CCD topology to the guest.
* **Split-host on EC2.** Second instance acts as dedicated wrk client over the EC2 network, DUT runs only Puma. Removes client + network noise from the compute-only measurement.
* **GCP C4D / Azure Dadsv6 cross-cloud comparison** using the same recipe — the per-CCD efficiency number is the cleanest way to compare across providers because it cancels out instance shape differences.

## 7. Artifacts

* `rails_4round_scaling.png` — RPS and per-CCD efficiency for all four rounds
* `rails_pmc_trends.png` — IPC, Backend Memory %, Retiring % across N for all four rounds
* `roundC_yjit/`, `roundB_isolated/`, `roundA_jemalloc/`, `rigfix_2ccd_client/` — per-N HTML reports (PerfSpect-style)
* `epyc_playbook_v12.pdf` — AMD EPYC Performance Playbook v1.2 preview, used as the diagnostic reference
