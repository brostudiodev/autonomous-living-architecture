---
title: "G03: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
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
| Automated Google Sheet Sync | S08 Orchestrator | [n8n: Pantry-Sync](../../50_Automations/n8n/services/SVC_Autonomous-Pantry-Data-Sync.md) | - |
| Automated Restocking List | S03 Data Layer | [pantry_to_tasks.py](../../50_Automations/scripts/pantry-to-tasks.md) | - |
| Predictive Burn Rate Engine | S03 Data Layer | [view: v_pantry_burn_rate](../../20_Systems/S03_Data-Layer/README.md) | - |
| Stock-out Forecasting | S03 Data Layer | [view: v_pantry_predictions](../../20_Systems/S03_Data-Layer/README.md) | - |
| Predictive restocking logic | S03 Data Layer | [script: g03_predictive_pantry_simple.py](../../50_Automations/scripts/g03-predictor.md) | - |
| Natural language inventory control | S08 Orchestrator | [n8n: AI Pantry Agent](../../50_Automations/n8n/services/PROJ_Inventory-Management.md) | [SOP: Pantry-Management](../../30_Sops/Home/Pantry-Management.md) |

> [!important]
> The **standard AI Agent for pantry** controls all data flows between the Google Sheets interface and the PostgreSQL data layer. No intermediate CSV files are used in this architecture.

