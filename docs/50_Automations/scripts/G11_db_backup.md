---
title: "G11: Automated Database Backup"
type: "automation_spec"
status: "active"
automation_id: "G11_db_backup.py"
goal_id: "goal-g11"
systems: ["S03"]
owner: "Michal"
updated: "2026-04-18"
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
1.  **Preparation:** Checks for existence of standardized backup directory (`_meta/backups/db/`).
2.  **Container Discovery:** Autonomously identifies the active PostgreSQL Docker container using `docker ps`.
3.  **Authentication (Syntax Repair):** Uses `docker exec -e PGPASSWORD=${DB_PASSWORD}` for secure, non-interactive execution within the container environment, resolving previous syntax errors with legacy password handling.
4.  **Execution:** Loops through the database list and executes `pg_dump` via the identified container.
5.  **Verification:** Checks exit codes for each dump operation and cleans up incomplete files on failure.

## Outputs
- **Storage:** Normalized `.sql` backup files in `_meta/backups/db/` with datestamped filenames (e.g., `autonomous_health_2026-04-18.sql`).
- **Centralized Logging:** Reports `SUCCESS`, `PARTIAL`, or `FAILURE` status to `system_activity_log`.

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
