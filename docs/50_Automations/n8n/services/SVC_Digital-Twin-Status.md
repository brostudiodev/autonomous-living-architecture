---
title: "SVC: Digital Twin Status"
type: "service_spec"
status: "active"
service_id: "SVC_Digital-Twin-Status"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Digital Twin Status

## Purpose
Provides a real-time summary of the entire Autonomous Living ecosystem, including Health (HIT stats), Finance (MTD Net), Pantry (Low items), Home (Temperature/Alerts), Brand (Automationbro), and Learning progress. This is the primary command for users to get a quick overview of all systems.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub for `/status` command |
| **Direct API** | HTTP GET | `http://{{INTERNAL_IP}}:5677/status?format=text` |

**Workflow ID:** `ddAcncpRNWtdH4mP`

**Note:** Workflow is currently marked as inactive (`active: false`) in n8n - may need activation.

## Processing Flow

```
┌─────────────────────────────────┐
│ When Executed by Another        │  Workflow Trigger (passthrough)
│        Workflow                 │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  Normalize Router Input         │  Code: Extract chat_id, source_type
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│     Fetch Full Status          │  HTTP: GET /status?format=text
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
- Extracts from input:
  - `chat_id` - from `input.chat_id` or `_router.chat_id`
  - `source_type` - from `input.source_type` or `_router.trigger_source`
  - `username` - from `input.username` or `_router.username`
- Returns normalized context in `_ctx`

### Stage 2: Status Fetch
- **Node:** `Fetch Full Status` (HTTP Request)
- **Endpoint:** `http://{{INTERNAL_IP}}:5677/status?format=text`
- **Note:** IP should be replaced with placeholder `{{INTERNAL_IP}}` for security
- Fetches full status from Digital Twin API
- Returns raw text response

### Stage 3: Response Formatting
- **Node:** `Format for Dispatcher` (Code)
- Handles multiple response formats:
  - Plain string response
  - JSON with `data`, `body`, `response_text`, or `content` fields
- Returns structured output:
  - `response_text` - formatted status message
  - `chat_id` - for routing
  - `source_type` - for dispatcher
  - `metadata` - with response_endpoint
  - `success: true`

## Inputs

```json
{
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "username": "Michal"
}
```

Or from Router:
```json
{
  "_router": {
    "chat_id": "{{TELEGRAM_CHAT_ID}}",
    "trigger_source": "telegram",
    "username": "Michal"
  }
}
```

## Outputs

```json
{
  "response_text": "📊 AUTONOMOUS LIVING STATUS\n\n💪 Health: 3/3 workouts this week\n💰 Finance: +2,450 PLN MTD\n🛒 Pantry: 5 items low stock\n🏠 Home: 22°C, all systems OK\n📚 Learning: 2/5 exams passed\n🤖 Brand: 1,234 Substack subscribers",
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    },
    "username": "Michal"
  },
  "success": true
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Status source
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution

### Called By
- [ROUTER_Intelligent-Hub.md](./ROUTER_Intelligent-Hub.md) - Via `/status` command

### External Services
- **Digital Twin API** (Port 5677) - Status data provider

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| Missing chat_id | Console warning | Continues with null chat_id | Log to console |
| API timeout | HTTP timeout | Returns "Status: Service Unavailable" | None |
| API unreachable | Connection error | Returns error in response_text | n8n error workflow |

## Manual Fallback

### Test via curl:
```bash
curl -s http://localhost:5677/status?format=text
```

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/ddAcncpRNWtdH4mP/execute \
  -H "Content-Type: application/json" \
  -d '{"chat_id": "{{TELEGRAM_CHAT_ID}}", "source_type": "telegram"}'
```

## Status Domains

| Domain | Data Source | Example Output |
|--------|--------------|----------------|
| Health | G01, G07 | "3/3 workouts this week" |
| Finance | G05 | "+2,450 PLN MTD" |
| Pantry | G03 | "5 items low stock" |
| Home | G08 | "22°C, all systems OK" |
| Brand | G02 | "1,234 Substack subscribers" |
| Learning | G06 | "2/5 exams passed" |

## Security Notes

- **Hardcoded IP:** Currently uses `{{INTERNAL_IP}}` - should use `{{INTERNAL_IP}}` placeholder
- **No Auth:** Status endpoint has no authentication (assumes internal network)

---

*Documentation synchronized with svc_digital-twin-status.json v1.0 (2026-04-10)*