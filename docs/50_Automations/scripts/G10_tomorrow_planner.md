---
title: "G10_tomorrow_planner: Mission Briefing Generator"
type: "automation_spec"
status: "active"
automation_id: "G10_tomorrow_planner"
goal_id: "goal-g10"
systems: ["S04", "S10"]
owner: "Michał"
updated: "2026-03-28"
---

# G10_tomorrow_planner: Mission Briefing Generator

## Purpose
Generates a comprehensive "Mission Briefing" for the upcoming day, summarizing accomplishments from today, identifying strategic priorities, and alerting on critical upcoming events (like courses or health recovery needs).

## Triggers
- **Scheduled:** Part of the `G11_global_sync.py` evening cycle.
- **Manual:** `python scripts/G10_tomorrow_planner.py`

## Inputs
- **Completed Goals:** `docs/10_Goals/**/Activity-log.md` (Matches today's date).
- **Calendar:** Google Calendar API (Tomorrow's events).
- **Digital Twin State:** `DigitalTwinEngine` (Health readiness, Finance alerts, Pantry stock).
- **Roadmap:** `DigitalTwinEngine.get_roadmap_mins()` (Q2 milestones).
- **Courses (NEW Mar 28):** `autonomous_learning.courses` (Courses starting within 3 days).

## Processing Logic
1. **Accomplishment Tracking:** Scans goal activity logs for "Action" entries from today.
2. **Calendar Fetching:** Retrieves all timed and all-day events for tomorrow.
3. **Strategic Intelligence:** 
    - Evaluates health (workout gap, sleep score).
    - Checks finance (budget alert count).
    - Monitors pantry (critical stock count).
    - **NEW (Mar 28):** Alerts on upcoming course starts (e.g., AI Architect Class).
4. **Roadmap Prioritization:** Fetches the top 5 relevant roadmap missions.
5. **Formatting:** Generates a structured Markdown briefing for the daily note and a Telegram-optimized summary.

## Outputs
- **Markdown:** Injected into the Daily Note via `autonomous_daily_manager.py`.
- **Telegram:** Sends "Mission Briefing" summary to the user.
- **ROI:** Logs 10 minutes of saved cognitive load per execution.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- Google Calendar API

## Error Handling
| Scenario | Detection | Response |
|----------|-----------|----------|
| Calendar API Error | Exception caught | Skip calendar section, log error |
| DB Connection Fail | Exception caught | Use partial context (cached or skip) |

## Monitoring
- **Success metric:** Briefing generated and delivered by 21:00 nightly.
- **ROI:** Tracked via `G04_roi_tracker`.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-05 | Initial mission briefing script |
| 2026-03-23 | Added strategic intelligence from G04 state |
| 2026-03-28 | Integrated course readiness logic and roadmap missions |
