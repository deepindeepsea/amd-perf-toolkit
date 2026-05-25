#!/usr/bin/env python3
"""
run_pmc_metrics.py — evaluate BRH Table 58 (Pipeline Utilization) composite
metrics using raw `cpu/event=,umask=/` codes so we bypass the perf JSON
mnemonic catalog (works on Nitro-filtered AWS + bare-metal alike).

Approach:
 - Load metrics YAML: events list (name → perf-syntax raw code) + metric formulas
 - For each workload, run ONE perf-stat collecting all events at once
   (perf will multiplex if > 6 generic counters — that's fine for ratios)
 - Wrap workload in 30s minimum-window loop (Playbook §4.1 steady-state)
 - Evaluate each formula in a sandboxed eval(), emit per-workload metric report

Usage:
  python3 run_pmc_metrics.py --min-seconds 30 \
      --workloads fp_avx,branch_random,l2_pressure,dram_stream \
      --metrics metrics/table58_pipeline.yaml

Output: results/metrics_<UTC>.json + a console table.
"""
from __future__ import annotations
import argparse, json, os, shlex, shutil, subprocess, sys, time
from datetime import datetime, timezone
from pathlib import Path

try:
    import yaml
except ImportError:
    print("pip install pyyaml --break-system-packages", file=sys.stderr); sys.exit(2)

ROOT = Path(__file__).resolve().parent
RESULTS = ROOT / "results"
METRICS_DIR = ROOT / "metrics"

DEFAULT_WORKLOADS = ["fp_avx", "branch_random", "l2_pressure", "dram_stream",
                     "tlb_thrash", "ccd_pingpong"]

# CPU family → preferred pipeline yaml (auto-select order)
FAMILY_YAML_PREF = {
    0x1A: ["table58_pipeline_zen5.yaml", "pipeline_zen4_genoa.yaml"],  # Zen5 Turin
    0x19: ["pipeline_zen4_genoa.yaml"],                                # Zen4 Genoa
}

def detect_cpu_family():
    """Return AMD CPU family as int (e.g. 0x19 Zen4, 0x1A Zen5), or None."""
    try:
        for line in Path("/proc/cpuinfo").read_text().splitlines():
            if line.startswith("cpu family"):
                return int(line.split(":")[1].strip())
    except Exception:
        pass
    return None

def resolve_metrics_path(arg, family):
    """Honor --metrics auto: pick the right yaml for this CPU family."""
    if arg != "auto":
        return Path(arg)
    if family is None:
        sys.exit("ERROR: --metrics auto requested but CPU family unknown")
    for cand in FAMILY_YAML_PREF.get(family, []):
        p = METRICS_DIR / cand
        if p.exists(): return p
    sys.exit(f"ERROR: no pipeline yaml found for cpu family 0x{family:X}")

def check_family_compat(spec, family, path):
    """Refuse to run a yaml on a CPU family it doesn't support."""
    req = (spec.get("requires") or {}).get("cpu_family")
    if not req or family is None:
        return  # no constraint declared, proceed
    if family not in req:
        allowed = ", ".join(f"0x{f:X}" for f in req)
        sys.exit(f"ERROR: {path.name} requires cpu_family in [{allowed}] "
                 f"but this host is 0x{family:X}.\n"
                 f"       Use --metrics auto to let the runner pick the right yaml.")

def workload_cmd(tag, root):
    b = root / "workloads"
    mb = lambda n: str(b / n)
    return {
        "fp_avx":        f"{mb('fp_avx')} 100000000",
        "branch_random": f"{mb('branch_random')} 33554432 2",
        "l2_pressure":   f"{mb('l2_pressure')} 786432 20000",
        "dram_stream":   f"{mb('dram_stream')} 256 3",
        "tlb_thrash":    f"{mb('tlb_thrash')} 65536 10",
        "ccd_pingpong":  f"{mb('ccd_pingpong')} 8 2000000",
        "stream":        f"{mb('stream')} 256 5",
        "syscall_heavy": f"{mb('syscall_heavy')} 2000000",
    }.get(tag)

def loop_for(cmd, secs):
    return ["bash", "-c",
            f'END=$(( $(date +%s) + {int(secs)} )); '
            f'while [ $(date +%s) -lt $END ]; do {cmd} >/dev/null 2>&1 || true; done']

