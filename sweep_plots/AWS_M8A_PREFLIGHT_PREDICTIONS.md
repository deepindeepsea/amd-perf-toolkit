# AWS m8a.24xlarge Pre-flight Predictions

**Source:** AMD EPYC Processor Performance Playbook v1.2 (Feb 2025, Netflix-released preview, 198 pages). Local copy: `outputs/epyc_playbook_v12.pdf`.
**Bare-metal baseline:** `amd-perf-toolkit/sweep_plots/SCALING_FINAL_REPORT.md` — EPYC 9684X Genoa-X, 12 CCDs × 8 cores, **96 MB L3/CCD** (3D V-Cache).
**Target:** AWS m8a.24xlarge — Turin (Zen5), 96 physical cores, **SMT off by default**, expected **32 MB L3/CCD**, EC2 Nitro hypervisor, ENA networking, no deterministic boost control.
**Validated recipe to port:** (1) Ruby 3.3.11 + YJIT, (2) jemalloc + `MALLOC_ARENA_MAX=2`, (3) per-CCD Puma master per port (SO_REUSEPORT workaround), (4) `taskset` per CCD.
**Author:** Pradeep (with Cowork) — 2026-05-23

---

## 1. Recipe component shifts on Turin/m8a

The Playbook §6.1 framing is that anything causing **cross-L3-domain interactions** becomes more punishing when each domain is smaller and frequency headroom is lower. Genoa-X's 96 MB L3 was masking some cross-CCD traffic that fit in cache; Turin's 32 MB L3 per CCD strips that buffer away. Three of four components get *more* important; one stays neutral.

| Component | Bare-metal lift | m8a prediction | Mechanism (with Playbook citation) |
|---|---:|---:|---|
| **(3) Per-CCD Puma isolation** | +21.6% @ N=10 | **+28-35% @ N=10** | The shared listen socket / accept queue is a §6.1.2 *Inter-Thread Synchronization* hotspot on cache lines shared across L3 domains. With 3× smaller L3 per CCD, those lines spill from L3 more often → cross-CCD coherence misses become more expensive in cycles and more frequent. The Playbook explicitly recommends "multiple smaller instances of the application... rather than a single large instance" (§6.1.2). This is exactly per-CCD Puma. |
| **(2) jemalloc + MALLOC_ARENA_MAX=2** | +3.4% uniform | **+8-12% uniform** | glibc per-thread arenas are a §6.1.1 *Concurrent Data Modification* pattern — arena metadata is read-modify-write across threads, classic cross-domain coherence load. The 32 MB L3 cannot absorb as many idle arena pages as 96 MB could, so cross-CCD heap walks happen earlier. Playbook §6.1.1 fix: "limit sharing of data structures to L3 domain granularity" → exactly what jemalloc + arena cap delivers. |
| **(1) YJIT** | +58% @ N=1 | **+45-55% @ N=1** (slightly less) | YJIT addresses §4.4.1 Pipeline Utilization — replaces interpreter dispatch loads (Backend Memory %) with native code (Retiring %). The mechanism is per-core and L3-size-independent, but the *absolute* per-CCD ceiling is lower on m8a because EC2 frequency is lower (~3.0 GHz all-core vs 3.66 GHz observed on bare-metal Genoa-X N=1). So the **percentage** lift is comparable; the **absolute** RPS-per-CCD is lower. |
| **(4) taskset per CCD** | n/a (rig requirement) | **Critical, but verify CCD visibility first** | Playbook §2.2.5 *L3 Domains* requires `lstopo` / `lscpu`/sysfs `index3/shared_cpu_list` to identify domain boundaries. If Nitro doesn't expose them faithfully (see §3 below), the pins become meaningless. **First-5-minute check.** |

**Net headline prediction (cumulative): full recipe lift on m8a vs vanilla Ruby 3.2/single Puma cluster should be larger than on Genoa-X**, because the recipe attacks an enlarged bottleneck (cross-CCD coherence on smaller L3) and adds a fresh one (jemalloc matters more). Expect cumulative N=10 lift in the **+45 to +55%** band vs +36% on Genoa-X.

---

## 2. Turin/m8a additions on top of the Genoa-X recipe

