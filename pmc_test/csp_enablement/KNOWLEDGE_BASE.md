# PMC Enablement Knowledge Base — AMD EPYC across CSPs

**Last updated:** 2026-05-25
**Owner:** Pradeep / AMD PMC Enablement
**Scope:** What PMC events work on which platform (bare metal vs AWS Nitro), what perf / PerfSpect / public PPR exposes, and how to extend the matrix to new clouds.

This is the single source of truth. When in doubt, start here.

---

## 1. Headline truths (don't relearn these)

1. **Always use named perf events on Turin**, not raw `cpu/event=,umask=/` codes. Raw codes silently drop PERF_CTL[35:32] high bits for events > 0xFF (e.g. `op_cache_hit_miss.*` = 0x28F, `ic_tag_hit_miss.*`, `bp_l1_tlb_miss_l2_tlb_miss.*`). The old "23 events Nitro-blocked" finding was a tooling artifact, not a hypervisor filter.
2. **The real AWS Nitro core-PMC filter is 9 events**, not 23 or 58, and only on `m8a.2xlarge`. Full-socket guests (`m8a.24xlarge`) and metal hit none of them. The filtered family is `ls_any_fills_from_sys.*` / `ls_dmnd_fills_from_sys.*` (umasks for local CCX / near cache / dram_io_near / all) plus the perf-generic wrapper for `iTLB-load-misses` (the raw `bp_l1_tlb_miss_l2_tlb_miss.all` works).
3. **`amd_uncore.ko` ships in `linux-modules-extra-aws`** — it is NOT stripped from the AWS kernel build. The default AMI just doesn't install that package. On metal: `sudo apt-get install -y linux-modules-extra-$(uname -r) && sudo depmod -a && sudo modprobe amd_uncore` exposes L3, DF, IOMMU, 12× UMC, IBS. On Nitro guests, the module loads but PMU devices do not appear — uncore MSRs are a real hypervisor restriction.
4. **Zen5 dispatch = 8 slots/cycle**, not 6. The toolkit's CLAUDE.md still says 6 — fix when working on the Zen5 path. PerfSpect's `turin.json` denominator is `ls_not_halted_cyc × 8`.
5. **L2 prefetch events 0x70/0x71/0x72 behave differently under Nitro across generations.** `0x71`/`0x72` are dead on partial-socket guests on both m7a and m8a. Genoa additionally blocks the `0x1F` composite umask even on `m7a.48xlarge`. Turin blocks individual umasks on `m8a.2xl` but allows `0x1F`. Genoa and Turin do not transfer.
6. **PerfSpect's canonical Turin metric set is `intel/PerfSpect@main` → `turin.json`** (137 metrics). Of those, 42 work on AWS m8a today, 9 are core-PMC-filtered, the rest were originally "unknown" but now confirmed via named-event sweeps. See §5.
7. **Public AMD PPR Rev 5.0 (BRH C1) exposes 81 / 299 core events.** PerfSpect uses ~20 umask combos that only appear in the **NDA PPR** — chief among them the Zen5 slot-account events (`0x1A0`, `0x1A2`, `0x1C2`). These return zero silently on Zen4. Maintain separate Zen4 and Zen5 pipeline event YAMLs.

   **Confidentiality:** the NDA PPR is AMD-internal. Counters that exist only in the NDA PPR are never to be published, exposed to customers, or used in external CSP "asks" documents. External asks must cite only public-PPR-documented events. NDA-only counters can be used for internal AMD analysis and for guiding PerfSpect's own implementation, but cannot leak into CSP-facing collateral.
8. **AWS results uploads land in S3** at `s3://amd-pmc-toolkit-pradeepn/results/aws/{instance-type}/{instance-id}/{YYYY-MM-DD}/{sweep}.txt`. Run wrapper is `s3://amd-pmc-toolkit-pradeepn/artifacts/run_pmc.sh`. IMDSv2 token required for metadata fetch.

---

## 2. Test instance inventory

