---
title: "Self-Healing Logic (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-28"
---

# Purpose
The **Self-Healing Logic** (`G11_self_healing_logic.py`) provides system-level robustness by automatically recovering from common failures. It monitors the activity logs, retries failed scripts, and clears stale lock files to ensure continuous operation without manual intervention.

# Scope
- **In Scope:** Retriable script failures, stale `/tmp/*.lock` files older than 30 minutes.
- **Out Scope:** Critical financial scripts (G05 budget/liquidity rebalancers) requiring manual approval, persistent network outages.

# Inputs/Outputs
- **Inputs:** `system_activity_log` from the Digital Twin database.
- **Outputs:** Script execution triggers and log activity.

# Dependencies
- **Systems:** S04 (Digital Twin), S08 (Automation Orchestrator), G11 (Meta-System)
- **Database:** `digital_twin_michal` (activity log)

# Procedure
- Executed by `autonomous_daily_manager.py` before and after parallel task execution.
- Can be run manually: `python3 scripts/G11_self_healing_logic.py`.

# Key Features
- **Priority-Based Retry Policies:** Utilizes a `RETRY_POLICIES` map to assign specific limits based on script criticality.
    - **API/Sync (Critical):** Up to 10 retries for `G04_digital_twin_api.py`.
    - **Orchestration:** 5 retries for `G11_global_sync.py`.
    - **Flaky APIs:** Limited to 2 retries for `G07_zepp_sync.py` to prevent rate-limiting.
- **Manifest-Aware Recovery:** Automatically identifies script paths via name-mapping from the `system_activity_log`.
- **Lock Sanitization:** Clears stale `.lock` files from `/tmp/` and the `scripts/` directory if they are older than 30 minutes.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Recursive Failure | Max retries reached (variable per script) | Log failure and skip; requires manual fix |
| Database Offline | Script logs DB error | Fails silently to prevent crash during sync |
| Permission Denied | subprocess.run error | Check sudo requirements for /tmp/ cleanup |

# Security Notes
- Script retries occur in the same environment as original scripts.
- Uses `load_dotenv` for DB credentials.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Weekly (Goal G11 health check)
