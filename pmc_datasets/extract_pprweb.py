#!/usr/bin/env python3
"""
extract_pprweb.py — parse an AMD pprweb HTML build into three PMC datasets:
  * core PMC (FP + LS + IC/BP + DE + EX + L2)
  * L3   PMC
  * DF   PMC

Each event is extracted as:
  code, name, symbolic, category, description, instance, unit_masks[]

Usage:
  python3 extract_pprweb.py <pprweb_root_dir> <output_dir> <chip_label>

Example:
  python3 extract_pprweb.py /path/to/ppr_BRH_C1_int_050_pprweb ./BRH BRH
"""

import json
import re
import sys
from pathlib import Path
from bs4 import BeautifulSoup

# ---------------------------------------------------------------------------
# Category map for the Core chapter (2.1.21.5.1 .. 2.1.21.5.6)
#   anchor in header_2.html -> category short name
# ---------------------------------------------------------------------------
CORE_CATEGORY_ANCHORS = {
    "head_2_1_21_5_1": "FP",
    "head_2_1_21_5_2": "LS",
    "head_2_1_21_5_3": "IC_BP",
    "head_2_1_21_5_4": "DE",
    "head_2_1_21_5_5": "EX",
    "head_2_1_21_5_6": "L2",
}

# ---------------------------------------------------------------------------
# Title line pattern, e.g.
#   "PMCx000 [FP scheduler uop pipe assignment] (Core::X86::Pmc::Core::FPU_Pipe_Assignment)"
#   "L3PMCx01 [L3 Cache Accesses] (Core::X86::Pmc::L3::L3RequestG1)"
#   "DFPMCx00000[40...6C]0 [CCM REQQ_OCCPNCY Queue Occupancy] (DF::PMC::CCM::CCM_REQQ_OCCPNCY)"
# ---------------------------------------------------------------------------
TITLE_RE = re.compile(
    r'^\s*(?P<code>[A-Za-z0-9.\[\]_\-]+)\s+\[(?P<name>.+?)\]\s+\((?P<symbolic>[^)]+)\)\s*$'
)


def text(el):
    """Whitespace-collapsed text of a BeautifulSoup element."""
    if el is None:
        return ""
    return re.sub(r"\s+", " ", el.get_text(" ", strip=True)).strip()


# ---------------------------------------------------------------------------
# Build the category map from header_2.html
# ---------------------------------------------------------------------------
def parse_core_category_map(header2_path: Path) -> dict:
    """
    Returns: symbolic_name -> category short name (FP/LS/IC_BP/DE/EX/L2).
    Walks each <p class=header id=head_2_1_21_5_*> section and reads the
    PMC list that immediately follows it.
    """
    html = header2_path.read_text(encoding="utf-8", errors="replace")
    soup = BeautifulSoup(html, "html.parser")

    sym_to_cat = {}

    for anchor, cat in CORE_CATEGORY_ANCHORS.items():
        hdr = soup.find(id=anchor)
        if not hdr:
            print(f"WARN: header anchor {anchor} not found", file=sys.stderr)
            continue
        # Walk forward until we hit the next <p class=header ...> or end
        node = hdr
        while True:
            node = node.find_next_sibling()
            if node is None:
                break
            classes = node.get("class") or []
            if node.name == "p" and "header" in classes:
                break
            if node.name == "table":
                # Pull every event link out of this list-table
                for a in node.find_all("a"):
                    title_attr = a.get("title", "")
                    m = TITLE_RE.match(title_attr)
                    if m:
                        sym_to_cat[m.group("symbolic")] = cat
    return sym_to_cat


# ---------------------------------------------------------------------------
# Parse a single register detail HTML file into a list of event records.
# Each <table id=...> at top-level is one event.
# ---------------------------------------------------------------------------
def parse_detail_page(html_path: Path) -> list:
    html = html_path.read_text(encoding="utf-8", errors="replace")
    soup = BeautifulSoup(html, "html.parser")

    events = []
    # The interesting tables have an id (the symbolic short name) and a
    # <th data-id=rTl> title row.
    for table in soup.find_all("table"):
        tid = table.get("id")
        if not tid:
            continue
        title_th = table.find(attrs={"data-id": "rTl"})
        if not title_th:
            continue

        title_str = text(title_th).replace("JIRA", "").strip()
        m = TITLE_RE.match(title_str)
        if not m:
            # Some titles wrap awkwardly; try to recover from <a name=...>
            a = title_th.find("a")
            if a and a.get("title"):
                m = TITLE_RE.match(a["title"])
        if not m:
            continue

        code = m.group("code")
        name = m.group("name")
        symbolic = m.group("symbolic")

        # Description row
        desc_row = table.find(attrs={"data-id": "rDes"})
        description = text(desc_row) if desc_row else ""

        # Instance row
        inst_row = table.find(attrs={"data-id": "rInst"})
        instance = text(inst_row) if inst_row else ""

        # Per-bit UnitMask rows: <tr id="<symbolic_short>_<mnemonic>">
        unit_masks = []
        for tr in table.find_all("tr"):
            row_id = tr.get("id")
            if not row_id:
                continue
            ths = tr.find_all("th")
            tds = tr.find_all("td")
            if not ths or not tds:
                continue
            bit_label = text(ths[0])
            # Mnemonic is in the <b>...</b> of the td; description is the rest
            td = tds[0]
            b = td.find("b")
            if not b:
                continue
            mnemonic = text(b)
            # Description = td text minus the <b> mnemonic and minus "Read-write." attr.
            # BS' get_text(" ") inserts a space separator, so text typically starts with
            # "Mnemonic . Read-write. <real desc>" (note the inserted space before the dot).
            full = text(td)
            stripped = re.sub(r"^" + re.escape(mnemonic) + r"\s*\.?\s*", "", full)
            stripped = re.sub(r"^Read-write\.\s*", "", stripped)
            # Drop AMD-internal debug attrs (xc_pmc_type, si_validation_priority, amdonly_text)
            stripped = re.sub(r"\b(xc_pmc_type|si_validation_priority|amdonly_text)\s*:[^.]*\.\s*", "", stripped)
            # Trim any stray "Read-write." that appears mid-string
            stripped = re.sub(r"\s*Read-write\.\s*", " ", stripped).strip()
            unit_masks.append({
                "bit": bit_label,
                "mnemonic": mnemonic,
                "description": stripped.strip(),
            })

        events.append({
            "code": code,
            "name": name,
            "symbolic": symbolic,
            "description": description,
            "instance": instance,
            "unit_masks": unit_masks,
        })

    return events


