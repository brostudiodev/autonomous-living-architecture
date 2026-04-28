---
title: "G10: Calendar Enforcer (The Focus Shield)"
type: "automation_spec"
status: "active"
automation_id: "G10_calendar_enforcer"
goal_id: "goal-g10"
systems: ["S10"]
owner: "Michał"
updated: "2026-04-28"
---

# G10: Calendar Enforcer (The Focus Shield)

## Purpose
Physically synchronizes the AI-optimized daily schedule into Google Calendar. This acts as a "Focus Shield" by blocking time for Deep Work, Health, and Admin, making the plan visible and enforceable across all devices.

## Triggers
- **Manual:** Triggered via Telegram/API endpoint `/calendar/enforce`.
- **Planned:** Future integration into the 07:00 Morning Launchpad.

## Inputs
- **Schedule Data:** Provided by `G10_schedule_optimizer.py` (Structured Blocks).
- **Google Calendar API:** Primary calendar access.

## Processing Logic
1.  **Clearance:** Identifies and deletes any existing events for today that were marked with the `🤖 Auto-generated` tag to ensure a clean sync.
2.  **Mapping:** Iterates through the optimized blocks (e.g., 06:00-08:00 -> Deep Work).
3.  **Color Coding:** Assigns specific Google Calendar colors based on task type:
    *   **Grape (3):** Deep Work / Roadmap Missions.
    *   **Sage (2):** Health / Training.
    *   **Graphite (11):** Standard Work / Core Professional.
    *   **Flamingo (4):** Admin / Email / Finance.
    *   **Basil (10):** Recovery / Rest.
4.  **Injection:** Creates new "Busy" events in the primary Google Calendar.

## Outputs
- **Google Calendar:** Populated time blocks for the current day.
- **Audit Log:** Recorded in `system_activity_log`.

## Dependencies
### Systems
- [S10 Intelligent Productivity](../../10_Goals/G{{LONG_IDENTIFIER}}/README.md)

### External Services
- **Google Calendar API:** Using service account credentials.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Auth Failure | Script log | Verify `google_credentials_digital-twin-michal.json` |
| Overlapping Events | API check | Current logic clears 🤖 events first; manual events remain. |
| Timezone Mismatch | API check | Defaults to centralized `db_config.TIMEZONE`. |

## Manual Fallback
If the enforcer fails, Michał must manually block time in the Google Calendar app based on the suggestions in the Obsidian Daily Note.
