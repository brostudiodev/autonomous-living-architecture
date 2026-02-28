---
title: "G01_training_planner.py: HIT Session Recommender"
type: "automation_spec"
status: "active"
automation_id: "training-planner"
goal_id: "goal-g01"
systems: ["S04", "S06"]
owner: "Michal"
updated: "2026-02-24"
---

# G01_training_planner.py: HIT Session Recommender

## Purpose
Analyzes historical workout frequency and recovery scores from the database to provide data-driven recommendations for the next High Intensity Training (HIT) session.

## Triggers
- **Internal Call:** Invoked by the Digital Twin API (`GET /training`).
- **Internal Call:** Invoked by the `autonomous_daily_manager.py` for schedule generation.
- **Manual:** `python3 scripts/G01_training_planner.py`

## Inputs
- **PostgreSQL:** `autonomous_training` database (table: `workouts`).
- **Logic:** HIT-specific recovery rules (48-72h window).

## Processing Logic
1. Fetch the date and recovery score of the last recorded workout.
2. Calculate "Days Since Last Workout".
3. Apply HIT CNS Recovery Rules:
   - < 2 days: Mandatory Rest.
   - 2 days: Rest/Active Recovery (Green if last score >= 4, Yellow otherwise).
   - >= 3 days: TRAIN TODAY (suggestion alternates templates).
4. Suggest the next template based on the previous one (e.g., Full Body → Lower).

## Outputs
- **JSON/Text:** Action (Rest/Train), Status (Ready/Recovering), and Suggested Template.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception caught | Returns error message in text | Console log |
| No History Found | Empty Result | Suggests starting with Full Body | None |

## Monitoring
- **API Health:** `curl http://localhost:5677/training`
- **Dashboard:** Integration into Telegram dashboard.
