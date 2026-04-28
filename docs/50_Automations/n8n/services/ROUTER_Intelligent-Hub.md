---
title: "ROUTER: Intelligent Hub"
type: "service_spec"
status: "active"
service_id: "ROUTER_Intelligent-Hub"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# ROUTER: Intelligent Hub

## Purpose
The **Central Brain Router** - the primary entry point for all user inputs entering the autonomous system. This workflow orchestrates the complete processing pipeline from input receipt through intelligent routing to appropriate domain services. It handles Telegram messages, webhooks, and chat interface inputs with unified authentication and intent classification.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Telegram Input** | Telegram Trigger | Updates: `message`, `callback_query` |
| **Webhook** | Webhook | Path: `/intelligence-hub`, Method: POST |
| **Chat Interface** | Chat Trigger (LangChain) | n8n Chat widget input |

**Credential:** Telegram (AndrzejSmartBot) - `XDROmr9jSLbz36Zf`

## Processing Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            ROUTER INTELLIGENT HUB                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  [Telegram] ──┐                                                            │
│  [Webhook]  ──┼──►  Call: Input Normalizer ──► Is Authorized? ──┐         │
│  [Chat]     ──┘                                            │             │
│                                                            ▼             │
│                                                     Converge & Clean       │
│                                                            │             │
│                                                            ▼             │
│                                                 SVC: Format Detector       │
│                                                            │             │
│                                                            ▼             │
│                                                    Post Detector           │
│                                                            │             │
│                                                            ▼             │
│                                              Call: Notification Dispatcher │
│                                               (Progress Update)           │
│                                                            │             │
│                                                            ▼             │
│                                                    Stage3: Classify Intent │
│                                                            │             │
│                                                            ▼             │
│                                              Stage 4: Route by Intent     │
│                                                            │             │
│         ┌──────────┬──────────┬──────────┬──────────┬───┴───┐           │
│         ▼          ▼          ▼          ▼          ▼       ▼           │
│     [command]  [question] [capture]   [task]  [conversation] [callback]  │
│         │          │          │          │          │           │        │
│         ▼          ▼          ▼          ▼          ▼           ▼        │
│    Cmd-Handler  LLM-Chat  Intelligence Task-Creator  Greeting  Callback  │
│         │          │          │          │          │           │        │
│         └──────────┴──────────┴────┬─────┴──────────┴───────────┘        │
│                                    ▼                                      │
│                            Response Dispatcher                            │
│                                    │                                      │
│                                    ▼                                      │
│                              Telegram Reply                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Input Normalization
Three parallel branches normalize inputs from different sources:
- **Call: Input Normalizer (TG)** - Telegram messages
- **Call: Input Normalizer (Webhook)** - HTTP POST requests
- **Call: Input Normalizer (Chat)** - n8n Chat interface

Each branch calls `SVC_Input-Normalizer` workflow to extract:
- User info (user_id, username, chat_id)
- Message content (text, attachments)
- Trace metadata (trace_id, timestamp)

### Stage 2: Authorization Check
- **Node:** `Is Authorized?` (IF condition)
- **Check:** `_normalized.success === true`
- **Result:** Unauthorized users receive rejection message; authorized flows continue

### Stage 3: Data Convergence
- **Node:** `Converge & Clean` (Code)
- Removes temporary normalization flags
- Preserves `_router` metadata for downstream services
- Ensures `metadata` structure compatibility with Format Detector

### Stage 4: Format Detection
- **Node:** `SVC: Format Detector` (Execute Workflow)
- Calls `SVC_Format-Detector-Extractor` (ID: `e8ra0WcR4TalzD7NpA7UD`)
- Detects input format: text, voice, YouTube URL, web URL, PDF, CSV, JSON, XML
- Extracts content using appropriate method (direct, Whisper STT, YouTube transcript, etc.)

### Stage 5: Post-Detector Processing
- **Node:** `Post Detector` (Code)
- Merges router metadata back with Format Detector result
- Sets default extraction_method and format if null

### Stage 6: Progress Notification
- **Node:** `Call 'SVC_Notification-Dispatcher'`
- Sends progress update to user: "🟡 **Intelligence Processor** - Started"

### Stage 7: Intent Classification
- **Node:** `Stage3 Classify` (Code)
- **Priority-based classification:**
  1. **Callback buttons** → `primary: "callback"` (confidence: 1.0)
  2. **Commands** (starts with `/`) → `primary: "command"` (confidence: 1.0)
  3. **Format-based capture** (YouTube, web URLs) → `primary: "capture"` (confidence: 0.95)
  4. **Task prefixes** (task:, todo:) → `primary: "task"` (confidence: 0.9)
  5. **Note prefixes** (note:, idea:) → `primary: "capture"` (confidence: 0.9)
  6. **Questions** → `primary: "question"` (confidence: 0.8)
  7. **Default** → `primary: "conversation"` (confidence: 0.5)

### Stage 8: Intent Routing
- **Node:** `Stage 4: Route by Intent` (Switch)
- Routes based on `intent.primary` value:

