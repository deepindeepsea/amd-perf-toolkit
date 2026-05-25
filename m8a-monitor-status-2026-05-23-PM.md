# M8A Testing Monitor — Scheduled Run Status

**Run time:** 2026-05-23 (PM) — scheduled task `m8a-testing-monitor`
**Instance:** i-082ca0124af7a18d0 (m8a.metal-24xl, AMD EPYC 9R45 / Zen5 Turin)
**Outcome:** Blocked — same environment limitation as the 05-24 05:22 UTC run

## What happened

This scheduled task ran inside the isolated Cowork Linux sandbox VM. Neither
of the two required actions was possible from the sandbox:

1. **SSH to `m8a` (i-082ca0124af7a18d0)** — `ssh: Could not resolve hostname m8a`.
   The `~/.ssh/config` entry with the AWS SSM `ProxyCommand` lives on the
   Windows host (`C:\Users\pradeepn\.ssh\config`), not in the sandbox. The
   sandbox also has no `aws` CLI and no SSM session manager plugin.

2. **Send the status email via `m365-email`** — no Microsoft Graph token at
   `~/.config/microsoft-graph/token.json` inside the sandbox. The shared
   token lives on the host under the user profile.

No fresh testing data was collected and no email was sent to PradeepN@AMD.com.

## Why this keeps happening

The scheduled task definition assumes host-machine credentials (SSH config,
AWS CLI, Graph OAuth token), but Cowork scheduled tasks execute in the
ephemeral sandbox VM that does not inherit those.

## Recommended fixes (unchanged from prior run)

- **Run the monitor on the Windows host** via a PowerShell scheduled task or
  WSL cron using the same prompt, so it inherits SSH + Graph credentials.
- **Or** bootstrap the sandbox: mount/copy `~/.ssh/config`, the SSM plugin,
  AWS CLI, and the Graph token before the monitoring steps run.

## Manual one-liner to get the same snapshot from the Windows host

```bash
ssh m8a 'cd ~/rails-benchmark-amd && \
  echo "== procs ==";   pgrep -af "puma|ruby|benchmark_ccd_sweep" || echo none; \
  echo "== results =="; ls -lt results/ 2>/dev/null | head -20; \
  echo "== reports =="; ls -lt *.html *.xlsx 2>/dev/null | head; \
  echo "== load ==";    uptime; \
  echo "== cpu ==";     mpstat 1 1 | tail -3'
```

## Action required

Until the task is migrated to a host-side runner (or the sandbox is provisioned
with SSH + Graph access), this scheduled monitor will continue to no-op.