| Platform | Identifier | CPU | Cores | Role |
|---|---|---|---|---|
| AWS m8a.2xlarge | spin per session | Zen5 Turin (EPYC 9R45) | 8 vCPU | Partial-socket Nitro guest — hits the 9-event filter |
| AWS m8a.24xlarge | i-0c102ade695b014bf (us-west-2) | Zen5 Turin (EPYC 9R45) | 96 vCPU full socket | Full-socket Nitro guest — clears all 9 filters |
| AWS m8a.metal-24xl | spin per session | Zen5 Turin (EPYC 9R45) | 96 cores bare metal | Full uncore stack after `linux-modules-extra-$(uname -r)` install |
| AWS m7a.4xlarge | per Palak (BMC sheet) | Zen4 Genoa (EPYC 9R14) | 16 vCPU | Genoa partial-socket Nitro |
| AWS m7a.8xlarge | i-0e413ac968cdef1e2 (us-west-2) | Zen4 Genoa (EPYC 9R14) | 32 vCPU | Genoa Nitro |
| AWS m7a.48xlarge | per Palak | Zen4 Genoa | full socket | Genoa full-socket Nitro |
| Turin on-prem | 10.194.179.119 amd/amd123 | 2× EPYC 9755 | 256 cores / 24 CCDs | Zen5 bare-metal reference |
| Genoa-X on-prem | host-ruby-de91.amd.com / 10.216.176.12 | EPYC 9684X 3D V-Cache | 96 cores / 12 CCDs | Zen4 bare-metal reference |

SSM creds: `claude-ssm-ruby` IAM user; SSM-full + S3-full attached. Instance profile `instanceRole` has inline policy `amd-pmc-toolkit-rw` for S3 read on `artifacts/`, write on `results/`.

---

## 3. Tooling — three sources of PMC data, not interchangeable

| Tool | What it gives you | When to use |
|---|---|---|
| **raw `perf stat`** | Whatever you ask for. Most flexible, no abstraction. | Diagnostic sweeps, building new metrics, validating event programmability |
| **PerfSpect** (`intel/PerfSpect@main`) | 137 pre-packaged Turin metrics in `turin.json`; ~145 for Genoa. Auto-detects topology, scales to full socket, emits HTML/CSV. | Standard reporting / customer-facing analysis. Canonical metric set. |
| **public PPR (AMD published)** | 81 / 299 core events documented for BRH C1 (Turin). No NDA-only umasks (esp. the 0x1A0 slot-account family). | Compliance / external citation; baseline for what CSPs are obligated to expose. **The only set safe to put in customer/CSP-facing material.** |
| **NDA PPR (AMD-internal)** | Full 299 events, including the slot-account family PerfSpect depends on for Zen5. | Internal AMD analysis only. Never quote these events in external asks, customer collateral, or public docs. |

**Internal vs public PPR:** NDA PPR has 20 extra umask combos that PerfSpect depends on. Most-load-bearing is `0x1A0` umasks (slot accounting) — without these, you cannot reconstruct the PerfSpect Pipeline Utilization tree from the public-PPR-only set on Zen5.

**Authoritative event lists in this repo:**
- `pmc_test/events.yaml` — full sweep grid
- `perfspect_genoa_metrics.json` — vendor copy of Genoa metric formulas
- `AMD_OFFICIAL_PMC_EVENTS.md` — Table 26 (Family 19h, Genoa)
- `AMD_PMC_REGISTER_REFERENCE.md` — PMC register format
- `amd_metric_groups.yaml` — PerfSpect grouping

---

## 4. The matrix — what works where

### 4a. Core PMC matrix (Turin, m8a 4-way sweep)

From `pmc_test/csp_enablement/AWS_4WAY_MATRIX.md` (full table). Headline counts:

| Target | Events programmable | Notes |
|---|---:|---|
| m8a.2xlarge | 35 / 49 | 9 events filtered (see §1.2); 5 are workload-zero (single socket / no SMT contention / no 1GB pages) |
| m8a.24xlarge | 44 / 49 | Same 5 workload-zero events |
| m8a.metal-24xl | 44 / 49 | Same 5 workload-zero events |
| Turin on-prem | 49 / 49 | Reference |

The 9-event Nitro filter is exclusively partial-socket. The 5 "workload-zero" events are not blocked — they just need a workload that exercises them (SMT contention, cross-socket traffic, 1GB hugepages).

### 4b. L2-prefetch matrix (cross-generation)

From `memory/l2pf_nitro_filter.md`:

| Event | Umask | m7a.4xl | m7a.48xl | m8a.2xl | m8a.24xl | m8a.metal |
|---|---|--:|--:|--:|--:|--:|
| 0x70 (PF hit L2) | 0x01..0x10 individual | OK | OK | ZERO | OK | OK |
| 0x70 | 0x1F composite | ZERO | **ZERO** | OK | OK | OK |
| 0x71 (PF miss L2, hit L3) | any | ZERO | ZERO | ZERO | OK | OK |
| 0x72 (PF miss L2/L3 → DRAM) | any | ZERO | ZERO | ZERO | OK | OK |

