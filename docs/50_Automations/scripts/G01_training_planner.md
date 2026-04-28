---
title: "G01: Training Planner"
type: "automation_spec"
status: "active"
automation_id: "G01_training_planner"
goal_id: "goal-g01"
systems: ["S06"]
owner: "Michał"
updated: "2026-04-23"
---

# G01: Training Planner

## Purpose
Analyzes recent training performance and current biological readiness to suggest the optimal next workout session or recovery protocol.

## Triggers
- **Scheduled:** Part of `G11_global_sync.py` and `autonomous_daily_manager.py`.
- **Manual:** `python3 scripts/G01_training_planner.py`.

## Inputs
- **Database:** `workouts` in `autonomous_training` (for recovery score and history).
- **Database:** `biometrics` in `autonomous_health` (for `readiness_score`).

## Processing Logic
1.  **Context Fetching:** Retrieves latest `readiness_score` and `hrv_ms` (G07) and last workout data (G01).
2.  **HRV Analysis (NEW Apr 23):** Calculates `hrv_suppression_pct` by comparing current `hrv_ms` against the 7-day average.
3.  **Recovery Check:** If `readiness_score < 55`, recommends **RECOVERY / YOGA**.
4.  **Volume Check:** Enforces at least 48h rest between high-intensity sessions.
5.  **Session Suggestion:** Rotates templates (Session A/B) when `readiness_score >= 65`.
6.  **Dynamic Progression:**
    *   **Peak State (>85):** Suggests aggressive overload (+1kg weight or +2s TUT).
    *   **Stable State (65-85):** Standard progression suggestions.
    *   **Low Readiness (<65):** Maintenance-only session; PR attempts discouraged.
7.  **Rules Engine Integration:** 
    *   Logs suggestions to `autonomous_decisions`. 
    *   **Context Fix (Apr 23):** Passes `hrv_suppression_pct` and `is_safe_downgrade` to the `health.auto_workout_adjustment` policy, enabling autonomous decision-making for training intensity adjustments.

## Outputs
- **Database:** `autonomous_decisions` updates.
- **Console:** Formatted recommendation text including progression adjustment.
- **Obsidian:** Integrated into Daily Note dashboard.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance System](../../20_Systems/S06_Health-Performance/README.md)

---
*Updated: 2026-04-23 | Fixed HRV suppression context for Rules Engine.*
