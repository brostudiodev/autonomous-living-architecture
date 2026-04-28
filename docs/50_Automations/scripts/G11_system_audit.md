---
title: "G11: Data Integrity Auditor"
type: "automation_spec"
status: "active"
automation_id: "G11_system_audit.py"
goal_id: "goal-g11"
systems: ["S03", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G11: Data Integrity Auditor

## Purpose
Performs high-level semantic validation of data across multiple domains (Health, Finance, Pantry) to ensure technical connectivity is matched by data logical accuracy. This prevents "Garbage In, Garbage Out" scenarios.

## Triggers
- **Automated:** Executed as part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G11_system_audit.py`

## Inputs
- PostgreSQL Databases: `autonomous_health`, `autonomous_finance`, `autonomous_pantry`.
- Logic Rules: Defined within the script (e.g., weight range, transaction volume).

## Processing Logic
1.  **Health Check:** Verifies today's weight entry exists and falls within a human-reasonable range (40kg - 150kg).
2.  **Finance Check:** Monitors for unusually high transaction counts (>50 per day) which may indicate sync duplication.
3.  **Budget Check:** Flags extreme utilization spikes (>500%) in the current month.
4.  **Pantry Check:** Scans for negative stock values which indicate logging errors.

## Outputs
- **Centralized Logging:** Reports `SUCCESS` if no anomalies are found, or `WARNING` with detailed issue descriptions.
- **Console:** Markdown report of detected issues.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Down | `psycopg2` connection error | Skip domain, log warning | System Activity Log |
| Schema Mismatch | SQL Execution error | Log failure, notify admin | System Activity Log |

## Manual Fallback
If integrity issues are flagged:
1.  Review raw database records for the flagged domain.
2.  Check for upstream API changes (Zepp, Withings, Google Sheets).
3.  Correct the data manually via SQL or Google Sheets sync.
