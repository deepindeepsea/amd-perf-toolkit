#!/usr/bin/env python3
"""
render_csp_report.py — Generate per-CSP enablement reports (Markdown + HTML)
from csp_matrix.json. Each report is structured to be shippable as a vendor ask.

Usage:
    python3 render_csp_report.py              # render all CSPs in csp_matrix.json
    python3 render_csp_report.py aws_m8a      # render just one
"""
from __future__ import annotations
import json, sys, html
from pathlib import Path
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parent
MATRIX = ROOT / "csp_matrix.json"
OUT    = ROOT / "reports"

CSP_META = {
    "aws_m8a":     {"display":"AWS m8a (Turin)",     "instance":"m8a.* (EPYC Turin)",
                    "hypervisor":"AWS Nitro",
                    "contact":"AWS EC2 support / Annapurna Labs"},
    "gcp_c4a":     {"display":"GCP Turin shapes",    "instance":"C4A / C3D / N4 (EPYC Turin)",
                    "hypervisor":"KVM (gVisor for serverless)",
                    "contact":"GCP Compute Engine support"},
    "azure_hbv5":  {"display":"Azure Turin shapes",  "instance":"HBv5 / Dasv6 (EPYC Turin)",
                    "hypervisor":"Hyper-V",
                    "contact":"Azure HPC / Azure Compute partner team"},
    "oci_e6":      {"display":"OCI E6 (Turin)",      "instance":"E6.Standard.* (EPYC Turin)",
                    "hypervisor":"OCI bare-metal / virt mix",
                    "contact":"OCI Compute support"},
    "bare_metal_turin": {"display":"Bare-Metal Turin", "instance":"AMD EPYC 9755 reference",
                    "hypervisor":"none",
                    "contact":"internal reference"},
}

def render_md(csp: str, mtx: dict) -> str:
    rows = mtx["rows"]
    s = mtx["summary"]["csps"][csp]
    meta = CSP_META.get(csp, {"display":csp,"instance":"unknown","hypervisor":"unknown","contact":""})
    total = mtx["summary"]["total_tuples"]
    bm = mtx["summary"]["csps"]["bare_metal_turin"]

    lines = []
    P = lines.append
    P(f"# PMC Enablement Report — {meta['display']}")
    P("")
    P(f"_Generated {datetime.now(timezone.utc):%Y-%m-%d %H:%M UTC} from `csp_matrix.json`_")
    P("")
    P(f"**Instance class:** {meta['instance']}  ")
    P(f"**Hypervisor:** {meta['hypervisor']}  ")
    P(f"**Vendor contact:** {meta['contact']}  ")
    P(f"**Scope:** Public Turin PPR (C1_pub_050) — {total} (event, umask) tuples")
    P("")
    P("## Headline")
    P("")
    P(f"| Status | Count | % of public PPR | Notes |")
    P(f"|---|---:|---:|---|")
    P(f"| **Supported (verified non-zero)** | {s['supported']} | {100*s['supported']/total:.0f}% | tuples that program AND produce signal |")
    P(f"| **BLOCKED by hypervisor** | **{s['blocked']}** | {100*s['blocked']/total:.0f}% | works on BM, silently returns zero on this CSP — gap to escalate |")
    P(f"| Zero-no-signal | {s['zero_no_signal']} | {100*s['zero_no_signal']/total:.0f}% | event legal, our workloads didn't exercise it |")
    P(f"| Untested | {s['untested']} | {100*s['untested']/total:.0f}% | per-bit umask not yet probed |")
    P("")
    P(f"BM-Turin reference: {bm['supported']} supported / {bm['zero_no_signal']} no-signal / {bm['untested']} untested.")
    P(f"This CSP exposes **{100*s['supported']/max(bm['supported'],1):.0f}% of BM-verified events** to guest workloads.")
    P("")

    if s['blocked']:
        P("## Events to Enable (P0/P1 first, then P2)")
        P("")
        P("These tuples are documented in the public BRH PPR and verified on bare-metal Turin, "
          "but return zero on this CSP — hypervisor PMC filtering blocks them. Listed by severity.")
        P("")
        for sev in ("P0","P1","P2"):
            blk = [r for r in rows if r[csp] == "B" and r["severity"] == sev]
            if not blk: continue
            P(f"### {sev} — {len(blk)} blocked")
            P("")
            P("| PMC | Event | Umask | PPR Name | Used by PerfSpect |")
            P("|---|---|---|---|:---:|")
            for r in sorted(blk, key=lambda x: (x['code'], x['umask'])):
                P(f"| {r['code']} | {r['event']} | {r['umask']} | {html.escape(r['ppr_name'])} | {r['perfspect_uses']} |")
            P("")

    P("## Events Supported (Verified Non-Zero)")
    P("")
    sup = [r for r in rows if r[csp] == "Y"]
    if sup:
        from collections import defaultdict
        by_code = defaultdict(list)
        for r in sup: by_code[r['code']].append(r)
        P("| PMC | PPR Name | Working umasks |")
        P("|---|---|---|")
        for code in sorted(by_code):
            lst = by_code[code]
            masks = ", ".join(r['umask'] for r in lst)
            P(f"| {code} | {html.escape(lst[0]['ppr_name'])} | {masks} |")
        P("")

    P("## Severity Legend")
    P("")
    P("- **P0** — Required for AMD's BRH Pipeline-Utilization (top-down) model. "
      "Blocking these breaks tier-1 performance methodology.")
    P("- **P1** — Used by upstream OSS tooling (PerfSpect, Linux perf metric groups, "
      "RHEL/Ubuntu pmu-tools). Blocking these breaks community observability.")
    P("- **P2** — Documented in the public PPR but not on the critical path of "
      "any known major tool. Lower priority.")
    P("")
    P("## State Legend")
    P("")
    P("- **Y** — Programmable AND returns non-zero on at least one well-known workload")
    P("- **B** — Programmable on bare metal but returns 0 on this CSP (hypervisor filter)")
    P("- **Z** — Programmable but our workload mix didn't trigger it (no information)")
    P("- **?** — Not yet probed in the current sweep")
    return "\n".join(lines)

