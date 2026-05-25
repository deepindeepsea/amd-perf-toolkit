# PMC Enablement across CSPs

End-to-end harness and reporting for "which AMD Turin (Zen5) Performance
Monitoring Counters are tappable inside each cloud guest." The deliverable
is a per-CSP report that lists every public-PPR event the CSP's hypervisor
blocks, with severity tagging, ready to hand to the CSP partner engineer.

## Scope

- **Catalog:** Public Turin PPR (BRH C1_pub_050) — 81 core events / 223
  (event, umask) tuples / 3 L3 events. We deliberately use the *public* PPR
  as the surface so the ask is defendable: "AMD publicly documents this
  event; please don't filter it."
- **Baselines:**
  - Bare-metal Turin (EPYC 9755) — the source of truth for "works on Zen5"
  - AWS m8a (currently the most permissive CSP)
- **CSPs to add later:** GCP C4A/C3D, Azure HBv5/Dasv6, Oracle OCI E6
- **Out of scope:** L3 PMCs and Data Fabric PMCs (already known-blocked on
  every CSP) and internal-PPR-only umasks (not defensible as a public ask).

## Pipeline

```
                         pmc_test/cross_cpu_results/turin_matrix.csv
                                          │  (838 raw codes, BM + AWS)
                                          ▼
                         public_ppr_coverage.csv     (project onto 223 tuples)
                                          │
                  ┌───────────────────────┼───────────────────────┐
                  ▼                       ▼                       ▼
         csp_enablement/raw/aws_m8a.csv  …gcp_c4a.csv      …azure_hbv5.csv
                  │                       │                       │
                  └──────► build_csp_matrix.py ◄──────────────────┘
                                          │
                                          ▼
                               csp_enablement/csp_matrix.{csv,json}
                                          │
                                          ▼
                              render_csp_report.py
                                          │
                          ┌───────────────┼────────────────┐
                          ▼               ▼                ▼
                  reports/aws_m8a.md   …gcp_c4a.md    …azure_hbv5.md
                          + .html         + .html         + .html
```

## Files

### Knowledge base (start here)

| File | Purpose |
|---|---|
| `KNOWLEDGE_BASE.md` | **Master single-source-of-truth.** Headline truths, instance inventory, full PMC matrix, per-event diagnosis map, S3 workflow, common pitfalls. Read first. |
| `CLOUD_READINESS_PLAYBOOK.md` | Hypervisor-agnostic protocol for adding a new CSP (GCP / Azure / Oracle) to the matrix. Phase 1–4 + per-CSP notes + asks template. |
| `AWS_4WAY_MATRIX.md` | Full m8a 2xl/24xl/metal/on-prem sweep with the L2-PF addendum. |
| `PERFSPECT_AWS_STATUS.md` | Superseded (banner inside points to KB). Kept for history. |

### Sweep tooling (uploaded to S3 `artifacts/`, mirrored here for GitHub)

| File | Purpose |
|---|---|
| `run_pmc.sh` | Bootstrap wrapper run on any EC2 instance. Pulls `mhammer.x86_64` + named sweep script from S3, runs it, uploads result back to `s3://amd-pmc-toolkit-pradeepn/results/aws/{type}/{iid}/{date}/{sweep}.txt`. Uses IMDSv2. |
| `sweep_runner.sh` | Generic events.yaml sweep runner (the default sweep `run_pmc.sh` invokes). |
| `l2pf_sweep.sh` | Full 7-umask grid for L2 prefetch events 0x70/0x71/0x72. |
| `l2pf_focus.sh` | 3-trial confirmation sweep on 0x71/0x72 × 0x1F composite. |
| `mhammer.c` | STREAM-style memory hammer used as the workload under the L2-PF sweeps. Build static: `gcc -O2 -pthread -static -o mhammer.x86_64 mhammer.c`. |

### Matrix builders

| File | Purpose |
|---|---|
| `build_csp_matrix.py` | Builds `csp_matrix.{csv,json}` from `public_ppr_coverage.csv` + per-CSP raw sweeps; tags severity + PerfSpect usage |
| `render_csp_report.py` | Renders one Markdown + HTML report per CSP from `csp_matrix.json` |
| `csp_matrix.csv` | Wide table: one row per (event, umask), one column per CSP |
| `csp_matrix.json` | Same data, structured + per-CSP summary stats |
| `reports/<csp>.md` | Per-CSP enablement report (vendor-facing) |
| `reports/<csp>.html` | Self-contained HTML rendering of the same |
| `raw/<csp>.csv` | (placeholder) Raw sweep output per CSP — populated when that CSP is swept |