| Addition | Playbook citation | Why it's Turin/m8a-specific |
|---|---|---|
| **Adaptive Allocation BIOS knob** | §6.1.3 *Producer and Consumer*: "BIOS options exist starting on Zen5". Cache dynamically changes policies based on observed behavior. | New on Zen5. We can't flip BIOS knobs in an EC2 guest, but we can detect via `dmidecode` and ask AWS support about the m8a default. Worth filing as a "ask AWS / Turin team" follow-up rather than blocking the run. |
| **Speculative Stores Mode** | §6.1 "Modify the Speculative Store Mode... BIOS options exist starting on Zen4." | Same constraint — not user-tunable on EC2. Document the m8a default if discoverable. |
| **2 MB Transparent Huge Pages** | Playbook silent on hugepages directly, but §6.1.4 *Thread Scheduling Effects* on TLB pressure. | First-principles: smaller L3 → more DRAM touches → TLB misses bite harder. Verify `cat /sys/kernel/mm/transparent_hugepage/enabled` is `[always]` or at minimum `[madvise]`. Nitro / Ubuntu 24.04 default is `[madvise]` — fine for Ruby's slab-allocated objects via jemalloc. **No action expected, but verify.** |
| **`pvspinlock` feature on VMs** | §6.1.2 fragment + libvirt example: `<features><pvspinlock state='on'/></features>` | This is a *host-side* hint for guest spinlock yielding. AWS Nitro should have it enabled by default; we can't change it. Mention in the report if `native_queued_spin_lock_slowpath` shows up high in `perf top` during the run — that's the symptom Playbook §6.1.2 describes. |
| **`net.core.busy_poll` / `busy_read` = 50** | Playbook silent (out of scope for the L3-domains preview). | Our prior `SCALING_DIAGNOSIS.md` Tier-3 recommendation. ENA on Nitro is a software NIC — busy polling can help at the high RPS we're chasing. Apply if N=10 hits a wall < 100k RPS. |
| **Confirm `cpufreq` governor is `performance`** | §3.4 Performance Variability — drift is a variability source. | EC2 doesn't always honor governor changes (Nitro may enforce schedutil). Document what's actually set; don't assume. |
| **NUMA policy `--interleave=all` for Puma master is NOT recommended** | §6.1 — interleave defeats domain-locality, which is the whole point of the per-CCD recipe. | Explicit anti-recommendation. Stay with default localalloc + per-CCD pin. |

---

## 3. AWS-guest gotchas — verify in the first 5 minutes

The Playbook §2.2.4–§2.2.5 commands all rely on `lstopo` / `numactl --hardware` / sysfs faithfully reporting hardware topology. Inside Nitro, this is hypervisor-dependent. **Run these first; the rest of the plan is conditional on the answers:**

```bash
# 1. CCD visibility — the single most important check
lscpu | grep -E "Model name|^CPU\(s\)|Thread\(s\)|Socket\(s\)|NUMA"
lstopo-no-graphics | grep -E "L3|Package|NUMA"
cat /sys/devices/system/cpu/cpu*/cache/index3/shared_cpu_list | sort -u
# Expected on m8a.24xlarge (Turin, no V-Cache): 12 unique L3 lists,
# each covering 8 contiguous CPUs (cpu0-7, cpu8-15, ...).
# If instead we see one giant list covering all 96 CPUs → Nitro is hiding CCD topology,
# and the entire per-CCD recipe degrades to "pin to any 8 cores".

# 2. NUMA exposure
numactl --hardware
# Expected: 1 NUMA node (single-socket m8a). NPS=1 unless AWS has done something unusual.

# 3. L3 size confirmation
lscpu | grep "L3 cache"
# Expected: ~32 MB per instance (Turin without V-Cache). If we see 96 MB → it's Turin-X
# (3D V-Cache Turin variant) and the whole "smaller L3" prediction is wrong — flag immediately
# and the lift table in §1 needs revision.

# 4. CPU model
cat /proc/cpuinfo | grep "model name" | head -1
# Expected: "AMD EPYC 9V64H" or similar 9005-series Turin SKU.

# 5. ENA IRQ steering — known cross-CCD risk
cat /proc/interrupts | awk '/ena|nvme/{print $1, $NF}' | head -20
for irq in $(awk '/ena/{gsub(":",""); print $1}' /proc/interrupts); do
  echo "IRQ $irq: $(cat /proc/irq/$irq/smp_affinity_list)"
done
# Risk: if all ENA queues are pinned to CPUs 0-7 (CCD 0), every Puma worker on CCDs 1-9
# receives packets via cross-CCD softirq handoff. Spread or move IRQs to the client CCDs
# (cores 80-95) so the kernel handoff stays inside the same CCD as wrk.
```