def render_html(csp: str, md_body: str) -> str:
    # very small Markdown-ish to HTML, just for self-contained shipping
    rows_lines = md_body.split('\n')
    out = ['<!doctype html><html><head><meta charset="utf-8">',
           f'<title>PMC Enablement — {csp}</title>',
           '<style>',
           'body{font-family:-apple-system,Segoe UI,sans-serif;max-width:1100px;'
           'margin:32px auto;padding:0 20px;line-height:1.5;color:#222;}',
           'h1{border-bottom:2px solid #C2233F;padding-bottom:6px;}',
           'h2{margin-top:1.6em;color:#23272F;}',
           'table{border-collapse:collapse;margin:12px 0;font-size:0.92em;}',
           'th,td{border:1px solid #d0d0d0;padding:6px 10px;text-align:left;}',
           'th{background:#f4f4f6;}',
           'code{background:#f3f3f5;padding:1px 4px;border-radius:3px;}',
           'tr:nth-child(even){background:#fafafa;}',
           '</style></head><body>']
    in_table = False
    for ln in rows_lines:
        if ln.startswith('# '):    out.append(f"<h1>{html.escape(ln[2:])}</h1>")
        elif ln.startswith('## '): out.append(f"<h2>{html.escape(ln[3:])}</h2>")
        elif ln.startswith('### '):out.append(f"<h3>{html.escape(ln[4:])}</h3>")
        elif ln.startswith('|') and '---' in ln:
            continue  # table separator
        elif ln.startswith('|'):
            cells = [c.strip() for c in ln.strip('|').split('|')]
            tag = 'th' if not in_table else 'td'
            if not in_table:
                out.append("<table><tr>" + "".join(f"<th>{c}</th>" for c in cells) + "</tr>")
                in_table = True
            else:
                out.append("<tr>" + "".join(f"<td>{c}</td>" for c in cells) + "</tr>")
        else:
            if in_table:
                out.append("</table>"); in_table = False
            if ln.strip():
                # bold **xxx**
                import re as _re
                ln_html = _re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', html.escape(ln))
                out.append(f"<p>{ln_html}</p>")
    if in_table: out.append("</table>")
    out.append("</body></html>")
    return "\n".join(out)

def main():
    mtx = json.loads(MATRIX.read_text())
    csps = sys.argv[1:] or list(CSP_META.keys())
    OUT.mkdir(exist_ok=True)
    for csp in csps:
        if csp not in mtx["summary"]["csps"]:
            print(f"  skip {csp}: not in matrix"); continue
        md = render_md(csp, mtx)
        (OUT/f"{csp}.md").write_text(md)
        (OUT/f"{csp}.html").write_text(render_html(csp, md))
        s = mtx["summary"]["csps"][csp]
        print(f"  rendered {csp}: supported={s['supported']} blocked={s['blocked']} "
              f"-> reports/{csp}.{{md,html}}")

if __name__ == "__main__":
    main()
