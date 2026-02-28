---
title: "G10_tomorrow_planner.py: Autonomous Mission Briefing"
type: "automation_spec"
status: "active"
automation_id: "g10-tomorrow-planner"
goal_id: "goal-g10"
systems: ["S10", "S04", "S09"]
owner: "Michal"
updated: "2026-02-27"
---

# G10_tomorrow_planner.py

## Purpose
Acts as the "Strategic Director" for the following day. It aggregates today's wins, tomorrow's calendar events, and real-time intelligence from the Digital Twin (Health, Finance, Pantry) to generate a consolidated "Mission Briefing" for the user.

## Triggers
- **On-Demand:** Called by the `G04_digital_twin_api` via the `GET /tomorrow` endpoint.
- **Scheduled:** Typically executed every evening (e.g., 20:00) to prepare the next day's strategy.

## Inputs
- **Obsidian Daily Notes:** Scans for completed goals in today's note.
- **Goal Activity Logs:** Extracts tactical actions from `Activity-log.md` files.
- **Google Calendar API:** Fetches events for the next 24-hour window.
- **Digital Twin Engine (G04):** Queries consolidated health (sleep/HRV), finance (alerts), and pantry (low stock) states.
- **Roadmap Milestones:** Identifies the top 5 incomplete Q1 tasks.

## Processing Logic
1.  **Wins Extraction:** Identifies completed tasks from the current daily note and activity logs to celebrate progress.
2.  **Calendar Sync:** Retrieves tomorrow's schedule to identify gaps and commitments.
3.  **Strategic Analysis:**
    - **Health:** Checks for recovery scores and workout frequency.
    - **Finance:** Identifies active budget alerts.
    - **Logistics:** Checks for low stock items in the pantry.
4.  **Tactical Prioritization:** Selects the highest priority roadmap tasks from foundation goals (G04, G10, G05, G12).
5.  **Formatting:** Compiles everything into a human-readable "Mission Briefing" formatted for Telegram Markdown.

## Outputs
- **Structured JSON:** Complete plan object for API consumption.
- **Response Text:** A formatted Telegram-ready string containing the Mission Briefing.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Source of strategic intelligence.
- [S09 Productivity Time](../../20_Systems/S09_Productivity-Time/README.md) - Parent system for time architecture.
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md) - Provides win/completion data.

### External Services
- **Google Calendar API:** Access to primary calendar.
- **Google Gemini API:** (via G04) for potential advanced reasoning.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Google Auth Fail | `G10_calendar_client` error | Skip calendar section in briefing | Console |
| Digital Twin Down | `ImportError` or `Exception` | Inject "Digital Twin context unavailable" note | Briefing Text |
| No Daily Note | `os.path.exists()` check | Skip "Today's Wins" section | Console |

## Security Notes
- **Credential Protection:** Google API tokens are managed via `G10_calendar_client` and `.pickle` files (not stored in Git).
- **No Private Data in Logs:** Briefing text is transient and not logged to disk.

## Manual Fallback
If the script fails, the user must manually review the `Roadmap.md` files and Google Calendar to plan the next day.

## Related Documentation
- [Goal: G10 Intelligent Productivity & Time Architecture](../../10_Goals/G10_Intelligent-Productivity-Time-Architecture/README.md)
- [System: S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
