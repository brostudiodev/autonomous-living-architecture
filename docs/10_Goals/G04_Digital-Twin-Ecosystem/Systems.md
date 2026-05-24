---
title: "G04: Systems"
type: "goal_systems"
status: "active"
owner: "Michał"
updated: "2026-05-01"
goal_id: "goal-g04"
---

# Systems

## Enabling systems
- [S03 Data Layer (Multi-DB)](../../20_Systems/README.md) - Storage for `digital_twin_michal`.
- [S04 Digital Twin Hub](../../20_Systems/README.md) - The core intelligence hub.
- [S11 Intelligence Router](../../20_Systems/README.md) - Input/Output orchestration.
- **RabbitMQ (Message Broker)** - For real-time state change events.
- **SVC_Language-Gate (n8n)** - Mandatory translation and intent normalization layer.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Strategic Brain & Reasoning | S04 Digital Twin | [core.engine](../../core/engine.py) | [Adr-0020](../../60_Decisions_adrs/Adr-0020-Language-Standard-Hardening.md) |
| Cross-Platform API Access | S04 Digital Twin | [core.api](../../core/api.py) | [RB_G04_001](../../40_Runbooks/G04/Restoration-and-Modularization.md) |
| Strategic Memory | S03 Data Layer | PostgreSQL: `strategic_memory` | - |
| Multi-Channel Ingest | S11 Router | [n8n: Language Gate](../../20_Systems/README.md) | - |
| Morning Mission Briefing | S04 Digital Twin | [G04_morning_briefing_sender.py](../../50_Automations/scripts/G04_morning_briefing_sender.md) | - |
| Autonomous Dashboard | S10 Automation | [autonomous_daily_manager.py](../../50_Automations/scripts/autonomous_daily_manager.md) | - |
| **Autonomy ROI (Real-Time)** | S04 Digital Twin | [G04_digital_twin_engine.md](../../50_Automations/scripts/G04_digital_twin_engine.md) -> **RabbitMQ** | [IMPL_RabbitMQ_EDA_Strategy](../../60_Decisions_adrs/IMPL_RabbitMQ_EDA_Strategy.md) |
| Hydration & Caffeine Persistence | S03 Data Layer | PostgreSQL: `water_log`, `caffeine_log` | - |
| System Activity Logging | S04 Digital Twin | PostgreSQL: `system_activity_log` | - |
| Proactive System Monitoring | S04 Digital Twin | [G04_digital_twin_monitor.md](../../50_Automations/scripts/G04_digital_twin_monitor.md) | - |
| Relationships Tracking | S04 Digital Twin | [G04_relationships_sync.md](../../50_Automations/scripts/G04_relationships_sync.md) | - |
| Weekly Momentum Reporting | S04 Digital Twin | [G04_system_velocity_reporter.md](../../50_Automations/scripts/G04_system_velocity_reporter.md) | - |
| **Self-Calibration (Ghost Schema)** | S04 Digital Twin | [G04_ghost_schema_reporter.md](../../50_Automations/scripts/G04_ghost_schema_reporter.md) | - |
| **Personal Context Integration** | S04 Digital Twin | [G04_personal_context_sync.md](../../50_Automations/scripts/G04_personal_context_sync.md) | - |
| **LLM Guardrail Layer** | S11 Router | n8n: `Language-Gate-Guardrail` | - |
| **API Security Hardening** | S04 Digital Twin | Bearer Tokens / OIDC | - |
| **Autonomous Decision Engine** | S04 Digital Twin | [API-Specification.md](../../20_Systems/S04_Digital-Twin/API-Specification.md) | - |
| **Quick Slash Approvals** | S04 Digital Twin | `AgentZero` -> `/approve [id]` | - |

---
*Updated: 2026-03-21 by Digital Twin Assistant*
