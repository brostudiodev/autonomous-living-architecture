---
title: "EVENT: Digital Twin Decision Resolver"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g04"
updated: "2026-05-01"
---

# EVENT: Digital Twin Decision Resolver

## Purpose
Handles real-time user feedback from Telegram interactive buttons to resolve pending autonomous decisions by communicating with the Digital Twin API.

## Scope
### In Scope
- Listening for Telegram `callback_query` (Trigger).
- Parsing `decide:{id}:{STATUS}` callback data.
- Submitting resolutions to `POST /decisions/resolve`.
- Updating the original Telegram message to show the final result and resolver identity.

### Out of Scope
- Prompting for new decisions (handled by `EVENT_Digital-Twin-Decision-Prompter`).

## Architecture
- **Trigger**: Telegram Trigger (Webhook).
- **Integration**: Digital Twin API for resolution execution.
- **Visual Feedback**: Edits original message via Telegram API.

## Dependencies
- Digital Twin API: `/decisions/resolve`.
- Telegram Bot API.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Resolution Error | Status 4xx/5xx | Send Telegram "Resolution Failed" alert |
| Expired Callback | Telegram timeout | User must retry (Decision remains PENDING) |

## Related Documentation
- [EVENT: Digital Twin Decision Prompter](EVENT_Digital-Twin-Decision-Prompter.md)
- [S04: Digital Twin API Specification](../../../20_Systems/S04_Digital-Twin/API-Specification.md)
