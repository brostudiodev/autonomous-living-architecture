---
title: "G11: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
updated: "2026-03-28"
goal_id: "goal-g11"
---

# Systems

## Enabling systems
- [S11 Intelligence Router](../../20_Systems/S11_Meta-System-Integration/README.md) - Meta-system coordination.
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md) - Strategic direction.
- [S03 Data Layer (Multi-DB)](../../20_Systems/S03_Data-Layer/README.md) - Foundation for all system data.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Quick Wins Generation | S10 Productivity | [G11_quick_wins.md](../../50_Automations/scripts/G11_quick_wins.md) | [SOP: Daily Dashboard Review](../../30_Sops/Daily-Dashboard-Review.md) |
| Unified System Synchronization | S11 Router | [G11_global_sync.md](../../50_Automations/scripts/G11_global_sync.md) (Retry-Aware) | - |
| Dynamic Connectivity Mapping | S11 Router | [G12_connectivity_mapper.md](../../50_Automations/scripts/G12_connectivity_mapper.md) | - |
| Bulk Decision Authority | S11 Router | [G11_bulk_approval_authority.md](../../50_Automations/scripts/G11_bulk_approval_authority.md) | [Autonomy-Rules-Runbook.md](../../40_Runbooks/G11/Autonomy-Rules-Runbook.md) |
| **Autonomy Promotion** | **S11 Router** | **[G11_autonomy_promoter.md](../../50_Automations/scripts/G11_autonomy_promoter.md)** | - |
| Autonomous Rebalance Trigger | S11 Router | [G05_auto_rebalance_trigger.md](../../50_Automations/scripts/G05_auto_rebalance_trigger.md) | - |
| Stale Task Archiver | S11 Router | [G11_task_archiver.md](../../50_Automations/scripts/G11_task_archiver.md) | - |
| **CEO Weekly Briefing** | S11 Router | [G11_ceo_weekly_briefing.md](../../50_Automations/scripts/G11_ceo_weekly_briefing.md) | [SOP: Weekly Review Process](../../30_Sops/Weekly-Review-Process.md) |
| Cross-Domain Intelligence | S04 Digital Twin | [G04_digital_twin_engine.md](../../50_Automations/scripts/G04_digital_twin_engine.md) | - |
| Meta-System Mapping | S11 Router | [G11_meta_mapper.py](../../50_Automations/scripts/G11_meta_mapper.md) | - |
| Rules-Engine Orchestration | S11 Router | [G11_rules_engine.py](../../50_Automations/scripts/G11_rules_engine.md) | - |
| Automated Health Audits | S11 Router | [G11_system_audit.py](../../50_Automations/scripts/G11_system_audit.md) | - |
| Strategic Summary Generation | S11 Router | [G11_strategic_summarizer.py](../../50_Automations/scripts/G11_strategic_summarizer.md) | - |
| Logistics Task Status Sync | S11 Router | [G11_task_syncer.md](../../50_Automations/scripts/G11_task_syncer.md) | - |
| **Maintenance Triage** | **S11 Router** | **[G11_maintenance_batcher.md](../../50_Automations/scripts/G11_maintenance_batcher.md)** | - |
| **Task Hygiene Agent** | **S11 Router** | **[G11_hygiene_agent.md](../../50_Automations/scripts/G11_hygiene_agent.md)** | - |
| **Meta-Decision Analysis** | **S11 Router** | **[G11_decision_pattern_analyzer](../../50_Automations/scripts/G11_decision_pattern_analyzer.md)** | - |
| Centralized Activity Logging | S04 Digital Twin | PostgreSQL: `system_activity_log` | - |
| **Proactive Decision Proposer** | S11 Router | [G11_decision_proposer.md](../../50_Automations/scripts/G11_decision_proposer.md) | - |
| **System Decision Handler** | S11 Router | [G11_decision_handler.md](../../50_Automations/scripts/G11_decision_handler.md) | [Autonomy-Rules-Runbook.md](../../40_Runbooks/G11/Autonomy-Rules-Runbook.md) |
| Google Tasks Suggestion Sync | S11 Router | [G11_suggestion_scrubber.md](../../50_Automations/scripts/G11_suggestion_scrubber.md) | - |

---
*Updated: 2026-03-28 by Digital Twin Assistant*
