# M8A Testing Monitor — Scheduled Run Status

**Run time:** 2026-05-23 night — scheduled task `m8a-testing-monitor` (5th no-op)
**Instance:** i-082ca0124af7a18d0 (m8a.metal-24xl, AMD EPYC 9R45 / Zen5 Turin)
**Outcome:** Blocked — sandbox environment limitation (unchanged from 4 prior runs)

## Summary

Same blockers as all previous runs today. The Cowork sandbox VM cannot:

1. **SSH to `m8a`** — `ssh: Could not resolve hostname m8a`. The SSH
   config + AWS SSM `ProxyCommand` lives on the Windows host, not in
   the sandbox. No `aws` CLI / SSM plugin installed.
2. **Send email via m365-email** — no Microsoft Graph token at
   `~/.config/microsoft-graph/token.json`. No email was sent to
   PradeepN@AMD.com.

## Verification performed this run

- `ssh -o ConnectTimeout=30 m8a` → name resolution failure
- `ls ~/.ssh/` and `ls ~/.config/microsoft-graph/` → both missing
- Reviewed prior status files — situation identical

## Recommended next action (repeated)

The scheduled task should be **disabled** or **re-homed to the Windows
host** (Task Scheduler / WSL cron) where the SSH config and Graph token
exist. Otherwise it will continue to no-op on every interval.

## Reference one-liner (run manually from Windows host)

```bash
ssh m8a 'cd ~/rails-benchmark-amd && \
  echo "== procs ==";   pgrep -af "puma|ruby|benchmark_ccd_sweep" || echo none; \
  echo "== results =="; ls -lt results/ 2>/dev/null | head -20; \
  echo "== reports =="; ls -lt *.html *.xlsx 2>/dev/null | head; \
  echo "== load ==";    uptime'
```
