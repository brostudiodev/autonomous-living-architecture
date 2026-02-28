---
title: "G07: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
updated: "2026-02-07"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL `autonomous_health` database.
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md) - Biometric analysis and training integration.

## Traceability (Outcome → System → Automation → SOP/Runbook)
| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Automated HR/Sleep Sync | S06 Health | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07-zepp-sync.md) | - |
| Automated Weight/Body Fat Sync | S06 Health | [script: G07_weight_sync.py](../../50_Automations/scripts/G07-weight-sync.md) | - |
| Biological Readiness Scoring | S03 Data Layer | [autonomous_daily_manager.py](../../50_Automations/scripts/autonomous-daily-manager.md) | - |
| Integrated Training Planning | S06 Health | [G01_training_planner.py](../../50_Automations/scripts/training-planner.md) | - |

