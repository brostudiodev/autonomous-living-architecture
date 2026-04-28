---
title: "System Vital Sentinel (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-28"
---

# Purpose
The **System Vital Sentinel** (`G11_system_vital_sentinel.py`) provides enterprise-grade infrastructure monitoring for the Autonomous Living host. It ensures that critical Docker containers are running and that disk space is available for system operations.

# Scope
- **In Scope:** Monitoring disk usage on `/`, tracking core Docker containers (Postgres, n8n, API, etc.), auto-restarting failed critical containers.
- **Out Scope:** Monitoring hardware temperature or network traffic (handled by S01 Observability).

# Logic
- **Disk Alert:** Flags `⚠️` at > 85% and `🚨` at > 95% usage.
- **Auto-Healing:** If a critical container is in `Exited` or `Restarting` state, the sentinel attempts exactly **one auto-restart**.
- **Reporting:** Injects status into the `HARDWARE` dashboard section.

# Inputs/Outputs
- **Inputs:** `df` command (Disk), `docker ps` command (Containers).
- **Outputs:** Infrastructure health report and restart triggers.

# Dependencies
- **Systems:** S01 (Observability), G11 (Meta-System)
- **Tools:** `docker` CLI, `shutil`

# Procedure
- Automatically executed as part of the daily sync.
- Logs successes and persistent failures to `system_activity_log`.

# Failure Modes
| Scenario | Response |
|----------|----------|
| Docker Daemon Down | Script logs error; dashboard shows ⚠️. |
| Restart Loop | Sentinel only attempts one restart per run to prevent cascading loops. |

# Security Notes
- Requires permission to run `docker` commands.
- No sensitive data is exposed in health reports.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify list of critical containers)