**Honest uncertainty:**
- **CCD visibility on m8a is the open question.** AWS has been good about exposing topology on m7a/m8a (vs hiding it like some Azure SKUs). I expect it works, but I haven't personally validated it on m8a.24xlarge.
- **Nitro can rate-limit network packets per-flow.** Even if Puma scales linearly, wrk-to-Puma over the in-instance loopback should bypass ENA, so this should not affect the co-located rig. Flag if it does.
- **EC2 enforces a ~3.0 GHz all-core boost cap** without exposing thermal headroom. Effective frequency will be much flatter across N than the 3.66→3.22 GHz curve we saw bare-metal.

---

## 4. PMC events Zen4 → Zen5

The toolkit's CLAUDE.md lists confirmed-working Zen4 events. Most are stable across Zen3/4/5 because they're core-pipeline indicators that have existed since Zen2. **Predicted Zen5 status:**

| Event | Predicted on Zen5 | Notes |
|---|---|---|
| `de_no_dispatch_per_slot.no_ops_from_frontend` | Works | Same name in PPR Family 1Ah (Turin). Pipeline width still 6 ops/cycle. |
| `de_no_dispatch_per_slot.backend_stalls` | Works | Same. |
| `de_src_op_disp.all` | Works | Stable. |
| `ex_ret_ops` | Works | Stable. |
| `ls_not_halted_cyc` | Works | Stable since Zen2. |
| `ex_no_retire.load_not_complete` | Likely renamed | Zen5 may expose this as `ex_no_retire.load_not_complete` (same) OR split into a finer set. Verify via `perf list ex_no_retire`. |
| `ex_no_retire.not_complete` | Same risk | Same as above. |
| `ex_ret_brn_misp`, `ex_ret_brn` | Works | Stable. |
| `l2_cache_req_stat.{dc_hit_in_l2,ls_rd_blk_c,ic_fill_miss,ic_hit_in_l2}` | Likely renamed/expanded | Zen5 L2 PMC event group was reorganized — naming convention shifted to `ls_l2_*` and `ic_l2_*` umasks. Check `perf list l2_cache` and `perf list ls_l2`. |
| `l3_lookup_state.*` | Already broken on Zen4 9684X | Not expected to work on m8a either. Don't add it back. |

**Zen5-only events worth adding** (per Family 1Ah PPR if accessible, or `perf list`):
- A more granular cross-CCX/CCD data-sharing event — Zen5 added telemetry around remote L3 fills. Look for `ls_any_fills_from_sys.*` umasks; specifically `near_cache` and `far_cache` distinguish same-CCX vs cross-CCX fills, which **directly measures the §6.1 bottleneck**. Already mentioned in Playbook §6.1.1.
- IBS sampling (`ibs_op//`) per §6.1.2 — works on both, but more useful at scale.

**Sanity-check command to run first on m8a (before the sweep):**
```bash
sudo perf list 2>/dev/null | grep -E "^  (de_no_dispatch_per_slot|de_src_op_disp|ex_ret_ops|ex_no_retire|ex_ret_brn|l2_cache_req_stat|ls_l2_|ls_any_fills_from_sys)" | sort -u
# Pipe to events_zen5_available.txt. Diff against the Zen4 confirmed list.
# Any missing event → either rename it or drop it from the per-CPU collector.
```

If `ex_no_retire.load_not_complete` doesn't work, the Backend Memory % decomposition (§4.4.1 Playbook) breaks and we'd report only the aggregate Backend %. That would still be a valid story but loses the "load vs cpu" split. **High priority to verify before the sweep.**

---

## 5. Predicted absolute numbers

**Per-CCD ceiling on m8a:** EC2 frequency penalty alone is roughly 3.66 → 3.0 GHz (~18% reduction). Zen5 IPC gain over Zen4 on Ruby workload is in the +5 to +10% range (frontend-bound workload, modest gain). Net per-CCD ceiling ≈ 0.82 × 1.07 ≈ **0.88× of Genoa-X**.

