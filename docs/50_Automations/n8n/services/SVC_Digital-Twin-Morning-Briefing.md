---
title: "SVC: Digital Twin Morning Briefing"
type: "service_spec"
status: "active"
service_id: "SVC_Digital-Twin-Morning-Briefing"
goal_id: "goal-g04"
systems: ["S04", "S08", "S10"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Digital Twin Morning Briefing

## Purpose
Generates a comprehensive morning briefing with daily priorities, tasks, health vitals, schedule, and system status. Provides users with a complete "daily launchpad" to start their day informed and prepared. Supports Polish and English languages based on query keywords.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub for `/morning_briefing` command |
| **Direct API** | HTTP POST | `http://{{INTERNAL_IP}}:5677/morning_briefing` |

**Workflow ID:** `Jh4AH3mKzrwKobam`

## Processing Flow

```
┌─────────────────────────────────┐
│ When Executed by Another        │
│        Workflow                 │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Normalize Router Input         │  Code: Extract query, language, chat_id
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Progress: Service Started     │  SVC_Response-Dispatcher: "🌅 Morning Briefing - Generating..."
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│    Trigger Morning Briefing     │  HTTP: POST /morning_briefing
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│    Format for Dispatcher        │  Code: Normalize response
└─────────────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Input Normalization
- **Node:** `Normalize Router Input` (Code)
- Extracts query from:
  - `input.query`, `input.text`, `input.chatInput`, or `input.message`
- Cleans command: removes `/morning_briefing` prefix
- **Language Detection:** Checks for Polish keywords (`rano`, `poranek`, `dzień dobry`) vs English (`morning`, `briefing`, `priorities`)
- Extracts routing metadata: `chat_id`, `source_type`, `username`

### Stage 2: Progress Notification
- **Node:** `Progress: Service Started` (Execute Workflow)
- Calls `SVC_Response-Dispatcher` with:
  - Message: "🌅 *Morning Briefing* - Generating...\n⏳ Fetching your priorities, tasks and vitals."
  - `message_type: "progress"` (silent)
  - `waitForSubWorkflow: false` (async)

### Stage 3: API Call
- **Node:** `Trigger Morning Briefing` (HTTP Request)
- **Endpoint:** `http://{{INTERNAL_IP}}:5677/morning_briefing`
- **Note:** IP should be replaced with `{{INTERNAL_IP}}` placeholder
- **Method:** POST
- **Response:** Full response object

### Stage 4: Response Formatting
- **Node:** `Format for Dispatcher` (Code)
- Extracts `response_text` from API body
- Returns structured output for `SVC_Response-Dispatcher`

## Inputs

```json
{
  "query": "/morning_briefing",
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "username": "Michal"
}
```

## Outputs

```json
{
  "response_text": "🌅 **MORNING BRIEFING** 🌅\n\n📋 **TASKS**\n1. Review G01 training progress\n2. Complete AI Architect study module\n3. Schedule content creation\n\n💪 **HEALTH**\n- Readiness: 87% ✅\n- Sleep: 7h 23m\n- HRV: 45ms\n\n📅 **TODAY**\n- 09:00 Team Standup\n- 14:00 Deep work block\n- 18:00 Gym session\n\n💰 **FINANCE**\n- MTD: +3,200 PLN\n- Budget: On track\n\n🏠 **HOME**\n- Temperature: 22°C\n- No alerts",
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    },
    "language": "pl",
    "username": "Michal"
  },
  "success": true
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Morning briefing data source
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution
- [S10 Intelligent Productivity](../../../20_Systems/S09_Productivity-Time/README.md) - Task/schedule data

### Workflows Called
- **SVC_Response-Dispatcher** - Progress and final responses

### External Services
- **Digital Twin API** (Port 5677) - Morning briefing generation

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| API timeout | HTTP timeout | Returns "No data available" message | n8n error workflow |
| API unreachable | Connection error | Returns error in response_text | n8n error workflow |
| Missing chat_id | Null check | Uses null, dispatcher handles | None |

## Manual Fallback

### Test via curl:
```bash
curl -s -X POST http://localhost:5677/morning_briefing
```

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/Jh4AH3mKzrwKobam/execute \
  -H "Content-Type: application/json" \
  -d '{"query": "/morning_briefing", "chat_id": "{{TELEGRAM_CHAT_ID}}"}'
```

## Supported Commands

| Command | Description |
|---------|--------------|
| `/morning_briefing` | Full morning briefing (default) |
| `/morning_briefing pl` | Polish language |
| `/morning_briefing en` | English language |
| `/briefing` | Short form |
| `morning` | Direct query |

## Language Support

| Detected Keywords | Language |
|-------------------|-----------|
| rano, poranek, dzień dobry, briefing, plan dnia, priorytety, zadania | Polish (pl) |
| morning, briefing, priorities, day plan, tasks, schedule | English (en) |

## Security Notes

- **Hardcoded IP:** Uses `{{INTERNAL_IP}}` - should use `{{INTERNAL_IP}}` placeholder
- **No Auth:** Morning briefing endpoint has no authentication

---

*Documentation synchronized with svc_digital-twin-morning-briefing.json v1.0 (2026-04-10)*