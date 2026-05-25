#!/usr/bin/env python3
"""
extract_ppr_pdf.py — parse an AMD PPR PDF volume into PMC event datasets.

Produces the same schema as extract_pprweb.py so the outputs from HTML-based
pprweb builds and PDF-based PPR releases can be diffed cleanly.

Per-event record:
    code, name, symbolic, category, description, instance, unit_masks[]
where unit_masks[i] = {bit, mnemonic, description}.

Usage:
    python3 extract_ppr_pdf.py <pdf_path> <first_page> <last_page> \
                               <chip_label> <dataset> <out_dir> [--source NOTE]

  <dataset>   one of: core | l3 | df
  Pages are 1-based, inclusive.

Examples:
    # Core PMC (Vol 1, sect 2.1.20.5)
    python3 extract_ppr_pdf.py ppr_RS_B2_nda_1.pdf 314 341 Genoa core ./Genoa

    # L3 PMC (Vol 1, sect 2.1.20.6)
    python3 extract_ppr_pdf.py ppr_RS_B2_nda_1.pdf 342 344 Genoa l3 ./Genoa

    # DF PMC (Vol 5, sect 11.9.2)
    python3 extract_ppr_pdf.py ppr_RS_B2_nda_5.pdf  99 382 Genoa df  ./Genoa
"""

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Recognised symbolic prefixes per dataset
# ---------------------------------------------------------------------------
SYM_PREFIX = {
    "core": ("Core::X86::Pmc::Core::", "Core::X86::Pmc::L2::"),  # L2 events live under section 2.1.20.5.6 Core chapter
    "l3":   ("Core::X86::Pmc::L3::",),
    "df":   ("DF::PMC::",),
}

# Title line:
#    "PMCx0XX [Name] (Core::X86::Pmc::Core::Symbolic)"
#    "L3PMCx04 [L3 tag lookup state] (Core::X86::Pmc::L3::L3LookupState)"
#    "DFPMCx00000[B5...D1]F [CAKE DATA_BW Data Bandwidth] (DF::PMC::CAKE::CAKE_DATA_BW)"
TITLE_RE = re.compile(
    r'^\s*(?P<code>(?:L3|DF)?PMCx[0-9A-Fa-fx\[\]\.,_]+)\s+\[(?P<name>.+?)\]\s+\((?P<symbolic>[^)]+)\)\s*$'
)

# Core section markers (2.1.20.5.X)
CORE_SECTION_RE = re.compile(
    r'^\s*2\.1\.20\.5\.(\d)\s+(.+)$'
)
CORE_SECTION_CAT = {
    "1": "FP",
    "2": "LS",
    "3": "IC_BP",
    "4": "DE",
    "5": "EX",
    "6": "L2",
}

# DF section markers (11.9.2.X "Data Fabric <BLOCK> Performance Monitor Events")
DF_SECTION_RE = re.compile(
    r'^\s*11\.9\.2\.\d+\s+Data Fabric\s+(\w+)\s+Performance Monitor Events\s*$'
)

# Page header/footer junk we strip
HEADER_FOOTER_RES = [
    re.compile(r'^AMD Confidential\b'),
    re.compile(r'^\s*\d+\s*$'),  # bare page numbers
    re.compile(r'^55\d{3}\s+Rev\s+'),
    re.compile(r'^\s*PPR Vol\s+\d+'),
]

# Bit row: leading spaces, then either "N" or "N:M" or "N..M", optional space,
# then mnemonic + descriptor. Mnemonic ends at ":" or "."
BITROW_RE = re.compile(
    r'^\s*(?P<bit>(?:\d+(?::\d+)?|\d+\.\.\d+))\s+(?P<rest>\S.*)$'
)

# Symbolic short name table header line: just "PMCxNNN" / "L3PMCxNN" / "DFPMCx..."
# on its own line, followed by "Bits Description"
TABLE_HDR_RE = re.compile(
    r'^\s*(?:L3|DF)?PMCx[0-9A-Fa-fx\[\]\.,_]+\s*$'
)
BITS_DESC_RE = re.compile(r'^\s*Bits\s+Description\s*$')

