---
title: "G02: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g02"
owner: "Michal"
updated: "2026-02-24"
---

# Systems

## Enabling systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Metrics aggregation and visualization.
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - Content synchronization.

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Content Synchronization | S08 Orchestrator | [G02_substack_sync.py](../../50_Automations/scripts/substack-sync.md) | - |
| Content Harvesting & Drafting | S08 Orchestrator | [G02_content_harvester.py](../../50_Automations/scripts/G02-content-harvester.md) | - |
| Brand Performance Tracking | S04 Digital Twin | [brand_metrics table](../../50_Automations/scripts/substack-sync.md) | - |
| Public Architecture Exposure | S08 Orchestrator | [sync-to-public.py](../../50_Automations/scripts/global-sync.md) | - |
