# Cloud 201: Intermediate Cloud for FAEs — Summary
*Based on slide deck "What FAEs Need to Know" by Lewis Carroll*
*Transcript commentary to be merged — marked [TRANSCRIPT PENDING] where spoken detail is expected*

---

## 1. Why Cloud AMD Deals Are Hard to Win

The deck opens with a frank breakdown of where AMD loses cloud deals:

**80%+ of obstacles** are general performance / instance feature issues where AMD's advantage is real but not compelling enough to displace the incumbent:
- AMD is often ~50% more performance per vCPU but ~15% higher price — insufficient to overcome Intel's installed base or ARM's subsidized pricing (Graviton at AWS, Cobalt at Azure, Axion at GCP)
- Java and Python workloads are a specific pain point (Intel has made substantial JVM contributions; SMT on Intel also benefits Java)

**Three real-world examples called out:**
- **AirBnB / AWS M7a (Genoa):** In a mixed Kubernetes cluster, all CPUs treated as equal → AMD's 15% price premium just added cost with no throughput benefit
- **Salesforce / AWS R7a (Genoa) vs. R7i (Sapphire Rapids):** AMD ~20% faster but SMT on Intel and Java optimizations made the switch not worth it
- **Snowflake:** Required local disk (not available on AMD at AWS); Azure allowed Cobalt to exceed local disk perf spec by 100% while AMD was held to spec

**10% specialized performance** — AMD wins on HPC, video encode, financial simulation; loses on FSI math (MKL), AI inference with Intel AMX

**10% other** — ISV marketplace compatibility gaps, random compatibility questions

---

## 2. Root Causes: Why Cloud AMD ≠ Bare Metal AMD

Customer symptoms:
- Cloud performance below expectations or insufficient price-performance incentive
- Cloud performance at or below on-prem / bare metal
- More variable performance vs. on-prem
- Feature availability differences

Root causes the FAE needs to understand:
- **CSP controls pricing** → ARM and Intel subsidization at AWS
- **Virtualization stack design** and VM/instance feature choices
- **CSP product/positioning choices**
- **Host hardware design and BIOS settings** (especially Package Power Limit)
- **Custom SKUs** with non-public specs

---

## 3. Host Hardware Configuration

### 1P vs. 2P
- **Most cloud hosts are 2P** (two sockets)
- **Exception: Microsoft general-purpose families** (Ba/Da/Ea/Fa) are **1P**

### CCD / Die Construction
| Host | CPU | Die Config |
|------|-----|------------|
| Most Genoa & Turin cloud hosts | Genoa / Turin | 12+1 parts (standard) |
| Google Cloud C4d & H4d | Turin Classic | 16+1, down-CCD to 12+1 |
| Oracle Cloud E6 | Turin | 16+1 (128 core) |
| AWS M8azn, X8aedz | Turin HF | 8+1, down-core to 48c |
| AWS _6a (Milan) | Milan | 6+1, 48c |

### Power / PPL Settings
| Instance Family | PPL | Notes |
|-----------------|-----|-------|
| AWS C/M/R7a (Genoa) | **280W** | Matches Graviton 3; vs. 400W+ elsewhere |
| AWS HPC7a, R7an | 400W | Exceptions |
| AWS M8azn | 500W | Exception |
| AWS C/M/R8a (Turin) | **320W** | Matches Graviton 4; GCP/Azure at 400W, Oracle at 450W |
| Intel _8i (Granite Rapids) at AWS | 630W | Lower price than AMD |

**Impact:** At 280W Genoa or 320W Turin, effective frequency runs ~25% below Fmax across most of the core range. At 400W Turin (GCP/Azure), the gap is ~15%. This directly erodes AMD's performance advantage at AWS.

### Memory Speed Settings
- AWS M/R7a (Genoa): limited to **4400 MT/s** (C7a / HPC7a run at 4800 MT/s)

### SMT Settings Per CSP
- **SMT disabled:** AWS C/M/R7a, HPC7a, C/M/R/X8a, HPC8a; Azure F-series, HB-series; Google H4d
- All others: SMT enabled by default

---

## 4. Virtualization Stack

### Deterministic vs. Non-Deterministic

**Deterministic** (VMs always from fewest logical vCPUs, same size = same CCX topology, topology correctly exposed to guest):
- **AWS:** All families
- **Google Cloud:** C2d, C3d, C4d, H4d
- **Azure:** Ba/Da/Ea/Fa (>90%); HB

**Non-deterministic** (host can be oversubscribed, NUMA/CCX misalignment possible):
- **Google Cloud:** N2d, N4d
- **Oracle Cloud:** VMs

### AWS Instance Topology Diagrams
These are explicitly taught in the deck — key instances:

