---
title: "G03: Systems"
type: "goal_systems"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Primary storage via `autonomous_pantry` database.
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n synchronization.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Centralized pantry inventory | S03 Data Layer | PostgreSQL: `autonomous_pantry` | [SOP: Pantry-Management](../../30_Sops/Home/Pantry-Management.md) |
| Automated Google Sheet Sync | S08 Orchestrator | [n8n: Pantry-Sync](../../50_Automations/n8n/services/pantry-data-sync.md) | - |
| Predictive restocking logic | S04 Digital Twin | [script: G03_predictor.py](../../50_Automations/scripts/g03-predictor.md) | - |

