---
title: "SVC: Notification Dispatcher"
type: "service_spec"
status: "active"
service_id: "SVC_Notification-Dispatcher"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC: Notification Dispatcher

## Purpose
Fire-and-forget notification service that sends silent progress updates to Telegram users when the system is processing content (PDFs, YouTube transcripts, web content, etc.). It provides real-time feedback without interrupting the user's workflow, then restores the original data payload for downstream processing.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub after Format Detector |

**Workflow ID:** `OucxezHUhgZbcBusRKVp5`

## Processing Flow

```
┌─────────────────────────┐
│     Workflow Trigger   │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Prepare Notification   │  Code: Determine message based on format
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      Should Send?      │  IF: Check should_send flag
└────────┬────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌────────┐ ┌─────────────────┐
│  Send  │ │Return Original  │
│   Notif │ │   (Skipped)     │
└───┬────┘ └─────────────────┘
    │
    ▼
┌─────────────────────────┐
│ Return Original Data    │  Code: Restore original payload
└─────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Notification Preparation
- **Node:** `Prepare Notification` (Code)
- Determines if notification should be sent based on:
  - **Source:** Must be Telegram (`trigger_source === 'telegram'`)
  - **Chat ID:** Must be present
  - **Format:** Must not be `direct` or `text`

### Notification Message Mapping

| Format | Message |
|--------|---------|
| `pdf` | 📄 Processing PDF... |
| `csv` | 📊 Processing CSV... |
| `json` | 🔧 Processing JSON... |
| `xml` | 📋 Processing XML... |
| `voice` | 🎤 Transcribing voice... |
| `audio` | 🎵 Processing audio... |
| `video` | 🎬 Processing video... |
| `youtube_url` | 📺 Fetching YouTube transcript... |
| `web_url` | 🌐 Extracting web content... |
| `photo` | 🖼️ Processing image... |
| `excel` | 📊 Processing Excel... |
| `word` | 📝 Processing Word document... |
| *(default)* | ⏳ Processing... |

### Stage 2: Send Decision
- **Node:** `Should Send?` (IF)
- Checks `_notification.should_send === true`
- Branches:
  - **True** → Send Notification
  - **False** → Return Original (Skipped)

### Stage 3: Notification Delivery
- **Node:** `Send Notification` (Telegram)
- Sends silent notification (`disable_notification: true`)
- Uses `appendAttribution: false`
- Preserves original chat context

### Stage 4: Data Restoration
- **Node:** `Return Original Data` (Code)
- **Critical:** Retrieves pre-notification payload from `Prepare Notification` node
- Removes `_notification` metadata
- Returns clean payload for downstream processing

### Skip Conditions
Notifications are skipped when:
1. **Non-Telegram source:** `trigger_source !== 'telegram'`
2. **Missing Chat ID:** No chat_id in response_endpoint
3. **Direct text input:** `extraction_method === 'direct'` or `format === 'text'`

## Inputs

```json
{
  "_router": {
    "trigger_source": "telegram",
    "chat_id": "{{TELEGRAM_CHAT_ID}}",
    "trace_id": "trace_1234567890"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  },
  "input": {
    "format": "youtube_url",
    "extraction_method": "youtube_transcript"
  }
}
```

## Outputs

### With Notification Sent:
```json
{
  "_notification": {
    "skipped": false,
    "sent": true,
    "chat_id": "{{TELEGRAM_CHAT_ID}}",
    "message": "📺 Fetching YouTube transcript...",
    "format": "youtube_url"
  },
  "_router": { ... },
  "metadata": { ... },
  "input": { ... }
}
```

### After Data Restoration (final output):
```json
{
  "_router": { ... },
  "metadata": { ... },
  "input": { ... }
}
```

### With Notification Skipped:
```json
{
  "_notification": {
    "skipped": true,
    "reason": "direct_text_input"
  },
  "_router": { ... },
  "metadata": { ... },
  "input": { ... }
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/README.md) - State queries
- [S08 Automation Orchestrator](../../../20_Systems/README.md) - Workflow execution
- [S11 Meta-System Integration](../../../20_Systems/README.md) - Cross-system coordination

### Called By
- [ROUTER_Intelligent-Hub.md](ROUTER_Intelligent-Hub.md) - Primary caller (after Format Detector)

### External Services
- **Telegram Bot API** - Silent notification delivery

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| Telegram API failure | HTTP error | Continue to Return Original Data | n8n error workflow |
| Invalid chat_id | Telegram returns error | Skip notification, continue | None |
| Non-Telegram source | Logic check | Skip silently | None |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/OucxezHUhgZbcBusRKVp5/execute \
  -H "Content-Type: application/json" \
  -d '{
    "_router": {
      "trigger_source": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    },
    "metadata": {
      "response_endpoint": {
        "type": "telegram",
        "chat_id": "{{TELEGRAM_CHAT_ID}}"
      }
    },
    "input": {
      "format": "youtube_url",
      "extraction_method": "youtube_transcript"
    }
  }'
```

### Direct Telegram Test:
```bash
# Send silent notification
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id={{TELEGRAM_CHAT_ID}}" \
  -d "text=📺 Fetching YouTube transcript..." \
  -d "disable_notification=true"
```

## Security Notes

- **Silent Notifications:** `disable_notification: true` ensures no sound/vibration
- **Chat ID Protection:** Only sends to valid Telegram chat_ids
- **Source Validation:** Only processes Telegram-triggered requests

---

*Documentation synchronized with svc_notification-dispatcher.json v1.0 (2026-04-10)*