# Cloud 201: Intermediate Cloud for FAEs — Final Summary
*Session by Lewis Carroll (Cloud FAE) & Douglas Hamilton (Cloud FAE)*
*Sources: Slide deck + full session transcript (SKO)*

---

## Purpose of This Session

This training was built around a specific AMD sales model: one AMD account team owns all AMD technology for a given end customer — cloud, OEM, ODM, whatever the route to revenue. That means a commercial FAE for a Walmart, Ford, or Home Depot needs to handle the front line of cloud questions, then have a backup plan when deeper expertise is needed.

**Escalation contacts (Pradeep's team):**
- Pradeep Nallimelli — Cloud FAE Team Manager, Santa Clara
- Noor Fairoza Khan — Cloud FAE, Charlotte
- Palak (Cloud FAE, Pradeep's team)
- Jeremy (Seattle-based sell-out resource for AWS, 9.5 years at AWS in support, service teams, and solutions architecture — also has a published blog + demo video on the SQL Server TCO optimization covered in Section 11)

---

## 1. Why Cloud AMD Deals Are Hard to Win

Nearly all cloud obstacles are **performance problems at their heart** — not functional or compatibility gaps. Lewis's framing: the customer either needs more performance to justify switching from Intel, to overcome a higher price vs. ARM, or to tackle a specific workload bottleneck.

**80%+ of obstacles — general performance / instance features:**
- AMD often has 50% more performance per vCPU but is ~15% higher price than Intel at AWS — insufficient to displace the incumbent
- ARM (Graviton, Cobalt, Axion) is subsidized by the CSP — nothing AMD can do about it; CSPs control the playing field

**Real customer examples:**
- **AirBnB / AWS M7a (Genoa):** Kubernetes treats all CPUs as equal — AMD's performance advantage was invisible to the scheduler, so the 15% price premium just added cost with no throughput benefit
- **Salesforce / AWS R7a (Genoa) vs. R7i (Sapphire Rapids):** Java garbage collection needed optimization; AMD was ~20% faster but the combination of Intel's JVM contributions, SMT benefit for Java, and regional instance availability made the switch not compelling enough. *Update: Colin subsequently closed a north-of-2M vCPU order at Salesforce after the performance issue was tackled.*
- **Snowflake:** Workload needs local NVMe — unavailable on AMD at AWS (available on Graviton and Intel). On Azure, Microsoft allows their own ARM (Cobalt) to exceed local disk perf spec by 100%; AMD is held to spec. "We went and asked about this... they're like, oh yeah, no."

**10% specialized performance:** AMD wins on HPC, video encode/transcode, financial/risk simulation. Loses on FSI math (Intel MKL), AI inference with Intel AMX.

**10% other:** ISV marketplace AMI doesn't have the AMD checkbox ticked (often just needs a conversation), random compatibility questions.

---

## 2. Root Causes: Why Cloud AMD ≠ Bare Metal AMD

Customer symptoms: performance below expectations, more variable than on-prem, feature availability gaps.

Root causes to understand for triage:
- **CSP controls pricing** → ARM and Intel subsidization
- **Virtualization stack design** — deterministic vs. non-deterministic
- **Host hardware design choices** — especially Package Power Limit (PPL)
- **CSP product/positioning choices**
- **Custom SKUs** with non-public specs

---

## 3. Host Hardware Configuration

### 1P vs. 2P
- **Most cloud hosts are 2P** (two sockets)
- **Microsoft general-purpose families (Ba/Da/Ea/Fa) are 1P** — exception worth remembering

### Memory Harmonics — Why CSPs Down-Core Parts
Lewis explained this verbally: CSPs use "golden ratios" of GiB per vCPU (2, 4, 8, or 16). With 96 cores and 12 memory channels, 32GB or 64GB DIMMs make those ratios work cleanly. At 128 cores, the ratio breaks. So Google takes a 128-core Turin Classic and turns off cores to bring it back to 96 — purely to preserve the memory product definition.

### CCD / Die Construction by Instance

| Host | CPU | Die Config | Why |
|------|-----|------------|-----|
| Most Genoa & Turin cloud hosts | Genoa / Turin | 12+1 → 96 cores | Memory harmonics |
| Google C4d & H4d | Turin Classic | 16+1, down-CCD to 12+1 | Memory harmonics |
| Oracle Cloud E6 | Turin | 16+1, 128 cores | Full part, no down-coring |
| AWS M8azn, X8aedz | Turin HF | 8+1, down-core to 48c | HBM/specialty variant |
| AWS _6a (Milan) | Milan | 6+1, 48c | Milan construction |

### Power / PPL Settings

| Instance Family | PPL | vs. Others | Impact |
|-----------------|-----|-----------|--------|
| AWS C/M/R7a (Genoa) | **280W** | GCP/Azure/Oracle ~400W | ~25% Feff below Fmax at high load |
| AWS HPC7a, R7an | 400W | Exceptions | Within tolerance |
| AWS M8azn | 500W | Exception | HBM variant |
| AWS C/M/R8a (Turin) | **320W** | GCP/Azure 400W, Oracle 450W | ~25% Feff below Fmax at high load |
| Intel _8i at AWS | ~630W | Cheaper than AMD at AWS | Ironic — more watts, lower price |
| GCP/Azure Turin | 400W | — | ~15% Feff below Fmax — within customer tolerance |

Story behind the 280W limit: AWS told AMD the constraint would help get prices lower. AMD agreed but gave a minimum floor. AWS went 20% below AMD's floor. AMD told them "absolutely positively don't do it." They did it anyway, and still charged a higher AMD price vs. Intel.

### Memory Speed
- AWS M/R7a (Genoa): limited to **4400 MT/s** — C7a / HPC7a run at 4800 MT/s

### SMT On/Off by Host
- **SMT OFF:** AWS C/M/R7a, HPC7a, C/M/R/X8a, HPC8a; Azure F-series, HBv4, HBv5; Google H4d
- All other hosts: SMT on

---

## 4. Virtualization Stack

### Quick vCPU Sizing Rule (AWS)
Take the number in front of XLarge × 4 = vCPUs. So **2XLarge = 8 vCPUs**, 8XLarge = 32, 24XLarge = 96, 48XLarge = 192.

### Deterministic vs. Non-Deterministic

**Deterministic** — same VM size always gets the same CCX topology, correctly reported to the guest:
- **AWS:** All families. Lewis: "Best in the business — 100% deterministic, predictable."
- **Google Cloud:** C2d, C3d, C4d, H4d
- **Azure:** Ba/Da/Ea/Fa (>90%); HB

**Non-deterministic** — host can be oversubscribed, NUMA/CCX misalignment possible, intentionally lower cost:
- **Google Cloud:** N2d, N4d
- **Oracle Cloud:** VMs

### AWS Instance Topology — What Each Size Looks Like

| Instance (also applies to _8a Turin) | vCPUs / Cores | Topology |
|--------------------------------------|---------------|----------|
| _7a.2xlarge and smaller | 8 / 8 | 1 full CCD on P0 — cleanest possible; almost never a performance issue |
| _7a.8xlarge | 32 / 32 | 4 CCDs on P0 |
| _7a.24xlarge | 96 / 96 | Full P0 socket (12 CCDs) — **largest non-NUMA instance**; always get the whole SOC |
| _7a.32xlarge | 128 / 128 | Full P0 + 4 CCDs on P1 — crosses NUMA; but almost never has neighbors; "really good VM size — full socket's performance, pay for two-thirds of the host" |
| _7a.48xlarge | 192 / 192 | Full 2P host |

**Watch-out for small instances:** A 2XLarge running a Stream memory bandwidth test will underperform vs. Intel. Reason: the GMI interface between the CCD and IOD limits memory bandwidth — can't use all channels. Intel has no such limit. This is an expected structural difference, not a bug.

**Largest non-NUMA question:** Customers running databases or Kubernetes hosts often ask this. Answer for AWS: **24XLarge** — full single socket, always predictable.

### Google Cloud Topology

| Instance | Notes |
|----------|-------|
| C3d (Genoa), ≤16 vCPU | 1 CCD on P0; has "hold-back" (blue) cores stolen for hypervisor offload |
| C3d (Genoa), 30 vCPU | 2 CCDs; hold-back cores mean 30 not 32 — no 32-core VM size on C3d; scales 30 at a time, not 32 |
| C4d (Turin) | No hold-back cores — Google solved the hypervisor offload problem in this gen |
| H4d (Turin) | SMT off, deterministic, HPC-optimized |
| N2d / N4d | Non-deterministic, oversubscribed, lower cost; host runs internal workloads alongside customer VMs; supports custom memory:vCPU ratios |

**AWS Nitro vs. Google C3d difference:** AWS has complete hardware offload of the hypervisor control plane — nothing on the host ever runs for the hypervisor domain. Google C3d couldn't fully do this and stole physical cores (shown in blue in slides).

**N-series misalignment types:**
- *NUMA misalignment:* Cores on one socket, some memory from the other socket — very hard to detect, Google tries to fix it when found
- *CCX misalignment:* e.g., three 16-vCPU VMs on a host — one gets split across two CCXs, causing variable performance vs. the other two

**N-series: good for, bad for:**
- Good: single-threaded workloads, small containers (≤1 vCPU), always-on web servers where performance just needs to be "alive"
- Bad: databases, multi-threaded data-sharing applications (Java), workloads trying to optimize on CCX affinity

---

## 5. SMT — The Full Story

### The ARM Marketing Problem
CSPs advertise "N ARM cores vs. N x86 vCPUs" — but when SMT is on, that's N ARM cores vs. N/2 x86 cores. Starting with _7a, AWS fixed this by disabling SMT: now each AMD vCPU = 1 full core = same as Graviton. But the price gap was simultaneously widened against AMD.

### GCP's vCPU Tax
On Google (N and C series with SMT on): to get a full core, you must buy 2 vCPUs. SMT uplift is ~25% (maybe 50% for IO-bound). Paying 100% more vCPUs for 25% more performance is poor value. The AWS approach — charge for 1 vCPU per core — is actually better for most workloads.

### Where AWS SMT-Off Helps AMD
- Compute-bound: Redis, HPC, financial/risk simulation, video encode/transcode, AI inference
- Licensed-per-vCPU software: MS SQL Server — fewer vCPUs = lower license cost
- Any workload where SMT gives <10% uplift — paying for two vCPUs to get a core on GCP doesn't make sense

### Where AWS SMT-Off Hurts AMD
- Java (Intel's JVM contributions + SMT benefit are meaningful)
- Multi-service container hosts
- Licensed-per-core software: Oracle DB — SMT-on gives 2N vCPUs for an N-core license, which AMD can't offer at AWS

### SMT Status by CSP

| CSP | Instance | SMT | Notes |
|-----|----------|-----|-------|
| AWS | C/M/R7a, HPC7a, C/M/R/X8a, HPC8a | OFF (cannot be turned on) | 1 vCPU = 1 core |
| AWS | _6a (Milan) and older | ON | Older approach |
| GCP | C2d, C3d, C4d | ON | Must pay 2 vCPUs per core |
| GCP | H4d | OFF | HPC-optimized |
| GCP | N2d, N4d | ON | Non-deterministic hosts |
| Azure | Ba/Da/Ea/Fa, HBv4 variants | ON | Standard GP |
| Azure | F-series, HBv5 | OFF | HPC/compute-optimized |
| Oracle | All | ON (by default) | **Best model:** 1 oCPU = 1 core = 2 vCPUs; cost the same whether you use 1 or 2 vCPUs — "pay for the core, use it however you want" |

---

## 6. Storage

### What Customers Need to Know
Most cloud storage is **network-attached**, emulated as a block device — looks local to the OS, but isn't. IOPS and bandwidth are constrained. Local NVMe is physically attached but **ephemeral** — contents erased when VM is deprovisioned, suspended, or migrated.

Key FAE question: does the customer's workload have a *hard* dependency on storage performance, or just a soft preference? SQL Server runs fine on network-attached storage — it may benefit from local NVMe as a caching tier, but rarely needs it as the primary store.

### Local NVMe — AMD Availability by CSP

| CSP | AMD Local NVMe | Notes |
|-----|----------------|-------|
| **AWS** | **Essentially NO** | No AMD "I" family; no recent AMD 'd' variants; only exception: **X8aedz** (EDA specialty). Graviton and Intel get full local NVMe offerings. |
| Azure | Yes | Las_v3 (Milan), Las_v4 / Laos_v4 (Genoa); 'd' variants of Da/Ea/Fa (e.g., D32ads_v6) |
| Google Cloud | Yes | `-lssd` option on C2d (Milan), C3d (Genoa), C4d (Turin) |
| Oracle Cloud | Yes | Dense-IO families |

### Storage Performance Options
- **AWS:** 'n' instances for higher EBS bandwidth; **Instance Bandwidth Configuration (IBC)** — trade network bandwidth for block storage bandwidth
- **Azure:** 'b' VMs for higher persistent storage bandwidth
- Block size on cloud block devices: almost always 4K; file systems can be configured for pseudo-16K alignment on top

---

## 7. AWS Power Limit — FAE Action Plan

**Customer symptoms to watch:** tail latency excursions in databases, transaction rate drops, variable performance at high utilization.

**The diagnostic:**
- Ask the customer to add **clock frequency** to their existing telemetry (Datadog, Dynatrace, in-house agents)
- When performance drops, if clock frequency also drops → confirmed AWS PPL throttling, not AMD's fault
- Tools that work inside AWS VMs: **TurboStat** (many customers didn't know this works) and **/proc/cpuinfo**

**FAE talking points with customer:**
- "This is AWS's power limit choice, not AMD's. Here's how to prove it."
- "Raise this with AWS — the more customers who complain, the less likely AWS does this again with the next generation."
- "Ask AWS why Intel _8i runs at ~630W in their environment and costs *less* than our 320W AMD instance."

**Impact by generation:**
- Genoa @ 280W: ~25% Feff below Fmax on high cache-weight workloads — customers design to lower performance baseline
- Turin @ 320W (AWS): still ~25% gap — meaningful improvement vs. 280W but still an issue
- Turin @ 400W (GCP, Azure): ~15% gap — within customer tolerance; not a problem

---

## 8. Performance Monitoring Counters (PMCs)

PMCs in VMs require hypervisor support. Uncore PMCs (L3, data fabric, memory controller) are treated as a side-channel exfiltration risk — most CSPs restrict or block them.

**Watch-out:** PMCs may appear to work (RDPMC doesn't fail) but return all-zero counts, or only some unit masks (umask) are supported. Always verify data is non-zero and meaningful.

| CSP | PMC Support |
|-----|-------------|
| AWS | Most public core PMCs available; full-socket (.24xlarge) and full-machine (.48xlarge) have some MSR-accessible uncore PMCs; SMN-only PMCs not supported |
| Google Cloud | Reduced core PMC set — **must enable PMC support at instance launch time** |
| Azure | Reduced core PMC set |
| Oracle Cloud | **No PMC support** |

**Workaround:** Profile the application on bare metal (all PMCs available, AMD uProf works fully). Constrain the bare metal test to the same core shape as the production VM. Most customers can run a test workload in a sandbox this way.

---

## 9. Custom SKUs

CSPs use custom AMD parts for price protection, inventory protection, and differentiation. Changes are typically minor: IRM group, ±50–100 MHz on boost, default TDP.

**How to identify:**
- CPUID brand string shows the custom part number (e.g., "AMD EPYC 9B45 128-Core Processor" on Google Turin)
- **Never trust the core count in the brand string** — it reflects the host part, not the guest. At Oracle, the brand string says 128-core but the VM runs on a 96-core host (down-cored in BIOS for memory harmonics). This applies even on bare metal.
- **Always use `lscpu`** to get the correct guest vCPU/core count before any topology-based optimization

**For customer questions about custom SKU specs:** escalate to the CSP GAM Sell-Out team — some information (IRM group, specific boost clocks) requires the cloud provider's permission to share.

---

## 10. Obfuscated CCX Topology

CCX topology (which cores share an L3) is exposed via CPUID topology extension calls. In a VM, the hypervisor controls what the guest sees.

| CSP | Topology Visibility |
|-----|---------------------|
| AWS | Visible and correct |
| Azure | Visible and usually correct (>90% of GP VMs and constrained-cores HB) |
| Google | Correct on C and H series; not reliable on N series |
| Oracle Cloud | Not visible — cores have L3 but no concept of shared L3 exposed to guest |

### Azure HBv4 (Genoa-X) — Intentional Design

Azure and AMD jointly decided to collapse the CCD topology on the full-size HBv4 VMs:
- Physical reality: multiple CCDs each with their own L3
- What the guest sees: 44 cores *appearing* to share one 96 MB L3 (Genoa-X = 32 MB base + 64 MB 3D V-Cache)
- Why: MPI-based HPC applications know how to spread work by NUMA node. In NPS2 mode, this looks like 4 NUMA nodes × 44 cores — HPL and single-threaded HPC processes "just work"
- Azure also steals some physical cores for hypervisor offload (shown as blue in the slides)

**Problem with full-size HBv4 for CFD (e.g., ANSYS Fluent):** Can't see real CCX topology → can't optimize core placement per CCD → suboptimal performance.

**Solution — Constrained Cores VM sizes (HB176-96rs_v4, etc.):**
- Available in 6, 4, 2, and 1 core-per-CCD variants
- Topology is correctly and fully exposed — equivalent to going into BIOS and setting 4 cores per CCD
- All EPYC HPC optimizations work normally on constrained cores VMs
- Use the 50% size (4 cores/CCD) as the starting point for Ansys Fluent

---

## 11. Optimizing Commercial Software

### Step 1: Know the License Model
- **Per physical core:** Oracle DB, MS Windows Server, EDA software
- **Per vCPU:** MS SQL Server, most Red Hat applications
- **Per block of cores:** Ansys HPC packs

Goal is not raw performance — it's **performance per licensed dollar**.

### AWS "License Included" AMIs
- Pay AWS one bill; AWS handles paying the software vendor (Microsoft, etc.)
- Legally bypasses Microsoft's "dedicated host" BYOL requirement
- Enables use of two key CPU Options that **also reduce the license cost proportionally:**

| Feature | What it does | Applies to |
|---------|-------------|------------|
| **Threads Per Core** | Hypervisor control of SMT — set to 1 to halve vCPUs | AMD _6a, Intel instances (SMT-off instances like _7a/_8a already at 1, cannot change to 2) |
| **Optimize Cores** | Reduce active core count in instance — doesn't reduce memory or instance cost | All instance types |

### SQL Server Migration Example (Lewis Carroll, credit to Jeremy)

**Baseline:** Customer on Intel **R7i.16xlarge** — 64 vCPUs / 32 cores (SMT on), license-included

**Common mistake — Move directly to R8a.16xlarge without Optimize Cores:**
- R8a: 64 vCPUs / 64 cores (SMT off)
- SQL Server performance: **same** (EBS network storage is the bottleneck, not CPU)
- EC2 cost: +15% (AMD premium)
- Windows Server cost: **+100%** (64 cores vs. 32 cores)
- SQL Server cost: unchanged (still 64 vCPUs)
- Result: customer pays more for the same performance → they are angry and blame you

**The right move — Add Optimize Cores (Step 2):**
- Testing shows SQL Server performance is constant beyond ~50% of cores (EBS-limited)
- Use Optimize Cores to disable half the cores → 32 active cores → 32 vCPUs
- EC2 cost: +15% vs. original Intel baseline
- Windows Server: **-50%** vs. original
- SQL Server license: **-50%** vs. original
- **Net result: ~45% TCO savings for equivalent performance**
- Note: some customers have turned off 75% of cores and still met their performance SLA

**Where to learn more:** Jeremy's published blog (linked from Lewis Carroll's LinkedIn) + demo video cover this in full detail with dollar figures.

---

## 12. Optimizing Commercial HPC — Ansys Fluent

**The objection to overcome:** "I paid for all these cores, I need to use all of them."
**The reality:** For CFD (memory-bandwidth-bound solvers), you run out of memory bandwidth long before you can use all cores — you'd use half, a third, or a fourth anyway. The goal is performance per licensed dollar, not utilization.

### Ansys Licensing Structure (HPC Packs)
| HPC Packs | HPC Pack Cores | + Solver Cores | Total Cores Licensed |
|-----------|----------------|----------------|----------------------|
| 0 | 0 | 4 | 4 |
| 1 | 8 | 4 | 12 |
| 2 | 32 | 4 | 36 |
| 3 | 128 | 4 | 132 |
| 4 | 512 | 4 | 516 |
| 5 | 2,048 | 4 | 2,052 |

### Strategy: Start at 50% Constrained Cores
Gives 4 cores per CCD on the relevant HPC instances — no extra MPI configuration needed:
- **Azure HB176-96rs_v4** → 4 cores/CCD, MPI PPN = 96
- **AWS HPC7a.48xlarge** → 4 cores/CCD, MPI PPN = 96

**Example at 50% size (3 HPC packs = 132 total cores licensed):**
- 1 node × 96 used cores; 36 cores unused per node
- Performance is *better* than using full-size nodes because memory bandwidth is not exhausted

**Example at 75% (Azure HB176-144rs_v4) or 100% (AWS HPC7a.96xlarge):**
- 5 used cores per CCD (use 5, regardless of whether node has 6 or 8 per CCD)
- Requires proper MPI command line for processes-per-node and binding
- Lower infrastructure cost but also lower simulation performance (fewer nodes = less total memory bandwidth)

---

## 13. Q&A Highlights from the Session

**Q: Does GCP over-provision memory as well as compute on N-series?**
A (Lewis): Yes — both compute and memory. The host may have more schedulable threads than physical vCPUs. If they need more memory, they reclaim it from internal (non-customer) workloads — no balloon driver, no squeezing of customer VMs.

**Q: Do cloud providers expose block size on block devices, and can customers align their filesystem?**
A (Lewis): Yes and yes. Block size is almost always 4K. Customers can configure a pseudo-16K block size at the filesystem layer on top. SQL Server performance is often limited by this — matching filesystem block size to the block device is key.

---

## Instance Quick Reference

| Instance | CSP | CPU | vCPUs | SMT | PPL | Local NVMe | PMC | Topology Visibility |
|----------|-----|-----|-------|-----|-----|------------|-----|---------------------|
| M7a / C7a / R7a | AWS | Genoa | 8–192 | OFF | 280W (C7a: 400W) | No | Core PMCs | Correct |
| HPC7a | AWS | Genoa | 96 / 192 | OFF | 400W | No | Core PMCs | Correct |
| R7an | AWS | Genoa | varies | OFF | 400W | No | Core PMCs | Correct |
| M8a / C8a / R8a | AWS | Turin | 8–192 | OFF | 320W | No | Core PMCs | Correct |
| HPC8a | AWS | Turin | varies | OFF | varies | No | Core PMCs | Correct |
| M8azn / X8azn | AWS | Turin HF | up to 48c/96 vCPU | OFF | 500W | No | Core PMCs | Correct |
| X8aedz | AWS | Turin HF | varies | OFF | varies | **Yes** (EDA) | Core PMCs | Correct |
| _6a (Milan) | AWS | Milan 6+1 | varies | ON | — | No | Core PMCs | Correct |
| C2d | GCP | Milan | varies | ON | — | `-lssd` | Core PMCs (must enable) | Correct |
| C3d | GCP | Genoa | varies | ON | — | `-lssd` | Core PMCs (must enable) | Correct; has hold-back cores |
| C4d | GCP | Turin | varies | ON | 400W | `-lssd` | Core PMCs (must enable) | Correct; no hold-back |
| H4d | GCP | Turin | varies | OFF | — | — | Core PMCs (must enable) | Correct |
| N2d | GCP | Milan | varies | ON | — | No | Core PMCs (must enable) | Unreliable — non-deterministic |
| N4d | GCP | Turin | varies | ON | — | No | Core PMCs (must enable) | Unreliable — non-deterministic |
| Ba/Da/Ea/Fa v6 | Azure | Genoa | varies | ON | — | 'd' variants | Core PMCs | Correct (1P host) |
| Ba/Da/Ea/Fa v8 | Azure | Turin | varies | ON | — | 'd' variants | Core PMCs | Correct (1P host) |
| HBv4 (full) | Azure | Genoa-X | 176 | OFF | — | No | Core PMCs | Obfuscated (44-core L3 view) |
| HBv4 (constrained) | Azure | Genoa-X | 96/144/etc. | OFF | — | No | Core PMCs | Correct and fully visible |
| HBv5 | Azure | Milan | varies | OFF | — | No | Core PMCs | Correct |
| F-series | Azure | varies | varies | OFF | — | No | Core PMCs | Correct |
| Las_v3/v4, Laos_v4 | Azure | Milan/Genoa | varies | ON | — | Yes | Core PMCs | Correct |
| E6 (bare metal) | Oracle | Turin 16+1 | 192 | ON | 450W | Dense-IO | **None** | Not visible |
| E6 VMs | Oracle | Turin | varies | ON | — | Dense-IO | **None** | Not visible |

---

## Key FAE Takeaways

1. **Almost every cloud AMD problem is a performance problem.** Understand the root cause before proposing a solution.
2. **Ask about PPL first on AWS.** Add clock frequency to customer telemetry. If perf drops when clock drops → AWS's fault, not AMD's.
3. **Memory harmonics explain down-coring.** When a customer sees an unexpected core count, it's almost always for the memory ratio.
4. **Largest non-NUMA on AWS = 24XLarge** (full single socket). The 32XLarge crosses NUMA but is a great value.
5. **AWS N-series problem = GCP's N-series, not N-series.** On GCP, steer variable-performance complaints toward C-series (deterministic). N-series is for cost-sensitive, performance-tolerant workloads.
6. **SQL Server opportunity = Optimize Cores.** Move from Intel to AMD R8a, then cut cores in half. ~45% TCO savings, same performance. Use Jeremy's blog for details and the demo video for customer conversations.
7. **Ansys Fluent = start at 50% constrained cores.** Overcome the "I paid for all the cores" objection with the memory bandwidth argument.
8. **When stuck:** call Pradeep, Noor, or Palak. For AWS-specific sellout questions: Jeremy in Seattle.
