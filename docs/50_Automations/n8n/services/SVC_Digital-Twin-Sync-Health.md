---
title: "SVC: Digital Twin Sync Health"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Sync-Health"
goal_id: "goal-g04"
systems: ["S04", "S08", "S07"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Digital-Twin-Sync-Health

## Purpose
Syncs health/biometric data from Zepp (Amazfit) cloud to local PostgreSQL database. Triggered manually or via `/health_sync` command. Provides real-time health telemetry for Digital Twin queries.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Command:** Triggered via `/health_sync` or `/sync` in Telegram.

## Inputs
- **Workflow Input:** JSON object containing `chat_id`, `source_type`, and `username`.
- **Zepp API:** Fetches health data from Amazfit cloud via `G07_zepp_sync.py` script.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 21-31): Extracts query, detects language (Polish/English), extracts chat_id, source_type, username.
2. **Send Progress Notification** (Execute Workflow node, lines 32-60): Calls `SVC_Response-Dispatcher` to notify "🏥 Fetching health data..."
3. **Execute Health Sync Script** (Execute Workflow node, lines 61-89): Runs `G07_zepp_sync.py` script for actual data sync.
4. **Verify Sync Success** (IF node): Checks if sync completed.
5. **Send Confirmation** (Execute Workflow node): Sends completion message to Telegram.

## Outputs
- **Database:** Health metrics in `autonomous_health.biometrics` table.
- **Telegram:** Confirmation message with sync status.

## Dependencies
### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Source API.
- [S07 Predictive Health Management](../../../20_Systems/S06_Health-Performance/README.md) - Health DB.
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution.

### External Services
- Zepp/Amazfit Cloud API.
- Telegram Bot.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Zepp API failure | Script returns error | Error message to user | n8n Execution log |
| Auth expired | Script error | "Please re-authenticate" message | Telegram |
| Database error | PostgreSQL node error | Workflow error logged | n8n Execution log |

## Security Notes
- Zepp credentials stored in `zepp_token.json`.
- Telegram credentials stored in n8n credential store.

## Manual Fallback
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts && python3 G07_zepp_sync.py
```