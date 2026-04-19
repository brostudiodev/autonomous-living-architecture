---
title: "SVC: Daily Calendar Brief"
type: "automation_spec"
status: "active"
automation_id: "SVC_Daily-Calendar-Brief"
goal_id: "goal-g10"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Daily-Calendar-Brief

## Purpose
Automated morning briefing that fetches today's calendar events from Google Calendar and delivers a formatted summary to Telegram. Runs daily at 6:45 AM to provide daily schedule visibility.

## Triggers
- **Schedule Trigger:** Daily at 6:45 AM (Schedule: Daily 6:45 AM node, lines 6-19).

## Inputs
- **Google Calendar API:** Fetches all events from primary calendar for current day (start/end of day).

## Processing Logic
1. **Google Calendar: Get Today** (Google Calendar node, lines 22-48): Queries Google Calendar API for today's events (max 20). Returns events with start/end times.
2. **Code: Process Events** (Code node, lines 52-58): Filters cancelled events, sorts by start time. Separates regular meetings from FOCUS blocks (events containing `[FOCUS]`). Formats time strings (HH:MM). Builds meeting list (top 5) and focus list (top 3). Counts total events.
3. **Telegram: Send Brief** (Telegram node, lines 61-79): Sends formatted message to chat ID `{{TELEGRAM_CHAT_ID}}` with:
   - Focus blocks (if any) with 🎯 emoji
   - Meetings list (or "No meetings scheduled")
   - First meeting time

## Outputs
- **Telegram Message:** Formatted daily calendar summary.
- **Example Output:** `📅 **Today's Calendar**\n\n🎯 **Focus Blocks:**\n🎯 09:00-11:00: Deep Work\n\n📅 **Meetings:\n• 14:00-14:30: Team Standup\n• 15:00-15:45: 1:1\n\n⏱️ First meeting: 14:00: Team Standup`

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.

### External Services
- Google Calendar API (via Google Calendar OAuth2).
- Telegram Bot (AndrzejSmartBot credentials).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Google API failure | Google Calendar node error | Workflow error logged | n8n Execution log |
| Telegram send fail | Telegram node error | Workflow error logged | n8n Execution log |

## Security Notes
- Hardcoded Telegram chat_id (`{{TELEGRAM_CHAT_ID}}`) - should use environment variable.
- Google Calendar credentials stored in n8n credential store.
- Telegram credentials stored in n8n credential store.

## Manual Fallback
```bash
# Check Google Calendar via CLI (requires gcal CLI or curl with OAuth)
gcalcli cal --tsv --calendar "primary" today
```