| Instance | vCPUs / Cores | Topology |
|----------|---------------|----------|
| _7a.2xlarge (and smaller) | 8 vCPUs / 8 cores | 1 CCD on P0 — also applies to _8a |
| _7a.8xlarge | 32 vCPUs / 32 cores | 4 CCDs on P0 — also applies to _8a |
| _7a.24xlarge | 96 vCPUs / 96 cores | Full P0 (12 CCDs), largest non-NUMA instance — also applies to _8a |
| _7a.32xlarge | 128 vCPUs / 128 cores | Full P0 + 4 CCDs on P1 (NUMA boundary crossed) — also applies to _8a |
| _7a.48xlarge | 192 vCPUs / 192 cores | Full 2P host |

### Google Cloud Topology

| Instance | Notes |
|----------|-------|
| C3d (Genoa), ≤16 vCPU | 1 CCD on P0; has "hold-back" cores (blue) |
| C3d (Genoa), 30 vCPU | 2 CCDs; hold-back cores present |
| C4d (Turin) | No hold-back cores |
| N2d / N4d | Non-deterministic; price leader; host can run internal workloads alongside VMs; supports custom memory:vCPU ratios → occasional NUMA and CCX misalignment |

**N-series impact:** Variable VM-to-VM performance; CCX topology incorrect or obfuscated. Good for single-threaded workloads and small containers (≤1.0 CPU). Bad for databases and multi-threaded data-sharing applications.

---

## 5. SMT — The Core Story

Starting with _7a (Genoa), **AWS disabled SMT on the host**. Each _7a / _8a vCPU = 1 full physical core — same as Graviton.

**Why this matters for AMD positioning:**
- Makes AMD vs. Graviton comparisons apples-to-apples on a per-vCPU basis
- Gives AMD favorable performance vs. Intel instances (where each vCPU is just an SMT thread = half a core)
- BUT: AMD price per vCPU is ~15% higher than Intel and ~30% higher than Graviton
- AND: SOC PPL is constrained to match Graviton → performance uplift from SMT isn't available anyway

**Where SMT-off is good for AMD:**
- Compute-bound: Redis, HPC, financial/risk simulation, video encode/transcode, AI inference
- Licensed-per-vCPU software: MS SQL Server (fewer vCPUs = lower license cost)

**Where SMT-off is bad for AMD:**
- Java workloads
- Multi-service container hosts
- Licensed-per-core software: Oracle DB (SMT on would give 2N vCPUs for the same N-core license cost)

### SMT-off by CSP
| CSP | SMT-off Instances |
|-----|-------------------|
| AWS | C/M/R7a, HPC7a, C/M/R/X8a, HPC8a |
| Azure | HBv4 (Genoa), HBv5 (MI300C) — HPC optimized; F-series |
| Google | H4d — HPC optimized |
| Oracle | N/A — Oracle prices by "oCPU" (1 core = 2 vCPUs); "pay for the core, use it however you want" |

---

## 6. Storage

### Storage Types Overview
- **Ephemeral / Local NVMe:** Fastest, non-persistent — EC2 "I" family, Azure "L" family, GCP `-lssd`, Oracle Dense-IO
- **Persistent block:** EBS, Azure Block, GCP Persistent Disk
- **High-performance persistent block:** EBS io2, Azure "b" VMs
- **Object/File:** S3, Azure Blob, EFS

### Local NVMe — AMD Availability
**AWS gives preferential treatment to Graviton and Intel for local NVMe:**
- No AMD "I" family at AWS
- No recent AMD 'd' variants (C/M/R with local NVMe) at AWS
- Only exception: specialty **X8aedz** for EDA workloads

**All other CSPs have AMD-based local NVMe:**
- **Azure:** Las_v3 (Milan), Las_v4 / Laos_v4 (Genoa); 'd' variants of Da/Ea/Fa (e.g. D32ads_v6)
- **Google Cloud:** `-lssd` option on C2d (Milan), C3d (Genoa), C4d (Turin)
- **Oracle Cloud:** Dense-IO families

### Storage-Dependent Workloads
- High-performance temp storage: caching tier for databases / data warehouses (e.g. Apache Spark)
- High-performance persistent: "hyperconverged" nodes (VMware, Nutanix)
- NAS performance can bottleneck workloads: e.g. MS SQL Server on AWS EBS
- Options for higher persistent storage BW: AWS 'n' instances, Azure 'b' VMs
- AWS also offers **Instance Bandwidth Configuration (IBC)**: trade network BW for storage BW

---

## 7. AWS Power Limit — FAE Talking Points

Key customer symptom to watch for: **variable performance, tail latency excursions** in databases and transaction processing systems.

