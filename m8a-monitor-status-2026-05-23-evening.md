# M8A Testing Monitor — Scheduled Run Status

**Run time:** 2026-05-23 evening — scheduled task `m8a-testing-monitor`
**Instance:** i-082ca0124af7a18d0 (m8a.metal-24xl, AMD EPYC 9R45 / Zen5 Turin)
**Outcome:** Blocked (4th consecutive no-op) — sandbox environment limitation

## Summary

Same blockers as the three prior runs documented in:
- `m8a-monitor-status-2026-05-23.md`
- `m8a-monitor-status-2026-05-23-PM.md`
- `m8a-monitor-status-2026-05-23-late.md`
- `m8a-monitor-status-2026-05-24.md`

This scheduled task runs inside the Cowork sandbox VM which does not have:

1. SSH access to `m8a` — `ssh: Could not resolve hostname m8a`. The
   `~/.ssh/config` entry with the AWS SSM `ProxyCommand` lives on the
   Windows host, not in the sandbox. No `aws` CLI, no SSM plugin.
2. Microsoft Graph token at `~/.config/microsoft-graph/token.json` — so
   `m365-email` cannot send the status email to PradeepN@AMD.com.

## Verification performed this run

- `ssh -o ConnectTimeout=30 m8a` → name resolution failure
- `ls ~/.ssh/` → directory does not exist
- Reviewed prior run reports — situation unchanged

## No fresh data collected. No email sent.

## Recommended next action

Please pick one of the following so this monitor stops no-op'ing:

1. **Disable the scheduled task** until it can be re-homed.
2. **Re-home to Windows host** as a Task Scheduler / WSL cron job that
   inherits `~/.ssh/config` and the Graph OAuth token.
3. **Provision the sandbox** with SSH config + AWS SSM + Graph token at
   each run (heavier lift).

## Reference one-liner (run manually from Windows host)

```bash
ssh m8a 'cd ~/rails-benchmark-amd && \
  echo "== procs ==";   pgrep -af "puma|ruby|benchmark_ccd_sweep" || echo none; \
  echo "== results =="; ls -lt results/ 2>/dev/null | head -20; \
  echo "== reports =="; ls -lt *.html *.xlsx 2>/dev/null | head; \
  echo "== load ==";    uptime'
```
