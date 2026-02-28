---
title: "G04_morning_briefing_sender.py: Proactive Mission Delivery"
type: "automation_spec"
status: "active"
automation_id: "morning-briefing-sender"
goal_id: "goal-g04"
systems: ["S04", "S10"]
owner: "Michal"
updated: "2026-02-24"
---

# G04_morning_briefing_sender.py: Proactive Mission Delivery

## Purpose
Gathers the morning's mission briefing, suggested schedule, and productivity insights and pushes them to Telegram to ensure the user can "Attack the Day" without opening Obsidian.

## Triggers
- **Scheduled**: Daily (06:00 AM Weekdays / 09:00 AM Weekends) via `autonomous_daily_manager.py`.
- **Manual**: `python3 scripts/G04_morning_briefing_sender.py`

## Inputs
- **Autonomous Intelligence:** Generated via `DigitalTwinEngine.generate_suggested_report()` in `G04_digital_twin_engine.py`.

## Processing Logic
1. Instantiate `DigitalTwinEngine`.
2. Generate the comprehensive autonomous report using `generate_suggested_report()`. This consolidates connectivity status, budget alerts, pantry logistics, and roadmap tasks.
3. Prepend "🚀 MORNING MISSION BRIEFING" header.
4. Send via `G04_digital_twin_notifier.py`, which handles automatic HTML formatting and message splitting.

## Outputs
- **Telegram Notification:** Detailed summary of the day's goals and missions.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- **Telegram Bot API:** Delivery mechanism.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Note not found | `data["status"] != "Success"` | Log and exit (Manager likely hasn't run) | Console log |
| Formatting error | `⚠️` in dashboard text | Skip send to avoid broken messages | Console log |

## Monitoring
- **Success Metric:** Briefing received within 5 minutes of scheduled time.
- **Alert on:** Absence of message.
