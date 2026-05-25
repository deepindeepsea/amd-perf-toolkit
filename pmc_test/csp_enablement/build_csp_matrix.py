#!/usr/bin/env python3
"""
build_csp_matrix.py — Build the cross-CSP PMC enablement matrix.

Source of truth = `cross_cpu_results/public_ppr_coverage.csv` (one row per
public-PPR (event, umask) tuple, with bm_ok + aws_ok from the existing sweep).

This script:
  1. Loads the public PPR coverage rows.
  2. Annotates each row with PerfSpect-Turin usage (does perf-list / upstream
     tooling reference this exact (event, umask) tuple?).
  3. Tags each row with a severity tier (P0/P1/P2) based on which AMD-internal
     metric model (Pipeline Utilization, cache analysis, branch, etc.) depends
     on the tuple.
  4. Emits `csp_matrix.csv` — one row per tuple, one column per CSP. AWS_m8a
     is populated from the sweep. GCP/Azure/OCI columns are placeholder
     "untested" until those sweeps land.
  5. Writes `csp_matrix.json` — same data in a structured form, ready for
     report rendering.

Re-run any time the public_ppr_coverage.csv or any CSP raw/<csp>.csv is updated.
"""
from __future__ import annotations
import csv, json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
SRC_COVERAGE = REPO / "pmc_test" / "cross_cpu_results" / "public_ppr_coverage.csv"
SRC_PERFSPECT = REPO / "perfspect_genoa_metrics.json"
PUBLIC_PPR    = REPO / "pmc_datasets" / "BRH_public" / "BRH_pmc_public.json"

CSPS = ["bare_metal_turin", "aws_m8a", "gcp_c4a", "azure_hbv5", "oci_e6"]

# Map a tuple → severity tier
# P0: critical to BRH Pipeline-Utilization top-down model
# P1: used by upstream OSS perf metric groups
# P2: documented but not on the critical path of any known tool
SEVERITY_RULES = {
    # P0 — BRH Table 58 Pipeline-Utilization slot-account model (Zen5)
    (0x1A0, 0x01): "P0",  # de_no_dispatch_per_slot.no_ops_from_frontend
    (0x1A0, 0x1E): "P0",  # de_no_dispatch_per_slot.backend_stalls
    (0x1A0, 0x60): "P0",  # de_no_dispatch_per_slot.smt_contention
    (0x1A2, 0x30): "P0",  # de_no_dispatch_for_smt
    (0x1C2, None): "P0",  # ops_retired (Zen5 variant)
    (0xAA,  0x07): "P0",  # de_src_op_disp.all
    (0xC1,  None): "P0",  # ops_retired (Zen4-compat)
    (0xC2,  None): "P0",  # retired branches (top-down BadSpec)
    (0xC3,  None): "P0",  # retired branch mispredict
    (0xD6,  0x02): "P0",  # ex_no_retire.not_complete
    (0xD6,  0xA2): "P0",  # ex_no_retire.load_not_complete
    (0x76,  None): "P0",  # cycles not halted

    # P1 — PerfSpect metric groups (cache, branch, TLB, FP)
    (0x29,  0x07): "P1",  # ls_dispatch.any
    (0x60,  0x10): "P1",  # l2_request_g1.cacheable_ic_read
    (0x60,  0xE0): "P1",  # l2_request_g1.all_dc
    (0x60,  0xF1): "P1",  # l2_request_g1.all_no_prefetch
    (0x64,  0x01): "P1",  # l2_cache_req_stat.ic_fill_miss
    (0x70,  0x1F): "P1",  # l2_pf_hit_l2.all
    (0x71,  0x1F): "P1",  # l2_pf_miss_l2_hit_l3.all
    (0x72,  0x1F): "P1",  # l2_pf_miss_l2_l3.all
    (0x45,  None): "P1",  # L1 DTLB reloads
    (0x85,  None): "P1",  # L1 ITLB Miss, L2 ITLB Miss
    (0x94,  None): "P1",  # ITLB instruction fetch hits
}

def severity_for(ev_int: int, um_int: int | None) -> str:
    if (ev_int, um_int) in SEVERITY_RULES:
        return SEVERITY_RULES[(ev_int, um_int)]
    # event-only match for tuples we tagged P0/P1 with umask=None
    if (ev_int, None) in SEVERITY_RULES and um_int is None:
        return SEVERITY_RULES[(ev_int, None)]
    return "P2"

def load_perfspect_usage():
    """Build set of (event_int, umask_int) used by upstream PerfSpect-Turin."""
    diff = REPO / "pmc_test" / "cross_cpu_results" / "perfspect_vs_ppr_turin_diff.json"
    used = set()
    try:
        data = json.loads(diff.read_text())
        # The "in_both" block lists what PerfSpect uses that's also in PPR
        for name, rec in data.get("in_both", {}).items():
            ev = int(rec["event"], 16)
            um_s = rec.get("umask")
            um = int(um_s, 16) if um_s and um_s != "None" else None
            used.add((ev, um))
    except Exception:
        pass
    return used

