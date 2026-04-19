---
title: "G11: Logistics to Calendar Sync"
type: "automation_spec"
status: "active"
automation_id: "G11_logistics_calendar_sync"
goal_id: "goal-g11"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Logistics to Calendar Sync

## Purpose
Automatically synchronizes upcoming administrative and life deadlines (Car inspection, insurance, legal dates) from the `autonomous_life_logistics` database to Google Calendar as all-day events.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- Database: `autonomous_life_logistics.items` (Filtered for `due_date` within next 30 days).
- Google Calendar API (via `G10_calendar_client.py`).

## Processing Logic
1. **Query:** Fetch all pending items with a due date in the next 30 days.
2. **Deduplicate:** Check existing calendar events for the same title to prevent spam.
3. **Format:** Create a "Yellow" (colorId: 5) all-day event with the category and notes in the description.
4. **Push:** Insert into the primary Google Calendar.

## Outputs
- Google Calendar Events (e.g., "📦 Car: Inspection").
- Activity Log entry.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Google API Error | Exception caught | Skip sync, log failure | Log Critical |
| DB Timeout | psycopg2 error | Wait and retry | Log Warning |
