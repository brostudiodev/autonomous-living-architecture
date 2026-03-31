---
title: "G07: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
updated: "2026-03-21"
goal_id: "goal-g07"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL `autonomous_health` database.
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md) - Biometric analysis and training integration.

## Traceability (Outcome → System → Automation → SOP/Runbook)
| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Automated HR/Sleep Sync | S06 Health | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07_zepp_sync.md) | - |
| Automated Weight/Body Fat Sync | S06 Health | [script: G07_weight_sync.py](../../50_Automations/scripts/withings_to_sheets.md) | - |
| Hydration & Caffeine Logging | S04 Digital Twin | [API: /log_water /log_coffee](../../50_Automations/scripts/G04_digital_twin_api.md) | - |
| Historical Sleep Persistence | S06 Health | [script: G07_zepp_sync.py](../../50_Automations/scripts/G07_zepp_sync.md) | - |
| Biological Readiness Scoring | S03 Data Layer | [autonomous_daily_manager.py](../../50_Automations/scripts/autonomous_daily_manager.md) | - |
| Biological Readiness Schedule Pivot | S06 Health | [G07_health_recovery_pro.md](../../50_Automations/scripts/G07_health_recovery_pro.md) | - |
| Integrated Training Planning | S06 Health | [G01_training_planner.py](../../50_Automations/scripts/G01_training_planner.md) | - |
| Proactive Health Anomaly Detection | S06 Health | [G07_health_anomaly_monitor.md](../../50_Automations/scripts/G07_health_anomaly_monitor.md) | - |

