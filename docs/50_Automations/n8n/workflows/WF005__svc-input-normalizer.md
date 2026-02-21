---
title: "WF005: SVC_Input-Normalizer"
type: "automation_spec"
status: "active"
automation_id: "WF005__svc-input-normalizer"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Micha\u0142"
updated: "2026-02-13"
---

# WF005: SVC_Input-Normalizer

## Purpose
Provides a unified input processing for Telegram, Webhook, and Chat sources. It normalizes the input, adds router metadata, and handles authentication for Telegram.

## Triggers
- **Workflow Call**: Triggered by other workflows to process raw input data.

## Inputs
- Raw input from various sources like Telegram, Webhooks, or n8n's chat interface.

## Processing Logic
1.  **Normalize Input**: Auto-detects the source type (Telegram, webhook, chat) and generates a `trace_id`. It creates a standardized `_router` metadata object with user and chat information.
2.  **Telegram Authentication**: If the source is Telegram, it checks the user ID against a hardcoded authorized ID (`7689674321`).
3.  **Route Auth Result**: Routes the workflow based on the authentication result (authorized, not_required, unauthorized).
4.  **Finalize**: Prepares the final JSON object to be returned, including the original payload, the `_router` metadata, and an `_auth_result`. Unauthorized requests are handled by sending a response via Telegram.

## Outputs
- A JSON object with the original input data, enriched with `_router`, `metadata`, and `_normalization` objects.

## Dependencies
### Systems
- [S04 Messaging & Interaction Layer](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Telegram API

### Credentials
- Telegram (AndrzejSmartBot) (ID: `XDROmr9jSLbz36Zf`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Unauthorized Telegram User | The user's ID does not match the authorized ID. | An "Unauthorized access" message is sent to the user via Telegram. | No alert, but the unauthorized attempt is logged in the workflow execution. |

## Monitoring
- **Success Metric**: A successful execution returns a normalized JSON object.
- **Alerts**: No automated alerts are configured.

## Manual Fallback
This is a core processing service. A manual fallback would involve manually crafting the JSON object that this service would have produced.

## Related Documentation
- [WF001: ROUTER_Intelligence-Hub](../WF001_Agent_Router.md)
- [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
- [WF003: SVC_Response-Dispatcher](../WF003__svc-response-dispatcher.md)
- [WF004: SVC_Intelligence-Processor](../WF004__intelligence-hub-input.md)
