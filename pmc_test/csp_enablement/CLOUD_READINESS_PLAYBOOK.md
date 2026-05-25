# Cloud Readiness Playbook — adding a new CSP to the PMC matrix

**Use this when:** you've just gotten access to GCP / Azure / Oracle / OCI / IBM Cloud and need to characterize AMD EPYC PMC support there.

This playbook is hypervisor-agnostic. Every CSP we've tested differs in *which* events are filtered, but the *shape* of the divergence is the same — partial-socket guest hides things that full-socket / metal guest exposes.

## Pre-flight checklist (before spinning anything)

- [ ] You have IAM / billing for the CSP
- [ ] You know how to attach an instance role with object-storage write permission (so results upload directly to S3 / GCS / Azure Blob)
- [ ] You have the public AMD PPR for the target generation (Zen4 Genoa = 55898 B2, Zen5 Turin = BRH C1 050)
- [ ] You have the latest `events.yaml` from this repo
- [ ] (NDA PPR is staying internal; do not put NDA-only events into anything that leaves AMD)

## Phase 1 — minimum-viable sweep

Three instances per generation. Skip any one only if the CSP doesn't offer it.

1. **Partial-socket guest** — smallest reasonable instance (e.g. m8a.2xl analogue). Catches the partial-socket Nitro-style filter.
2. **Full-socket guest** — instance that fills exactly one socket (e.g. m8a.24xl analogue). Catches mid-tier filters that don't apply at full-socket scale.
3. **Bare metal** — full uncore stack reference. Always do `linux-modules-extra-$(uname -r)` (or distro equivalent) and `modprobe amd_uncore` first.

On each: install awscli (for S3 upload), pull `s3://amd-pmc-toolkit-pradeepn/artifacts/run_pmc.sh`, run `bash run_pmc.sh sweep_runner`.

> **Note:** `run_pmc.sh` uses AWS IMDSv2 for instance-id / instance-type. For GCP and Azure, fork the script to use their respective metadata endpoints:
> - GCP: `curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/...`
> - Azure: `curl -H "Metadata: true" http://169.254.169.254/metadata/instance?api-version=2021-02-01`

## Phase 2 — focused sweeps

After the generic sweep finishes, run these to characterize the hypervisor's filter shape:

| Sweep | What it measures | Why |
|---|---|---|
| `l2pf_sweep.sh` | All 7 umask values × 0x70/0x71/0x72 | L2 prefetch filter — most differentiated between hypervisors |
| `l2pf_focus.sh` | 3-trial confirmation 0x71/0x72 × 0x1F | Partial-socket DRAM-prefetch detection |
| `ls_fills_sweep.sh` (to be built) | All `ls_*_fills_from_sys.*` umasks | The AWS Nitro 9-event filter family — does new CSP do the same? |
| PerfSpect end-to-end | All 137 Turin metrics / ~145 Genoa metrics | Which canonical metrics return zero? |

## Phase 3 — analysis & deliverables

For each new CSP, produce these outputs (mirror the AWS structure):

1. **`{CSP}_4WAY_MATRIX.md`** — instance-tier-by-event grid, same shape as `AWS_4WAY_MATRIX.md`
2. **`PERFSPECT_{CSP}_STATUS.md`** — per-metric verdict (works / broken / needs-probe) on each instance tier
3. **`{csp}_asks.md`** — list of asks for the CSP team, citing **only public-PPR events**

## Phase 4 — fold into knowledge base

Update:
- `pmc_test/csp_enablement/KNOWLEDGE_BASE.md` §2 (instance inventory) and §4 (matrix tables)
- `pmc_test/csp_enablement/csp_matrix.csv` — add CSP columns
- Auto-memory: new `gcp_matrix.md` / `azure_matrix.md` files + MEMORY.md pointers
- S3 `reports/` — upload mirror of the new docs

## CSP-specific notes (collected as we go)

### GCP (C4D / C3D) — not yet tested

- C4D = Zen5 Turin, C3D = Zen4 Genoa
- Hypervisor is gVisor for some, KVM for others — needs confirmation per family
- Need to check if GCP exposes `--enable-nested-virtualization` style flag that affects PMC
- Object storage equivalent: GCS bucket; `gsutil cp` or `gcloud storage cp`

### Azure (HBv5) — not yet tested

- HBv5 = Zen4 Genoa-X (3D V-Cache). HPC-oriented; likely full-socket bare-metal-ish exposure
- Hypervisor: Azure Hyper-V; historically more PMC-friendly than KVM but verify
- Object storage equivalent: Azure Blob with `az storage blob upload`

### Oracle (E6) — not yet tested

- E6 = Zen5 Turin
- Oracle has historically passed through more PMCs than AWS in standard tiers

## Asks-template for a new CSP

```markdown
# Asks for {CSP} {generation} — PMC enablement

Based on PMC sweep run YYYY-MM-DD on {instances tested}, we observed these gaps
against the public AMD PPR Rev {N} for {family}. All events cited below are
documented in the public PPR.

1. **Documentation:** call out `{distro equivalent of linux-modules-extra}` as
   the one-line uncore-PMU unlock on .metal in your AMI guide.

2. **Lift partial-socket filter on demand-fill family:**
   - `ls_dmnd_fills_from_sys.{umasks}`
   - `ls_any_fills_from_sys.{umasks}`
   These are programmable on full-socket and metal but return zero on partial-socket guests.

3. **Fix perf-generic event mapping:** `iTLB-load-misses` returns zero on
   partial-socket; the raw `bp_l1_tlb_miss_l2_tlb_miss.all` works. Indicates a
   perf wrapper / topology issue, not a hypervisor filter.

4. **Stretch:** expose uncore MSRs (especially DF / UMC) to full-socket guests
   so memory-bandwidth metrics work without going to .metal.
```

Replace `{CSP}` and concrete event names per sweep.