# Instance line typical patterns:
#   "_ccd0_lthree0_core[7:0]; PMCx000"
#   "_inst[CAKE[7:0]]; DFPMCx0000_0[D1,CD,C9,C5,C1,BD,B9,B5]F"
INSTANCE_RE = re.compile(
    r'^\s*(_[a-zA-Z0-9_\[\]:,\.]+;\s*(?:L3|DF)?PMCx[0-9A-Fa-fx\[\]\.,_]+)\s*$'
)

# Attribute lines that come right after the title, e.g. "Read-write. Reset: 00h."
ATTR_RE = re.compile(
    r'^\s*(Read-write\.|Read-only\.|Write-only\.|Reset:|See \d|Refer to)'
)


def run_pdftotext(pdf: Path, first: int, last: int) -> str:
    """Extract text from the page range with -layout preserved."""
    out = subprocess.check_output(
        ["pdftotext", "-layout", "-f", str(first), "-l", str(last), str(pdf), "-"],
        stderr=subprocess.DEVNULL,
    )
    return out.decode("utf-8", errors="replace")


TITLE_HEAD_RE = re.compile(
    r'^\s*(?:L3|DF)?PMCx[0-9A-Fa-fx\[\]\.,_]+\s+\[.+?\]\s*$'
)
TITLE_SYM_RE = re.compile(r'^\s*\([^)]+\)\s*$')


def clean_pages(text: str) -> list:
    """Split into pages (\\f), strip header/footer lines, return flat list of clean lines.

    Also joins title lines that wrap, where the '[Name]' bracket lands on one line
    and the '(Symbolic)' parenthetical on the next.
    """
    out_lines = []
    for page in text.split("\f"):
        for raw in page.splitlines():
            if any(p.match(raw) for p in HEADER_FOOTER_RES):
                continue
            if not raw.strip():
                out_lines.append("")
                continue
            out_lines.append(raw.rstrip())

    # Second pass: join wrapped titles
    joined = []
    i = 0
    while i < len(out_lines):
        cur = out_lines[i]
        if TITLE_HEAD_RE.match(cur):
            # peek next non-blank line for the symbolic
            j = i + 1
            while j < len(out_lines) and not out_lines[j].strip():
                j += 1
            if j < len(out_lines) and TITLE_SYM_RE.match(out_lines[j]):
                joined.append(cur.rstrip() + " " + out_lines[j].strip())
                i = j + 1
                continue
        joined.append(cur)
        i += 1
    return joined


def clean_bit_description(rest: str, mnemonic: str | None = None) -> str:
    """Strip leading mnemonic + 'Read-write. Reset:' boilerplate from a bit description."""
    s = rest
    # Drop a leading "Read-write." etc. (common when mnemonic absent)
    s = re.sub(r'^(?:Read-write|Read-only|Write-only)\.\s*', '', s)
    s = re.sub(r'^Reset:\s*\S+\.?\s*', '', s)
    # Drop a second "Read-write." that often appears mid-string after mnemonic
    s = re.sub(r'\bRead-write\.\s*', '', s)
    s = re.sub(r'\bReset:\s*\S+?\.\s*', '', s)
    # Strip AMD-internal debug attrs
    s = re.sub(r'\b(xc_pmc_type|si_validation_priority|amdonly_text)\s*:[^.]*\.\s*', '', s)
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def parse_bit_row(rest: str) -> tuple[str, str]:
    """
    Decompose 'rest' into (mnemonic, description). Handles three shapes:

      "Reserved."                                        -> ("", "Reserved.")
      "MulOps: Multiply Ops. Read-write. Reset: 0."      -> ("MulOps", "Multiply Ops.")
      "SseBotRet. Read-write. Reset: 0. SSE/AVX bottom-executing ops retired."
                                                          -> ("SseBotRet", "SSE/AVX bottom-executing ops retired.")
      "VectorFpOpType. Read-write. Reset: 0h."           -> ("VectorFpOpType", "")
    """
    s = rest.strip()
    if s.lower().startswith("reserved"):
        return ("", "Reserved.")

    # Form A: "Mnemonic: rest..."
    m = re.match(r'^([A-Za-z_][\w]*):\s*(.*)$', s)
    if m:
        mnemonic = m.group(1)
        desc = clean_bit_description(m.group(2), mnemonic)
        return (mnemonic, desc)

    # Form B: "Mnemonic. Read-write. Reset: X. rest..." OR "Mnemonic. rest..."
    m = re.match(r'^([A-Za-z_][\w]*)\.\s*(.*)$', s)
    if m:
        mnemonic = m.group(1)
        desc = clean_bit_description(m.group(2), mnemonic)
        return (mnemonic, desc)

    # Fallback: no mnemonic, whole thing is description
    return ("", clean_bit_description(s))


