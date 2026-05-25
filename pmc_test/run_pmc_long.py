#!/usr/bin/env python3
"""
run_pmc_long.py — sanity-style PMC validation with a MINIMUM collection
window per perf invocation.

For each (workload, event-chunk) pair we wrap the workload in a bash loop that
keeps re-running it until at least --min-seconds has elapsed, then perf-stat
the whole wrapper. That guarantees every counter has >= MIN_SECONDS of wall-
clock time to accumulate, eliminating "looked zero because the workload was
too short" false negatives.

Usage:
  python3 run_pmc_long.py --min-seconds 30 --chunk-size 5 \
      [--workloads fp_avx,branch_random,...] [--events events.yaml]

Output: results/long_<UTC>_summary.json, same schema as mode_sanity
        plus per-(event,workload) rows so we can pick the best counter
        per event across workloads.
"""
from __future__ import annotations
import argparse, json, os, shlex, shutil, subprocess, sys, time, hashlib
from datetime import datetime, timezone
from pathlib import Path

try:
    import yaml
except ImportError:
    print("PyYAML required: pip install pyyaml --break-system-packages", file=sys.stderr)
    sys.exit(2)

ROOT = Path(__file__).resolve().parent
EVENTS_YAML = ROOT / "events.yaml"
RESULTS_DIR = ROOT / "results"
RAW_DIR     = RESULTS_DIR / "raw"

DEFAULT_WORKLOADS = [
    "fp_avx", "branch_random", "l2_pressure", "dram_stream",
    "tlb_thrash", "syscall_heavy", "ccd_pingpong", "stream",
]

def have(b): return shutil.which(b) is not None

def base_workload_cmd(tag, root):
    """One-shot invocation of each workload (we will loop this in bash)."""
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
    if tag == "openssl" and have("openssl"):
        return "openssl speed -seconds 3 -elapsed aes-256-cbc"
    return None

def loop_for_seconds(cmd, min_seconds):
    """Build a bash one-liner that keeps re-running `cmd` until min_seconds elapsed."""
    return [
        "bash", "-c",
        f'END=$(( $(date +%s) + {int(min_seconds)} )); '
        f'while [ $(date +%s) -lt $END ]; do {cmd} >/dev/null 2>&1 || true; done'
    ]

def perf_run_long(events, workload_tag, root, min_seconds, raw_dir):
    cmd = base_workload_cmd(workload_tag, root)
    if not cmd:
        return None, f"workload-unavailable:{workload_tag}"
    elist = ",".join(events)
    wrapper = loop_for_seconds(cmd, min_seconds)
    pcmd = ["perf", "stat", "-j", "-e", elist, "--"] + wrapper
    t0 = time.time()
    p = subprocess.run(pcmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    dur = time.time() - t0
    # write raw
    sig = hashlib.sha1((elist + "|" + workload_tag).encode()).hexdigest()[:8]
    fname = f"long_{workload_tag}__{sig}.log"
    try:
        with open(raw_dir / fname, "w") as fh:
            fh.write(f"# cmd: {' '.join(shlex.quote(x) for x in pcmd)}\n")
            fh.write(f"# dur_s: {dur:.3f}\n# rc: {p.returncode}\n")
            fh.write(p.stdout)
    except Exception:
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
    counters["__duration_s"] = dur
    counters["__rc"] = p.returncode
    return counters, None

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--min-seconds", type=int, default=30,
                    help="minimum wall-clock collection window per perf invocation")
    ap.add_argument("--chunk-size", type=int, default=5,
                    help="events per perf invocation (perf multiplexes if > HW counters)")
    ap.add_argument("--workloads", type=str, default=",".join(DEFAULT_WORKLOADS))
    ap.add_argument("--events", type=str, default=str(EVENTS_YAML))
    ap.add_argument("--limit", type=int, default=0, help="debug: limit total events processed")
    args = ap.parse_args()

    reg = yaml.safe_load(Path(args.events).read_text())
    events = reg["events"]
    if args.limit > 0: events = events[:args.limit]

    workloads = [w for w in args.workloads.split(",") if w.strip()]
    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    raw_dir = RAW_DIR / f"long_{ts}"
    raw_dir.mkdir(parents=True, exist_ok=True)
    print(f"[{datetime.utcnow():%H:%M:%S}] min_seconds={args.min_seconds} chunk={args.chunk_size} "
          f"events={len(events)} workloads={workloads}")
    print(f"[{datetime.utcnow():%H:%M:%S}] raw -> {raw_dir}")

    rows = []
    total_perf_calls = sum( (len(events)+args.chunk_size-1)//args.chunk_size for _ in workloads)
    print(f"[{datetime.utcnow():%H:%M:%S}] total perf invocations: {total_perf_calls} "
          f"(estimate wall {total_perf_calls*args.min_seconds/60:.1f} min)")

    call_idx = 0
    for tag in workloads:
        if not base_workload_cmd(tag, ROOT):
            print(f"[{datetime.utcnow():%H:%M:%S}] skip workload {tag} (binary missing)")
            continue
        for i in range(0, len(events), args.chunk_size):
            chunk = events[i:i+args.chunk_size]
            call_idx += 1
            evnames = [e["perf"] for e in chunk]
            counters, err = perf_run_long(evnames, tag, ROOT, args.min_seconds, raw_dir)
            dur = counters["__duration_s"] if counters else 0.0
            if call_idx % 5 == 0 or call_idx == 1:
                print(f"[{datetime.utcnow():%H:%M:%S}] {tag} {call_idx}/{total_perf_calls} dur={dur:.1f}s")
            if err:
                for e in chunk:
                    rows.append({"event": e["perf"], "amd": e.get("amd",""),
                                 "workload": tag, "value": 0.0, "ok": False,
                                 "skipped": err, "duration_s": 0.0})
                continue
            for e in chunk:
                v = counters.get(e["perf"], 0.0)
                rows.append({
                    "event": e["perf"], "amd": e.get("amd",""), "workload": tag,
                    "value": v, "ok": v > 0,
                    "duration_s": counters["__duration_s"],
                    "rc": counters.get("__rc", -1),
                    "pmc": e.get("pmc",""), "bit": e.get("bit",""),
                })

    out = {
        "meta": {
            "ts": ts, "host": os.uname().nodename, "ncpu": os.cpu_count(),
            "mode": "long-sanity", "min_seconds": args.min_seconds,
            "chunk_size": args.chunk_size, "workloads": workloads,
            "events_count": len(events),
        },
        "long_sanity": rows,
    }
    out_path = RESULTS_DIR / f"long_{ts}_summary.json"
    out_path.write_text(json.dumps(out))
    print(f"[{datetime.utcnow():%H:%M:%S}] wrote {out_path}")
    # quick rollup
    by_event = {}
    for r in rows:
        e = r["event"]
        d = by_event.setdefault(e, {"any_nonzero": False, "best_value": 0.0, "best_workload": None})
        if r.get("value",0) > d["best_value"]:
            d["best_value"] = r["value"]; d["best_workload"] = r["workload"]
        if r.get("value",0) > 0: d["any_nonzero"] = True
    nz = sum(1 for e,d in by_event.items() if d["any_nonzero"])
    print(f"[{datetime.utcnow():%H:%M:%S}] unique events: {len(by_event)}, nonzero on >=1 workload: {nz}")

if __name__ == "__main__":
    sys.exit(main() or 0)
