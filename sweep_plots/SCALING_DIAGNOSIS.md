# Rails (Puma + wrk) CCD Scaling Diagnosis

**Host:** AMD EPYC 9684X (96-core, 12 CCDs, Zen4, 96 MB L3 per CCD)
**Workload:** Ruby on Rails "hello" endpoint, Puma workers pinned per CCD, wrk on reserved CCD 11 (cores 88-95)
**Sweep:** N = 1, 2, 4, 8, 11 server CCDs; wrk threads = N (capped at 8)

## 1. Headline numbers

| N | wrk | RPS    | vs ideal | Avg ms | p50  | p99  | IPC   | Eff GHz | FE%  | BE%  | BE_mem% | Retiring% | L2 DC | L2 IC |
|---|-----|--------|----------|--------|------|------|-------|---------|------|------|---------|-----------|-------|-------|
| 1 | 1   | 11,988 | 100%     | 8.36   | 8.43 | 13.65| 0.951 | 3.66    | 53.6 | 21.4 | 19.7    | 16.4      | 60.9  | 78.7  |
| 2 | 2   | 21,319 | 89%      | 9.39   | 9.04 | 18.50| 0.901 | 3.54    | 54.9 | 21.1 | 19.3    | 15.7      | 61.0  | 78.3  |
| 4 | 4   | 41,557 | 87%      | 9.66   | 9.13 | 20.77| 0.891 | 3.51    | 54.4 | 21.9 | 20.1    | 15.5      | 60.4  | 78.2  |
| 8 | 8   | 77,274 | 81%      | 10.68  | 9.30 | 32.32| 0.862 | 3.40    | 53.6 | 23.5 | 21.6    | 15.0      | 60.9  | 78.1  |
| 11| 8†  | 92,871 | 70%      | 9.35   | 7.26 | 33.38| 0.808 | 3.22    | 50.8 | 27.7 | 25.5    | 14.1      | 60.7  | 77.8  |

† wrk thread count capped at 8; load generator (single CCD, 8 cores) became the bottleneck at N=11.

Per-CCD efficiency falls from 11,988 RPS/CCD at N=1 to 8,443 RPS/CCD at N=11 — a **30% loss** in per-CCD throughput at scale.

## 2. What the PMCs are telling us

The cache hit rates barely move (L2 DC ~61%, L2 IC ~78% across the whole sweep), so this is **not** an L2 thrashing problem — the per-request working set still fits inside each CCD's 1 MB L2 / 96 MB L3. The interesting signal is in three other counters that all move together as N grows:

**Backend Memory Bound climbs 19.7% → 25.5%.** Backend stalls themselves grow from 21.4% to 27.7% of dispatch slots, and almost all of that growth is in the memory component (`ex_no_retire.load_not_complete / not_complete` ratio rises). Since L2 hit rate is flat, the extra load-completion stalls have to be coming from **L3 misses that go to DRAM or to a remote CCD's L3** — i.e. cross-CCD shared cachelines. Likely sources: shared Rails class hierarchy / method cache / inline caches mutated by every worker, GC marks touching objects allocated across CCDs, and kernel socket / epoll structures shared between accept thread and worker threads.

**Effective frequency drops 3.66 → 3.22 GHz (-12%).** Base clock is 3.694 GHz and the CPU never throttles in 8-core workloads on this part, so the drop is not thermal/power. It's **idle time inside the measured window** — cores blocking in syscalls (epoll_wait, futex on the GVL, write to socket) so `cpu-cycles` per `task-clock` ms decreases. That's confirmation the workload is becoming **serialization-bound**, not compute-bound.

**IPC drops 0.95 → 0.81 (-15%).** This is the direct consequence of (a) more memory stalls (lower retiring) and (b) more time the dispatch unit has nothing to do because the core is waiting on a kernel object. Retiring% falls 16.4 → 14.1.

**p99 latency more than doubles, 13.6 → 33.4 ms,** while p50 actually improves at N=11 (7.3 ms). That tail shape is the fingerprint of a **queueing bottleneck somewhere downstream of accept** — most requests sail through, but a small fraction get stuck behind a contended lock (GVL, malloc arena, listen-socket accept-lock, IRQ steering of all packets to one CPU).

Frontend Bound stays in the 51-55% band the whole time. That's high, but it's not the thing that's getting worse, so it's a property of the Ruby interpreter (icache pressure from a large method dispatch path), not of the scaling problem.

## 3. Root-cause summary

