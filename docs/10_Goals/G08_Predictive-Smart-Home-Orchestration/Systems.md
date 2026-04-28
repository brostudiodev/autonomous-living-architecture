---
title: "G08: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g08"
owner: "Michał"
updated: "2026-02-24"
---

# Systems

## Enabling systems
- [S07 Smart Home](../../20_Systems/S07_Smart-Home/README.md) - MariaDB & Home Assistant platform.
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Integration and dashboarding.

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Real-time environmental monitoring | S07 Smart Home | [G08_home_monitor.py](../../50_Automations/scripts/G08_home_monitor.md) | - |
| Device health alerting (Battery) | S07 Smart Home | [G08_home_monitor.py](../../50_Automations/scripts/G08_home_monitor.md) | - |
| Focus Mode Orchestration | S07 Smart Home | [G08_focus_orchestrator.md](../../50_Automations/scripts/G08_focus_orchestrator.md) | - |
| Deep Work Accountability | S07 Smart Home | [G08_focus_readiness_check.md](../../50_Automations/scripts/G08_focus_readiness_check.md) | - |
| **Proactive Context Advisor** | S07 Smart Home | [G08_environment_advisor.md](../../50_Automations/scripts/G08_environment_advisor.md) | - |
| Unified environmental context | S04 Digital Twin | [G04_digital_twin_api.py](../../50_Automations/scripts/G04_digital_twin_api.md) | - |
