# M8A Testing Monitor — Scheduled Run Status

**Run time:** 2026-05-24 05:22 UTC
**Task:** m8a-testing-monitor
**Outcome:** Blocked — could not execute

## What happened

The scheduled task ran inside an isolated Cowork Linux sandbox VM. From that
sandbox, neither of the two required actions was possible:

1. **SSH to `i-082ca0124af7a18d0` (host alias `m8a`)** — failed:
   `ssh: Could not resolve hostname m8a: Name or service not known`.
   The `~/.ssh/config` entry and the AWS SSM Session Manager plugin live on
   the host Windows machine (`C:\Users\pradeepn\.ssh\config`), not inside
   the sandbox. The sandbox also has no `aws` CLI installed.

2. **Send email via `m365-email`** — no Microsoft Graph token present at
   `~/.config/microsoft-graph/token.json` inside the sandbox. The shared
   token lives on the host.

No testing data was collected and no email was sent.

## To run this monitor successfully

This task needs to execute in an environment that has access to:

- The user's `~/.ssh/config` (with the `m8a` host entry and SSM proxy command)
- The AWS CLI + Session Manager plugin
- The Microsoft Graph token under `~/.config/microsoft-graph/token.json`

Two reasonable fixes:

- **Run the monitor directly on the Windows host** (PowerShell scheduled task
  or WSL cron) using the same SKILL.md prompt, so it inherits the user's SSH
  and Graph credentials.
- **Or** add a small bootstrap step in the task that mounts/copies the host
  SSH config and Graph token into the sandbox before the monitoring steps —
  along with installing `aws` and the SSM plugin.

## Suggested manual check (one-liner)

Until the monitor can run end-to-end, the user can get the same snapshot from
their Windows machine with:

```bash
ssh m8a 'cd ~/rails-benchmark-amd && \
  echo "== procs =="; pgrep -af "puma|ruby|benchmark_ccd_sweep" || echo none; \
  echo "== results =="; ls -lt results/ 2>/dev/null | head -20; \
  echo "== reports =="; ls -lt *.html *.xlsx 2>/dev/null | head; \
  echo "== load =="; uptime; \
  echo "== cpu =="; mpstat 1 1 | tail -3'
```
