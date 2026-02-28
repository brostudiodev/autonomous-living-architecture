---
title: "smart_log_workout.py: DB-First Workout Logger"
type: "automation_spec"
status: "active"
automation_id: "smart-log-workout"
goal_id: "goal-g01"
systems: ["S03", "S06"]
owner: "Michal"
updated: "2026-02-24"
---

# smart_log_workout.py: DB-First Workout Logger

## Purpose
A command-line utility for logging HIT workouts. It treats the PostgreSQL database as the primary source of truth for both pre-filling previous performance data and persisting new logs, while maintaining local CSVs as a backup staging layer.

## Triggers
- **Manual:** `python3 scripts/smart_log_workout.py`

## Inputs
- **PostgreSQL:** `workout_sets` (for previous weights/TUT).
- **Obsidian:** `01_Daily_Notes` (for auto-filling mood/energy).
- **User Input:** Confirmation of weights, durations, and template choice.

## Processing Logic
1. **Fetch Context:** Pulls mood/energy from today's daily note and recovery score from the last DB entry.
2. **Template Selection:** Loads YAML workout configurations.
3. **Data Pre-fill:** Queries `workout_sets` for the most recent weights/TUT for each exercise in the chosen template.
4. **Interactive Log:** Prompts user for current performance, defaulting to previous bests.
5. **DB Persistence:** Performs UPSERT operations on `workouts` and `workout_sets`.
6. **CSV Backup:** Appends data to `sets.csv` and `workouts.csv` for staging/reference.

## Outputs
- **PostgreSQL:** Updated training tables.
- **CSV:** Updated staging files.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Offline | `OperationalError` | Reverts to 0 for pre-fills; logs only to CSV | Terminal Warning |
| Note Missing | `FileNotFoundError` | Uses default values (3/5) | Terminal Warning |

## Manual Fallback
If script fails, log directly into PostgreSQL or the staging CSV files.
