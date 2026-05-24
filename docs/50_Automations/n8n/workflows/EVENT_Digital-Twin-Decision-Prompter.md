---
title: "EVENT: Digital Twin Decision Prompter"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g04"
updated: "2026-05-01"
---

# EVENT: Digital Twin Decision Prompter

## Purpose
Periodically polls the Digital Twin for pending autonomous decisions and prompts Michal via Telegram with interactive buttons for approval or denial.

## Scope
### In Scope
- Polling `GET /decisions/pending` every 30 minutes.
- Formatting decision metadata (Domain, Action, Reason, Priority) into Markdown.
- Providing Inline Telegram buttons (`Approve`, `Deny`, `Defer`).

### Out of Scope
- Actually executing the decision (delegated to `EVENT_Digital-Twin-Decision-Resolver`).

## Architecture
- **Trigger**: Schedule Trigger (30m).
- **Integration**: Digital Twin API for data, Telegram for user interaction.
- **Callback Format**: `decide:{id}:{STATUS}`.

## Dependencies
- Digital Twin API: `/decisions/pending`.
- Telegram Bot: `AndrzejSmartBot`.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API 404/500 | Node error | Silent skip (will retry next cycle) |
| Empty Inbox | `Has Pending?` node | Workflow terminates gracefully |

## Related Documentation
- [EVENT: Digital Twin Decision Resolver](EVENT_Digital-Twin-Decision-Resolver.md)
- [S04: Digital Twin API Specification](../../../20_Systems/S04_Digital-Twin/API-Specification.md)
