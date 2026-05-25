# Perf Architect Analysis — M8A (Zen5 Turin) vs Genoa-X (Zen4 + 3D V-Cache) on Rails Puma

**Date:** 2026-05-24
**Author:** Performance Architect persona
**Source data:** `m8a_results/baseline/*.html` (PMC reports), `m8a_results_summary.md`

---

## TL;DR

M8A (EPYC 9R45, Zen5 Turin custom) delivers **2.0–2.3× the per-CCD throughput** of bare-metal EPYC 9684X Genoa-X on Rails Puma "Hello World", despite Genoa-X having 3× the L3 (96 MB vs 32 MB per CCD). The win decomposes roughly as **~30% frequency, ~70% Zen5 microarchitecture** (front-end width, branch predictor, op-cache). The 3D V-Cache offers no measurable benefit because the per-worker hot footprint already fits in the 1 MB L2 + 32 MB CCD-local L3, and Puma workers are fork-isolated so cross-core sharing in L3 is small.

---

## 1. Why does M8A beat Genoa-X 2.0–2.3× per CCD?

### Measured PMC (M8A baseline, full recipe)

| Metric | N=1 | N=2 | N=4 | N=8 | N=11 |
|---|---|---|---|---|---|
| RPS | 24,630 | 48,600 | 93,792 | 155,607 | 145,177 |
| IPC | 1.10 | 1.10 | 1.08 | 0.99 | 0.78 |
| Retiring % | 17.5 | 17.6 | 17.4 | 15.9 | 12.9 |
| Frontend Bound % | 101.3 | 101.1 | 100.2 | 97.7 | 88.9 |
| Backend Bound % | 11.2 | 11.3 | 12.5 | 16.2 | 27.0 |
| Bad Speculation % | 0.44 | 0.45 | 0.47 | 0.77 | 2.45 |
| Branch Misp Rate | 2.75 | 2.75 | 2.82 | 2.61 | 2.00 |
| Effective Freq (GHz) | 4.46 | 4.37 | 4.33 | 3.99 | 3.73 |
| Backend Memory % of BE | 50.3 | 50.5 | 49.1 | 49.1 | 49.0 |

