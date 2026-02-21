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
- [S05 Intelligent Routing Hub](../../20_Systems/S05_Intelligent-Routing-Hub/README.md) - Router that classifies calendar intents
- [S08 Personal Assistants](../../20_Systems/S08_Personal-Agents/README.md) - Domain-specific AI agents including calendar
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Logging and analytics foundation

### Productivity System
List systems that will carry this goal.

## Traceability (Outcome → System → Automation → SOP)

### Calendar Management
| Outcome | System | Automation | SOP/Runbook |
|---|---|---|---|
| Natural language calendar processing | S05 Intelligent Routing Hub | [WF001__router-intelligence-hub](../../50_Automations/n8n/workflows/WF001__router-intelligence-hub.md) | [Calendar-Operations.md](../../30_Sops/Calendar-Operations.md) |
| Autonomous event creation/checking | S08 Personal Assistants | [WF012__svc-google-calendar](../../50_Automations/n8n/workflows/WF012__svc-google-calendar.md) | [Calendar-Operations.md](../../30_Sops/Calendar-Operations.md) |
| Intelligent assumption system | S08 Personal Assistants | [WF012__svc-google-calendar](../../50_Automations/n8n/workflows/WF012__svc-google-calendar.md) | [AI-Agent-Troubleshooting.md](../../30_Sops/AI-Agent-Troubleshooting.md) |
| Multi-channel response routing | S05 Intelligent Routing Hub | [WF013__svc-response-dispatcher](../../50_Automations/n8n/workflows/WF013__svc-response-dispatcher.md) | [Response-Routing.md](../../30_Sops/Response-Routing.md) |

### Productivity System
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Centralized response delivery for Intelligence Hub | S04, S10 | [WF003: SVC_Response-Dispatcher](../../50_Automations/n8n/workflows/WF003__svc-response-dispatcher.md) | SOP: Service Deployment |
| Centralized command orchestration for Intelligence Hub | S04, S10 | [WF002: SVC_Command-Handler](../../50_Automations/n8n/workflows/WF002__svc-command-handler.md) | SOP: Service Deployment |
| Automated daily note preparation and schedule injection | S09 Productivity & Time | [script: autonomous-daily-manager.py](../../50_Automations/scripts/autonomous-daily-manager.md) | [SOP: Daily-Briefing-Management](../../30_Sops/Daily-Briefing-Management.md) |
| Synchronize external to-do lists to Obsidian | S10 Task Management | [script: G10_google_tasks_sync.py](../../50_Automations/scripts/G10-google-tasks-sync.md) | [SOP: Daily-Task-Review](../../30_Sops/SOP_Daily_Task_Review.md) |
