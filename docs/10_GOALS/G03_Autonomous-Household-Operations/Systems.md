---
title: "G03: Systems"
type: "goal_systems"
status: "active"
owner: "Michał"
updated: "2026-02-07"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md) - Primary storage via `autonomous_pantry` database.
- [S08 Automation Orchestrator](../../20_SYSTEMS/S08_Automation-Orchestrator/README.md) - n8n synchronization.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Centralized pantry inventory | S03 Data Layer | PostgreSQL: `autonomous_pantry` | [SOP: Pantry-Management](../../30_SOPS/Home/Pantry-Management.md) |
| Automated Google Sheet Sync | S08 Orchestrator | [n8n: Pantry-Sync](../../50_AUTOMATIONS/n8n/services/pantry-data-sync.md) | - |
| Predictive restocking logic | S04 Digital Twin | [script: G03_predictor.py](../../50_AUTOMATIONS/scripts/g03-predictor.md) | - |

