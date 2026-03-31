---
title: "G04: Digital Twin Core Engine"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_engine.py"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
updated: "2026-03-20"
---

# G04: Digital Twin Core Engine

## Purpose
The primary "brain" of the Autonomous Living ecosystem. This script aggregates data from all subsystems (Finance, Health, Logistics, Pantry, etc.) to provide holistic insights, generate strategic directives, and maintain the cross-domain correlation engine.

## Key Features
- **State Aggregation:** Pulls current reality from 7+ PostgreSQL databases.
- **Strategic Memory:** Records and retrieves "strategic_memory" to maintain contextual continuity across days.
- **Correlation Engine:** Detects patterns between domains (e.g., Caffeine vs. REM Sleep, Budget vs. Pantry).
- **Morning Directive:** Generates the "Primary Directive" for the Morning Mission Briefing.
- **Autonomy ROI:** Calculates time saved via automated systems.

## Triggers
- **Internal:** Called by `G04_digital_twin_api.py` and `autonomous_daily_manager.py`.
- **Manual:** `python3 scripts/G04_digital_twin_engine.py` (prints suggested report).

## Inputs
- **Databases:** `digital_twin_michal`, `autonomous_finance`, `autonomous_health`, `autonomous_pantry`, `autonomous_training`, `autonomous_learning`, `autonomous_life_logistics`.
- **Obsidian:** Scans `02_Projects/` for active roadmap statuses.

## Outputs
- **Twin State:** A unified JSON state object used by the API and Bot.
- **Director's Insights:** Markdown formatted insights for the Daily Note.
- **Snapshots:** Persists daily system state to `twin_state_snapshots`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sub-DB Offline | `psycopg2` error | Skips that domain, populates error msg | Log Info |
| Memory Full | Disk space check | Rotates older logs | Log Warning |

## Manual Fallback
If the engine is failing:
1. Check connectivity to all Postgres databases.
2. Run `python3 scripts/G04_digital_twin_engine.py` to see domain-specific error messages.
