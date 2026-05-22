# EPYC Performance Knowledge Base

> **Source**: AMD EPYC Processor Performance Playbook v1.0 (63994i, 14-May-2026, 198 pages)
> **Access**: NABU EPYC Playbook Agent — `9c936425-8ba1-4c7f-b5fe-dbcd1d8c5f9c`
> **Classification**: AMD Internal / NDA — do not distribute
> **Related**: Cloud Performance Analysis Agent (Cruncher) — `f7578702-ce56-4f3d-b746-448c6dd64e00`

This document synthesizes the playbook into the amd-perf-toolkit's reference knowledge.
Every metric threshold, perf event name, and interpretation rule in this file comes
directly from the NDA playbook unless otherwise noted.

---

## 1. EPYC Architecture Basics (§1.3)

### ZenCore Block Diagram (Zen4 / Zen5)
- **Frontend** (top block): instruction cache (IC), op cache (OC), branch prediction, decode, dispatch
- **Backend** (middle + bottom blocks): execution engines (SIMD/FP/INT/AGU) + memory section
- **Pipeline operations ("ops")**: ISA instructions are decoded into 1–N micro-ops
- **Dispatch width**: 6 slots per cycle (AMD model — NOT Intel's 4-wide TopDown assumption)
- **AVX-512**: implemented by double-pumping 256-bit data path over 2 consecutive cycles
  — no frequency drop, no power penalty on Zen4/Zen5
- **SIMD**: VNNI (neural network convolution) and BFLOAT16 supported natively

### L3 Domain / CCX Structure
- **L3 domain = CCX (Core Complex)** — AMD terminology is interchangeable
- **8 physical cores per CCX**, 16 SMT threads (16 logical CPUs when SMT=ON)
- **Cache hierarchy per core** (private):
  - L1 instruction cache + op cache
  - L1 data cache
  - L2: private, inclusive of both I and D; **1 MB per core on Zen4/5**
- **L3**: shared across all 8 cores in the CCX; **mostly exclusive** (lines installed on eviction from L1/L2)
  - Genoa (9004 series standard): 32 MB L3 per CCX
  - Genoa-X (9004X, e.g. EPYC 9684X): **96 MB L3 per CCX** (32 MB base + 64 MB 3D V-Cache)
  - Lines cached ONLY in the local L3 — no load/store hits in L3 leave the domain
  - Cross-CCX L3 access latency ≈ DRAM read latency (~100 ns)

### NUMA and Multi-Socket Topology
- Multiple L3 domains (CCXs) per socket; e.g. EPYC 9684X = **12 CCDs × 8 cores = 96 cores**
- **NPS (NUMA Per Socket)**: controls how L3 domains and memory channels group into NUMA nodes
  - NPS=1: single NUMA node per socket
  - NPS=4: 4 NUMA nodes per socket (most common for HPC)
  - NPS=4, L3-as-NUMA disabled: each NUMA node covers 3 CCDs + associated memory channels
- Cross-NUMA within same socket: **minimal penalty**
- Cross-socket via Infinity Fabric G-links: **4× x16 IF G-links** for 2P systems; higher latency

### Infinity Fabric (IF)
- Connects CCDs to I/O die; I/O die hosts memory controllers, PCIe, CXL, inter-socket links
- **G-Links**: CPU-to-CPU cross-socket; **P-Links**: CPU-to-I/O or peripheral
- Fabric Frequency (DF frequency): separate clock domain; can be a bottleneck
  - Low Fabric Freq: < 1.1× DF P1 Frequency
  - High Fabric Freq: > 0.95× P0 Frequency (optimal)

### Memory Subsystem
- DDR5 (Zen4/5); DDR4 (Zen3/Milan)
- Multiple memory channels per NUMA node; bandwidth = f(channels per node)
- **Local NUMA access**: always preferred; cross-NUMA within socket: minimal penalty
- **Far memory (CXL)**: higher latency; tracked separately (Far Memory %)

---

## 2. Playbook Methodology (§1.1, §2)

The playbook uses a 4-step iterative methodology:

1. **Identify Performance Motivators** — what triggered the investigation?
2. **Run System Checks** — verify hardware/software baseline
3. **Collect Performance Indicators** — gather L/M/H qualified metrics
4. **Identify and Optimize Bottlenecks** — use indicator→solution mapping

Each solution section lists which indicators and motivators lead to it.

---

## 3. System Checks (§4)

Before collecting PMC data, verify:

| Check | Command / Tool | What to look for |
|-------|---------------|-----------------|
| CPU frequency (actual vs boost) | `cpupower frequency-info` or `perf stat cpu-cycles,task-clock` | Should be ≥ 0.9× max boost for loaded cores |
| SMT status | `lscpu \| grep Thread` | Know if SMT=ON (2 threads/core) or OFF |
| NPS setting | `numactl -H` | Verify expected NUMA node count and CPU assignments |
| Power limits (PPL) | BIOS / `msr-tools` | Cloud instances often cap at 320W (AWS) or 400W (GCP/Azure) |
| Turbo state | `cpupower info` | Ensure P-states not stuck at base |
| DF C-States | `cpupower idle-set -d 2` | Disable for latency-sensitive workloads only |
| NUMA balancing daemon | `/proc/sys/kernel/numa_balancing` | May interfere with manual affinity binding |
| `numad` daemon | `systemctl status numad` | Can override physcpubind — disable for benchmarks |
| Core C6 (CC6) | `cpupower idle-set -d 2` | Discouraged to disable except for jitter-sensitive |
| Kernel version | `uname -r` | Some perf events require kernel ≥ 6.10 |
| Access level | Can run `perf stat` without sudo? | Cloud often restricts PMC access |

---

## 4. Complete L/M/H Indicator Quick Reference (§2.5)

All units are **PTI = Per Thousand Retired Instructions, per thread** unless noted.
Thresholds assume **all threads active in L3 domain at High Per-CPU Utilization**.

### 4.1 Fundamental Indicators

| Indicator | Low | Moderate | High |
|-----------|-----|----------|------|
| CPU Usage % | 0–30% | 30–90% | >90% |
| Per-CPU Utilization % | 2–30% | 30–90% | >90% |
| CPU Frequency MHz | <1.1× Base | 1.1× Base – 0.9× Max Boost | >0.9× Max Boost |
| IPC w/o halt | <0.2 | 0.2–1.0 | >1.0 |

### 4.2 Pipeline Utilization (% of 6-slot dispatch pipeline)

| Indicator | Low | Moderate | High |
|-----------|-----|----------|------|
| `frontend_bound %` | <10% | 10–20% | >20% |
| `bad_speculation_mispredicts %` | <5% | 5–10% | >10% |
| `smt_contention %` | <10% | 10–20% | >20% |
| `backend_bound %` | <25% | 25–50% | >50% |
| `backend_bound_memory %` | <20% | 20–50% | >50% |
| `backend_bound_cpu %` | <5% | 5–20% | >20% |
| `retiring %` | <10% | 10–25% | >25% |

**Typical workload pipeline breakdown ranges** (from playbook Table 5.1):

| Workload type | frontend_bound % | bad_spec % | backend_cpu % | retiring % |
|---------------|-----------------|-----------|--------------|-----------|
| Compute-heavy | 10–20% | 5–10% | 15–30% | 35–45% |
| Memory-bound  | 5–15% | 5–15% | 5–15% | 10–20% |
| (mixed)       | 10–20% | 5–10% | 10–20% | 15–20% |

### 4.3 High-Level CPU Hardware Indicators

| Indicator | Low | Moderate | High |
|-----------|-----|----------|------|
| Cross-L3 Domain Data Sharing % | <2% | 2–5% | >5% |
| Cross-Socket % | <1% | 1–5% | >5% |
| Cross-Socket to DRAM Bandwidth % | <0.01% | 0.01–0.05% | >0.05% |
| Cross-NUMA Node % | <1% | 1–5% | >5% |
| DRAM Utilization % | <30% | 30–60% | 60–90% |
| Far Memory % | <1% | 1–5% | >5% |
| Fabric Frequency MHz | <1.1× DF P1 | 1.1× P1 – 0.95× P0 | >0.95× P0 |

### 4.4 Microarchitecture Indicators (PTI)

| Indicator | Low | Moderate | High |
|-----------|-----|----------|------|
| Instruction Cache Miss | <2.0 | 2.0–10.0 | >10.0 |
| Op Cache Efficiency % | <40% | 40–90% | >90% |
| Data Cache Miss | <15.0 | 15.0–30.0 | >30.0 |
| L2 Cache Miss | <2.0 | 2.0–10.0 | >10.0 |
| L3 Cache Miss | <1.0 | 1.0–10.0 | >10.0 |
| L2 ITLB Miss | <0.5 | 0.5–1.0 | >1.0 |
| L2 DTLB Miss | <1.0 | 1.0–5.0 | >5.0 |
| Store To Load Interlock | <2.0 | 2.0–20.0 | >20.0 |
| Branch Mispredicts | <2.0 | 2.0–5.0 | >5.0 |
| L3 Miss Latency (ns) | <125 | 125–175 | >175 |

**Op Cache note**: High Op Cache Efficiency % (>90%) is GOOD — the cache is hitting well.
Low (<40%) means the frontend is suffering from op cache misses → frontend stalls.

### 4.5 Typical Instruction Mix (Table 5.3)

| Type | Moderate/Typical range |
|------|----------------------|
| Load Mix % | 25–40% |
| Store Mix % | 5–20% |

---

## 5. Linux Perf Event Reference (§13)

Tested on Zen4, Linux kernel ≥ 6.10. Use `perf stat -j` for JSON parsing.

### 5.1 Pipeline Utilization Events

```bash
# AMD's 6-slot model metrics — requires Linux kernel >= 6.10 and perf AMD metric groups
perf stat -M frontend_bound,backend_bound,bad_speculation,retiring <workload>
```

### 5.2 Exact Per-Indicator Event Strings

| Indicator | perf stat command / event |
|-----------|--------------------------|
| **Instruction Cache Miss** | `-e l2_request_g1.cacheable_ic_read,instructions` |
| Formula | `(l2_request_g1.cacheable_ic_read × 1000) / instructions` |
| **Op Cache Efficiency %** | `-e op_cache_hit_miss.op_cache_miss,op_cache_hit_miss.all_op_cache_accesses` |
| Formula | `(1 − op_cache_miss / all_op_cache_accesses) × 100` |
| **Data Cache Miss** | `-e l2_request_g1.all_dc,instructions` |
| Formula | `(l2_request_g1.all_dc × 1000) / instructions` |
| **L2 Cache Miss** | `-e l2_cache_req_stat.ic_dc_miss_in_l2,l2_pf_miss_l2_hit_l3.all,l2_pf_miss_l2_l3.all,instructions` |
| Formula | `((ic_dc_miss_in_l2 + l2_pf_miss_l2_hit_l3.all + l2_pf_miss_l2_l3.all) × 1000) / instructions` |
| **L3 Cache Miss** (Zen4+) | `-e cpu/event=0x165,umask=0xdc,name=l3_misses_in_ccx/,instructions` |
| Formula | `(l3_misses_in_ccx × 1000) / instructions` |
| **L2 ITLB Miss** | `-e bp_l1_tlb_miss_l2_tlb_miss.all,instructions` |
| Formula | `(bp_l1_tlb_miss_l2_tlb_miss.all × 1000) / instructions` |
| **L2 DTLB Miss** | `-e ls_l1_d_tlb_miss.all,instructions` |
| Formula | `(ls_l1_d_tlb_miss.all × 1000) / instructions` |
| **Store To Load Interlock** | `-e ls_bad_status2.stli_other,irperf -C <cpu_list> -a` |
| Formula | `ls_bad_status2.stli_other / irperf` |
| **Misaligned Loads** | `-e cpu/event=0x047,umask=0x03,name=ls_misal_loads/,instructions -a` |
| Formula | `(ls_misal_loads × 1000) / instructions` |
| **Write Combining (WCB)** | `-e cpu/event=0x50,umask=0x1,name=AllBytesWritten/ -e cpu/event=0x063,umask=0x20,name=WCBClose/ -C <cpu_list> -a` |
| Formula | `Partial Writes Per WCB Close % = (1 − AllBytesWritten / WCBClose) × 100` |
| **Branch Mispredicts** | `-e branch-misses,instructions -a` |
| **L3 Miss Latency** | `perf stat -M l3_read_miss_latency` |
| **DC Fills HW Prefetch** | `-e ls_hw_pf_dc_fills.all -a` |
| **DC Fills Demand Only** | `-e ls_dmnd_fills_from_sys.all -a` |
| **Prefetch-to-Demand Ratio** | `ls_hw_pf_dc_fills.all / ls_dmnd_fills_from_sys.all` |

### 5.3 Branch Profiling (for Bad Speculation root cause)

```bash
perf record -e ex_ret_brn <workload>           # profile by branch rate
perf record -e ex_ret_brn_misp <workload>      # profile by mispredicts
perf record -e ex_ret_brn_tkn <workload>       # profile by taken branches
perf record -e ex_ret_near_ret_mispred <workload>  # mispredicted near returns
perf report -i perf.data
```

### 5.4 Backend CPU Stalls (no dedicated event — use ex_no_retire)

```bash
perf record -e ex_no_retire.not_complete -- <workload>
perf report -i perf.data
```

### 5.5 Cross-L3 Domain Traffic (AMD MultEvent / uProf events)

The playbook references these via MultEvent tool (CORE.csv):
- `DC Fills From Remote CCX Cache (pti)`
- `DC Fills From different CCX in same node (pti)`
- `All DC Fills (pti)`
- Formula: `Cross-L3 % = (RemoteCCX + DiffCCXSameNode) / AllDCFills × 100`

Threshold: Low <2%, Moderate 2–5%, High >5%

### 5.6 Infinity Fabric / DRAM Bandwidth (AMD MultEvent DF.csv, UMC.csv)

| Metric | Source |
|--------|--------|
| Fabric Frequency MHz | DF.csv |
| Total Main Memory Bandwidth (GB/s) | DF.csv |
| Cross-Socket (CPU+IO) Main Memory Bandwidth (GB/s) | DF.csv |
| DRAM Utilization % | UMC.csv |

These require AMD MultEvent or uProf — not directly available via `perf stat`.

---

## 6. CPU Pipeline-Based Opportunities (§8)

### 6.1 Frontend Stalls (§8.1)

**Trigger**: `frontend_bound % ≥ 10%` (Moderate) or `≥ 20%` (High)
Also: High L2 ITLB Miss, High Instruction Cache Miss

**Root cause**: Frontend cannot supply ops fast enough — large code footprint,
poor locality in instruction accesses, IC/OC misses, ITLB pressure.

**Solutions**:
- Pin threads that share code to the same physical core or same L3 domain
  → shared IC lines and L3 reduce effective fetch miss rate
- For ITLB: use 2 MB huge pages for text segments (`-Wl,--hugetlbfs-align`,
  `HUGETLB_ELFMAP=R <app>`)
- Reduce code size / inlining (compiler PGO helps)
- Optimize branch prediction (see §8.2)

### 6.2 Bad Speculation (§8.2)

**Trigger**: `bad_speculation_mispredicts % > 10%` and/or `Branch Mispredicts > 5.0 PTI`

**Root cause**: Pipeline flush and refetch on mispredicted branches → wasted dispatch slots

**Solutions**:
- Profile with `perf record -e ex_ret_brn_misp` → identify hot mispredicted branches
- PGO (Profile-Guided Optimization) in compiler
- Reduce branch count in hot loops (eliminate redundant error checks)
- Inline functions to reduce CALL/RET pairs
- Move taken branch to the infrequent case (favor straight-line code)
- Indirect branch optimizations: consult generation-specific SWOG

### 6.3 SMT Contention (§8.3)

**Trigger**: `smt_contention % > 20%` (High)

**Root cause**: SMT sibling wins the 6 dispatch slots, blocking the other thread.
Shared resources: L1/L2 cache, execution units, TLBs, ROB slots.

**Solutions**:
- Disable SMT (`BIOS: SMT Mode = Disabled`) or use `taskset`/`numactl` to avoid SMT siblings
- Tradeoff: SMT=OFF improves single-thread IPC but halves logical CPU count
- See §6.3 "Deploying SMT" for workload-specific guidance
- Also investigate: Tuning Data Cache Prefetchers, reduce Bad Speculation

### 6.4 Backend Memory Stalls (§8.4)

**Trigger**: `backend_bound_memory % ≥ 20%` (Moderate) or `≥ 50%` (High)
Also: High Data Cache Miss, High L3 Cache Miss

**Root cause**: Backend stalled waiting for memory loads — cache misses, latency,
bandwidth saturation, DTLB misses.

**Solutions** (in priority order):
1. Optimize Main Memory Bandwidth (data structure layout, access patterns)
2. Optimize L3 Domain Usage (keep working set within CCX's L3)
3. NUMA Tradeoffs (NPS setting, memory affinity)
4. Cross-Socket Traffic reduction
5. Optimize Main Memory Access Latency (prefetch, streaming)
6. Tune Data Cache Prefetchers (§14.7, §6.4)
7. DTLB Misses (huge pages)
8. CPU to Infinity Fabric Bandwidth (§7.4)

### 6.5 Backend CPU Stalls (§8.5)

**Trigger**: `backend_bound_cpu % > 20%` (High), often with Low Vector Instruction %

**Root cause**: Execution unit contention or pipeline hazards; compiler usually handles this
well so this category is typically small. Likely: suboptimal vectorization.

**Detection**:
```bash
perf record -e ex_no_retire.not_complete -- <workload>
perf report -i perf.data
```

**Solutions**:
- Maximize vectorization via compiler flags (`-O3 -march=znver4 -mavx512f`)
- Use AOCL / MKL libraries for hot math routines
- Review AMD SWOG for AVX-512 coding guidelines (§14.5)

### 6.6 ITLB Misses (§8.6)

**Trigger**: `L2 ITLB Miss > 1.0 PTI` (High), AND `frontend_bound % ≥ 10%`
**Worse in virtualized environments** (nested page table walks multiply latency)

**Solutions**:
- Use 2 MB huge pages for code: link with `-Wl,--hugetlbfs-align`
- Run with `HUGETLB_ELFMAP=R <app>` (Linux libhugetlbfs)
- Reduce instruction footprint (smaller code size, fewer translation units)

### 6.7 DTLB Misses (§8.7)

**Trigger**: `L2 DTLB Miss > 5.0 PTI` (High), AND `backend_bound_memory % ≥ 20%`
**Worse in virtualized environments**

**Solutions**:
- Enable Transparent Huge Pages (THP): `echo always > /sys/kernel/mm/transparent_hugepage/enabled`
- Manual huge pages: `mmap` with `MAP_HUGETLB` flag
- Reduce data working set size and improve locality

### 6.8 Instruction Cache and Op Cache Misses (§8.8)

**Trigger**: `Instruction Cache Miss > 10.0 PTI` OR `Op Cache Efficiency % < 40%`
AND `frontend_bound % ≥ 10%`

**Root cause**: Large code footprint that doesn't fit in L1 IC (32 KB) or Op Cache.
Op Cache stores decoded micro-ops — a hit avoids full re-decode.

**Solutions**:
- Reduce code bloat: avoid excessive inlining, template instantiation explosion
- Use compiler PGO to improve code layout (hot paths contiguous)
- Pin threads sharing code to same CCX (L2/L3 IC sharing)
- `BOLT` (Binary Optimization and Layout Tool) for code layout

### 6.9 Store-To-Load Interlock (§8.9)

**Trigger**: `Store To Load Interlock > 20.0 PTI` (High)

**Root cause**: Load issued before preceding store to same address has committed → pipeline stall.
Event: `ls_bad_status2.stli_other`

**Solutions**:
- Reorder instructions to create separation between store and dependent load
- Use compiler options for aggressive scheduling
- Reduce store-load forwarding chains in hot loops

### 6.10 Misaligned Loads (§8.10)

**Trigger**: `Misaligned Loads > Moderate` (threshold not explicitly specified)
Event: `ls_misal_loads` (`cpu/event=0x047,umask=0x03`)

**Root cause**: Loads crossing cache line boundaries → extra cycle(s)

**Solutions**:
- `__attribute__((aligned(64)))` for hot data structures
- Compiler: `-falign-functions=64 -falign-loops=64`
- Use `posix_memalign` / `aligned_alloc` for dynamically allocated arrays

### 6.11 Write Combining (§8.11)

**Trigger**: High `Partial Writes Per WCB Close %`
Events: `AllBytesWritten` (`0x50/0x1`), `WCBClose` (`0x063/0x20`)
Formula: `(1 − AllBytesWritten / WCBClose) × 100`

**Root cause**: Write Combining Buffers (WCBs) closed before full — partial cache line
writes create unnecessary DRAM traffic.

**Solutions**:
- Use streaming stores (non-temporal) for sequential write patterns
- Ensure write patterns are cache-line-sequential (64 bytes at a time)
- Minimize partial writes to MMIO / WC memory regions

---

## 7. EPYC-Specific Behaviors (§7)

### 7.1 L3 Domain Usage (§7.1)

**Key insight**: AMD L3 is **mostly exclusive** — data lives in only one L3 domain.
Cross-CCX access latency ≈ DRAM latency (~100 ns). This is architectural, not a bug.

**Optimization**: Keep threads that share data in the same CCX (8 cores).
Use `numactl --cpunodebind=N --membind=N` or `taskset -c 0-7` (for CCX 0).

**Cross-L3 % formula**: `(RemoteCCX fills + DiffCCXSameNode fills) / AllDCFills`
- Low: <2% — data is well-localized to CCX
- High: >5% — data is being shared across CCX boundaries → consider data partitioning

### 7.2 NUMA Tradeoffs (§7.2)

NPS=4 gives best memory bandwidth (each NUMA node has dedicated channels) but
requires careful affinity binding. NPS=1 is simpler but may not exploit full BW.

Cross-NUMA within socket: **minimal penalty** (distance=12 vs local=10 per numactl).
Cross-socket: significant latency increase via IF G-links.

### 7.3 Cross-Socket Traffic (§7.3)

**Trigger**: `Cross-Socket % > 5%` (High) or `Cross-Socket to DRAM BW % > 0.05%` (High)

**Solutions**: NUMA binding, process isolation, reduce shared memory across sockets.
Disable cross-socket link width management (§14.12) for latency-sensitive cases.

### 7.4 CPU to Infinity Fabric Bandwidth (§7.4)

IF bandwidth can be a bottleneck for DRAM-bound workloads. Measured via
AMD MultEvent DF.csv (Fabric Frequency, Total BW, Cross-Socket BW).

DRAM Utilization % thresholds: Low <30%, Moderate 30–60%, High 60–90%.
Sustained High DRAM utilization → consider memory bandwidth optimization.

---

## 8. Processor-Specific Solutions (§14)

### 8.1 Adaptive Allocation (§14.3, §14.4)

**What it is**: Hardware feature that dynamically allocates L3 cache ways between
threads/processes to maximize overall throughput. Available on Zen3+.

**BIOS setting**: "Adaptive Allocation" (exact knob name varies by OEM BIOS)

**When to disable**: High `smt_contention %` or high `backend_bound_memory %` with
known cache-sensitive workloads — static allocation may help.

**When to enable**: Default (most workloads benefit from dynamic allocation).

**Perf indicators**: Use backend_bound_memory %, L3 cache miss PTI, smt_contention % to assess.

### 8.2 Individual Prefetcher Configuration (§14.7, §14.8)

EPYC has multiple independent prefetchers configurable per-core via BIOS/MSR:
- **L1 Data Cache Prefetcher** (hardware stride prefetcher)
- **L2 Data Cache Prefetcher**
- **L3 Data Cache Prefetcher**
- **Core Prefetch Throttle** (§14.8): throttles prefetch when resources are contested

**Indicators for tuning**:
- High `Prefetch-to-Demand Fill Ratio` → prefetcher is speculative but effective
- Low ratio → prefetcher not helping; or already throttled
- `DC Fills HW Prefetch / DC Fills Demand Only`

**BIOS**: Look for "Data Prefetcher" and "L3 Prefetcher" toggles under CPU Configuration.

### 8.3 AVX-512 Considerations (§14.5)

On AMD Zen4/5: AVX-512 is **double-pumped** → executes over 2 clock cycles.
**No frequency penalty**, **no increased power** (unlike Intel pre-Sapphire Rapids).

**When AVX-512 helps**: matrix multiply, FFT, inference (VNNI/BFLOAT16), compression.
**When it may not help**: register-count limited code, short vectors (<256-bit content).

**Detection**: `perf stat -e fp_ret_sse_avx_ops.*` (check SWOG for exact event names).
Also: `Vector Instruction %` metric from MultEvent CORE.csv.

### 8.4 CCX to IF Folding (§14.6)

**What it is**: Folds the CCX's interface to the Infinity Fabric — reduces latency
for cross-CCX traffic by consolidating IF interface transactions.

**When helpful**: High `Cross-L3 Domain Data Sharing %` (>5%) with latency-sensitive workload.

**BIOS setting**: "CCX to Infinity Fabric Interface Folding" (exact name OEM-specific).

### 8.5 Speculative Stores Mode (§14.13)

Controls whether stores are speculative before commit. Can affect memory ordering
performance in certain concurrency-heavy workloads. Change only if correctness
issues or performance regression is traced to store ordering.

### 8.6 ERMS/FSRM (§14.1)

**What it is**: Enhanced REP MOVSB/STOSB — fast string operations.
- ERMS: improvements for ≥128-byte operations
- FSRM: improvements for ≤128-byte operations

**Trigger**: High `backend_bound_memory %` with `memcpy`/`memset` in hot profile.
Implementation evolves Zen3→Zen4→Zen5 — always test with latest kernel + glibc.

### 8.7 Large Pages (§8.6, §8.7)

```bash
# Enable THP globally
echo always > /sys/kernel/mm/transparent_hugepage/enabled

# Explicit huge page for code (text segment)
# Link with:
-Wl,--hugetlbfs-align
# Run with:
HUGETLB_ELFMAP=R <app>

# Reserve explicit huge pages
echo 512 > /proc/sys/vm/nr_hugepages
```

### 8.8 Fixed Frequency Configuration (§14.11)

For reproducible benchmarking: pin Pstate to P0 (max freq) via `cpupower`.
```bash
cpupower frequency-set -g performance
cpupower -c all frequency-set -d <max_freq>GHz -u <max_freq>GHz
```

---

## 9. Gap Analysis: Toolkit vs. Playbook

### Currently measured by amd-perf-toolkit

| Playbook indicator | Toolkit events | Status |
|--------------------|---------------|--------|
| `frontend_bound %` | `de_no_dispatch_per_slot.no_ops_from_frontend` | ✅ |
| `backend_bound %` | `de_no_dispatch_per_slot.backend_stalls` | ✅ |
| `bad_speculation %` | `(dispatched - retired) / total_slots` | ✅ |
| `retiring %` | `ex_ret_ops / total_slots` | ✅ |
| `backend_bound_memory %` | `ex_no_retire.load_not_complete` ratio | ✅ |
| `backend_bound_cpu %` | `ex_no_retire.not_complete` minus memory | ✅ |
| IPC | `instructions / cpu-cycles` | ✅ |
| Effective Frequency | `cpu-cycles / task-clock` | ✅ |
| CPU Utilization % | `task-clock metric-value` | ✅ |
| Branch Misp Rate | `ex_ret_brn_misp / ex_ret_brn` | ✅ |
| L2 DC Hit Rate | `l2_cache_req_stat.dc_hit_in_l2` / misses | ✅ |
| L2 IC misses | `l2_cache_req_stat.ic_fill_miss` | ✅ |

### Gaps — events the playbook recommends but toolkit lacks

| Playbook indicator | Playbook event | Priority |
|--------------------|---------------|----------|
| **L2 ITLB Miss PTI** | `bp_l1_tlb_miss_l2_tlb_miss.all` | HIGH |
| **L2 DTLB Miss PTI** | `ls_l1_d_tlb_miss.all` | HIGH |
| **Instruction Cache Miss PTI** | `l2_request_g1.cacheable_ic_read` | HIGH |
| **Op Cache Efficiency %** | `op_cache_hit_miss.op_cache_miss`, `op_cache_hit_miss.all_op_cache_accesses` | HIGH |
| **Store-To-Load Interlock PTI** | `ls_bad_status2.stli_other` | HIGH |
| **Misaligned Loads PTI** | `cpu/event=0x047,umask=0x03` (`ls_misal_loads`) | MEDIUM |
| **DC Fills HW Prefetch** | `ls_hw_pf_dc_fills.all` | MEDIUM |
| **DC Fills Demand Only** | `ls_dmnd_fills_from_sys.all` | MEDIUM |
| **Prefetch-to-Demand Ratio** | ratio of above two | MEDIUM |
| **Write Combining (WCB)** | `cpu/event=0x50,umask=0x1` + `cpu/event=0x063,umask=0x20` | LOW |
| **L3 Miss Latency (ns)** | `perf stat -M l3_read_miss_latency` | MEDIUM |
| **L3 Cache Miss PTI** | `cpu/event=0x165,umask=0xdc` (Zen4+ only, kernel ≥ 6.10) | HIGH |
| **Data Cache Miss PTI** | `l2_request_g1.all_dc` | MEDIUM |
| **L2 Cache Miss PTI (full)** | `l2_cache_req_stat.ic_dc_miss_in_l2` + PF events | LOW (partial coverage exists) |
| **smt_contention %** | perf metric group (kernel ≥ 6.10) | HIGH |
| **Cross-L3 Domain %** | AMD MultEvent only (not available via vanilla perf) | N/A — tool gap |
| **DRAM Utilization %** | AMD MultEvent UMC.csv only | N/A — tool gap |

### Verification Plan

Test all HIGH priority events on EPYC 9684X (bare metal) first:
```bash
sudo perf stat -j -e \
  bp_l1_tlb_miss_l2_tlb_miss.all,\
  ls_l1_d_tlb_miss.all,\
  l2_request_g1.cacheable_ic_read,\
  op_cache_hit_miss.op_cache_miss,\
  op_cache_hit_miss.all_op_cache_accesses,\
  ls_bad_status2.stli_other,\
  irperf,\
  ls_hw_pf_dc_fills.all,\
  ls_dmnd_fills_from_sys.all,\
  instructions,cpu-cycles \
  sleep 5
```

Then test L3 Miss metric (requires kernel ≥ 6.10):
```bash
sudo perf stat -j -e cpu/event=0x165,umask=0xdc,name=l3_misses_in_ccx/,instructions sleep 5
```

Then test on AWS M8A / GCP C4D to determine cloud PMC availability.

---

## 10. Cloud Context Integration

See `cloud_context.py` for the Cloud 201 knowledge base. Key intersections:

### Package Power Limit Effects on Playbook Metrics

| CSP | PPL | Expected Feff Ratio | Impact on CPU Freq MHz indicator |
|-----|-----|--------------------|---------------------------------|
| AWS M7A/M8A | 320W | 0.75 (25% deficit) | Freq will show Low/Moderate even at full load |
| GCP C4D | 400W | 0.85 (15% deficit) | Freq may appear Moderate |
| Azure HBv4 | 400W | 0.85 | Same as GCP |
| Oracle OCI | 450W | 0.88 | Closest to bare metal |
| Bare metal | N/A | 0.92 | Reference baseline |

**Important**: On cloud, Low CPU Frequency MHz is expected and normal due to PPL.
Do NOT interpret as a BIOS/OS misconfiguration — it's a cloud economic constraint.

### PMC Availability by Cloud Provider

| CSP | PMC Support | Missing capabilities |
|-----|------------|---------------------|
| AWS | `core` | Uncore (DF/UMC) events unavailable |
| GCP | `core` | Uncore unavailable |
| Azure | `limited` | Subset of core events |
| Oracle | `none` | No PMC access at all |

**Consequence**: On cloud, DRAM Utilization %, Fabric Frequency, Cross-Socket BW
(all from AMD MultEvent DF/UMC sources) are **unavailable**. Plan accordingly.

### SMT Effects on Threshold Interpretation

All playbook thresholds assume specific SMT conditions. Key adjustments:
- AWS: SMT=OFF → 1 thread/core → `backend_bound_memory %` thresholds apply directly
- GCP: SMT=ON → 2 threads/core → `smt_contention %` becomes relevant
- IPC is halved when SMT is ON vs OFF for same workload (slots shared)
- L2 hit rates decrease with SMT=ON due to working set competition

---

## 11. Nabu Agents for EPYC Analysis

| Agent | Nabu ID | Purpose |
|-------|---------|---------|
| **EPYC Playbook Agent** | `9c936425-8ba1-4c7f-b5fe-dbcd1d8c5f9c` | Full 198-page NDA playbook Q&A — architecture, PMC events, optimization |
| **Cloud Performance Analysis (Cruncher)** | `f7578702-ce56-4f3d-b746-448c6dd64e00` | Cloud perf insights, validates/uploads test results, aggregates AMD internal data |
| **Cloud Benchmark Performance (EPDW)** | `6bb60d83-1310-4490-9c34-27b1b4f9f150` | Structured benchmark data warehouse — query by instance type, workload, metric |

### EPDW — Cloud Benchmark Performance Data Warehouse

Created by: Lucas.Li@amd.com | Model: claude-sonnet-4.5

**What EPDW contains**:
- Historical benchmark results for AMD cloud instances (AWS, GCP, Azure, Oracle)
- Instance types tracked: `c6a.4xlarge`, `m6i.4xlarge`, M8A family, and others
- Workloads: Redis, Nginx, SPEC-CPU, and additional cloud benchmarks
- Metrics: throughput, latency, response time, CPU/memory/network utilization, benchmark scores

**EPDW data schema** (key fields per record):
```
sutInstanceMetadata: { cloudProvider, instanceType, geoLocation, sutType }
platformProfile.Summary: { Server.Model, Server.CPUModel, CPU topology, OS, Memory }
cpuModel (top-level)
benchmarkType, benchmarkName, benchmarkCategory, runCategory, runType
resultSummary[]: { metricsName, mean } ← preferred metric source
resultsInfo[].statistics[]             ← per-run fallback
runConfigurations: { workload, threads, connections, duration(secs), kbsize, nodes, compiler }
testDate, createdOn, lastModifiedOn
```

**Example EPDW query** (natural language to Nabu agent):
```
"Show me all AWS M8A benchmark results for SPEC-CPU. Compare M8A vs M7A if available."
"What is the Nginx throughput on GCP C4D-standard-16 vs AWS m7a.4xlarge?"
"List all benchmark runs for EPYC 9654 instances in us-east-1 from last 30 days."
```

**Comparison math**: `% change = (current − baseline) / baseline × 100`
Significant change threshold: ±5% (flagged automatically).

**Relationship to Cruncher**: EPDW is the underlying data warehouse (historical structured
data). Cruncher is the analytics/validation layer on top. EPDW is migrating data into
Cruncher — both should be queried. EPDW for raw historical results; Cruncher for
validated cloud perf insights and comparisons.

**How to use in the toolkit workflow**:
1. Run `amd_pipeline_metrics.sh` or `amd_perf_html_report.py` on your workload
2. Query EPDW: "What is the baseline SPEC-CPU score for this instance type?" to set context
3. Query Cruncher: "Does this performance match AMD's validation data for M8A?"
4. Use playbook agent: "My backend_bound_memory is 45% on M8A — what does the playbook suggest?"

**Query Cruncher for**:
- Cloud instance performance validation against AMD's internal baselines
- Uploading and tracking new benchmark results over time
- Latest cloud perf insights and AMD-validated numbers

**Query EPDW for**:
- Historical benchmark data for specific instance types and workloads
- Cross-instance and cross-CSP comparisons from stored results
- Trend analysis: is performance improving/regressing across runs?

**Query EPYC Playbook Agent for**:
- Architecture questions (cache sizes, IF topology, SMT behavior)
- PMC event names and formulas
- Optimization strategies for specific indicator values

---

## 12. Key Formulas Reference

```
# AMD 6-slot pipeline model
Total_Slots        = ls_not_halted_cyc × 6
Frontend_Bound%    = de_no_dispatch_per_slot.no_ops_from_frontend / Total_Slots × 100
Backend_Bound%     = de_no_dispatch_per_slot.backend_stalls / Total_Slots × 100
Bad_Speculation%   = (de_src_op_disp.all - ex_ret_ops) / Total_Slots × 100
Retiring%          = ex_ret_ops / Total_Slots × 100
(Sum should ≈ 100% if SMT=OFF; add smt_contention when SMT=ON)

Backend_Memory%    = Backend_Bound% × (ex_no_retire.load_not_complete / ex_no_retire.not_complete)
Backend_CPU%       = Backend_Bound% × (1 - load_not_complete / not_complete)

IPC                = instructions / cpu-cycles
Effective_Freq_GHz = cpu-cycles / (task_clock_ms × 1e6)
CPU_Util%          = CPUs_utilized / total_cores × 100  (CPUs_utilized from task-clock metric-value)

Branch_MispRate%   = ex_ret_brn_misp / ex_ret_brn × 100
L2_DC_HitRate%     = dc_hit_in_l2 / (dc_hit_in_l2 + ls_rd_blk_c) × 100

# Playbook PTI formulas
IC_Miss_PTI        = l2_request_g1.cacheable_ic_read × 1000 / instructions
ITLB_Miss_PTI      = bp_l1_tlb_miss_l2_tlb_miss.all × 1000 / instructions
DTLB_Miss_PTI      = ls_l1_d_tlb_miss.all × 1000 / instructions
STLI_PTI           = ls_bad_status2.stli_other / irperf
MisalignedLd_PTI   = ls_misal_loads × 1000 / instructions
WCB_Partial_Write% = (1 - AllBytesWritten / WCBClose) × 100
Prefetch_Demand_R  = ls_hw_pf_dc_fills.all / ls_dmnd_fills_from_sys.all
```

---

*Last updated: 2026-05-22. Source: NABU EPYC Playbook Agent queries (§1–§14).*
*Refresh via NABU agent when playbook is updated — do not use a stale PDF.*
