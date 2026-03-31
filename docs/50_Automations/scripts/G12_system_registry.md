---
title: "G12: Meta-System Dashboard Registry"
type: "automation_spec"
status: "active"
automation_id: "G12_system_registry.py"
goal_id: "goal-g12"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-03-19"
---

# G12: Meta-System Dashboard Registry

## Purpose
Acts as the central "Heartbeat" aggregator for the entire Autonomous Living ecosystem. It collects metrics from the PostgreSQL database and the documentation audit report to generate a high-level executive dashboard in Obsidian.

## Triggers
- **Scheduled:** Part of the `G11_global_sync.py` registry (runs 3x daily).
- **Manual:** `python3 scripts/G12_system_registry.py`

## Inputs
- **Database:** `digital_twin_michal` (Tables: `system_activity_log`, `autonomous_decisions`, `decision_requests`).
- **Files:** `docs/G12_Documentation_Audit_Report.md`.

## Processing Logic
1.  **Automation Analytics:** Calculates the success rate of all scripts over the last 24 hours.
2.  **Autonomy Metrics:** Counts decisions made today and identifies pending human-in-the-loop approvals.
3.  **Documentation Parsing:** Extracts the documentation health percentage from the latest audit report.
4.  **Surgical Update:** Overwrites `99_System/Meta-System-Dashboard.md` with a clean, formatted Markdown table and status report.

## Outputs
- **Obsidian Dashboard:** `99_System/Meta-System-Dashboard.md`.
- **Console Feedback:** Confirmation of the dashboard update.

## Dependencies
### Systems
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)
- [G12 Complete Process Documentation](../../10_Goals/G12_Complete-Process-Documentation/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | `psycopg2` exception | Defaults to "Error" in dashboard | Console Output |
| Audit File Missing | `os.path.exists` failure | Reports health as "Unknown" | Dashboard Status |

## Manual Fallback
If the dashboard is stale:
1.  Run the audit first: `python3 scripts/G12_documentation_audit.py`.
2.  Run the registry: `python3 scripts/G12_system_registry.py`.
