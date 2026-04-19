---
title: "script: G01 Strength Gains Reporter"
type: "automation_spec"
status: "active"
automation_id: "G01_strength_gains_reporter"
goal_id: "goal-g01"
systems: ["S01", "S03"]
owner: "Michal"
updated: "2026-02-25"
---

# script: G01_strength_gains_reporter.py

## Purpose
Generates a weekly Markdown report in Obsidian summarizing HIT strength progression and providing AI-driven recommendations based on the `v_hit_progression` SQL view. This bridges the gap between raw data and actionable training decisions.

## Triggers
- **Manual:** `python3 scripts/G01_strength_gains_reporter.py`
- **Global Sync:** Automatically triggered as part of `G11_global_sync.py`.

## Inputs
- **PostgreSQL:** `autonomous_training` database (`v_hit_progression` view).
- **Time Window:** Last 7 days.

## Processing Logic
1. Queries the `v_hit_progression` view for all exercises performed in the last 7 days.
2. Calculates weight differences between the current and previous sessions.
3. Formats the data into a Markdown table including current weight, change, TUT, and the AI recommendation.
4. Saves the report to `03_Areas/A - Life/Health/Strength Reports/Strength-Gains-YYYY-MM-DD.md`.

## Outputs
- **Markdown Report:** A dated file in the Obsidian Vault for review.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL database.
- [S01 Observability](../../20_Systems/S01_Observability-Monitoring/README.md) - Progress reporting.

### External Services
- Obsidian (File system)

## Credentials
- DB Access: `DB_USER:DB_PASSWORD@localhost:5432` via `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | `psycopg2.OperationalError` | Script logs error and exits | Console |
| View Missing | `psycopg2.errors.UndefinedTable` | Script logs error (schema mismatch) | Console |

## Manual Fallback
Review the `v_hit_progression` view directly in pgAdmin or Grafana to make training decisions.
