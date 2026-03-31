---
title: "G01: Training Planner"
type: "automation_spec"
status: "active"
automation_id: "G01_training_planner"
goal_id: "goal-g01"
systems: ["S06"]
owner: "Michal"
updated: "2026-03-31"
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
1.  **Context Fetching:** Retrieves latest `readiness_score` (G07) and last workout data (G01).
2.  **Recovery Check:** If `readiness_score < 55`, recommends **RECOVERY / YOGA**.
3.  **Volume Check:** Enforces at least 48h rest between high-intensity sessions.
4.  **Session Suggestion:** Rotates templates (Session A/B) when `readiness_score >= 65`.
5.  **Dynamic Progression (NEW Mar 31):**
    *   **Peak State (>85):** Suggests aggressive overload (+1kg weight or +2s TUT).
    *   **Stable State (65-85):** Standard progression suggestions.
    *   **Low Readiness (<65):** Maintenance-only session; PR attempts discouraged.
6.  **Rules Engine Integration:** Logs suggestions to `autonomous_decisions`. Low-readiness conflicts are routed through the `health.auto_workout_adjustment` policy.

## Outputs
- **Database:** `autonomous_decisions` updates.
- **Console:** Formatted recommendation text including progression adjustment.
- **Obsidian:** Integrated into Daily Note dashboard.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S06 Health Performance System](../../20_Systems/S06_Health-Performance/README.md)

---
*Updated: 2026-03-31 | Dynamic Progression documented.*
