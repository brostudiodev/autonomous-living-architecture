---
title: "script: weekly-briefing-bot"
type: "automation_spec"
status: "active"
automation_id: "weekly-briefing-bot"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-02-23"
---

# script: weekly-briefing-bot

## Purpose
Bridges the "Information Layer" to the "Interactive Layer". It extracts the core wins and metrics from the auto-generated Weekly Review note and pushes them to Telegram, prompting the Director for a human-in-the-loop reflection.

## Triggers
- **Scheduled:** Sunday at 06:05 AM (immediately after `autonomous_weekly_manager.py`).
- **Manual:** `python3 G11_weekly_briefing_bot.py`.

## Inputs
- **Obsidian Note:** The Markdown file for the current week (e.g., `2026-W08.md`).
- **Environment:** `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`.

## Processing Logic
1. **Extraction:** Loads the latest weekly review from `03_Areas/A - Systems/Reviews/`.
2. **Summarization:** Extracts the "Strategic Accomplishments" section.
3. **Dispatch:** Sends a formatted summary to the user's Telegram chat.
4. **Interaction Prompt:** Appends a request for the "Closing Reflection" to trigger the next automation step.

## Outputs
- **Telegram Message:** Formatted summary sent to the user.

## Dependencies
### Systems
- [Intelligence Router (S11)](../../../20_Systems/S11_Intelligence_Router/README.md)

### External Services
- **Telegram Bot API**: Requires valid bot token and chat ID.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Note missing | `os.path.exists` fails | Skip notification, log warning |
| API Timeout | `requests.post` exception | Retry once or notify via alternate channel |

## Manual Fallback
Review the generated Markdown file in Obsidian and manually type the reflection.
