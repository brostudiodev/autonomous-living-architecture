---
title: "G10: Location Intelligence"
type: "automation_spec"
status: "active"
automation_id: "G10_location_intelligence"
goal_id: "goal-g10"
systems: ["S09", "S04"]
owner: "Michał"
updated: "2026-04-23"
---

# G10: Location Intelligence

## Purpose
Autonomously analyzes upcoming calendar events for location-based travel requirements. It estimates travel times and injects "🚗 Travel" blocks into Google Calendar to protect transit time and reduce manual planning friction.

## Triggers
- **Scheduled:** Part of `autonomous_daily_manager.py` (Daily at 06:00).
- **Scheduled:** Part of `autonomous_evening_manager.py` (Daily at 18:00).
- **Manual:** `python3 scripts/G10_location_intelligence.py`.

## Inputs
- **Calendar:** Tomorrow's events from the Primary Google Calendar (G10).
- **Profiles:** Pre-defined travel estimates for common locations (Office, Gym, Home, etc.).

## Logic Flow
1.  **Scan:** Retrieves events for today and tomorrow from the primary calendar.
2.  **Filter:** Identifies events with a non-empty `location` field that are not already travel blocks.
3.  **Estimate:** Matches location keywords against the `TRAVEL_ESTIMATES` profile (defaulting to 30 mins).
4.  **Deduplicate:** Checks if a "🚗 Travel to [Event]" block already exists at the calculated time.
5.  **Inject:** Inserts a new Google Calendar event with a gray color (ID 8) and an opaque transparency.

## Outputs
- **Calendar:** New events titled `🚗 Travel to [Summary]` in Google Calendar.
- **Logs:** `system_activity_log` entry with the count of blocks added.

## Dependencies
- **Services:** Google Calendar API.
- **Credentials:** `google_tasks_token.pickle` (Shared with G10 tasks).
- **Profiles:** `TRAVEL_ESTIMATES` dictionary in script.

## Failure Modes
- **API Offline:** Connection error → Script skips execution and logs a warning.
- **Overlap:** If travel time overlaps with another event, it still injects (User must resolve conflict).
- **Unknown Location:** Defaults to 30-minute travel time.

## Security Notes
- Read/Write access to Google Calendar.
- No sensitive location data is logged outside the calendar itself.

---
*Updated: 2026-04-06 | Initial automation specification.*