| Metric | Genoa-X observed | m8a.24xlarge prediction | Reasoning |
|---|---:|---:|---|
| **RPS @ N=1 (full recipe)** | 19,649 | **15,000 – 18,000** | 0.88× Genoa-X N=1; jemalloc lift slightly larger on smaller L3 partially offsets. |
| **RPS @ N=10 (full recipe)** | 122,582 | **105,000 – 130,000** | Per-CCD eff prediction below × N × per-CCD ceiling. Range reflects uncertainty in whether CCD topology is exposed cleanly. |
| **Per-CCD efficiency @ N=10** | 91% | **88 – 94%** | Recipe attacks cross-CCD coherence directly. Smaller L3 means *easier* to overflow into cross-CCD misses, but the fix (per-CCD isolation) addresses exactly that, so efficiency should hold. |
| **Backend Memory % @ N=1** | 8.2% (Round C) | **9 – 12%** | Smaller L3 → more L3 misses → slightly higher BE_mem%. Still in §4.4.1 *Low* band (<20%). |
| **Backend Memory % @ N=10** | 14.6% (Round C) | **15 – 19%** | If recipe holds, the N delta over N=1 stays small (≤7 pp), per §6.1 endpoint. If we see >25% at N=10, cross-CCD chatter has not been suppressed → CCD topology likely hidden by Nitro (§3 check failed). |
| **IPC @ N=1** | 1.153 | **1.10 – 1.25** | Zen5 +5-10% IPC over Zen4 on similar workload. |
| **Effective frequency** | 3.22 GHz @ N=10 | **2.8 – 3.0 GHz, flatter across N** | EC2 governance; no thermal headroom we control. |
| **p99 latency @ N=10** | ~30 ms | **35 – 50 ms** | Lower per-CCD ceiling → similar absolute queueing depth at similar offered load. Hypervisor jitter is the wildcard; if Nitro steal time is non-trivial, p99 blows up. |

**Falsifiable headline claim:** *"Applying the validated Genoa-X Rails recipe to AWS m8a.24xlarge with no changes will deliver ≥88% per-CCD efficiency at N=10 — confirming the recipe is microarchitecture-portable across Zen4-X and Zen5."* If we land below 80%, the recipe didn't carry over and we need to identify which assumption broke (likely §3 topology visibility or §4 PMC availability).

---

## 6. Post-run validation checklist (before publishing)

Run these against the m8a result set before the comparative report goes out:

1. **§2.2.5 L3 Domains:** Confirm `lstopo` reports 12 L3 domains. Attach the topology dump as appendix. If <12, explain.
2. **§4.4.1 Pipeline Utilization thresholds:** All four Pipeline Util values at N=10 fall in expected bands (FE 20-50%, BE_mem <20%, Retiring >15%). Anything in the *High* column (>50% FE or BE_mem, <10% Retiring) triggers a §6.1 cross-domain drill-down.
3. **§6.1 endpoint:** Backend Memory % at N=10 ≤ N=1 value + 5pp. This is *the* indicator that the L3-domain optimization landed. Same pass/fail criterion as the bare-metal report.
4. **§6.1.4 Thread Migration:** `perf record -e sched:sched_migrate_task` for 30s during steady-state, count Cross-L3 migrations. Should be near zero with `taskset` pinning. If non-zero, our pins are leaking — investigate.
5. **§4.3.1 Per-CPU Utilization %:** All pinned server CPUs >90% during steady-state. <90% → recipe isn't saturating, look for upstream (kernel, ENA, wrk) bottleneck.
6. **§3.4 Performance Variability:** Run each (N, round) point 3× and report median + range. Bare-metal was single-run.
7. **Diff predicted-vs-actual** table from this document. Predictions that miss by >20% should be examined; either the prediction was wrong (update mental model) or something on m8a is genuinely surprising (investigate).
8. **Confirm `perf list` Zen5 PMC delta** is documented in the comparative report so future runs on Zen5 know what's available.
9. **Capture `dmidecode -t processor`, `cpupower frequency-info`, `cat /proc/cmdline`, `aws ec2 describe-instances` JSON** as appendix — proof of run conditions.
10. **One non-Playbook check:** confirm `cat /proc/sys/kernel/numa_balancing` is `0` for the run. Auto-NUMA balancing fights `taskset` pinning.

---

## Notes & caveats

- **Playbook v1.2 is a preview** focused on the L3 Domain Usage subset. Sections on memory bandwidth, prefetcher tuning, and full pipeline-based opportunities are mentioned but not expanded. Where this document says "Playbook silent — first-principles estimate," the full Playbook (NABU agent ID `9c936425-8ba1-4c7f-b5fe-dbcd1d8c5f9c`, 198-page version) may have more detail. NABU returned 403 for me today; falling back to PDF excerpts was the right call.
- The "Zen5 IPC +5-10% over Zen4" estimate is generic-workload; Ruby/Puma on a stateless `/hello` is mostly dispatch + branch + L2 hit traffic, which is the regime where Zen5's frontend improvements help least. **Don't be surprised if the IPC gain is closer to 0-5%.**
- If the AWS run lands in the predicted bands, the Genoa-X → m8a comparative report becomes a much stronger artifact than either standalone report — it validates the methodology, the recipe, and the playbook as portable across one generation and one execution mode (bare-metal → cloud).
