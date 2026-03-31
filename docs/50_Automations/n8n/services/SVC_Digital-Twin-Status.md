---
title: "SVC: Digital Twin Status"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Status"
goal_id: "goal-g04"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-02-25"
---

# SVC: Digital-Twin-Status

## Purpose
Provides a real-time summary of the entire Autonomous Living ecosystem, including Health (HIT stats), Finance (MTD Net), Pantry (Low items), Home (Temp/Alerts), Brand, and Learning progress.

## Triggers
- **Workflow Trigger:** Executed by `ROUTER_Intelligent_Hub`.
- **Command:** Triggered via `/status` in Telegram.

## Inputs
- **API Call:** `http://[INTERNAL_IP]:5677/status?format=text`.

## Processing Logic
1. **Fetch:** Retrieves the unified state summary from the Digital Twin Engine.
2. **Format:** Normalizes the text for clear viewing on mobile devices.

## Outputs
- **Response Message:** Multi-domain status block.

## Dependencies
- Digital Twin Engine (`G04_digital_twin_engine.py`).
- PostgreSQL Databases.

## Manual Fallback
```bash
curl -s http://localhost:5677/status?format=text
```
