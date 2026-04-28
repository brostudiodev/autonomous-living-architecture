---
title: "System Reliability Auditor (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **System Reliability Auditor** (`G11_system_reliability_auditor.py`) provides meta-level observability for the Autonomous Living ecosystem. It identifies flaky automations and calculates a global reliability score, ensuring the system remains an asset rather than an overhead.

# Scope
- **In Scope:** Success rates of all G-series scripts, global system health score, identification of failing trends.
- **Out Scope:** Fixing the failures (handled by G11 Self-Healing Logic).

# Logic
- **Success Rate:** `(Successes / Total Runs) * 100`.
- **Exclusion Rule (NEW Apr 13):** Archived or deprecated scripts (e.g., `G10_schedule_negotiator`, `G11_friction_resolver`) are excluded from metrics to prevent data noise.
- **Global Score:** Weighted average of all core script success rates over the **last 7 days**.
- **Flaky Detection:** Success Rate **< 90%** with a minimum of 3 runs.

# Inputs/Outputs
- **Inputs:** `system_activity_log` from the Digital Twin database.
- **Outputs:** Reliability report and "Flaky List" for the Obsidian dashboard.

# Dependencies
- **Systems:** S01 (Observability), G11 (Meta-System)
- **Database:** `digital_twin_michal`

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the daily sync.

# Failure Modes
| Scenario | Response |
|----------|----------|
| No Logs | Script returns empty report. |
| DB Error | System logs failure; dashboard shows ⚠️ status. |

# Security Notes
- Read-only access to system logs.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Weekly (investigate any script with < 90% reliability)