def perf_stat(perf_events, wrapper, raw_log):
    elist = ",".join(perf_events)
    pcmd = ["perf", "stat", "-j", "-e", elist, "--"] + wrapper
    t0 = time.time()
    p = subprocess.run(pcmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    dur = time.time() - t0
    try:
        with open(raw_log, "w") as fh:
            fh.write(f"# cmd: {' '.join(shlex.quote(x) for x in pcmd)}\n")
            fh.write(f"# dur_s: {dur:.3f}\n# rc: {p.returncode}\n")
            fh.write(p.stdout)
    except Exception:
        pass
    vals = {}
    for line in p.stdout.splitlines():
        line = line.strip()
        if not line.startswith("{"): continue
        try: obj = json.loads(line)
        except Exception: continue
        ev = (obj.get("event") or "").strip()
        if not ev: continue
        try: v = float((obj.get("counter-value") or "0").replace(",", ""))
        except Exception: v = 0.0
        # perf names the counter after the name= field in the raw spec
        vals[ev] = vals.get(ev, 0.0) + v
    vals["__duration_s"] = dur
    vals["__rc"] = p.returncode
    return vals

def eval_metrics(formulas, ev_values):
    """Safe-ish eval — only allows the event names + arithmetic."""
    out = {}
    env = dict(ev_values)
    # iterate twice so derived metrics can reference earlier ones
    for _pass in range(3):
        for name, expr in formulas.items():
            if name in out: continue
            try:
                # forbid attributes/calls
                if any(c in expr for c in ["__", "import", ";"]):
                    raise ValueError("unsafe expr")
                v = eval(expr, {"__builtins__": {}}, env)
                out[name] = float(v)
                env[name] = float(v)
            except ZeroDivisionError:
                out[name] = float("nan")
            except Exception:
                pass  # may depend on a later-computed value
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--min-seconds", type=int, default=30)
    ap.add_argument("--workloads", default=",".join(DEFAULT_WORKLOADS))
    ap.add_argument("--metrics", default="auto",
                    help="Path to metrics yaml, or 'auto' (default) to pick by CPU family")
    args = ap.parse_args()

    family = detect_cpu_family()
    metrics_path = resolve_metrics_path(args.metrics, family)
    spec = yaml.safe_load(metrics_path.read_text())
    check_family_compat(spec, family, metrics_path)
    fam_str = f"0x{family:X}" if family is not None else "unknown"
    print(f"[cpu_family={fam_str}] metrics={metrics_path.name}")

    ev_list = spec["events"]                    # [{name,perf}, ...]
    formulas = spec["metrics"]                  # {name: expression}
    workloads = [w for w in args.workloads.split(",") if w.strip()]

    RESULTS.mkdir(parents=True, exist_ok=True)
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    raw_dir = RESULTS / f"metrics_{ts}_raw"; raw_dir.mkdir(parents=True, exist_ok=True)
    print(f"[{datetime.now(timezone.utc):%H:%M:%S}] events={len(ev_list)} workloads={workloads} "
          f"min_seconds={args.min_seconds}")

    perf_specs = [e["perf"] for e in ev_list]
    event_names = [e["name"] for e in ev_list]

    report = {"meta": {"ts": ts, "host": os.uname().nodename, "ncpu": os.cpu_count(),
                       "cpu_family": fam_str, "metrics_file": str(metrics_path),
                       "min_seconds": args.min_seconds},
              "runs": []}

    for tag in workloads:
        cmd = workload_cmd(tag, ROOT)
        if not cmd:
            print(f"[skip] {tag} (binary missing)"); continue
        wrapper = loop_for(cmd, args.min_seconds)
        raw_log = raw_dir / f"{tag}.log"
        vals = perf_stat(perf_specs, wrapper, raw_log)
        ev_vals = {k: vals.get(k, 0.0) for k in event_names}
        derived = eval_metrics(formulas, ev_vals)
        row = {"workload": tag, "duration_s": vals["__duration_s"], "rc": vals["__rc"],
               "events": ev_vals, "metrics": derived}
        report["runs"].append(row)
        print(f"\n=== {tag} ({vals['__duration_s']:.1f}s) ===")
        for m in ("frontend_bound_pct","bad_spec_pct","backend_bound_pct",
                  "retiring_pct","smt_contention_pct"):
            v = derived.get(m, float("nan"))
            print(f"  {m:24s} {v:7.2f}%")

    out_path = RESULTS / f"metrics_{ts}.json"
    out_path.write_text(json.dumps(report, indent=2))
    print(f"\n[{datetime.now(timezone.utc):%H:%M:%S}] wrote {out_path}")

if __name__ == "__main__":
    sys.exit(main() or 0)