## S3 persistence layer

Reusable artifacts and per-instance results live in **`s3://amd-pmc-toolkit-pradeepn`** (us-west-2, versioning ON). Survives instance termination. See KNOWLEDGE_BASE.md §6 for the layout and `s3_pmc_toolkit_bucket.md` in auto-memory for IAM details.

Quick pull from any computer with AWS creds:
```bash
aws s3 ls s3://amd-pmc-toolkit-pradeepn/
aws s3 sync s3://amd-pmc-toolkit-pradeepn/results/ ./results/   # mirror all sweep results
aws s3 cp s3://amd-pmc-toolkit-pradeepn/reports/KNOWLEDGE_BASE.md .
```

## State legend (per-CSP columns)

| State | Meaning |
|:---:|---|
| `Y` | Programmable AND verified non-zero on at least one well-known workload |
| `B` | Programmable on bare metal but returns zero on this CSP → **hypervisor blocked** |
| `Z` | Programmable but the current workload mix didn't trigger it (no information either way) |
| `?` | Not yet probed in the current sweep |

## Severity tiers

| Tier | Meaning |
|:---:|---|
| `P0` | Required for AMD's BRH Pipeline-Utilization (top-down) model — blocking breaks tier-1 perf methodology |
| `P1` | Used by upstream OSS tooling (PerfSpect, Linux perf metric groups, pmu-tools) |
| `P2` | Documented in public PPR but not on the critical path of major tools today |

## Extending to a new CSP (GCP / Azure / Oracle)

The harness is CSP-agnostic. To add a new cloud:

1. **Provision** a Turin guest on the target CSP (≥ 8 vCPU, root or sudo
   access to `perf stat`, recent Linux kernel — 6.10+ ideal for full Zen5
   event coverage).
2. **Sync** the `pmc_test/` directory to the guest (`rsync` or `scp`).
3. **Run the existing sweep** — same harness that produced `turin_matrix.csv`:
   ```
   cd pmc_test
   make events                                          # build perf event list
   python3 run_pmc_test.py --mode all --workloads all \
       --output cross_cpu_results/<csp>_matrix.csv
   ```
   Output: one row per (event, umask), with `bm_value` left blank (the new
   CSP is *this* host) and `csp_value` plus `csp_ok`.
4. **Project** onto public PPR:
   ```
   python3 cross_cpu_results/project_pub_ppr.py --csp <csp>
   ```
5. **Add the CSP column** to `build_csp_matrix.py`'s `CSPS` list and
   `CSP_META` block (display name, hypervisor, contact).
6. **Regenerate** matrix + reports:
   ```
   cd csp_enablement
   python3 build_csp_matrix.py
   python3 render_csp_report.py <csp>
   ```

## Expected results per CSP

Based on prior reporting and AMD field experience:

| CSP | Expected support | Notes |
|---|---|---|
| **AWS** (m8a) | Best — ~22% of public PPR tuples confirmed today | Nitro filters specific perfctr ranges but allows the bulk |
| **GCP** (C4A) | Very good — most events expected to work | KVM-based, GCP historically permissive on PMCs |
| **Azure** (HBv5) | None by default | Hyper-V hides PMU from guests; needs explicit enablement |
| **Oracle** (OCI E6) | None by default | Same as Azure pattern |

The reports will quantify this exactly once each sweep lands.

## Reproducing this work end-to-end

```
# 1. Public PPR catalog (already in repo at pmc_datasets/BRH_public/)
# 2. Existing BM + AWS sweep:
ls pmc_test/cross_cpu_results/turin_matrix.csv
# 3. Project onto public PPR (already done):
ls pmc_test/cross_cpu_results/public_ppr_coverage.csv
# 4. Build the CSP matrix (run after any new CSP sweep):
python3 pmc_test/csp_enablement/build_csp_matrix.py
# 5. Render the per-CSP reports:
python3 pmc_test/csp_enablement/render_csp_report.py
ls pmc_test/csp_enablement/reports/
```