def parse_events(lines: list, dataset: str, source_note: str) -> list:
    """Walk cleaned lines, emit event records."""
    expected_prefix = SYM_PREFIX[dataset]
    events = []
    current_cat = {
        "core": None,
        "l3":   "L3",
        "df":   None,
    }[dataset]

    i = 0
    N = len(lines)
    while i < N:
        line = lines[i]

        # Update category from section headers
        if dataset == "core":
            m = CORE_SECTION_RE.match(line)
            if m:
                current_cat = CORE_SECTION_CAT.get(m.group(1), "Core")
                i += 1
                continue
        elif dataset == "df":
            m = DF_SECTION_RE.match(line)
            if m:
                current_cat = f"DF/{m.group(1)}"
                i += 1
                continue

        # Look for a title line
        m = TITLE_RE.match(line)
        if not m:
            i += 1
            continue

        symbolic = m.group("symbolic").strip()
        # Filter: only accept titles whose symbolic matches the dataset
        if not any(symbolic.startswith(p) for p in expected_prefix):
            i += 1
            continue

        code = m.group("code").strip()
        name = m.group("name").strip()

        # Walk forward collecting description/instance/bit rows
        # until we hit the NEXT title line or a section header.
        desc_parts = []
        instance = ""
        unit_masks: list[dict] = []
        last_bit_record = None  # for continuation lines
        in_bit_table = False
        j = i + 1
        while j < N:
            nl = lines[j]

            # Stop at next title
            if TITLE_RE.match(nl):
                m_sym = TITLE_RE.match(nl).group("symbolic").strip()
                # Stop if it's another event of the same family OR a different
                # PMC family — we always want the boundary between events.
                if m_sym.startswith(("Core::X86::Pmc::", "DF::PMC::")):
                    break

            # Stop at section header
            if dataset == "core" and CORE_SECTION_RE.match(nl):
                break
            if dataset == "df" and DF_SECTION_RE.match(nl):
                break
            # Generic ch-level boundaries
            if re.match(r'^\s*2\.1\.20\.[67]\s', nl) or re.match(r'^\s*2\.1\.21\s', nl):
                break
            if re.match(r'^\s*1[12]\.\d', nl) and dataset == "df":
                # Watch out for benign sub-section refs; only break on actual headers
                if re.match(r'^\s*12\s', nl):
                    break

            # Bit row inside the table?
            bm = BITROW_RE.match(nl)
            if in_bit_table and bm:
                bit = bm.group("bit")
                rest = bm.group("rest")
                mnemonic, desc = parse_bit_row(rest)
                last_bit_record = {
                    "bit": bit,
                    "mnemonic": mnemonic,
                    "description": desc,
                }
                unit_masks.append(last_bit_record)
                j += 1
                continue

            # Inside the bit table: detect continuation lines (indented, no leading bit#)
            if in_bit_table and last_bit_record is not None:
                stripped = nl.strip()
                if stripped and not BITROW_RE.match(nl) \
                        and not TABLE_HDR_RE.match(nl) \
                        and not BITS_DESC_RE.match(nl):
                    # Treat as continuation of last bit description
                    extra = clean_bit_description(stripped)
                    if extra:
                        if last_bit_record["description"]:
                            last_bit_record["description"] += " " + extra
                        else:
                            last_bit_record["description"] = extra
                    j += 1
                    continue

            # Table-start marker: short symbolic on its own line + "Bits Description" header
            if TABLE_HDR_RE.match(nl) and not in_bit_table:
                # peek next non-blank line
                k = j + 1
                while k < N and not lines[k].strip():
                    k += 1
                if k < N and BITS_DESC_RE.match(lines[k]):
                    in_bit_table = True
                    j = k + 1
                    continue

            # Instance line
            if not in_bit_table:
                im = INSTANCE_RE.match(nl)
                if im:
                    instance = im.group(1).strip()
                    j += 1
                    continue

                # Skip pure attribute lines like "Read-write. Reset: 00h."
                if ATTR_RE.match(nl):
                    j += 1
                    continue

                # Description text
                if nl.strip():
                    desc_parts.append(nl.strip())

            j += 1

        description = re.sub(r'\s+', ' ', " ".join(desc_parts)).strip()

        events.append({
            "code": code,
            "name": name,
            "symbolic": symbolic,
            "category": current_cat or "",
            "description": description,
            "instance": instance,
            "unit_masks": unit_masks,
        })

        i = j

    return events