| Intent | Output Key | Handler Workflow |
|--------|------------|------------------|
| `command` | command | SVC_Command-Handler |
| `question` | question | Route: LLM Chat (Webhook) |
| `capture` | capture | SVC_Intelligence-Processor |
| `task` | task | Route: Task Creator (Webhook) |
| `conversation` | conversation | Handle Greeting (Telegram) |
| `callback` | callback | Route: Callback Handler (Webhook) |
| `calendar` | calendar | SVC_Google-Calendar |
| `status` (command) | status_command | SVC_Digital-Twin-Status |
| fallback | extra | Intent Fallback Response |

## Inputs

```json
{
  "_router": {
    "trigger_source": "telegram|webhook|chat",
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
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  },
  "input": {
    "raw_content": "Hello, what's the weather?",
    "format": "text"
  }
}
```

## Outputs

Each branch produces output passed to `SVC_Response-Dispatcher`:
```json
{
  "response_text": "Response message to user",
  "message_type": "result|progress",
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  }
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - State queries
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md) - Cross-system coordination

### Workflows Called

| Workflow | ID | Purpose |
|----------|-----|---------|
| SVC_Input-Normalizer | CGDnB0528onmqKW7X0yHg | Input normalization & auth |
| SVC_Format-Detector-Extractor | e8ra0WcR4TalzD7NpA7UD | Format detection & extraction |
| SVC_Notification-Dispatcher | OucxezHUhgZbcBusRKVp5 | Progress notifications |
| SVC_Command-Handler | 0oOi-Ucz-WkXC-RXjHXAT | Command processing |
| SVC_Intelligence-Processor | 2Tw0zw8nti_kcLB1CSynU | AI content analysis |
| SVC_Google-Calendar | 9GISOtBzooWu9JSI | Calendar operations |
| SVC_Digital-Twin-Status | new-digital-twin-status-id | System status |
| SVC_Response-Dispatcher | pag6IhR3yLeBUpR4cb8L9 | Response formatting |

### External Services
- **Telegram Bot API** - Message reception and sending
- **Google Gemini** - LLM processing (via downstream services)

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| Unauthorized user | `_normalized.success !== true` | Telegram: "⛔ Unauthorized access" | None |
| Input Normalizer timeout | Workflow timeout (>120s) | Return "System busy" via Dispatcher | n8n error workflow |
| Format Detector error | HTTP 500 from sub-workflow | Fallback to direct text extraction | Log to console |
| Intent classification failure | Unhandled exception | Default to "conversation" intent | None |
| Sub-workflow failure | executeWorkflow error | Send error message via Dispatcher | n8n error workflow |

## Manual Fallback

### Test via curl (Webhook):
```bash
curl -X POST http://localhost:5678/webhook/intelligence-hub \
  -H "Content-Type: application/json" \
  -d '{"message": {"chat": {"id": "{{TELEGRAM_CHAT_ID}}"}, "text": "test"}}'
```

### Test via Telegram:
Send any message to AndrzejSmartBot

### Check workflow status:
```bash
# List workflow runs
curl -s http://localhost:5678/rest/workflows/ROUTER_Intelligent_Hub -u user:pass | jq '.data'
```

## Supported Input Formats

| Format | Detection | Extraction Method |
|--------|-----------|-------------------|
| Text (direct) | Default | `direct` |
| Voice/Audio | Telegram voice file | `whisper_stt` |
| YouTube URL | youtube.com/watch or youtu.be | `youtube_transcript` |
| Web URL | https:// prefix | `web_scraper` |
| PDF | file attachment .pdf | `pdf_text_extraction` |
| CSV | file attachment .csv | `csv_parsing` |
| JSON | file attachment .json | `json_parsing` |
| XML | file attachment .xml | `xml_parsing` |
| Text file | .txt or .md attachment | `direct` |

## Supported Commands

| Command | Handler | Description |
|---------|---------|-------------|
| `/start` | SVC_Command-Handler | Start bot |
| `/help` | SVC_Command-Handler | Show help |
| `/status` | SVC_Digital-Twin-Status | System status |
| `/goals` | SVC_Command-Handler | Show 12 goals |
| `/inventory` | SVC_Command-Handler | Pantry status |
| `/pantry` | SVC_Command-Handler | Pantry status |
| `/finance` | SVC_Command-Handler | Financial overview |
| `/today` | SVC_Command-Handler | Daily plan |
| `/sync` | SVC_Command-Handler | Trigger sync |
| *(any other)* | SVC_Command-Handler | Forward to Digital Twin API |

## Security Notes

- **Telegram Authentication:** Only user ID `{{TELEGRAM_CHAT_ID}}` (Michał) is authorized
- **Webhook Security:** No auth on webhook (internal-only, not exposed to internet)
- **Chat Interface:** No auth required (assumes trusted internal network)
- **Rate Limiting:** Not implemented at router level (handled by Telegram API)

---

*Documentation synchronized with ROUTER_Intelligent_Hub.json v1.0 (2026-04-10)*