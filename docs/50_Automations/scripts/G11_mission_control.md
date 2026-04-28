---
title: "G11: Mission Control (Task Automation)"
type: "automation_spec"
status: "active"
automation_id: "G11_mission_control"
goal_id: "goal-g11"
systems: ["S11", "S10"]
owner: "Michał"
updated: "2026-04-28"
---

# G11: Mission Control (Task Automation)

## Purpose
Bridges the gap between system intelligence and human execution by autonomously injecting high-priority recommendations from the Digital Twin Engine into the user's task management system (Google Tasks).

## Triggers
- **Global Sync:** Part of the `G11_global_sync.py` orchestration cycle.
- **Manual Execute:** `python3 G11_mission_control.py`

## Inputs
- **Digital Twin Engine:** Provides high-priority task recommendations based on current cross-domain state (Health, Finance, Logistics).
- **Google Tasks API:** Used to fetch current tasks for deduplication and inject new missions.

## Processing Logic
1.  **Recommendation Retrieval:** Fetches all active task suggestions from `DigitalTwinEngine.get_task_recommendations()`.
2.  **Filtering:** Selects only tasks with `high` or `medium` priority.
3.  **Deduplication:** Fetches existing tasks from the "Missions (Autonomous)" and "My Tasks" lists to prevent duplicate injections.
4.  **Injection:** 
    - Adds new missions to the **"Missions (Autonomous)"** Google Tasks list.
    - Prepends priority tags (e.g., `[HIGH]`) to the task title for immediate visibility on mobile/calendar.
    - Sets the due date to the current day to ensure they appear in today's focus.
5.  **ROI Tracking:** Logs 2 minutes of "Time Saved" per injected mission to the `autonomy_roi` table.

## Outputs
- **Google Tasks:** New entries in the "Missions (Autonomous)" list.
- **System Activity Log:** Records success and the number of missions injected.
- **ROI Log:** Updates the productivity impact metrics.

## Dependencies
### Systems
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)
- [S09 Productivity & Time Architecture](../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- **Google Tasks API**: Requires valid OAuth2 credentials (`google_tasks_token.pickle`).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Auth Fail | `invalid_grant` or missing token | Logs error, skips injection | System Activity Log |
| Deduplication Fail | Title mismatch | May result in duplicate task | Manual cleanup |
| Engine Offline | Exception in engine call | Logs failure, aborts | System Activity Log |

## Monitoring
- **Success metric**: Number of high-priority missions successfully moved from "System Insight" to "Actionable Task".
- **Audit**: Review the "Missions (Autonomous)" list in Google Tasks.
