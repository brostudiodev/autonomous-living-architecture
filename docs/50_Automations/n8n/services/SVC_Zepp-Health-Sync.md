---
title: "SVC: Zepp Health Sync"
type: "service_spec"
status: "active"
service_id: "SVC_Zepp-Health-Sync"
goal_id: "goal-g07"
systems: ["S04", "S06", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Zepp Health Sync

## Purpose
Synchronizes health data from Amazfit/Zepp wearable devices (via Zepp API) to the local PostgreSQL database. This workflow retrieves biometric data including heart rate, HRV, sleep quality, and activity metrics, then stores them for analysis by other services like G07 (Predictive Health Management) and G01 (Target Body Fat).

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub or scheduled workflows |

**Workflow ID:** (Embedded in SVC_Zepp-Health-Sync.json - ID not visible in truncated output)

## Processing Flow

```
┌─────────────────────────────────┐
│ When Executed by Another         │  Workflow Trigger (passthrough)
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
│    Trigger Health Sync          │  HTTP: POST /health_sync
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│   Format for Dispatcher        │  Code: Format response
└─────────────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Input Normalization
- **Node:** `Normalize Router Input` (Code)
- Extracts routing metadata:
  - `chat_id` - for response routing
  - `source_type` - telegram/webhook/etc
  - `username` - for display

### Stage 2: Health Sync API Call
- **Node:** `Trigger Health Sync` (HTTP Request)
- **Endpoint:** `http://{{INTERNAL_IP}}:5677/health_sync`
- **Method:** POST
- Calls the Digital Twin health sync endpoint

### Stage 3: Response Formatting
- **Node:** `Format for Dispatcher` (Code)
- Extracts `report` from API response
- Formats for `SVC_Response-Dispatcher`

## Data Flow

```
Amazfit/Zepp API → G07_zepp_sync.py → PostgreSQL (autonomous_health)
                                            ↓
                              G01, G07, G10 (read for analysis)
```

## Inputs

```json
{
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "username": "Michal"
}
```

## Outputs

```json
{
  "response_text": "💪 Health Sync Complete\n\n❤️ Heart Rate: 65 bpm (avg)\n😴 Sleep: 7h 23m\n  - Deep: 1h 45m\n  - REM: 2h 10m\n📊 Readiness: 87%\n🏃 Steps: 8,432",
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "success": true
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Health sync endpoint
- [S06 Health Performance System](../../../20_Systems/S06_Health-Performance/README.md) - Health data processing
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution

### Scripts
- **G07_zepp_sync.py** - Primary sync script for Zepp API data

### Database
- **autonomous_health** - Stores health metrics

## Data Collected

| Metric | Description | Storage |
|--------|-------------|---------|
| Heart Rate | BPM (resting, avg, max) | `biometrics` table |
| HRV | Heart rate variability (ms) | `biometrics` table |
| Sleep | Deep/REM/Light duration | `sleep_log` table |
| Activity | Steps, calories, distance | `body_metrics` table |
| Readiness | Daily readiness score | `biometrics` table |

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| API timeout | HTTP timeout | Returns "Health Sync Initiated" | n8n error workflow |
| API unreachable | Connection error | Returns error message | n8n error workflow |
| No data from Zepp | Empty response | Returns generic message | Log to console |

## Manual Fallback

### Test via curl:
```bash
curl -s -X POST http://localhost:5677/health_sync
```

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/SVC_Zepp-Health-Sync/execute \
  -H "Content-Type: application/json" \
  -d '{"chat_id": "{{TELEGRAM_CHAT_ID}}"}'
```

## Security Notes

- **Internal API:** Health sync endpoint uses `{{INTERNAL_IP}}` placeholder
- **No Auth:** Assumes internal network access
- **Data Privacy:** Health data stored in local PostgreSQL only

---

*Documentation synchronized with SVC_Zepp-Health-Sync.json v1.0 (2026-04-10)*