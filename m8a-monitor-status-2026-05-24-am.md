# M8A Testing Monitor — Scheduled Run Status

**Run time:** 2026-05-24 06:52 UTC — scheduled task `m8a-testing-monitor` (6th consecutive no-op)
**Instance:** i-082ca0124af7a18d0 (m8a.metal-24xl, AMD EPYC 9R45 / Zen5 Turin)
**Outcome:** Blocked — same sandbox environment limitations as prior 5 runs

## Verified this run

- `ssh m8a` → `Could not resolve hostname m8a` (SSH config + AWS SSM ProxyCommand live on the Windows host)
- `aws` CLI not installed in sandbox
- No `.pem` key file accessible at the path the monitor script expects
- `~/.config/microsoft-graph/token.json` missing → m365-email skill cannot send to PradeepN@AMD.com

## Recommendation

**Disable this scheduled task** or re-home it to the Windows host (Task Scheduler / WSL cron)
where SSH config, AWS SSM plugin, the `.pem` key, and the Graph token all exist.
Until then, every run will produce only a status file like this one — no SSH check,
no email delivered.

## Manual one-liner (run from Windows host)

```bash
ssh m8a 'cd ~/rails-benchmark-amd && \
  pgrep -af "puma|ruby|benchmark_ccd_sweep" || echo "no procs"; \
  ls -lt results/ 2>/dev/null | head -20; \
  ls -lt *.html *.xlsx 2>/dev/null | head; uptime'
```
