---
title: "G01: Progressive Overload Analyzer (HIT-Focused)"
type: "automation_spec"
status: "active"
automation_id: "G01_progressive_overload.py"
goal_id: "goal-g01"
systems: ["S07", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G01: Progressive Overload Analyzer (HIT-Focused)

## Purpose
Ensures training progression by analyzing Time Under Tension (TUT) and intensity in High-Intensity Training (HIT) sessions. The system autonomously evaluates and approves weight increases when muscular failure is being reached too late (TUT > 90s).

## Key Features
- **Effort-First Logic:** Prioritizes intensity and TUT over Reps x Sets volume.
- **Progression Triggers:** Specifically alerts when TUT exceeds the 90-second threshold for any exercise.
- **Autonomous Decisioning:** Integrates with `G11_rules_engine` to auto-approve weight increases based on `health.auto_weight_increase` policy.
- **Noise Reduction:** Automatically hides exercises that are stable or haven't yet reached the TUT threshold.

## Triggers
- **Scheduled:** Part of the `autonomous_daily_manager.py` daily dashboard generation.
- **Manual:** `python3 scripts/G01_progressive_overload.py`

## Inputs
- **Database:** `autonomous_training` (Tables: `workout_sets`, `exercises`).
- **KPI:** `max_tut` (Time Under Tension in seconds).

## Processing Logic
1.  **Data Retrieval:** Fetches the last 3 sessions for every exercise in the database.
2.  **TUT Evaluation:**
    *   If **TUT > 90 seconds**: Suggests increasing the weight by 2.0kg.
    *   **Policy Evaluation:** Calls `G11_rules_engine` with `health.auto_weight_increase` policy and current performance context.
    *   **Autonomous Action:** If the engine returns `AUTO_ACT`, the report marks the increase as **🚀 AUTO-ACT**.
    *   **NEW:** If **TUT <= 90 seconds**, the exercise is skipped from the report to maintain focus.
3.  **Reporting:** Generates a formatted Markdown report for injection into the Obsidian Daily Note.

## Outputs
- **Markdown Report:** Injected into the `%%TRAINING_DETAILS%%` section of the Daily Note.
- **System Activity Log:** Records a `SUCCESS` entry with the count of TUT alerts generated.

## Dependencies
### Systems
- [S07 Predictive Health Management](../../10_Goals/G07_Predictive-Health-Management/README.md)
- [G01 Target Body Fat](../../10_Goals/G01_Target-Body-Fat/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No Training Data | Empty DataFrame | Returns "No training data available" | Log Info |
| DB Connectivity | `psycopg2.OperationalError` | Log failure, abort analysis | System Activity Log |
| Missing TUT Data | `None` in `max_tut` column | Defaults to 0s for that session | Log Warning |

## Manual Fallback
If the analyzer provides incorrect suggestions:
1.  Verify the `workout_sets` table in the `autonomous_training` database for manual entry errors.
2.  Adjust the 90s threshold directly in `scripts/G01_progressive_overload.py` if training goals shift.
