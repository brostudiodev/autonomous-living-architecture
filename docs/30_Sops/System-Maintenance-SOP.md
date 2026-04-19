---
title: "SOP: System Maintenance & Self-Healing"
type: "sop"
status: "active"
owner: "Michal"
updated: "2026-04-02"
---

# Purpose
This SOP defines the procedures for maintaining system stability and responding to automated self-healing events within the Autonomous Living ecosystem.

# Scope
- **In Scope:** Monitoring script failure logs, managing lock files, and responding to "Manual Fix" mission tasks.
- **Out Scope:** Fixing logic errors in Python scripts (refer to [Development Standard](../10_Goals/Documentation-Standard.md)).

# Procedure

## 1. Daily Review (Morning Sync)
The `autonomous_daily_manager.py` executes `G11_self_healing_logic.py` automatically.
- **Action:** Open your Daily Note and check the **Golden Mission** list.
- **Trigger:** If you see 🩹 **Manual Fix: [script_name]**, it means the self-healer reached 3 retries and failed.

## 2. Manual Troubleshooting
If a script requires manual intervention:
1.  **Check Logs:** Query the database for the specific error message:
    ```sql
    SELECT * FROM system_activity_log WHERE script_name = 'failed_script.py' ORDER BY logged_at DESC LIMIT 5;
    ```
2.  **Clear Locks:** If the script failed due to a "Lockfile exists" error and it's not actually running:
    ```bash
    rm /tmp/failed_script.lock
    ```
3.  **Run Manually:** Attempt to execute the script from the terminal to see real-time output:
    ```bash
    {{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 {{ROOT_LOCATION}}/autonomous-living/scripts/failed_script.py
    ```

## 3. Weekly Database Cleanup
The system rotates local backups, but if disk space is low:
- **Action:** Check `_meta/backups/db/`.
- **Command:** `du -sh _meta/backups/db/`
- **Retention:** Ensure only `.gpg` files are present. Unencrypted `.sql` files should be deleted immediately.

# Failure Modes
| Scenario | Response |
|----------|----------|
| Persistent Failure | Disable the script in `autonomous_daily_manager.py` parallel list until fixed. |
| DB Connection Loss | Check if the Postgres container is healthy: `docker ps`. |
| GPG Failure | Check disk space or passphrase validity in `.env`. |

# Security Notes
- Maintenance tasks often require database access. Always use the `.venv` Python interpreter to ensure `psycopg2` and other dependencies are loaded correctly.

# Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (during G11 system audit)