Verified non-zero stable counts on m8a.metal under mhammer (12-thread STREAM-triad + copy): `0x70×0x1F ~160M`, `0x71×0x1F ~4M`, `0x72×0x1F ~380M`.

### 4c. Uncore PMU matrix

| PMU | On-prem | m8a.metal (after apt install) | m8a.24xl | m8a.2xl |
|---|---|---|---|---|
| amd_l3 | ✓ | ✓ | ✗ | ✗ |
| amd_df (Data Fabric) | ✓ | ✓ | ✗ | ✗ |
| amd_iommu_0..3 | ✓ | ✓ | ✗ | ✗ |
| amd_umc_0..11 (12 channels) | ✓ | ✓ | ✗ | ✗ |
| ibs_op / ibs_fetch | ✓ | ✓ | ✗ | ✗ |

**Single-line metal unlock:** `sudo apt-get install -y linux-modules-extra-$(uname -r) && sudo depmod -a && sudo modprobe amd_uncore`.

### 4d. PerfSpect Turin metrics — current status (after named-event correction)

| Status | Count | Meaning |
|---|---:|---|
| Works on AWS partial-socket | 42 | Every event the metric needs is programmable on m8a.2xl |
| Works on AWS full-socket only | ~37 | Needs the 9 filtered events OR uncore — works on 24xl/metal |
| Truly broken on AWS (any size) | ~9 | Needs DF/UMC PMU on a non-metal guest, or is the perf-generic iTLB wrapper |

The previous "58 broken on AWS" count is **superseded** — file `PERFSPECT_AWS_STATUS.md` carries a banner pointing here.

---

## 5. How each metric helps with performance optimization

Compact map from PMC → diagnosis. Use this when somebody asks "what does this event tell me?"

| Event(s) | What it tells you | Action when high |
|---|---|---|
| `de_no_dispatch_per_slot.no_ops_from_frontend` | Frontend can't feed the pipeline (icache miss, BTB miss, branch resteer) | Profile icache miss rate, branch density; consider PGO / code layout |
| `de_no_dispatch_per_slot.backend_stalls` | Backend can't accept new ops (load not complete, ROB/RS full, execution port pressure) | Drill into Backend.Memory vs Backend.CPU; check load-latency PMCs |
| `ex_no_retire.load_not_complete / ex_no_retire.not_complete` | Fraction of backend stalls caused by memory | If high → cache / TLB / prefetcher tuning; if low → execution-port bound |
| `ex_ret_brn_misp / ex_ret_brn` | Branch misprediction rate | High → look at hot indirect branches; consider `__builtin_expect`, BTB pressure |
| `op_cache_hit_miss.op_cache_miss` (0x28F u0x04) | Op-cache miss → fallback to decode pipeline | High → reduce hot footprint, avoid icache-thrashing inline asm |
| `l2_cache_req_stat.dc_hit_in_l2` vs `ls_rd_blk_c` | L2 DC hit rate from L1D miss path | Low → working set escapes L1D & L2; tune prefetchers, NT stores, cache blocking |
| `l2_pf_hit_l2.*` (0x70) | HW prefetcher accuracy (prefetched lines that landed) | Healthy non-zero → prefetcher engaged; zero → either useless prefetcher or workload not streaming |
| `l2_pf_miss_l2_hit_l3.*` (0x71) | Prefetched data took an L3 hit (still wasted L2 fill) | High → prefetcher running ahead of L3 residency; consider sw prefetch tuning |
| `l2_pf_miss_l2_l3.*` (0x72) | Prefetched line went all the way to DRAM | Most expensive miss path; if dominant, HW prefetcher is mostly waste |
| `ls_any_fills_from_sys.local_ccx` | Demand fill served from another L2 in same CCX | High → false sharing across SMT siblings or co-located cores |
| `ls_any_fills_from_sys.near_cache` | Cross-CCX (same NUMA) cache fill | High → cross-CCD migration, consider CCD pinning |
| `ls_any_fills_from_sys.dram_io_near` | Demand DRAM read in same NUMA | Memory-bandwidth bound; check BW counters on metal |
| `ls_any_fills_from_sys.remote_*` | Cross-socket fill | NUMA tuning needed |
| `bp_l1_tlb_miss_l2_tlb_miss.*` | TLB pressure → page walks | Try hugepages (2M / 1G); reduce working-set fragmentation |
| `amd_df/event=0x1F0F/` (cs_dispatch_action) and friends | Cross-CCD coherence traffic on the DF | Indicates whether scaling is bottlenecked at the fabric (metal only) |
| `amd_umc/event=0x00,umask=0x..` per UMC | Per-channel DRAM bandwidth | Skew across UMCs → unbalanced channel use |