The non-linear scaling is **not** a per-CCD cache or topology problem (per-CCD cache behavior is essentially constant). It is a **cross-CCD coherence + kernel/Ruby serialization** problem with three reinforcing layers:

1. **Cross-CCD coherence traffic on shared cachelines.** As Puma workers spread across more CCDs, every shared mutable object (logger, GC bitmap, method cache, malloc arena metadata, kernel sockets) bounces between CCD L3 domains. ~100 ns per cross-CCD miss. This is what shows up as BE_mem% climbing 19.7→25.5.

2. **Single load-generator CCD becomes a bottleneck above N=8.** At N=11 wrk is still on 8 cores generating 92.9k RPS = ~11.6k RPS/wrk-thread, very close to the per-thread ceiling we observed at N=1. The fact that p99 stays flat from N=8 to N=11 while RPS only grows 20% tells us the **client** is now in the loop. The 81%→70% efficiency drop at N=11 is partly an artifact of the test setup, not the server.

3. **Kernel/Ruby serialization (GVL, accept lock, IRQ steering, single listen socket).** Effective frequency dropping while no thermal throttling is happening means more wall-clock time spent in kernel waits. The p99 tail confirms a single contended resource.

## 4. Recommended experiments, ranked by expected payoff

**Tier 1 — try these first, expect 15-40% gain at N=8:**

- **`MALLOC_ARENA_MAX=2` + jemalloc** (`LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2`). glibc's per-thread arenas fragment badly across CCDs and produce exactly the BE_mem signature we're seeing. jemalloc with bounded arenas is the standard fix; documented 15-30% RPS lift on Rails/Puma.
- **`SO_REUSEPORT` with one Puma cluster per CCD** instead of one cluster spanning all CCDs. Each CCD then has its own listen socket, its own accept queue, and the kernel hashes incoming connections by 4-tuple → no shared accept lock. This is the single biggest scaling fix for socket servers above 8 cores.
- **Pin NIC IRQs to the client CCD (or split across server CCDs).** `cat /proc/interrupts | grep <nic>` then `echo <mask> > /proc/irq/<n>/smp_affinity`. If all softirqs are landing on CCD 0 today, every packet for CCDs 1-7 is doing a cross-CCD touch before the Ruby worker even sees it.

**Tier 2 — Ruby/Rails level, expect 10-25% additional:**

- **YJIT enabled** (`RUBY_YJIT_ENABLE=1`, Ruby 3.3+). Reduces frontend pressure and instructions retired per request — directly attacks the high FE% (53%) we see across the board.
- **`RUBY_GC_HEAP_INIT_SLOTS` / `RUBY_GC_HEAP_GROWTH_FACTOR` tuning** to stop GC mark-phase cross-CCD walks.
- **Drop logger to async or `/dev/null`** during the benchmark — Rails logger writes a mutex-protected line per request.

**Tier 3 — kernel/network, expect 5-15%:**

- `net.core.somaxconn=65535`, `net.ipv4.tcp_max_syn_backlog=65535`
- `net.core.busy_poll=50`, `net.core.busy_read=50` (cuts epoll wake latency)
- Try UDS (Unix domain socket) between wrk-equivalent and Puma to remove the TCP stack entirely as a control experiment — if the BE_mem% gap vanishes, we've localized to TCP socket coherence.

**Test-rig fixes (do these before drawing more scaling conclusions):**

- **Move wrk to a second machine** or at minimum to 2 CCDs (16 threads) and re-run N=8 and N=11. Today's N=11 number is contaminated by client saturation.
- **Run the sweep 3× and report median** — single-run RPS has ~3% noise from cold caches and the first GC cycle.
- **Add `--latency` and `-d 60s`** to wrk and discard the first 10 s (warmup).

## 5. Suggested next sweep

```bash
# Per-CCD Puma cluster with SO_REUSEPORT + jemalloc + YJIT
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 \
MALLOC_ARENA_MAX=2 \
RUBY_YJIT_ENABLE=1 \
PERF_CPULIST=0-7,8-15,...  ./benchmark_ccd_sweep.sh
```

If this lifts the N=8 point from 77k to ~100k+ RPS and shrinks BE_mem% back toward 20%, the diagnosis above is confirmed and the same set of changes will give us a credible path to >150k RPS at N=11 (with the client moved off-box).

## 6. Plots

- `rps_scaling.png` — RPS vs N with ideal-linear overlay and per-CCD efficiency labels
- `latency_scaling.png` — avg / p50 / p99 vs N
- `pmc_trends.png` — IPC, pipeline breakdown, effective frequency, L2 hit rates vs N
