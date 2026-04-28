---
title: "SVC: Input Normalizer"
type: "service_spec"
status: "active"
service_id: "SVC_Input-Normalizer"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC: Input Normalizer

## Purpose
Unified input processing service that normalizes and authenticates all incoming requests from Telegram, Webhooks, and Chat interfaces. It extracts user information, message content, and creates standardized metadata structure for downstream services.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub |

**Workflow ID:** `CGDnB0528onmqKW7X0yHg`

## Processing Flow

```
┌──────────────────┐
│ Workflow Trigger │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Normalize Input │  Code: Auto-detect source (Telegram/Webhook/Chat)
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   Is Telegram?   │  IF: Check trigger_source === "telegram"
└────────┬─────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐  ┌───────────┐
│ Telegram │ │Skip Auth  │
│   Auth   │ │(Non-TG)  │
└────┬────┘  └─────┬─────┘
     │             │
     └─────┬───────┘
           ▼
┌──────────────────┐
│ Route Auth Result│  Switch: authorized / not_required / unauthorized
└────────┬─────────┘
         │
    ┌────┴────┐
    ▼         ▼         ▼
┌────────┐ ┌──────────┐ ┌────────────┐
│Finalize│ │Finalize  │ │  Send      │
│Author- │ │Unauth    │ │Unauth Resp │
│ ized   │ │          │ │  (Telegram)│
└────────┘ └──────────┘ └────────────┘
```

## Detailed Processing Logic

### Stage 1: Source Detection
- **Node:** `Normalize Input` (Code)
- Auto-detects input source if not explicitly provided:
  - **Telegram:** `input.message`, `input.callback_query`, `input.edited_message`
  - **Webhook:** `input.body`, `input.headers`
  - **Chat:** `input.chatInput`, `input.sessionId`
- Generates unique `trace_id` for end-to-end tracking
- Initializes `_router` metadata with:
  - `trigger_source`: Source type
  - `user_id`, `username`, `chat_id`, `message_id`
  - `trace_id`, `timestamp`

### Stage 2: Authorization Check
- **Node:** `Is Telegram?` (IF)
- Branches based on `trigger_source`

### Stage 3: Authentication (Telegram only)
- **Node:** `Telegram Auth` (Code)
- Validates user ID against authorized list:
  - **Authorized User:** `{{TELEGRAM_CHAT_ID}}` (Michał)
  - Returns `_auth_result.status: "authorized"` or `"unauthorized"`

### Stage 4: Non-Telegram Bypass
- **Node:** `Skip Auth (Non-Telegram)` (Code)
- Sets `_auth_result.status: "not_required"` for Webhook/Chat sources

### Stage 5: Route Auth Result
- **Node:** `Route Auth Result` (Switch)
- Three output branches:
  1. **authorized** → `Finalize Authorized`
  2. **not_required** → `Finalize Authorized` (same handler)
  3. **unauthorized** → `Send Unauthorized Response` → `Finalize Unauthorized`

### Stage 6: Finalization
- **Node:** `Finalize Authorized` (Code)
  - Removes `_auth_result` temp fields
  - Adds `_normalized` flag with `success: true`, `authorized: true`
  
- **Node:** `Send Unauthorized Response` (Telegram)
  - Sends "⛔ Unauthorized access. This bot is private." to user
  - Calls `Finalize Unauthorized` to return error structure

## Inputs

```json
{
  "message": {
    "chat": { "id": "{{TELEGRAM_CHAT_ID}}" },
    "from": { "id": "{{TELEGRAM_CHAT_ID}}", "username": "Michal", "first_name": "Michał" },
    "text": "Hello world",
    "message_id": 123
  }
}
```

## Outputs

### Authorized Output:
```json
{
  "_router": {
    "trigger_source": "telegram",
    "user_id": "{{TELEGRAM_CHAT_ID}}",
    "username": "Michal",
    "chat_id": "{{TELEGRAM_CHAT_ID}}",
    "message_id": 123,
    "trace_id": "trace_1234567890_abc123",
    "timestamp": "2026-04-10T12:00:00.000Z"
  },
  "metadata": {
    "source": "telegram",
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}",
      "message_id": 123
    }
  },
  "message": { ... },
  "_normalized": {
    "success": true,
    "authorized": true,
    "ready_for_processing": true
  }
}
```

### Unauthorized Output:
```json
{
  "_normalized": {
    "success": false,
    "authorized": false,
    "error": "unauthorized_access"
  },
  "_router": { ... }
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - State queries
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md) - Cross-system coordination

### Called By
- [ROUTER_Intelligent-Hub.md](./ROUTER_Intelligent-Hub.md) - Primary caller

### External Services
- **Telegram Bot API** - For sending unauthorized access response

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| Missing source data | All source fields null | Default to "unknown" source | None |
| Invalid Telegram message | No message.chat.id | Set chat_id to null | None |
| Auth check exception | try/catch in code | Return unauthorized structure | Log to console |
| Telegram send failure | HTTP error from Telegram node | Continue to Finalize Unauthorized | n8n error workflow |

## Manual Fallback

### Test via Workflow Execute:
```bash
# Via n8n API
curl -s -X POST http://localhost:5678/rest/workflow/CGDnB0528onmqKW7X0yHg/execute \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "chat": {"id": "{{TELEGRAM_CHAT_ID}}"},
      "from": {"id": "{{TELEGRAM_CHAT_ID}}", "username": "test"},
      "text": "test"
    }
  }'
```

### Test via curl (simulate Telegram):
```bash
curl -s -X POST http://localhost:5678/webhook/intelligence-hub \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "chat": {"id": "{{TELEGRAM_CHAT_ID}}"},
      "from": {"id": "{{TELEGRAM_CHAT_ID}}", "username": "Michal"},
      "text": "Hello"
    }
  }'
```

## Supported Sources

| Source | Auth Required | Key Fields |
|--------|---------------|------------|
| Telegram | ✅ Yes | `message`, `callback_query`, `edited_message` |
| Webhook | ❌ No | `body`, `headers` |
| Chat (n8n) | ❌ No | `chatInput`, `sessionId` |

## Security Notes

- **Telegram Auth:** Only user ID `{{TELEGRAM_CHAT_ID}}` is authorized
- **Webhook Security:** No authentication (assumes internal network)
- **Chat Security:** No authentication (assumes trusted interface)
- **User Data:** Only `user_id` and `username` are stored in `_auth_result`

---

*Documentation synchronized with svc_input-normalizer.json v1.0 (2026-04-10)*