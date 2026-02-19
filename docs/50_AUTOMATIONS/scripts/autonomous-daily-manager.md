---
title: "script: autonomous-daily-manager.py"
type: "automation_spec"
status: "active"
automation_id: "autonomous-daily-manager"
goal_id: "goal-g11"
systems: ["S03", "S09"]
owner: "Michał"
updated: "2026-02-19"
---

# script: autonomous-daily-manager.py

## Purpose
Prepares the Obsidian Daily Note every morning by auto-creating it from a template and injecting data-driven task suggestions (workouts, pantry) and a suggested schedule.

## Triggers
- **Scheduled:** Daily at 05:00 AM via Cron.
- **Manual:** `/home/michal/Documents/autonomous-living/.venv/bin/python /home/michal/Documents/autonomous-living/scripts/autonomous_daily_manager.py`

## Inputs
- **Template:** `/home/michal/Documents/Obsidian Vault/99_System/Templates/Daily/Daily Note Template.md`
- **Workout Data:** `/home/michal/Documents/Training/workouts.csv`
- **Finance DB:** PostgreSQL `autonomous_finance` on `localhost:5432` (via Docker).
- **Date:** System current date.

## Processing Logic
1. **Note Creation:** If `YYYY-MM-DD.md` doesn't exist, create it from the template, replacing `{{date}}` and weekday placeholders.
2. **Workout Analysis:** Calculate days since last workout from CSV. If >= 3 days, generate a HIT workout task.
3. **Finance Alerts:** Query `get_current_budget_alerts()` from the database.
4. **Pantry Logic:** Generate restocking tasks (currently placeholder, logic from G03).
5. **Schedule Injection:** Insert a pre-defined 2026-optimized schedule into the note.
6. **Task Injection:** Insert all generated tasks into the `## Tasks (manual planning)` section.

## Outputs
- **Obsidian Note:** Updated or created `/home/michal/Documents/Obsidian Vault/01_Daily_Notes/YYYY-MM-DD.md`

## Dependencies
### Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)
- [S09 Productivity & Time](../../20_SYSTEMS/S09_Productivity-Time/README.md)

### External Services
- PostgreSQL (Docker container)
- Python 3.11+ with `pandas` and `psycopg2`

### Credentials
- **DB User:** `root`
- **DB Pass:** `admin` (Stored in script - *Pending migration to env vars*)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | `psycopg2.connect` exception | Log error, skip finance tasks | Console/Log output |
| Template Missing | `os.path.exists` check | Abort creation | Console/Log output |
| CSV Read Error | `pd.read_csv` exception | Skip workout analysis | Console/Log output |

## Monitoring
- **Success Metric:** Daily note exists and contains "🤖 Suggested Schedule" by 05:15 AM.
- **Logs:** `/home/michal/Documents/autonomous-living/_meta/daily_briefing.log`

## Manual Fallback
If automation fails, manually create the daily note in Obsidian and use the "Daily Note Template". Run the script manually to attempt task injection.

## Related Documentation
- [SOP: Daily Briefing Management](../../30_SOPS/Daily-Briefing-Management.md)
- [Goal: G11 Intelligent Productivity](../../10_GOALS/G11_Intelligent-Productivity-Time-Architecture/README.md)
