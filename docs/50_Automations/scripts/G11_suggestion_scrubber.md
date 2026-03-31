---
title: "G11: Suggestion Scrubber"
type: "automation_spec"
status: "active"
automation_id: "G11_suggestion_scrubber"
goal_id: "goal-g11"
systems: ["S04", "S10", "S11"]
owner: "Michal"
updated: "2026-03-19"
---

# G11: G11_suggestion_scrubber.py

## Purpose
Aggregates intelligent system suggestions (Health, Finance, Career, Logistics) from the Digital Twin Engine and synchronizes them to the "Suggestions" list in Google Tasks.

## Triggers
- **Scheduled:** Part of the global sync cycle via `G11_global_sync.py`.
- **Manual:** `python3 scripts/G11_suggestion_scrubber.py`

## Inputs
- **Digital Twin Engine:** `get_task_recommendations()` method.
- **Data Sources:** Combined state of all sub-databases (Health, Finance, Pantry, etc.).

## Processing Logic
1.  Instantiates the `DigitalTwinEngine` to gather current system state and identify gaps or opportunities.
2.  Retrieves structured recommendations (e.g., "Hydration needed", "HIT session overdue", "Review budget breaches").
3.  Formats each recommendation into a Google Task title with appropriate categorization (e.g., `💡 Health: Drink 1250ml more`).
4.  Pushes tasks to the "Suggestions" list in Google Tasks.
5.  Sets the due date to Today to ensure visibility in daily views.
6.  Prevents duplication by matching task titles.

## Outputs
- **Google Tasks:** "Suggestions" list updated with actionable system recommendations.

## Dependencies
### Systems
- [S04 Digital Twin Subsystem](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- Google Tasks API

### Credentials
- `token.json` (User OAuth for Google Tasks)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Auth Fail | `google.auth.exceptions.RefreshError` | Log error, notify manual reauth needed | Console |
| Engine Offline | `Exception` in Engine init | Log failure, skip sync | System Sync Status: ❌ |

## Monitoring
- **Success Metric:** "Suggestions" task count matches engine output.
- **Log:** `system_activity_log` records execution status.

## Manual Fallback
Review the "AI Suggested Priorities" section in the Obsidian Daily Note or check the Digital Twin API `/suggested` endpoint directly.
