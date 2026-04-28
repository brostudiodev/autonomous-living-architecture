---
title: "SVC: Response Dispatcher"
type: "service_spec"
status: "active"
service_id: "SVC_Response-Dispatcher"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC: Response Dispatcher

## Purpose
Universal response formatting and delivery service that routes system outputs to the appropriate channel (Telegram, Webhook, or Chat interface). It handles Markdown sanitization, progress updates vs. final results, and ensures proper message formatting for each platform.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by all service workflows |

**Workflow ID:** `pag6IhR3yLeBUpR4cb8L9`

## Processing Flow

```
┌─────────────────────────┐
│ Input from Main Workflow│
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Detect Source & Type   │  Code: Extract source, message_type, response_text
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│    Route by Source      │  Switch: telegram / webhook / chat / extra
└────────────┬────────────┘
             │
    ┌────────┼────────┬────────┐
    ▼        ▼        ▼        ▼
┌────────┐ ┌──────┐ ┌──────┐ ┌────────────┐
│  Send  │ │Resp  │ │ Chat │ │  Unknown   │
│ Telegram│ │Webhook│ │Response│ │  Source    │
└───┬────┘ └──┬───┘ └──┬───┘ └──────┬─────┘
    │        │        │            │
    ▼        ▼        ▼            │
┌────────┐ ┌──────┐ ┌──────┐       │
│Confirm │ │Confirm│ │      │       │
│ Telegram│ │Webhook│ │      │       │
└────────┘ └──────┘ └──────┘       │
```

## Detailed Processing Logic

### Stage 1: Source Detection
- **Node:** `Detect Source & Type` (Code)
- Extracts key information from input:
  - **Source:** From `metadata.response_endpoint.type` or `_router.trigger_source`
  - **Chat ID:** From `metadata.response_endpoint.chat_id` or `_router.chat_id`
  - **Message Type:** From `message_type` (default: `result`)
  - **Response Text:** From `response_text`, `text`, `output`, or `chatResponse`

### Stage 2: JSON Parsing
- If `response_text` starts with `{` or `[`, attempts to parse JSON
- Extracts `content`, `summary`, or `status` fields
- Falls back to raw text if parsing fails

### Stage 3: Markdown Sanitization
- **Function:** `sanitizeTelegramMarkdown(text)`
- Preserves intentional formatting:
  - `*bold*` - temporarily replaced with markers, then restored
  - `` `code` `` - temporarily replaced with markers, then restored
- Removes Obsidian wiki-links: ``[[...]]``
- Escapes remaining brackets: `[` → `\[`, `]` → `\]`

### Stage 4: Source Routing
- **Node:** `Route by Source` (Switch)
- Four output branches:

| Source | Handler Node | Output Method |
|--------|--------------|---------------|
| `telegram` | Send Telegram | Telegram Bot API |
| `webhook` | Respond Webhook | HTTP Response |
| `chat` | Chat Response | Direct text |
| `extra` (fallback) | Unknown Source (Fallback) | Error log |

### Stage 5: Message Delivery

#### Telegram Branch
- **Node:** `Send Telegram` (Telegram)
- Sends response via Telegram Bot API
- Supports additional fields:
  - `appendAttribution` (boolean)
  - `disable_notification` (boolean)
  - `parse_mode` (Markdown/HTML)

#### Webhook Branch
- **Node:** `Respond Webhook` (Respond to Webhook)
- Returns JSON response:
  ```json
  {
    "success": true,
    "message": "response text",
    "data": {...},
    "type": "result"
  }
  ```

#### Chat Branch
- **Node:** `Chat Response` (Code)
- Filters out progress updates (returns empty for `is_progress: true`)
- Returns raw text for chat interface

### Stage 6: Confirmation
- **Node:** `Confirm Telegram` / `Confirm Webhook`
- Returns dispatch confirmation with metadata:
  ```json
  {
    "dispatched": true,
    "source": "telegram",
    "message_type": "result",
    "timestamp": "2026-04-10T12:00:00.000Z"
  }
  ```

## Inputs

```json
{
  "response_text": "Hello! Your system status is **operational**.",
  "message_type": "result",
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  },
  "_router": {
    "trigger_source": "telegram",
    "chat_id": "{{TELEGRAM_CHAT_ID}}"
  }
}
```

## Outputs

### Telegram Output:
```json
{
  "dispatched": true,
  "source": "telegram",
  "message_type": "result",
  "timestamp": "2026-04-10T12:00:00.000Z"
}
```

### Webhook Output:
```json
{
  "success": true,
  "message": "Response text",
  "data": {...},
  "type": "result"
}
```

### Chat Output:
```json
{
  "text": "Response text"
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - State queries
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md) - Cross-system coordination

### Called By
- [ROUTER_Intelligent-Hub.md](./ROUTER_Intelligent-Hub.md) - Primary caller
- [SVC_Command-Handler.md](./SVC_Command-Handler.md)
- [SVC_Intelligence-Processor.md](./SVC_Intelligence-Processor.md)
- [SVC_Google-Calendar.md](./SVC_Google-Calendar.md)
- And all other service workflows

### External Services
- **Telegram Bot API** - Message delivery

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| Missing chat_id | chat_id is null | Send to "Unknown Source (Fallback)" | Log to console |
| JSON parse failure | Invalid JSON | Keep raw text | None |
| Telegram send failure | HTTP error from Telegram node | Continue to Confirm (log error) | n8n error workflow |
| Unknown source type | Switch fallback | Log error and return error JSON | None |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/pag6IhR3yLeBUpR4cb8L9/execute \
  -H "Content-Type: application/json" \
  -d '{
    "response_text": "Test message",
    "message_type": "result",
    "metadata": {
      "response_endpoint": {
        "type": "telegram",
        "chat_id": "{{TELEGRAM_CHAT_ID}}"
      }
    }
  }'
```

### Test Telegram directly:
```bash
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id={{TELEGRAM_CHAT_ID}}" \
  -d "text=Test message"
```

## Supported Message Types

| Type | Behavior | Use Case |
|------|----------|----------|
| `result` | Full response | Final responses |
| `progress` | Filtered for Chat | Interim updates (not shown in chat) |
| *(any)* | Full response | Default behavior |

## Supported Formatting

| Format | Telegram Support | Notes |
|--------|------------------|-------|
| `*bold*` | ✅ Yes | Converted to Telegram Markdown |
| `` `code` `` | ✅ Yes | Converted to Telegram code |
| ``[[wiki-links]]`` | ❌ No | Stripped |
| `[brackets]` | ✅ Yes | Escaped as `\[brackets\]` |
| Markdown links | ✅ Yes | Full support |

---

*Documentation synchronized with svc_response-dispatcher.json v1.0 (2026-04-10)*