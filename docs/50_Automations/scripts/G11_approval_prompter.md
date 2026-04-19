---
title: "G11: Approval Prompter"
type: "automation_spec"
status: "active"
automation_id: "G11_approval_prompter"
goal_id: "goal-g11"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Approval Prompter

## Purpose
Pushes pending decision requests from the `decision_requests` table to the user via Telegram with interactive buttons for Approval/Denial.

## Triggers
- **Scheduled:** Part of `G11_global_sync.py` and `autonomous_daily_manager.py`.
- **Manual:** `{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 G11_approval_prompter.py`.

## Inputs
- **Database:** `decision_requests` table in `digital_twin_michal`.
- **Environment Variables:** `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`.
- **Configuration:** `API_BASE_URL` (Direct IP of the Digital Twin API).

## Processing Logic
1. Fetch `PENDING` requests where `is_notified = FALSE`.
2. Format request payload into a user-friendly message.
3. **Integration Layer (REFINED Apr 07):** Messages now include a hybrid interface:
    - **Tap-to-Copy:** Standard `/approve {ID}` commands in `<code>` blocks for manual entry.
    - **One-Tap Deep Links:** `t.me` links (`/start approve_{ID}`) for zero-friction approval.
4. **Command Translation:** The Digital Twin API (G04) automatically translates deep-link parameters and underscored commands back into the standard space-separated format.
5. Send message to the user.
6. Mark the request as `is_notified = TRUE`.

## Outputs
- **Telegram:** Formatted messages with `<code>` blocks and clickable deep links.
- **Database:** Updated `is_notified` flag in `decision_requests`.

## Dependencies
### Systems
- [S04 Digital Twin Ecosystem](../../20_Systems/S04_Digital-Twin/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- Telegram Bot API.

### Credentials
- Telegram Bot Token & Chat ID.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Telegram API Error | `requests` exception | Skip current request, retry on next cycle | Log Error |
| DB Update Fail | `psycopg2` exception | Request remains `is_notified=FALSE`, will retry | Log Warning |
| API Unreachable | Button click (User side) | User receives browser error; can fallback to text commands | Bot logs error if text used |

## Monitoring
- Success metric: Number of approval prompts successfully sent.
- Feedback: Successful decision resolutions monitored via `G11_decision_handler` activity logs.

## Manual Fallback
If buttons fail, the user can type:
- `/approve [ID]`
- `/deny [ID]`
Directly in the Telegram chat.
