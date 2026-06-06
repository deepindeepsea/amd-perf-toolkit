#!/usr/bin/env python3
"""
run_pmc_tests.py — Validate AMD Zen4/5 (Genoa/Turin) core PMCs against
the PPR and PerfSpect using a battery of microbenchmarks and known workloads.
"""
from __future__ import annotations
import argparse, json, os, re, shlex, shutil, subprocess, sys, time
from datetime import datetime, timezone
from pathlib import Path

try:
    import yaml
except ImportError:
    print("PyYAML required: pip install pyyaml --break-system-packages", file=sys.stderr)
    sys.exit(2)

ROOT = Path(__file__).resolve().parent
EVENTS_YAML = ROOT / "events.yaml"
DIFF_JSON   = ROOT / "ppr_vs_perfspect_diff.json"
RESULTS_DIR = ROOT / "results"
RAW_DIR     = RESULTS_DIR / "raw"

def detect_ccd_topology():
    try:
        import xml.etree.ElementTree as ET
        out = subprocess.check_output(["lstopo", "--of", "xml"], stderr=subprocess.DEVNULL)
        root = ET.fromstring(out)
        ccds = {}
        for pkg in root.iter('object'):
            if pkg.attrib.get('type') == 'L3Cache':
                cpus = []
                for pu in pkg.iter('object'):
                    if pu.attrib.get('type') == 'PU':
                        cpus.append(int(pu.attrib['os_index']))
                if cpus:
                    ccds[len(ccds)] = sorted(set(cpus))
        if ccds:
            return [ccds[i] for i in sorted(ccds)]
    except Exception:
        pass
    ccds = {}
    for cpu_dir in sorted(Path('/sys/devices/system/cpu').glob('cpu[0-9]*')):
        try:
            cpu = int(cpu_dir.name[3:])
            die = int((cpu_dir / 'topology/die_id').read_text().strip())
            ccds.setdefault(die, []).append(cpu)
        except Exception:
            continue
    return [sorted(v) for _, v in sorted(ccds.items())]

def cpu_count(): return os.cpu_count() or 1

def perf_supports_event(name):
    cmd = ["perf", "stat", "-e", name, "-x", ",", "sleep", "0.01"]
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    err = p.stderr.strip().splitlines()[-1:] if p.stderr else []
    ok = (p.returncode == 0) and ("not supported" not in p.stderr) and ("Bad event" not in p.stderr)
    return ok, " ".join(err)