def main():
    perfspect = load_perfspect_usage()
    out_rows = []
    coverage_rows = list(csv.DictReader(open(SRC_COVERAGE)))
    print(f"loaded {len(coverage_rows)} public-PPR tuples from {SRC_COVERAGE.name}")
    print(f"perfspect-tagged (in_both) tuples: {len(perfspect)}")

    # Load the source matrix to get the classification (NITRO_FILTERED vs ZERO_BOTH)
    src_matrix = REPO / "pmc_test" / "cross_cpu_results" / "turin_matrix.csv"
    class_by_key = {}
    for r in csv.DictReader(open(src_matrix)):
        m = re.search(r'event=0x([0-9a-fA-F]+)(?:,umask=0x([0-9a-fA-F]+))?', r["event"])
        if not m: continue
        ev = int(m.group(1), 16)
        um = int(m.group(2), 16) if m.group(2) else None
        class_by_key[(ev, um)] = r["classification"]

    # State legend (used per-CSP column):
    #   Y = supported & verified non-zero
    #   B = BLOCKED by hypervisor (works on BM, returns zero on cloud)
    #   Z = programmable but zero (workload didn't exercise it)
    #   ? = untested
    def csp_state(ev, um, csp, bm_ok, cloud_ok):
        if csp == "bare_metal_turin":
            if bm_ok: return "Y"
            cls = class_by_key.get((ev, um), "")
            return "Z" if "ZERO" in cls else "?"
        if csp == "aws_m8a":
            if cloud_ok: return "Y"
            cls = class_by_key.get((ev, um), "")
            if "NITRO_FILTERED" in cls: return "B"
            if "ZERO_BOTH" in cls:      return "Z"
            return "?"
        return "?"  # GCP/Azure/OCI not yet swept

    for r in coverage_rows:
        ev_int = int(r["event"], 16)
        um_str = r["umask"]
        um_int = int(um_str, 16) if um_str and um_str != "-" else None
        used_by_perfspect = (ev_int, um_int) in perfspect or (ev_int, None) in perfspect
        sev = severity_for(ev_int, um_int)
        bm_ok    = r["bm_ok"] == "True"
        cloud_ok = r["aws_ok"] == "True"
        row = {
            "code":      r["code"],
            "ppr_name":  r["ppr_name"],
            "symbolic":  r["symbolic"],
            "event":     r["event"],
            "umask":     r["umask"],
            "severity":  sev,
            "perfspect_uses": "Y" if used_by_perfspect else "N",
            "bare_metal_turin": csp_state(ev_int, um_int, "bare_metal_turin", bm_ok, cloud_ok),
            "aws_m8a":          csp_state(ev_int, um_int, "aws_m8a", bm_ok, cloud_ok),
            "gcp_c4a":   "?",
            "azure_hbv5":"?",
            "oci_e6":    "?",
            "matrix_src": r["matrix_src"],
        }
        out_rows.append(row)

    out_csv = ROOT / "csp_matrix.csv"
    with open(out_csv, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(out_rows[0].keys()))
        w.writeheader(); w.writerows(out_rows)
    print(f"wrote {out_csv}  ({len(out_rows)} rows)")

    # Per-CSP summary
    summary = {"csps": {}}
    for csp in CSPS:
        sup    = sum(1 for r in out_rows if r[csp] == "Y")
        blk    = sum(1 for r in out_rows if r[csp] == "B")
        zero   = sum(1 for r in out_rows if r[csp] == "Z")
        unk    = sum(1 for r in out_rows if r[csp] == "?")
        p0_bl  = sum(1 for r in out_rows if r[csp] == "B" and r["severity"] == "P0")
        p1_bl  = sum(1 for r in out_rows if r[csp] == "B" and r["severity"] == "P1")
        summary["csps"][csp] = {
            "supported": sup, "blocked": blk, "zero_no_signal": zero, "untested": unk,
            "p0_blocked": p0_bl, "p1_blocked": p1_bl,
        }
    summary["total_tuples"] = len(out_rows)
    summary["public_ppr_events"] = json.load(open(PUBLIC_PPR))["event_count"]
    (ROOT/"csp_matrix.json").write_text(json.dumps({"summary":summary,"rows":out_rows}, indent=2))
    print(f"wrote {ROOT/'csp_matrix.json'}")

    print("\n=== Per-CSP support tier (of 223 public-PPR tuples) ===")
    print(f"  {'CSP':20s} {'Y(work)':>8} {'B(blocked)':>10} {'Z(no-sig)':>10} {'?(untested)':>11} {'P0blk':>5} {'P1blk':>5}")
    for csp, d in summary["csps"].items():
        print(f"  {csp:20s} {d['supported']:>8} {d['blocked']:>10} "
              f"{d['zero_no_signal']:>10} {d['untested']:>11} {d['p0_blocked']:>5} {d['p1_blocked']:>5}")

if __name__ == "__main__":
    main()