FAE actions:
- Suggest customers **add clock frequency to logging/telemetry** (`/proc/cpuinfo` works on AWS)
- **Raise the issue with AWS** — the more customers complain, the less likely AWS repeats this with future generations
- AWS pushback: "higher PPL = higher price" → counter: Intel _8i runs at 630W at a *lower* price than AMD

---

## 8. Performance Monitoring Counters (PMCs)

PMCs in VMs require hypervisor support. "Uncore" PMCs (L3, data fabric, memory controller) are considered a side-channel exfiltration risk — CSPs restrict or disable them.

| CSP | PMC Support |
|-----|-------------|
| AWS | Most public core PMCs available; full-socket (.24xlarge) and full-machine (.48xlarge) have some MSR-accessible uncore PMCs; SMN-only PMCs not supported |
| Google Cloud | Reduced set of core PMCs; instance must be **started with PMC support enabled** |
| Azure | Reduced set of core PMCs |
| Oracle Cloud | **No PMC support** |

Watch out: PMCs may *appear* to work (RDPMC doesn't fail) but return all-zero counts, or not all unit masks (umask) are supported. All PMCs always available on bare metal.

---

## 9. Custom SKUs

CSPs use custom AMD SKUs for price protection, inventory protection, and differentiation. What's customized:
- IRM group
- Default TDP
- ±base and max boost clocks (usually ≤100 MHz delta)
- **Specific CSP SKU specs are confidential** — escalate to the CSP GAM Sell-Out team for end-customer custom SKU questions

**Identifying custom SKUs:**
- CPUID brand string lists the custom part number (e.g. Google/Turin: "AMD EPYC 9B45 128-Core Processor")
- Core count in brand string = host core count, **not** guest core count
- Always use `lscpu` to get the correct guest vCPU / core count for optimization work

---

## 10. Obfuscated CCX Topology

CCX topology (which cores share an L3) is exposed via CPUID topology extension calls — in a VM, the hypervisor controls what the guest sees.

| CSP | Topology Visibility |
|-----|---------------------|
| AWS | Visible and correct |
| Azure | Visible and usually correct (>90% of VMs) on GP and "constrained cores" HB |
| Google | Correct on C and H series; not necessarily correct on N series |
| Oracle Cloud | **Not visible** — cores have L3, but no concept of shared L3 exposed |

### Azure HBv4 & HX (Genoa-X) — Special Case
These instances have a deliberately obfuscated topology:
- HB176rs_v4: 44 cores *appear* to share one 96 MB L3 (not the physical reality)
- HB176-96rs_v4 (constrained cores): Equal cores per CCX — topology is visible and correct
- "Minroot" cores (Azure hypervisor overhead) consume some physical cores and are hidden from the guest

---

## 11. Optimizing Commercial Software

### Licensing Model First
- **Per physical core:** Oracle DB, MS Windows Server, EDA software
- **Per vCPU:** MS SQL Server, most Red Hat applications
- **Per block of cores:** Ansys HPC applications

### SMT Optimization Lever
- SMT off: N vCPUs on N cores → for per-vCPU licensed software, lower license cost
- SMT on: 2N vCPUs on N cores → for per-core licensed software, more vCPUs for same license cost
- AWS AMD (_7a/_8a) SMT is off by default and **cannot be turned on** — disadvantages per-core licensed apps

### AWS "License Included" AMIs
- Pay AWS one bill; AWS handles the license payment
- Legally bypasses Microsoft's "dedicated host" requirement for BYOL
- Enables use of **CPU Options**: Threads Per Core and Optimize Cores

**New AWS feature for License Included AMIs:**
- **Threads Per Core:** Hypervisor control of SMT (AMD _6a, Intel instances); defaults to 2, user can set to 1 to halve vCPUs → reduces SQL Server and Windows Server license cost proportionally. Note: SMT-off instances (_7a/_8a, Graviton) default to 1 and cannot be changed to 2.
- **Optimize Cores:** Reduce number of active cores in the instance → reduces vCPUs without reducing memory or instance cost → **also reduces license-included software license cost proportionally**

### SQL Server Migration Example (taught in detail)

**Baseline:** Customer on Intel R7i.16xlarge — 64 vCPUs / 32 cores (SMT on)

**Step 1 — Move to R8a.16xlarge (AMD Turin):**
- 64 vCPUs / 64 cores (SMT off)
- Similar SQL Server performance vs. R7i (SQL Server is EBS-limited, not CPU-limited)
- EC2 cost: +15%; Windows and SQL Server license: unchanged

**Step 2 — Use Optimize Cores to disable half the cores:**
- SQL Server performance is constant beyond ~half the cores
- Enable Optimize Cores → 32 active cores → 32 vCPUs
- EC2 cost: +15% vs. R7i baseline; Windows Server: **−50%**; SQL Server: **−50%**
- **Net result: ~45% TCO savings for equivalent performance**

---

## 12. Optimizing Commercial HPC (Ansys Fluent)

Ansys uses HPC Pack licensing: packs unlock additional solver cores in exponential blocks (8 cores pack 1, 32 pack 2, 128 pack 3, 512 pack 4, 2048 pack 5 — always plus 4 base solver cores).

**Key principle:** Optimize performance per license dollar, not raw throughput. For memory-bandwidth-bound solvers (CFD), more nodes with fewer cores per node beats fewer large nodes.

**Start at 50% "Constrained Cores" instance size** — this gives 4 cores per CCX on the relevant HPC instances:
- Azure HB176-96rs_v4 → 4 cores/CCX
- AWS HPC7a.48xlarge → 4 cores/CCX
- MPI PPN = 96 (all cores, no extra configuration)

**Example 1 (50% size):**
| HPC Packs | Total Cores | 50% Nodes | Used Cores | Unused |
|-----------|-------------|-----------|------------|--------|
| 3 | 132 | 1 | 96 | 36 |
| 4 | 516 | 5 | 480 | 36 |
| 5 | 2052 | 21 | 2016 | 36 |

**Example 2 (75% Azure / 100% AWS):**
- Azure HB176-144rs_v4 → 6 cores/CCX (use 5); AWS HPC7a.96xlarge → 8 cores/CCX (use 5)
- Requires proper MPI command line for processes-per-node and mapping
- Lower infrastructure cost, lower simulation performance (fewer nodes = less memory BW)

---

## 13. Key FAE Contacts

- **Pradeep Nallimelli** — Cloud FAE Team Manager, Santa Clara, CA
- **Noor Fairoza Khan** — Cloud FAE, Charlotte, NC

---

## Instance Quick-Reference Table

| Instance | CSP | CPU | vCPUs | SMT | PPL | Local NVMe | PMC | Topology |
|----------|-----|-----|-------|-----|-----|------------|-----|----------|
| M7a / C7a / R7a | AWS | Genoa | 8–192 | OFF | 280W (C7a: 400W) | No | Core PMCs | Deterministic |
| HPC7a | AWS | Genoa | 96–192 | OFF | 400W | No | Core PMCs | Deterministic |
| R7an | AWS | Genoa | varies | OFF | 400W | No | Core PMCs | Deterministic |
| M7azn / X7azn | AWS | Turin HF | up to 48c | OFF | 500W | X8aedz only | Core PMCs | Deterministic |
| M8a / C8a / R8a | AWS | Turin | 8–192 | OFF | 320W | No | Core PMCs | Deterministic |
| HPC8a | AWS | Turin | varies | OFF | varies | No | Core PMCs | Deterministic |
| X8aedz | AWS | Turin HF | varies | OFF | varies | Yes (EDA specialty) | Core PMCs | Deterministic |
| _6a (Milan) | AWS | Milan 6+1 | varies | OFF (was on) | — | No | Core PMCs | Deterministic |
| C2d | GCP | Milan | varies | on | — | -lssd option | Core PMCs (enable at start) | Deterministic |
| C3d | GCP | Genoa | varies | on | — | -lssd option | Core PMCs (enable at start) | Deterministic |
| C4d | GCP | Turin | varies | on | 400W | -lssd option | Core PMCs (enable at start) | Deterministic |
| H4d | GCP | Turin | varies | OFF | — | — | Core PMCs (enable at start) | Deterministic |
| N2d | GCP | Milan | varies | on | — | No | Core PMCs (enable at start) | Non-deterministic |
| N4d | GCP | Turin | varies | on | — | No | Core PMCs (enable at start) | Non-deterministic |
| Ba/Da/Ea/Fa v6 | Azure | Genoa | varies | on | — | 'd' variants | Core PMCs | Deterministic (1P host) |
| Ba/Da/Ea/Fa v8 | Azure | Turin | varies | on | — | 'd' variants | Core PMCs | Deterministic (1P host) |
| HBv4 | Azure | Genoa-X | 176 | OFF | — | No | Core PMCs | Obfuscated (see §10) |
| HBv5 | Azure | MI300C | varies | OFF | — | No | Core PMCs | Deterministic |
| F-series | Azure | varies | varies | OFF | — | No | Core PMCs | Deterministic |
| Las_v3/v4 | Azure | Milan/Genoa | varies | on | — | Yes | Core PMCs | Deterministic |
| E6 (bare metal) | Oracle | Turin 16+1 | 192 | on | 450W | Dense-IO | None | Deterministic |
| E6 VMs | Oracle | Turin | varies | on | — | Dense-IO | None | Non-deterministic |

---

*[TRANSCRIPT PENDING — spoken commentary, Q&A, and verbal elaborations to be merged once transcript is available]*
