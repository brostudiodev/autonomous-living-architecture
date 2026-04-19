---
title: "SVC: Google Calendar"
type: "service_spec"
status: "active"
service_id: "SVC_Google-Calendar"
goal_id: "goal-g10"
systems: ["S04", "S08", "S10"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Google Calendar

## Purpose
AI-powered Google Calendar assistant that handles natural language calendar queries and actions. It uses Google Gemini to understand intent and automatically executes calendar operations (create events, get events, etc.) with intelligent assumption-making when information is missing. Operates in "Assume & Act" mode - never asks for clarification, always makes a decision.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub for `calendar` intent |
| **Command** | Via Telegram | Any message with calendar-related content |

**Workflow ID:** `9GISOtBzooWu9JSI`

## Processing Flow

```
┌─────────────────────────────────┐
│    Execute Workflow Trigger     │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│      Normalize Input            │  Code: Extract query, action, timezone
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│      Calendar Agent             │  LangChain Agent: Gemini + Tools
│    (LangChain Agent)            │
└────────────┬────────────────────┘
             │
     ┌───────┴───────┐
     ▼               ▼
┌─────────┐   ┌──────────────┐
│ Create  │   │   Get        │
│  Event  │   │   Events     │
└─────────┘   └──────────────┘
     │               │
     └───────┬───────┘
             │
             ▼
┌─────────────────────────────────┐
│    Response Formatter           │  Code: Format result for Dispatcher
└─────────────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Input Normalization
- **Node:** `Normalize Input` (Code)
- Extracts query from router payload:
  - `intent.entities.raw_query` (primary)
  - `normalized.text` (fallback)
  - `input.raw_content` (fallback)
- Extracts action from `intent.secondary`
- Sets context:
  - Current datetime in `Europe/Warsaw` timezone
  - ISO format for tool calculations
  - Preserves `_router` metadata

### Stage 2: Calendar Agent (LangChain)
- **Node:** `Calendar Agent` (LangChain Agent)
- **Model:** Google Gemini Flash Lite (temperature: 0.2)
- **System Prompt:** Contains comprehensive "Assume & Act" directives

**Core Directives:**
1. **NEVER ask for clarification** - Make intelligent assumptions
2. **Missing month:** If day passed → next month, else current month
3. **Missing year:** Current year (or next if date passed)
4. **Missing time:** Default 10:00, "rano"→09:00, "popołudniu"→14:00
5. **Missing duration:** Default 60 min, "szybkie"→30 min, "dłuższe"→90 min

**Polish Language Support:**
- Months: "stycznia", "lutego", "marca", etc.
- Days: "poniedziałek", "wtorek", "środa", etc.
- Times: "godz 15:40" format support

### Stage 3: Tool Execution
The agent has access to Google Calendar tools:

| Tool | Operation | Description |
|------|-----------|-------------|
| **Create Event** | `create` | Create single event with title, start, end |
| **Create Event with Attendee** | `create` | Create event with attendee email |
| **Get Events** | `getAll` | List events in date range |

### Stage 4: Response Formatting
- **Node:** `Response Formatter` (Code)
- Formats result for `SVC_Response-Dispatcher`

## Inputs

```json
{
  "intent": {
    "primary": "calendar",
    "entities": {
      "raw_query": "spotkanie z Markiem w poniedziałek o 14"
    }
  },
  "_router": {
    "chat_id": "{{TELEGRAM_CHAT_ID}}",
    "trigger_source": "telegram"
  }
}
```

## Outputs

```json
{
  "response_text": "✅ Utworzyłem spotkanie:\n📅 Poniedziałek, 14 kwietnia 2025\n🕑 14:00 - 15:00\n👤 Z: Marek\n\nSzczegóły dodane do kalendarza.",
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
- [S10 Intelligent Productivity](../../../20_Systems/S09_Productivity-Time/README.md) - Calendar data

### Called By
- [ROUTER_Intelligent-Hub.md](./ROUTER_Intelligent-Hub.md) - Via `calendar` intent

### External Services
- **Google Gemini API** - LLM reasoning (gemini-flash-lite-latest)
- **Google Calendar API** - Calendar operations ({{EMAIL}})

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| No query found | throw Error | Error propagated to Dispatcher | None |
| Gemini API failure | HTTP error | Returns error message | n8n error workflow |
| Calendar API failure | API error | Returns tool error | n8n error workflow |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/9GISOtBzooWu9JSI/execute \
  -H "Content-Type: application/json" \
  -d '{
    "intent": {
      "entities": {
        "raw_query": "spotkanie w środę o 10"
      }
    },
    "_router": {
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  }'
```

### Direct Google Calendar test:
```bash
# List upcoming events
curl -s "https://www.googleapis.com/calendar/v3/calendars/{{EMAIL}}/events?maxResults=10" \
  -H "Authorization: Bearer ${GOOGLE_TOKEN}"
```

## Supported Query Patterns

| Polish Example | English Translation | Action |
|----------------|---------------------|---------|
| "spotkanie w poniedziałek o 14" | "meeting Monday at 2pm" | Create event |
| "dodaj event jutro o 9" | "add event tomorrow at 9" | Create event |
| "co mam dziś w kalendarzu" | "what do I have today" | Get events |
| "pokaż spotkania na przyszły tydzień" | "show next week meetings" | Get events |
| " Spotkanie z Markiem" | "Meeting with Marek" | Create event with attendee |

## Intelligent Assumptions

| Missing Information | Assumption Made |
|---------------------|-----------------|
| Month (only day number) | Current month (or next if passed) |
| Year | Current year (or next if date passed) |
| Time | 10:00 (morning default) |
| Duration | 60 minutes |
| "rano" time | 09:00 |
| "popołudniu" time | 14:00 |
| "wieczorem" time | 18:00 |
| "szybkie spotkanie" | 30 minutes |
| "dłuższe spotkanie" | 90 minutes |

## Security Notes

- **Calendar Access:** Uses `{{EMAIL}}` calendar
- **OAuth:** Requires Google Calendar OAuth2 credentials
- **No Public Access:** Workflow is internal-only

---

*Documentation synchronized with svc_google-calendar.json v1.0 (2026-04-10)*