*(Frontend+Backend slot totals can exceed 100% — perf's slot accounting overlaps in some categories. Treat as ordinal magnitudes.)*

### Frequency contribution

Genoa-X 9684X under sustained all-core load runs ~3.2–3.6 GHz (TDP-capped). M8A holds **4.46 GHz at N=1, 3.99 GHz at N=8**. Frequency ratio:

- N=8: 3.99 / ~3.4 ≈ **1.17× freq alone**
- N=1: 4.46 / ~3.6 ≈ **1.24× freq alone**

So frequency explains roughly **1.17–1.24× of the 2.0–2.3× gap**. The remaining **~1.6–1.9× is microarchitecture and platform**.

### Microarchitecture contribution (Zen5 vs Zen4)

Zen5 widens decode from 4-wide to 8-wide, doubles op-cache, and adds a second branch-predictor pipeline. PMC confirms front-end is the dominant pressure: Frontend Bound is ~100% slots at low load. Rails interpreter dispatch is heavily branchy and instruction-footprint-heavy — exactly the workload where Zen5's front-end upgrades matter most.

Branch misp rate is **2.75% at N=1** — high for a steady workload (SPEC CPU typical is 0.5–1%). Rails dispatch (method-lookup, type-checks, polymorphic call sites) issues many indirect branches. Zen5's TAGE-class predictor and larger BTB absorb more of these. Even at the same misp *rate*, Zen5's wider fetch recovers more useful work per mispredict-recovery cycle.

### Why 3D V-Cache buys nothing here

L2 DC Hit Rate sits at **~80% across all N** — 80% of L1D misses are caught by the 1 MB private L2 before they touch L3. The remaining 20% mostly hit in the CCD's local 32 MB L3. The extra 64 MB of stacked V-Cache on Genoa-X helps when *cores in the same CCD share working sets* (databases, in-memory analytics). Puma workers are fork-isolated — no shared mutable state, no benefit from larger shared L3.

**Conclusion #1:** ~30% of the M8A win is clock, ~70% is Zen5 front-end + branch prediction. V-Cache is dark for fork-isolated Ruby.

---

## 2. Why does per-CCD efficiency collapse from 100% (N=1) to 79% (N=8) to 54% (N=11)?

| N | Backend Bound % | Δ vs N=1 | RPS/CCD | Efficiency |
|---|---|---|---|---|
| 1 | 11.2 | — | 24,630 | 100% |
| 2 | 11.3 | +0.1 | 24,300 | 98.7% |
| 4 | 12.5 | +1.3 | 23,448 | 95.2% |
| 8 | 16.2 | +5.0 | 19,451 | 79.0% |
| 11 | 27.0 | +15.8 | 13,198 | 53.6% |

**Frequency droop**: 4.46 → 3.99 → 3.73 GHz from N=1→8→11. That alone is 11% loss at N=8 and 16% at N=11. The 9R45 honors the socket TDP envelope — once 88 cores boost together the package ceiling kicks in.

**Backend memory pressure**: Backend Bound nearly *triples* between N=4 and N=11; Backend Memory % of BE stays at ~50%, so half of those new stalls are memory. With 11 active CCDs all driving traffic into the shared IOD and DDR controllers, SDF/IOD bandwidth begins to bite. This is independent of any per-CCD L3 — it's the chip fabric.

**Bad Speculation rise**: 0.44% → 2.45%. Under heavy concurrency the kernel context-switches more (epoll, accept, scheduling), and each switch poisons branch history → misp spike on re-entry.

**Retiring share falls** 17.5% → 12.9%. Combined with the frequency drop, real µops/sec per CCD falls roughly in line with the efficiency curve.

**Important caveat for N=11**: the wrk client is bound to a single CCD (8 cores). Much of the N=11 plateau is the *client* hitting its connection-handling ceiling, not the server. See the Scaling Analyst report.

---

## 3. Why does WEB_CONCURRENCY alone deliver 58.9× while everything else is noise?

Naive default is **5 Puma workers** (Puma's safe default when CPU count is unknown). Optimized recipe is **64 workers** (one per active core). 5 workers cannot saturate 64 cores — the bottleneck is *process count*, not any CPU resource. At default config, CPU utilization stays under 8%; 91 cores sit idle.

Going 5 → 64 workers lets the kernel actually schedule work onto all the cores. The *next* round of knobs (jemalloc, YJIT, taskset, sysctl) each move the needle 1–7% because they tune behavior of cores already running hot. jemalloc cuts arena-lock contention (the multi-arena default in glibc malloc is famously bad for forked Ruby workers). YJIT compiles hot Ruby methods to native — but on trivial Hello World there is barely any Ruby work to JIT.

**The asymmetry is structural**: WEB_CONCURRENCY changes *how many CPUs are doing work*. The other knobs change *how efficiently each working CPU executes*. The first effect is multiplicative across cores; the second is additive per core. On a 64-core target the first wins by ~64×.

---

## 4. Why did SO_REUSEPORT fail (flat ~25k RPS regardless of N)?

The Linux kernel's SO_REUSEPORT load-balancer hashes the connection 4-tuple (src IP, src port, dst IP, dst port). For wrk → Rails on `localhost`, **src IP = dst IP = 127.0.0.1** and the dst port is fixed. Only src port varies. Each wrk thread opens a narrow ephemeral-port range; the hash mod N tends to collapse to **one bucket per wrk thread**.

Net effect: 11 Puma instances listen, but the kernel routes ~all connections from the wrk client to a single instance. The other 10 sit idle. Single-instance ceiling on one CCD is ~25k RPS — exactly what we measured at every N.

**This is a localhost-benchmark artifact, not a real-deployment finding.** Behind a real load balancer (ALB, HAProxy) or with wrk on a different machine and source-port entropy, SO_REUSEPORT spreads correctly. Recommend **not** using REUSEPORT for any future localhost benches; use a single Puma cluster with `WEB_CONCURRENCY` instead.

---

## Open architectural questions for follow-up

1. No matched Genoa-X PMC report at N=8 yet — would confirm the IPC/freq split numerically.
2. SDF/IOD bandwidth at N=11 — needs uprof or RDMA counters not in our current harness.
3. Real Stripe-style Rails (controllers, ActiveRecord, JSON serialization) will increase retiring share and L2/L3 footprint — V-Cache *may* show value there. Re-benchmark with a representative app, not Hello World.

---

## Citations
- Baseline PMC reports: `m8a_results/baseline/m8a_ccd{1,2,4,8,11}*.html`
- Consolidated summary: `outputs/m8a_results_summary.md`