# ---------------------------------------------------------------------------
# Markdown rendering (identical schema to extract_pprweb.py)
# ---------------------------------------------------------------------------
def render_markdown(events, title, chip, source_note):
    out = []
    out.append(f"# {chip} — {title}\n")
    out.append(f"_Source: {source_note}_\n")
    out.append(f"_Total events: {len(events)}_\n")
    out.append("")
    out.append("Events are listed in document order. Per-event, the table lists the "
               "UnitMask bits — to use with `perf stat -e rXXXX`, OR together the bits you want.\n")
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
                d = um["description"].replace("|", "\\|")
                m = um["mnemonic"]
                m_str = f"`{m}`" if m else ""
                out.append(f"| {um['bit']} | {m_str} | {d} |")
            out.append("")
        out.append("")
    return "\n".join(out)


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("pdf",        type=Path)
    p.add_argument("first_page", type=int)
    p.add_argument("last_page",  type=int)
    p.add_argument("chip")
    p.add_argument("dataset",    choices=["core", "l3", "df"])
    p.add_argument("out_dir",    type=Path)
    p.add_argument("--source",   default="")
    p.add_argument("--append",   action="store_true",
                   help="Append to an existing dataset (used to merge core+l3+df into a single chip dir).")
    args = p.parse_args()

    args.out_dir.mkdir(parents=True, exist_ok=True)
    source_note = args.source or f"AMD PPR PDF {args.pdf.name} pp.{args.first_page}-{args.last_page}"

    raw = run_pdftotext(args.pdf, args.first_page, args.last_page)
    lines = clean_pages(raw)
    events = parse_events(lines, args.dataset, source_note)

    json_path = args.out_dir / f"{args.chip}_pmc_{args.dataset}.json"
    md_path   = args.out_dir / f"{args.chip}_pmc_{args.dataset}.md"

    payload = {
        "chip": args.chip,
        "source": source_note,
        "dataset": args.dataset,
        "event_count": len(events),
        "events": events,
    }
    json_path.write_text(json.dumps(payload, indent=2, ensure_ascii=False))

    title = {
        "core": "Core PMC Events (FP / LS / IC+BP / DE / EX / L2)",
        "l3":   "L3 PMC Events",
        "df":   "Data Fabric PMC Events",
    }[args.dataset]
    md_path.write_text(render_markdown(events, title, args.chip, source_note))
    print(f"{args.dataset:5s}: {len(events):4d} events  ->  {json_path.name}, {md_path.name}")


if __name__ == "__main__":
    main()
