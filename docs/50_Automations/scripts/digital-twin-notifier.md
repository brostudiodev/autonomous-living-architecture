---
title: "G04_digital_twin_notifier.py: Telegram Notification Hub"
type: "automation_spec"
status: "active"
automation_id: "digital-twin-notifier"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-02-24"
---

# G04_digital_twin_notifier.py: Telegram Notification Hub

## Purpose
Provides a centralized, reusable utility for all autonomous scripts to send Markdown-formatted notifications to the user via Telegram.

## Triggers
- **Internal Call:** Imported and called by other scripts (e.g., `G04_morning_briefing_sender.py`, `autonomous_daily_manager.py`).
- **Manual Test:** `python3 scripts/G04_digital_twin_notifier.py "Test message"`

## Inputs
- **Environment Variables:** `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` (loaded from root `.env`).
- **Function Arguments:** Message text and optional parse mode.

## Processing Logic
1. Load credentials from `.env`.
2. Send POST request to Telegram Bot API `sendMessage` endpoint.
3. Handle basic request exceptions.

## Outputs
- **Telegram Message:** Instant push notification to the user's device.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- **Telegram Bot API:** Message delivery service.

### Credentials
- `TELEGRAM_BOT_TOKEN`: Secret token from BotFather.
- `TELEGRAM_CHAT_ID`: User's unique chat ID.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing .env | `None` returned for env vars | Log error and return `False` | Script console output |
| API Timeout | `requests.exceptions.Timeout` | Log error and return `False` | Script console output |
| Invalid Token | `401 Unauthorized` | Log error and return `False` | Script console output |

## Manual Fallback
```bash
# Manual CURL test
curl -X POST https://api.telegram.org/bot<TOKEN>/sendMessage -d chat_id=<ID>&text="Manual Alert"
```
