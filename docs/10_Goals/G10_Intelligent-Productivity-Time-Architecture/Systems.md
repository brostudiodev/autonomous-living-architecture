---
title: "G10: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g10"
owner: "{{OWNER_NAME}}"
updated: "2026-02-15"
---

# Systems

## Enabling systems

### Calendar Management
- [S11 Intelligence Router](../../20_Systems/S11_Intelligence_Router/README.md) - Router that classifies calendar intents
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - Domain-specific AI agents including calendar
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Logging and analytics foundation

### Productivity System
- [S09 Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md) - Scheduling and note automation
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md) - Goal tracking engine

## Traceability (Outcome → System → Automation → SOP)

### Calendar Management
| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Natural language calendar processing | S11 Intelligence Router | [WF001_Agent_Router](../../50_Automations/n8n/workflows/WF001_Agent_Router.md) | [Calendar-Operations.md](../../30_Sops/Calendar-Operations.md) |
| Autonomous event creation/checking | S08 Orchestrator | [WF012__svc-google-calendar](../../50_Automations/n8n/workflows/WF012__svc-google-calendar.md) | [Calendar-Operations.md](../../30_Sops/Calendar-Operations.md) |
| Intelligent assumption system | S08 Orchestrator | [WF012__svc-google-calendar](../../50_Automations/n8n/workflows/WF012__svc-google-calendar.md) | [AI-Agent-Troubleshooting.md](../../30_Sops/AI-Agent-Troubleshooting.md) |
| Multi-channel response routing | S11 Intelligence Router | [WF003__svc-response-dispatcher](../../50_Automations/n8n/workflows/WF003__svc-response-dispatcher.md) | [Response-Routing.md](../../30_Sops/Response-Routing.md) |

### Productivity System
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Centralized response delivery for Intelligence Hub | S11 Intelligence Router | [WF003__svc-response-dispatcher](../../50_Automations/n8n/workflows/WF003__svc-response-dispatcher.md) | [Service-Deployment.md](../../30_Sops/Service-Deployment.md) |
| Centralized command orchestration for Intelligence Hub | S11 Intelligence Router | [WF002__svc-command-handler](../../50_Automations/n8n/workflows/WF002__svc-command-handler.md) | [Service-Deployment.md](../../30_Sops/Service-Deployment.md) |
| Automated daily note preparation and schedule injection | S09 Productivity & Time | [script: autonomous-daily-manager](../../50_Automations/scripts/autonomous-daily-manager.md) | [SOP: Daily-Briefing-Management](../../30_Sops/Daily-Briefing-Management.md) |
| Synchronize external to-do lists to Obsidian | S10 Task Management | [script: G10-google-tasks-sync](../../50_Automations/scripts/G10-google-tasks-sync.md) | [SOP: Daily-Task-Review](../../30_Sops/SOP_Daily_Task_Review.md) |
