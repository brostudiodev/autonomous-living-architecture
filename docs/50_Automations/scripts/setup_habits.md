---
title: "G11: Habits System Setup"
type: "automation_spec"
status: "active"
automation_id: "setup_habits"
goal_id: "goal-g11"
systems: ["S04"]
owner: "Michal"
updated: "2026-03-25"
---

# G11: Habits System Setup

## Purpose
Initializes and seeds the `habits` table in the Digital Twin database to support decoupled habit tracking.

## Triggers
- **Manual:** Executed once to initialize the system or add new base habits.
- **Workflow:** Part of the G11 meta-system maintenance cycle.

## Inputs
- **PostgreSQL Connection:** Requires access to the `digital_twin_michal` database.
- **Environment Variables:** `DB_PASSWORD`, `DB_USER`, `DB_HOST`.

## Processing Logic
1. **Schema Creation:** Creates the `habits` table with columns: `id`, `habit_name`, `frequency`, `last_completed`, `streak`, and `category`.
2. **Seeding:** Injects foundational habits (e.g., "Filip: Szczotkowanie zębów") if the table is empty.
3. **Commit:** Finalizes database transactions.

## Outputs
- **Database Table:** `habits` table in `digital_twin_michal`.
- **Seed Data:** Initial rows for core daily/weekly maintenance tasks.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

### External Services
- PostgreSQL instance (Local/Docker)

### Credentials
- Database root credentials via `.env`.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Failure | Exception caught | Log error and exit | Log error |
| Table Collision | Table already exists | Skips creation, proceed to seed | None |
| Duplicate Seeds | Unique constraint violation | Catch and skip | Log warning |

## Monitoring
- **Success Metric:** `SELECT COUNT(*) FROM habits;` returns > 0.

## Manual Fallback
If the script fails, habits must be manually inserted via `psql` or a database GUI.