### Mapping to the performance playbook

PerfSpect's grouped output is essentially a top-down tree:

```
Pipeline Utilization
├── Retiring                       ← ex_ret_ops / (ls_not_halted_cyc × N_slots)
├── Bad Speculation                ← (dispatched - retired) / Total_Slots
├── Frontend Bound                 ← de_no_dispatch_per_slot.no_ops_from_frontend / Total_Slots
└── Backend Bound                  ← de_no_dispatch_per_slot.backend_stalls / Total_Slots
    ├── Backend.Memory             × (load_not_complete / not_complete)
    │   ├── L1/L2/L3 hit-rate metrics (l2_cache_req_stat.*, l2_pf_*)
    │   ├── TLB metrics (bp_l1_tlb_miss_l2_tlb_miss.*, ls_dmnd_fills_from_sys.*)
    │   └── DRAM/UNC metrics (UMC PMU — metal only)
    └── Backend.CPU                × (1 - load_not_complete / not_complete)
        └── Execution-port pressure (per-port dispatch events)
```

N_slots = 6 on Zen4, **8 on Zen5**.

---

## 6. The S3-backed test workflow

Bucket: `amd-pmc-toolkit-pradeepn` (us-west-2). Versioning ON, public access blocked.

```
artifacts/                      ← reusable, read by every instance
  run_pmc.sh                    ← bootstrap wrapper; fetches mhammer + sweep, runs, uploads result
  mhammer.x86_64                ← static STREAM-style memory hammer (12-thread default)
  mhammer.c                     ← source
  l2pf_sweep.sh                 ← full 7-umask grid for 0x70/0x71/0x72
  l2pf_focus.sh                 ← 3-trial confirmation on 0x71/0x72 × 0x1F
  sweep_runner.sh               ← generic events.yaml runner (default)

results/aws/{instance-type}/{instance-id}/{YYYY-MM-DD}/{sweep}.txt
                                ← every run lands here, auto-segmented by IMDSv2 metadata

reports/                        ← versioned snapshots of the human-readable findings
  AWS_4WAY_MATRIX.md
  PERFSPECT_AWS_STATUS.md
  KNOWLEDGE_BASE.md             ← this file
  CLOUD_READINESS_PLAYBOOK.md
```

### IAM / permissions

- IAM **user** `claude-ssm-ruby` (this is "me from outside") — has `AmazonS3FullAccess`, `AmazonSSMFullAccess`. Used for uploading artifacts and dispatching SSM commands.
- Instance **role** `instanceRole` (this is "EC2 from inside") — has inline policy `amd-pmc-toolkit-rw`:
  - `s3:ListBucket`, `s3:GetBucketLocation` on the bucket
  - `s3:GetObject` on `artifacts/*`
  - `s3:PutObject`, `s3:PutObjectAcl` on `results/*`

### Bootstrap on a fresh instance

```bash
# One-time prerequisites (Ubuntu 24 AWS AMIs have no awscli in apt):
curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/aws.zip
sudo apt-get install -y unzip
unzip -qo /tmp/aws.zip -d /tmp/
sudo /tmp/aws/install --update

# Pull and run any sweep:
aws s3 cp s3://amd-pmc-toolkit-pradeepn/artifacts/run_pmc.sh /tmp/run_pmc.sh
chmod +x /tmp/run_pmc.sh
bash /tmp/run_pmc.sh l2pf_focus     # or l2pf_sweep, sweep_runner, etc
```

`run_pmc.sh` already uses IMDSv2 token-based metadata fetch (fixed 2026-05-25).

---

## 7. Extending to GCP and Azure (next big push)

The matrix is generation × hypervisor. We have AWS Nitro × {Zen4, Zen5} covered. The matrix entries to populate next are:

| CSP | Instance | CPU | Priority |
|---|---|---|---|
| GCP | c4d-standard-* | Zen5 Turin | **1st** — user has plan to spin once GCP access lands |
| GCP | c3d-standard-* | Zen4 Genoa | 2nd |
| Azure | HBv5 (HPC) | Zen4 Genoa-X | 3rd |
| Oracle | E6 | Zen5 | 4th |

