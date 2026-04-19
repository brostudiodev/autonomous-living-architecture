---
title: "SVC: Digital Twin Content Harvest"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Harvest"
goal_id: "goal-g02"
systems: ["G02", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Digital-Twin-Harvest

## Purpose
Triggers the "Automationbro Content Harvester" script via the Digital Twin API. This service scans recent project achievements and generates ready-to-use content drafts in the Obsidian vault.

## Triggers
- **Workflow Trigger:** Executed by `ROUTER_Intelligent_Hub`.
- **Command:** Triggered via `/harvest` in Telegram.

## Inputs
- **API Trigger:** `http://{{INTERNAL_IP}}:5677/harvest?format=text`.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 19-29): Extracts `chat_id`, `source_type`, and `username` from input JSON. Logs warning if chat_id is missing.
2. **Trigger Content Harvest** (HTTP Request node, line 32): GET request to `http://{{INTERNAL_IP}}:5677/harvest?format=text` - triggers content harvester script.
3. **Format for Dispatcher** (Code node, lines 52-62): Processes raw response - extracts text from various response fields. Returns fallback text "Harvest: Complete (Check Obsidian)" if response empty.

## Outputs
- **Obsidian File:** Creates a new `.md` draft in `00_Inbox/Content Ideas/`.
- **Response Message:** "Harvest: Complete (Check Obsidian)" sent to the user.

## Dependencies
### Systems
- [G02 Automationbro Recognition](../../../10_Goals/G02_Automationbro-Recognition/README.md) - Primary goal.
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Script executor.

## Manual Fallback
```bash
./.venv/bin/python scripts/G02_content_harvester.py
```
