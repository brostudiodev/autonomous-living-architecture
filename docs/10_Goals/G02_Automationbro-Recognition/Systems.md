---
title: "G02: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g02"
owner: "Michał"
updated: "2026-02-24"
---

# Systems

## Enabling systems
- [S04 Digital Twin](../../20_Systems/README.md) - Metrics aggregation and visualization.
- [S08 Automation Orchestrator](../../20_Systems/README.md) - Content synchronization.

## Traceability (Outcome → System → Automation → SOP)
| Outcome | System | Automation | SOP |
|---|---|---|---|
| Content Synchronization | S08 Orchestrator | [G02_substack_sync.py](../../50_Automations/scripts/G02_substack_sync.md) | - |
| Content Harvesting & Drafting | S08 Orchestrator | [G02_content_harvester.py](../../50_Automations/scripts/G02_content_harvester.md) | - |
| **Thought Leadership Pipeline** | **S08 Orchestrator** | **[G02_brand_orchestrator](../../50_Automations/scripts/G02_brand_orchestrator.md)** | - |
| Automated LinkedIn Distribution | S08 Orchestrator | [G02_linkedin_drafter.py](../../50_Automations/scripts/G02_linkedin_drafter.md) (Calls [SVC_LLM_Draft-Content](../../50_Automations/n8n/workflows/SVC_LLM_Draft-Content.md)) | - |
| **Content Ideation** | **S08 Orchestrator** | **[G02_idea_generator.py](../../20_Systems/S12_LinkedIn-Ideas-System/G02_idea_generator.md)** (Calls [SVC_LLM_Generate-Idea](../../50_Automations/n8n/workflows/SVC_LLM_Generate-Idea.md)) | - |
| Brand Performance Tracking | S04 Digital Twin | [brand_metrics table](../../50_Automations/scripts/G02_substack_sync.md) | - |
| Public Architecture Exposure | S08 Orchestrator | [sync-to-public.py](../../50_Automations/scripts/G11_global_sync.md) | - |
