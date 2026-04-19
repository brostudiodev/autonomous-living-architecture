---
title: "System Sanity Auditor (G11)"
type: "automation_spec"
status: "active"
owner: "Michal"
updated: "2026-04-16"
---

# Purpose
The **System Sanity Auditor** (`G11_system_sanity_auditor.py`) provides a proactive "Smoke Test" for the entire Autonomous Living ecosystem. It verifies that every script in the system is healthy (dependencies met, database connections working, API keys valid) without actually executing their functional logic.

# Scope
- **In Scope:** All scripts registered in `G04_tool_manifest.json`, environment variable verification, database connectivity checks, dependency validation.
- **Out Scope:** Functional testing of script logic, data integrity validation (handled by domain-specific auditors).

# Logic
- **AUDIT_MODE Protocol:** Every functional script supports an `AUDIT_MODE=1` environment variable. When set, the script performs a non-destructive health check and exits with `0` (Healthy) or `1` (Broken).
- **Orchestration:** The auditor iterates through the `G04_tool_manifest.json`, executes each script in `AUDIT_MODE`, and captures the output.
- **Reporting:** Results are logged as `SANITY_CHECK` entries in the `system_activity_log` and summarized in a "Health Grid" for the Obsidian Daily Note.

# Inputs/Outputs
- **Inputs:** `G04_tool_manifest.json`, individual script exit codes and stdout/stderr.
- **Outputs:** `system_activity_log` entries (SUCCESS/FAILURE), Health Grid in Obsidian Daily Note (`%%G11_RELIABILITY_START%%`).

# Dependencies
- **Systems:** G11 (Meta-System Integration), G04 (Digital Twin Ecosystem)
- **Database:** `digital_twin_michal` (for logging)
- **Files:** `scripts/_meta/G04_tool_manifest.json`

# Procedure
### Manual Execution (On-Demand Audit)
To verify the system state manually (e.g., after updating dependencies or `.env` files), run the following command from the project root:
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 scripts/G11_system_sanity_auditor.py
```

### Dashboard Integration
The script is integrated into the "System Actions" bar in the Obsidian Daily Note. Clicking **[⚡ Sanity Audit]** triggers a background check and refreshes the health grid.

### Automated Execution
- Integrated into the daily synchronization workflow (`autonomous_daily_manager.py`).

# Failure Modes
| Scenario | Response |
|----------|----------|
| Manifest Missing | Script exits with error; no audit performed. |
| Script Missing | Logged as FAILURE in the health grid with "File missing". |
| Timeout (30s) | Audit for that specific script is marked as FAILURE. |
| DB Connectivity | Fails the auditor's own logging; printed to stderr. |

# Security Notes
- Requires read/write access to `system_activity_log`.
- Executes scripts in a subprocess; standard system permissions apply.

# Owner + Review Cadence
- **Owner:** Michal
- **Review:** Bi-weekly (ensure new scripts are added to manifest and support `AUDIT_MODE`).