_RAW_DIR_CURRENT = None
def perf_run(events, cmd, cpu_list=None, repeat=1, tag=None):
    if not events: return {}
    elist = ",".join(events)
    pcmd = ["perf", "stat", "-j", "-e", elist]
    if repeat > 1: pcmd += ["-r", str(repeat)]
    if cpu_list is not None:
        pcmd = ["taskset", "-c", cpu_list] + pcmd
    pcmd += ["--"] + shlex.split(cmd) if isinstance(cmd, str) else (pcmd + ["--"] + cmd)
    t0 = time.time()
    p = subprocess.run(pcmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    dur = time.time() - t0
    # write raw log per invocation for auditability
    if _RAW_DIR_CURRENT is not None:
        try:
            import hashlib
            sig = hashlib.sha1((elist + "|" + str(cmd) + "|" + str(cpu_list)).encode()).hexdigest()[:8]
            fname = f"{tag or 'run'}__{sig}.log"
            with open(os.path.join(_RAW_DIR_CURRENT, fname), "w") as fh:
                fh.write(f"# cmd: {' '.join(pcmd)}\n# dur_s: {dur:.3f}\n# rc: {p.returncode}\n")
                fh.write(p.stdout)
        except Exception as _e:
            pass
    counters = {}
    for line in p.stdout.splitlines():
        line = line.strip()
        if not line.startswith("{"): continue
        try: obj = json.loads(line)
        except Exception: continue
        ev = (obj.get("event") or "").strip()
        if not ev: continue
        try: v = float((obj.get("counter-value") or "0").replace(",", ""))
        except Exception: v = 0.0
        counters[ev] = counters.get(ev, 0.0) + v
        mv = obj.get("metric-value", "")
        if mv:
            try: counters[ev + "__metric"] = float(mv)
            except Exception: pass
    counters["__duration_s"] = dur
    counters["__rc"] = p.returncode
    counters["__stdout_tail"] = "\n".join(p.stdout.splitlines()[-8:])
    return counters

def have(prog): return shutil.which(prog) is not None

def workload_cmd(tag, root):
    bin_dir = root / "workloads"
    mb = lambda n: str(bin_dir / n)
    if tag == "fp_avx":        return f"{mb('fp_avx')} 100000000"
    if tag == "branch_random": return f"{mb('branch_random')} 33554432 2"
    if tag == "l2_pressure":   return f"{mb('l2_pressure')} 786432 20000"
    if tag == "dram_stream":   return f"{mb('dram_stream')} 256 3"
    if tag == "tlb_thrash":    return f"{mb('tlb_thrash')} 65536 10"
    if tag == "syscall_heavy": return f"{mb('syscall_heavy')} 2000000"
    if tag == "ccd_pingpong":  return f"{mb('ccd_pingpong')} 8 2000000"
    if tag == "stream":        return f"{mb('stream')} 256 5"
    if tag == "mlc_lat" and have("mlc"):  return "mlc --loaded_latency -e -d0 -t5"
    if tag == "mlc_bw"  and have("mlc"):  return "mlc --max_bandwidth -X -t5"
    if tag == "mlc_c2c" and have("mlc"):  return "mlc --c2c_latency"
    if tag == "stress_cache" and have("stress-ng"):
        return "stress-ng --cache 4 --cache-level 3 --aggressive -t 6"
    if tag == "openssl" and have("openssl"):
        return "openssl speed -seconds 3 -elapsed aes-256-cbc"
    if tag == "stress_ng" and have("stress-ng"):
        return "stress-ng --cpu 2 --cpu-method matrixprod -t 5"
    if tag == "dd":
        return "dd if=/dev/zero of=/dev/null bs=1M count=2048"
    if tag == "lmbench" and have("lat_mem_rd"):
        return "lat_mem_rd -W 1 -N 1 64M 512"
    if tag == "ffmpeg" and have("ffmpeg"):
        return "ffmpeg -y -f lavfi -i testsrc=duration=5:size=1280x720:rate=30 -c:v libx264 -f null -"
    if tag == "all":
        return f"{mb('fp_avx')} 50000000"
    return None

def workload_available(tag):
    return workload_cmd(tag, ROOT) is not None

def load_registry():
    reg = yaml.safe_load(EVENTS_YAML.read_text())
    return reg["events"], reg.get("metrics", [])

def load_ppr_only():
    if not DIFF_JSON.exists(): return set()
    d = json.loads(DIFF_JSON.read_text())
    return {e["perf"] for e in d.get("in_ppr_not_in_perfspect", [])}

def mode_programmability(events):
    res = []
    for e in events:
        if e.get("linux_perf_unavailable"):
            res.append({"event": e["perf"], "amd": e["amd"], "category": e["category"], "ok": None, "error": "skipped: linux_perf_unavailable"}); continue
        ok, err = perf_supports_event(e["perf"])
        res.append({"event": e["perf"], "amd": e["amd"], "category": e["category"],
                    "ok": ok, "error": err if not ok else ""})
    return res

def mode_sanity(events, root, restrict_perf=None):
    by_tag = {}
    res = []
    for e in events:
        if restrict_perf is not None and e["perf"] not in restrict_perf: continue
        if e.get("expect_zero"):
            res.append({"event": e["perf"], "workload": (e.get("nonzero_on") or ["-"])[0],
                        "category": e.get("category"), "ok": None,
                        "skipped": "expect_zero: " + e.get("zero_reason", "not exercised by suite")})
            continue
        for tag in (e.get("nonzero_on") or ["all"]):
            by_tag.setdefault(tag, []).append(e)
    for tag, evs in by_tag.items():
        cmd = workload_cmd(tag, root)
        if not cmd:
            for e in evs:
                res.append({"event": e["perf"], "workload": tag, "skipped": "workload-unavailable"})
            continue
        for i in range(0, len(evs), 5):
            chunk = evs[i:i+5]
            counters = perf_run([e["perf"] for e in chunk], cmd, tag=f"sanity_{tag}")
            for e in chunk:
                v = counters.get(e["perf"], 0.0)
                ok = v > 0 if tag != "all" or e["category"] != "EX" else True
                res.append({"event": e["perf"], "workload": tag, "value": v,
                            "category": e["category"], "ok": ok,
                            "duration_s": counters.get("__duration_s", 0)})
    return res

def mode_bounds(events, root):
    res = []
    for e in events:
        cap = e.get("max_per_inst")
        if cap is None: continue
        tag = (e.get("nonzero_on") or ["all"])[0]
        cmd = workload_cmd(tag, root)
        if not cmd: continue
        counters = perf_run([e["perf"], "instructions"], cmd, tag=f"bounds_{tag}")
        inst = counters.get("instructions", 0.0)
        v = counters.get(e["perf"], 0.0)
        ratio = (v / inst) if inst > 0 else 0.0
        res.append({"event": e["perf"], "workload": tag, "value": v, "instructions": inst,
                    "per_inst": ratio, "cap": cap, "ok": ratio <= cap})
    return res

def safe_eval(expr, env):
    if not re.match(r'^[\w\.\s+\-*/()0-9]+$', expr):
        raise ValueError("unsafe expr: " + expr)
    name_re = r'[A-Za-z_][\w\.]*(?:-[\w\.]+)*'
    tokens = re.findall(rf'{name_re}|[0-9]+\.?[0-9]*|[+\-*/()]', expr)
    py = []
    for t in tokens:
        if re.match(r'^[A-Za-z_]', t): py.append(f'env[{t!r}]')
        else: py.append(t)
    return eval(" ".join(py), {"__builtins__": {}}, {"env": env})

def extract_event_names(formula):
    return sorted(set(re.findall(r'[A-Za-z_][\w\.]*(?:-[\w\.]+)*', formula)))

def mode_metrics(metrics, root):
    res = []
    for m in metrics:
        for tag, (lo, hi) in m.get("bounds_per_workload", {}).items():
            workload_tag = tag if tag != "all" else "openssl"
            cmd = workload_cmd(workload_tag, root)
            if not cmd: continue
            evs = extract_event_names(m["formula"])
            counters = perf_run(evs, cmd, tag="metric_" + m["name"] + "_" + workload_tag)
            env = {k: counters.get(k, 0.0) for k in evs}
            try:    val = safe_eval(m["formula"], env)
            except ZeroDivisionError: val = float("nan")
            ok = (val == val) and (lo <= val <= hi)
            res.append({"metric": m["name"], "workload": workload_tag, "value": val,
                        "bounds": [lo, hi], "ok": ok, "formula": m["formula"]})
    return res

def mode_ccd_scale(events, root):
    topo = detect_ccd_topology()
    if len(topo) < 2:
        return [{"event": "*", "skipped": f"need >=2 CCDs, found {len(topo)}"}]
    ccd0 = topo[0]
    ccd1 = topo[1]
    scales = [
        ("1c",       ",".join(map(str, ccd0[:1]))),
        ("1ccd",     ",".join(map(str, ccd0))),
        ("2ccd",     ",".join(map(str, ccd0 + ccd1))),
    ]
    pick = [e for e in events if e["category"] in ("LS","L2","EX","DE")]
    res = []
    base_cmd_tpl = str(ROOT / "workloads" / "ccd_pingpong") + " {nth} 2000000"
    for i in range(0, len(pick), 5):
        chunk = pick[i:i+5]
        row = {"events": [e["perf"] for e in chunk], "scales": {}}
        for label, cpus in scales:
            nth = len(cpus.split(","))
            cmd = base_cmd_tpl.format(nth=nth)
            counters = perf_run([e["perf"] for e in chunk], cmd, cpu_list=cpus, tag=f"ccdscale_{label}")
            row["scales"][label] = {e["perf"]: counters.get(e["perf"], 0.0) for e in chunk}
            row["scales"][label]["__duration_s"] = counters.get("__duration_s", 0)
        for e in chunk:
            v1   = row["scales"]["1c"  ][e["perf"]]
            v1cd = row["scales"]["1ccd"][e["perf"]]
            v2cd = row["scales"]["2ccd"][e["perf"]]
            classifier = classify_scale(v1, v1cd, v2cd)
            res.append({"event": e["perf"], "category": e["category"],
                        "v_1core": v1, "v_1ccd": v1cd, "v_2ccd": v2cd,
                        "scale_class": classifier})
    return res

def classify_scale(v1, v1cd, v2cd):
    eps = 1.0
    if v1 + v1cd < 0.02 * max(v2cd, eps) and v2cd > 100:
        return "cross_ccd_only"
    if v1 <= eps and v1cd <= eps and v2cd <= eps:
        return "always_zero"
    if v1 > 0:
        r1 = v1cd / v1
        r2 = v2cd / max(v1cd, eps)
        if 3 < r1 < 16 and 1.3 < r2 < 4:
            return "linear"
        if v2cd < 1.5 * v1cd:
            return "saturating"
    return "irregular"

HTML_TPL = """<!doctype html><meta charset=utf-8>
<title>PMC Test Report {ts}</title>
<style>
body{{font:14px/1.4 -apple-system,Inter,Arial;color:#222;background:#fafafa;margin:24px}}
h1,h2{{color:#000}}
.grid{{display:grid;grid-template-columns:1fr 80px 80px 80px 80px;gap:2px;margin:8px 0 24px}}
.grid>div{{padding:4px 8px;background:#fff;border:1px solid #eee}}
.grid>div.head{{font-weight:600;background:#eee}}
.ok{{background:#d4f4d4}}
.fail{{background:#f8c8c8}}
.skip{{background:#eee;color:#999}}
.extra{{box-shadow:inset 0 0 0 2px #f80}}
.legend span{{display:inline-block;padding:2px 8px;margin-right:6px;border:1px solid #ccc}}
table{{border-collapse:collapse;margin:8px 0 24px;background:#fff;width:100%}}
td,th{{border:1px solid #ddd;padding:4px 8px;font-size:13px;text-align:left}}
th{{background:#eef}}
.muted{{color:#888;font-size:12px}}
</style>
<h1>AMD Zen4/5 PMC Test Report</h1>
<p class=muted>Generated {ts} UTC Host {host} CPU {cpu_model} Cores {ncpu} CCDs {nccd}</p>
<div class=legend>
  <span class=ok>pass</span><span class=fail>fail</span><span class=skip>skip</span>
  <span class=extra>orange border = PPR-only (not in PerfSpect)</span>
</div>
{body}
"""

def render_html(summary, ts, ppr_only):
    body = []
    host = os.uname().nodename
    cpu_model = "?"
    try:
        for ln in open("/proc/cpuinfo"):
            if ln.startswith("model name"):
                cpu_model = ln.split(":",1)[1].strip(); break
    except Exception: pass
    ncpu = cpu_count()
    nccd = len(detect_ccd_topology())

    by_ev = {}
    for r in summary.get("programmability", []):
        by_ev.setdefault(r["event"], {})["prog"] = r["ok"]
    for r in summary.get("sanity", []):
        by_ev.setdefault(r["event"], {}).setdefault("sanity", {})[r.get("workload","?")] = r.get("ok")
    for r in summary.get("bounds", []):
        by_ev.setdefault(r["event"], {})["bounds"] = r["ok"]

    body.append("<h2>Per-event matrix</h2>")
    body.append('<div class=grid>')
    body.append('<div class=head>event</div><div class=head>prog</div><div class=head>sanity</div><div class=head>bounds</div><div class=head>ppr-only</div>')
    for ev, st in sorted(by_ev.items()):
        prog = st.get("prog")
        _sv = [v for v in st.get("sanity", {}).values() if v is not None]
        san  = (all(_sv) if _sv else None)
        bnd  = st.get("bounds")
        extra = "extra" if ev in ppr_only else ""
        def cell(v):
            if v is None: return '<div class=skip>-</div>'
            return f'<div class={"ok" if v else "fail"}>{"Y" if v else "N"}</div>'
        body.append(f'<div class="{extra}">{ev}</div>{cell(prog)}{cell(san)}{cell(bnd)}<div>{"yes" if extra else ""}</div>')
    body.append('</div>')

    body.append("<h2>Derived metric bounds</h2><table><tr><th>metric</th><th>workload</th><th>value</th><th>bounds</th><th>ok</th></tr>")
    for r in summary.get("metrics", []):
        cls = "ok" if r["ok"] else "fail"
        body.append(f'<tr><td>{r["metric"]}</td><td>{r["workload"]}</td><td>{r["value"]:.3f}</td><td>{r["bounds"]}</td><td class={cls}>{"Y" if r["ok"] else "N"}</td></tr>')
    body.append("</table>")

    if summary.get("ccd_scale"):
        body.append("<h2>CCD scaling (1 core -> 1 CCD -> 2 CCDs)</h2>")
        body.append("<table><tr><th>event</th><th>cat</th><th>1c</th><th>1 CCD</th><th>2 CCD</th><th>class</th></tr>")
        for r in summary["ccd_scale"]:
            if "skipped" in r: continue
            body.append(f'<tr><td>{r["event"]}</td><td>{r.get("category","")}</td>'
                        f'<td>{r["v_1core"]:.0f}</td><td>{r["v_1ccd"]:.0f}</td><td>{r["v_2ccd"]:.0f}</td>'
                        f'<td>{r["scale_class"]}</td></tr>')
        body.append("</table>")

    return HTML_TPL.format(ts=ts, host=host, cpu_model=cpu_model, ncpu=ncpu, nccd=nccd,
                           body="\n".join(body))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", default="all",
                    choices=["programmability","sanity","bounds","metrics","ccd-scale","ppr-extras","all"])
    ap.add_argument("--out", default=None, help="results dir override")
    args = ap.parse_args()

    out_dir = Path(args.out) if args.out else RESULTS_DIR
    out_dir.mkdir(parents=True, exist_ok=True)
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    raw_subdir = out_dir / "raw" / ts
    raw_subdir.mkdir(parents=True, exist_ok=True)
    global _RAW_DIR_CURRENT
    _RAW_DIR_CURRENT = str(raw_subdir)
    print(f"[{datetime.utcnow():%H:%M:%S}] raw logs -> {raw_subdir}", flush=True)

    events, metrics = load_registry()
    ppr_only = load_ppr_only()
    summary = {"meta": {"ts": ts, "host": os.uname().nodename, "ncpu": cpu_count(),
                        "ccd_topology": detect_ccd_topology(), "mode": args.mode}}

    if not shutil.which("perf"):
        print("ERROR: linux `perf` not found on PATH", file=sys.stderr)
        sys.exit(2)

    def maybe(mode_name, fn):
        if args.mode in (mode_name, "all"):
            print(f"[{datetime.utcnow():%H:%M:%S}] running mode={mode_name} ...", flush=True)
            summary[mode_name.replace("-","_")] = fn()

    maybe("programmability", lambda: mode_programmability(events))
    maybe("sanity",          lambda: mode_sanity(events, ROOT))
    maybe("bounds",          lambda: mode_bounds(events, ROOT))
    maybe("metrics",         lambda: mode_metrics(metrics, ROOT))
    maybe("ccd-scale",       lambda: mode_ccd_scale(events, ROOT))
    if args.mode in ("ppr-extras","all"):
        print(f"[{datetime.utcnow():%H:%M:%S}] running mode=ppr-extras ...", flush=True)
        summary["ppr_extras"] = mode_sanity(events, ROOT, restrict_perf=ppr_only)
    summary_path = out_dir / f"{ts}_summary.json"
    summary_path.write_text(json.dumps(summary, indent=2, default=str))
    html_path = out_dir / f"{ts}_report.html"
    html_path.write_text(render_html(summary, ts, ppr_only))
    print(f"[{datetime.utcnow():%H:%M:%S}] wrote {summary_path}")
    print(f"[{datetime.utcnow():%H:%M:%S}] wrote {html_path}")

if __name__ == "__main__":
    main()