# ---------------------------------------------------------------------------
# Walk a register namespace directory (skipping reglist.html).
# ---------------------------------------------------------------------------
def parse_namespace_dir(ns_dir: Path) -> list:
    events = []
    for f in sorted(ns_dir.glob("*.html")):
        if f.name == "reglist.html":
            continue
        events.extend(parse_detail_page(f))
    return events


# ---------------------------------------------------------------------------
# Markdown rendering
# ---------------------------------------------------------------------------
def render_markdown(events: list, title: str, chip: str, source_note: str) -> str:
    out = []
    out.append(f"# {chip} — {title}\n")
    out.append(f"_Source: {source_note}_\n")
    out.append(f"_Total events: {len(events)}_\n")
    out.append("")
    out.append("Events are listed in code order. Per-event, the table lists the UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.\n")
    out.append("")

    for ev in events:
        cat = ev.get("category", "")
        cat_str = f" — {cat}" if cat else ""
        out.append(f"## {ev['code']}{cat_str} — {ev['name']}\n")
        out.append(f"**Symbolic:** `{ev['symbolic']}`  ")
        if ev["instance"]:
            out.append(f"**Instance:** `{ev['instance']}`")
        out.append("")
        if ev["description"]:
            out.append(f"{ev['description']}\n")
        if ev["unit_masks"]:
            out.append("| Bit | Mnemonic | Description |")
            out.append("|-----|----------|-------------|")
            for um in ev["unit_masks"]:
                # Escape pipes inside descriptions
                d = um["description"].replace("|", "\\|")
                out.append(f"| {um['bit']} | `{um['mnemonic']}` | {d} |")
            out.append("")
        out.append("")
    return "\n".join(out)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    if len(sys.argv) != 4:
        print(__doc__)
        sys.exit(2)

    root = Path(sys.argv[1])
    out_dir = Path(sys.argv[2])
    chip = sys.argv[3]
    out_dir.mkdir(parents=True, exist_ok=True)

    header2 = root / "header" / "header_2.html"
    if not header2.exists():
        print(f"ERROR: {header2} not found", file=sys.stderr)
        sys.exit(1)

    sym_to_cat = parse_core_category_map(header2)
    print(f"Loaded {len(sym_to_cat)} core category mappings")

    # ----- CORE (Core_X86_Pmc_Core + Core_X86_Pmc_L2) -----
    core_events = []
    core_dir = root / "reg" / "Core_X86_Pmc_Core"
    l2_dir = root / "reg" / "Core_X86_Pmc_L2"
    if core_dir.is_dir():
        for ev in parse_namespace_dir(core_dir):
            ev["category"] = sym_to_cat.get(ev["symbolic"], "Core")
            core_events.append(ev)
    if l2_dir.is_dir():
        for ev in parse_namespace_dir(l2_dir):
            ev["category"] = sym_to_cat.get(ev["symbolic"], "L2")
            core_events.append(ev)
    core_events.sort(key=lambda e: e["code"])

    # ----- L3 -----
    l3_events = []
    l3_dir = root / "reg" / "Core_X86_Pmc_L3"
    if l3_dir.is_dir():
        for ev in parse_namespace_dir(l3_dir):
            ev["category"] = "L3"
            l3_events.append(ev)
    l3_events.sort(key=lambda e: e["code"])

    # ----- DF (every DF_PMC_* namespace) -----
    df_events = []
    for ns in sorted((root / "reg").glob("DF_PMC_*")):
        if not ns.is_dir():
            continue
        block = ns.name.split("DF_PMC_")[-1]
        for ev in parse_namespace_dir(ns):
            ev["category"] = f"DF/{block}"
            df_events.append(ev)
    df_events.sort(key=lambda e: e["code"])

    # ----- Write JSON + Markdown -----
    source_note = f"AMD pprweb build at {root.name}"
    datasets = [
        ("core", "Core PMC Events (FP / LS / IC+BP / DE / EX / L2)", core_events),
        ("l3",   "L3 PMC Events",                                    l3_events),
        ("df",   "Data Fabric PMC Events",                           df_events),
    ]
    for tag, title, events in datasets:
        json_path = out_dir / f"{chip}_pmc_{tag}.json"
        md_path = out_dir / f"{chip}_pmc_{tag}.md"
        payload = {
            "chip": chip,
            "source": str(root),
            "dataset": tag,
            "event_count": len(events),
            "events": events,
        }
        json_path.write_text(json.dumps(payload, indent=2, ensure_ascii=False))
        md_path.write_text(render_markdown(events, title, chip, source_note))
        print(f"  {tag:5s}: {len(events):4d} events  ->  {json_path.name}, {md_path.name}")

    print("Done.")


if __name__ == "__main__":
    main()
5s}: {len(events):4d} events  ->  {json_path.name}, {md_path.name}")

    print("Done.")


if __name__ == "__main__":
    main()