### Repeatable sweep protocol (apply to any new CSP)

1. **Spin a partial-socket guest, a full-socket guest, and bare metal** (if offered). The partial vs full-socket axis is where every Nitro divergence lives — we expect the same pattern on KVM-based CSPs even though the filter set may differ.
2. **Install `linux-modules-extra-$(uname -r)`** (or distro equivalent) on metal and probe for L3/DF/UMC PMU appearance.
3. **Run `pmc_test/run_pmc.sh sweep_runner`** with the full `events.yaml`. Drop results into `s3://amd-pmc-toolkit-pradeepn/results/{csp}/...`.
4. **Run PerfSpect** with `intel/PerfSpect@main` and capture the 137-metric report. Diff the "metrics that returned zero" set against AWS to identify CSP-specific filters.
5. **Run the L2-PF focused sweep** (0x70/0x71/0x72 × {individual umasks, 0x1F}). This is where CSP filters diverge most cleanly.
6. **Diff against the public PPR baseline** — note any events documented in PPR Rev 5.0 that the CSP filters. These are the strongest "Asks for $CSP" candidates.

### Asks-template (per CSP)

After a sweep, the deliverable for the CSP team is shaped like our AWS asks list:

1. Lift the partial-socket filter on the `ls_*_fills_from_sys` family
2. Fix any perf-generic-name → raw-event mismatches
3. Document the metal uncore-PMU enablement one-liner in the official docs
4. Stretch: expose DF / UMC MSRs to full-socket guests

---

## 8. Common pitfalls — don't repeat these

- **Don't use raw `cpu/event=,umask=/` codes on Turin** — see §1.1. Use `perf list` names.
- **Don't assume Genoa ⇒ Turin filter behavior carries over** (the L2-PF matrix in §4b is the canonical counterexample).
- **Don't claim `amd_uncore.ko` is "missing from the AWS kernel"** — it ships in `linux-modules-extra-aws`, just not pre-installed.
- **Don't use Zen4's 6-slot dispatch in Zen5 formulas** (use 8). PerfSpect handles this; hand-rolled scripts must too.
- **Don't quote the old PERFSPECT_AWS_STATUS.md "58 broken" number** — it's stale.
- **Don't expect IMDS to work without an IMDSv2 token** in scripts (AWS Nitro requires the token preflight).
- **Don't conflate IAM user `claude-ssm-ruby` with the EC2 `instanceRole`** — they're two different identities with two different policy sets.

---

## 9. References & index of supporting docs

In repo:
- `pmc_test/csp_enablement/AWS_4WAY_MATRIX.md` — full m8a 4-way sweep with addendum on L2-PF
- `pmc_test/csp_enablement/PERFSPECT_AWS_STATUS.md` — superseded but kept for history
- `pmc_test/events.yaml` — sweep grid definition
- `pmc_test/csp_enablement/perfspect_aws_status.csv` — per-metric verdict + reason
- `pmc_test/cross_cpu_results/turin_matrix.csv` — raw BM-vs-AWS sweep, 838 rows
- `pmc_test/csp_enablement/csp_matrix.csv` — public-PPR-filtered cross-CSP view
- `CLAUDE.md` — toolkit project instructions (**TODO: update Zen5 slot count to 8**)

In auto-memory (cross-session):
- `aws_4way_pmc_matrix.md`
- `l2pf_nitro_filter.md`
- `zen5_only_pipeline_events.md`
- `public_vs_internal_ppr.md`
- `perfspect_turin_canonical.md`
- `pmc_table40_41_plan.md`

In S3 (`amd-pmc-toolkit-pradeepn/reports/`):
- This file (`KNOWLEDGE_BASE.md`)
- `CLOUD_READINESS_PLAYBOOK.md`
- `AWS_4WAY_MATRIX.md` (mirror of repo)
- `PERFSPECT_AWS_STATUS.md` (mirror)

External:
- `intel/PerfSpect@main` — `cmd/metrics/resources/legacy/events/x86_64/AuthenticAMD/turin.txt` + `turin.json`
- AMD PPR Rev 5.0 (BRH C1) — `~/Downloads/ppr_BRH_C1_pub_050_pprpdf`
- AMD PPR (Genoa B2 public) — `~/OneDrive/.../55898_B2_pub_070`
