---
title: "SVC: Digital Twin Personal OS"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-OS"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Digital-Twin-OS

## Purpose
Serves the "Personal OS Meta-Optimization" report, providing high-signal warnings, insights, and recommendations across all life domains. This is the central intelligence node for "Director's Advice."

## Triggers
- **Workflow Trigger:** Executed by `ROUTER_Intelligent_Hub`.
- **Command:** Triggered via `/os` in Telegram.

## Inputs
- **Workflow Input:** `chat_id`, `source_type`.
- **API Call:** Requests data from `http://{{INTERNAL_IP}}:5677/os?format=text`.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 21-31): Extracts `chat_id`, `source_type`, and `username` from input JSON. Logs warning if chat_id is missing.
2. **Fetch Personal OS Advice** (HTTP Request node, line 34): GET request to `http://{{INTERNAL_IP}}:5677/os?format=text` - fetches Personal OS meta-optimization report.
3. **Format for Dispatcher** (Code node, lines 54-64): Processes raw response - extracts text from various response fields. Returns fallback text "OS: Offline" if response empty.

## Outputs
- **JSON Object:** `response_text` containing the Meta-Optimization Report.

## Dependencies
### Systems
- [S11 Intelligence Router](../../../20_Systems/S11_Meta-System-Integration/README.md) - Host logic for Meta-Rules.
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - State source.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Rules Engine Error | HTTP 500 / Timeout | Returns "OS: Offline" | Telegram Admin |

## Manual Fallback
```bash
curl -s http://localhost:5677/os?format=text
```
