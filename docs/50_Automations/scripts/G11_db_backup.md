---
title: "G11: Automated Database Backup"
type: "automation_spec"
status: "active"
automation_id: "G11_db_backup.py"
goal_id: "goal-g11"
systems: ["S03"]
owner: "Michal"
updated: "2026-03-11"
---

# G11: Automated Database Backup

## Purpose
Ensures disaster recovery capability by performing daily logical backups (`pg_dump`) of all seven core PostgreSQL databases in the autonomous ecosystem.

## Triggers
- **Automated:** Executed as part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G11_db_backup.py`

## Inputs
- PostgreSQL Instance: Localhost (Port 5432).
- Credentials: `DB_PASSWORD` from `.env`.
- Database List: `autonomous_health`, `autonomous_finance`, `autonomous_pantry`, `autonomous_training`, `autonomous_learning`, `autonomous_life_logistics`, `digital_twin_michal`.

## Processing Logic
1.  **Preparation:** Checks for existence of backup directory (`_meta/backups/db`).
2.  **Authentication:** Sets the `PGPASSWORD` environment variable for non-interactive execution.
3.  **Execution:** Loops through the database list and executes `pg_dump`.
4.  **Verification:** Checks exit codes for each dump operation.

## Outputs
- **Storage:** `.sql` backup files in `_meta/backups/db/` with datestamped filenames.
- **Centralized Logging:** Reports `SUCCESS` or `PARTIAL` status to `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

### External Tools
- `pg_dump` (PostgreSQL client utility)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Disk Full | `pg_dump` exit code 1 | Log failure | System Activity Log |
| Permission Denied | Folder write error | Log failure | System Activity Log |

## Manual Fallback
If backups fail:
1.  Manually run `pg_dump` from the command line.
2.  Use a GUI tool (like pgAdmin or DBeaver) to export the database schemas and data.
