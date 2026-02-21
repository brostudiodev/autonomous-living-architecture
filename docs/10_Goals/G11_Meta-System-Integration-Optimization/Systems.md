---
title: "G11: Systems"
type: "goal_systems"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-21"
---

# Systems

## Enabling systems
- [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- [S09 Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Audit system connectivity and data flow health | S01 Observability | [script: g11-meta-mapper](../../50_Automations/scripts/g11-meta-mapper.md) | [SOP: System-Health-Monitoring](../../30_Sops/System-Health-Monitoring.md) |
| Automate weekly data aggregation and review generation | S09 Productivity | [script: autonomous-weekly-manager](../../50_Automations/scripts/autonomous-weekly-manager.md) | [SOP: Weekly-Review-Process](../../30_Sops/Weekly-Review-Process.md) |

