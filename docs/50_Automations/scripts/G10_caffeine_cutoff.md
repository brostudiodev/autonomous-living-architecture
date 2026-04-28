---
title: "G10: Caffeine Cutoff Reminder"
type: "automation_spec"
status: "active"
automation_id: "caffeine_cutoff"
goal_id: "goal-g10"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-04-27"
---

# G10: Caffeine Cutoff Reminder

## Purpose
Protects REM sleep quality by providing a proactive Telegram alert at 14:00 if caffeine has been consumed today, recommending a cessation of intake for the remainder of the day.

## Triggers
- **Scheduled:** Daily at 14:00 via `autonomous_daily_manager.py`.

## Inputs
- **Health Database:** `caffeine_log` table in `autonomous_health` database.

## Processing Logic
1. **Time Check:** Script only executes its core logic if the current hour is 14:00 (or forced via `--force`).
2. **Intake Query:** Queries the `caffeine_log` for the total milligrams consumed today.
3. **Telegram Dispatch:** If intake > 0, sends a formatted alert with the total mg and the time of the last intake.

## Outputs
- **Telegram Notification:** Alert sent to the user.
- **System Activity Log:** Logged as SUCCESS with total mg reported.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### Credentials
- `TELEGRAM_BOT_TOKEN`: Required for notifications (handled via `G04_digital_twin_notifier`).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception | Log FAILURE | None |
| Telegram API Fail | Exception | Log FAILURE to local logs | None |

## Monitoring
- **Success metric:** "Sent cutoff alert" in `system_activity_log`.
