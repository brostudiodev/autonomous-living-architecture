---
title: "script: tomorrow-planner"
type: "automation_spec"
status: "active"
automation_id: "tomorrow-planner"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michal"
updated: "2026-02-22"
---

# script: tomorrow-planner

## Purpose
Aggregates today's wins, tomorrow's calendar events, and current roadmap missions to generate a comprehensive "Mission Briefing" for the next day. This facilitates the "Rest + Prep" strategy by removing planning friction.

## Triggers
- **API Call:** Triggered via the `/tomorrow` endpoint of the Digital Twin API.
- **Manual Execution:** `python3 G10_tomorrow_planner.py` for terminal preview.

## Inputs
- **Obsidian Daily Note:** Parses `[x]` goals and activity logs for today's date.
- **Google Calendar:** Fetches events for the next 24 hours via `G10_calendar_client`.
- **Roadmap Files:** Extracts incomplete Q1 tasks from all goal directories.

## Processing Logic
1. **Completions Extraction:** Scans today's Daily Note and all `Activity-log.md` files for today's date to find "Wins".
2. **Calendar Fetching:** Uses the G10 Service Account to retrieve tomorrow's schedule.
3. **Task Prioritization:** Pulls upcoming tasks from Google Tasks and top missions from goal Roadmaps.
4. **Formatting:** Strips Obsidian wiki-links (`[[ ]]`) and applies Telegram-compatible Markdown v1.

## Outputs
- **JSON Object:** Structured data for API consumption.
- **Markdown Text:** Formatted string for Telegram delivery.

## Dependencies
### Systems
- [Digital Twin System](../../20_Systems/S04_Digital-Twin/README.md)
- [Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- **Google Calendar API**: Requires valid `google_credentials.json`.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Calendar Auth Fail | "Calendar Error" in output | Check `google_credentials.json` |
| Note Missing | "Note not found" | Gracefully skip wins aggregation |

## Monitoring
- Verified daily through the evening planning routine.

## Manual Fallback
Review the Obsidian Daily Note and Google Calendar manually.
