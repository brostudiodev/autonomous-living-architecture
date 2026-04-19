---
title: "SVC: Digital Twin Sync Scale"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Sync-Scale"
goal_id: "goal-g04"
systems: ["S04", "S08", "S07"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Digital-Twin-Sync-Scale

## Purpose
Syncs weight/body composition data from Withings scale to local PostgreSQL database. Triggered manually or via `/scale_sync` command. Provides body metrics for Digital Twin queries.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Command:** Triggered via `/scale_sync` or `/sync` in Telegram.

## Inputs
- **Workflow Input:** JSON object containing `chat_id`, `source_type`, and `username`.
- **Withings API:** Fetches weight data from Withings Health API.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 21-31): Extracts query, detects language (Polish/English), extracts chat_id, source_type, username.
2. **Send Progress Notification** (Execute Workflow node): Calls `SVC_Response-Dispatcher` to notify "⚖️ Fetching scale data..."
3. **Execute Scale Sync Script** (Execute Workflow node): Runs `G07_weight_sync.py` script for data sync.
4. **Verify Sync Success** (IF node): Checks if sync completed.
5. **Send Confirmation** (Execute Workflow node): Sends completion message to Telegram.

## Outputs
- **Database:** Weight metrics in `autonomous_health.measurements` table.
- **Telegram:** Confirmation message with sync status.

## Dependencies
### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Source API.
- [S07 Predictive Health Management](../../../20_Systems/S06_Health-Performance/README.md) - Health DB.
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution.

### External Services
- Withings Health API.
- Telegram Bot.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Withings API failure | Script returns error | Error message to user | n8n Execution log |
| Auth expired | Script error | "Please re-authenticate" message | Telegram |

## Manual Fallback
```bash
cd {{ROOT_LOCATION}}/autonomous-living/scripts && python3 G07_weight_sync.py
```