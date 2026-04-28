---
title: "ROUTER: Intelligent Hub"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g04"
updated: "2026-04-16"
---

# ROUTER: Intelligent Hub

## Purpose

Central routing intelligence for the autonomous living system. Receives all Telegram messages, webhooks, and chat inputs; normalizes them; classifies intent; and routes to appropriate handlers (AI agents, command handlers, calendar, intelligence processors).

## Scope

### In Scope
- Multi-source input handling (Telegram, Webhook, Chat)
- Input normalization and authorization
- Format detection and content extraction
- Intent classification (6 types: command, question, capture, task, conversation, callback)
- Routing to domain-specific handlers
- Partner access restrictions

### Out of Scope
- Direct command execution (delegates to SVC workflows)
- Response formatting (delegates to Response Dispatcher)
- Persistence (delegates to database workflows)

## Architecture

### Clean Architecture Flow
```
Triggers → Normalizer → Auth → Converge → Format Detector → Intent Classifier → Router → Handlers
```

### Input Sources
| Source | Type | Notes |
|--------|------|-------|
| Telegram | Bot Webhook | AndrzejSmartBot |
| Webhook | HTTP POST | `/intelligence-hub` endpoint |
| Chat | LangChain | AI chat interface |

### Supported Formats
- PDF, CSV, JSON, XML, TXT, MD (text extraction)
- Audio/Voice (Whisper STT)
- YouTube URLs (transcript extraction)
- Web URLs (HTML scraping)

### Intent Types
| Intent | Handler | Description |
|--------|---------|-------------|
| command | SVC_Command-Handler | System commands (/start, /help, etc.) |
| question | SVC_AI-Agent-Interactive | Intelligence queries |
| capture | SVC_Intelligence-Processor | Data capture from URLs/files |
| task | Task Creator | Task creation requests |
| conversation | SVC_AI-Agent-Interactive | Free-form conversation |
| callback | Callback Handler | Telegram button presses |
| calendar | SVC_Google-Calendar | Calendar-related requests |
| fallback | Intent Fallback | Unrecognized input |

## Dependencies

### Sub-Workflows
| Workflow ID | Name | Purpose |
|-------------|------|---------|
| e8ra0WcR4TalzD7NpA7UD | SVC_Format-Detector-Extractor | Format detection and extraction |
| pag6IhR3yLeBUpR4cb8L9 | SVC_Response-Dispatcher | Response formatting |
| 9GISOtBzooWu9JSI | SVC_Google-Calendar | Calendar integration |
| CGDnB0528onmqKW7X0yHg | SVC_Input-Normalizer | Input normalization |
| OucxezHUhgZbcBusRKVp5 | SVC_Notification-Dispatcher | Notifications |
| 2Tw0zw8nti_kcLB1CSynU | SVC_Intelligence-Processor | Intelligence processing |
| 0oOi-Ucz-WkXC-RXjHXAT | SVC_Command-Handler | Command handling |
| bLHLw65krtyBRdUZ | SVC_AI-Agent-Interactive | AI conversation |

### Infrastructure
- Telegram Bot API
- LangChain n8n integration
- Internal webhook endpoints

## Procedure

### Execution Flow
1. **Receive Input:** From Telegram, Webhook, or Chat trigger
2. **Normalize:** SVC_Input-Normalizer standardizes input
3. **Authorize:** Check if user is authorized
4. **Detect Format:** SVC_Format-Detector extracts content type
5. **Classify Intent:** AI-powered or rule-based classification
6. **Route:** Switch node routes to appropriate handler
7. **Process:** Handler executes domain-specific logic
8. **Respond:** SVC_Response-Dispatcher sends reply

### Debugging
- Check execution logs for routing decisions
- Monitor "Stage 3" node output for intent classification
- Verify sub-workflow connectivity in n8n

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Sub-workflow timeout | 30s timeout | Fallback to error response |
| Unrecognized input | Intent = fallback | Send help message |
| Authorization failure | `_normalized.success = false` | Block and notify |
| Telegram API error | n8n error | Check bot credentials |

## Security Notes

- Telegram authorization checks all incoming messages
- Partner Hub (ROUTER_Partner_Hub) restricts access to household queries
- No sensitive data logged in execution traces
- Webhook URL should be kept secure

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (during G11 system audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [ROUTER_Partner_Hub](./ROUTER_Partner_Hub.md)
- [SVC: Format Detector](./WF005__svc-input-normalizer.md)
- [SVC: AI Agent Interactive](./WF001_Agent_Router.md)
- [S04 Digital Twin](../20_Systems/S04_Digital-Twin/README.md)
