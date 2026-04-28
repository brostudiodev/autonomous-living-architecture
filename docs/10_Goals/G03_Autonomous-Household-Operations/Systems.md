---
title: "G03: Systems"
type: "goal_systems"
status: "active"
owner: "Michał"
updated: "2026-03-27"
goal_id: "goal-g03"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Primary storage via `autonomous_pantry` database.
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md) - Contextual intelligence and alerting.
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md) - Google Tasks synchronization.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Centralized pantry inventory | S03 Data Layer | PostgreSQL: `autonomous_pantry` | [SOP: Pantry-Management](../../30_Sops/Home/Pantry-Management.md) |
| Automated Inventory Sync | S03 Data Layer | [pantry_sync.md](../../50_Automations/scripts/pantry_sync.md) | - |
| Predictive Restocking Suggestions | S03 Data Layer | [G03_pantry_suggestor.md](../../50_Automations/scripts/G03_pantry_suggestor.md) | - |
| Predictive Accuracy Validation | S04 Digital Twin | [G03_predictive_validation.md](../../50_Automations/scripts/G03_predictive_validation.md) | - |
| **Proactive Procurement** | **S04 Digital Twin** | **[G11_approval_prompter](../../50_Automations/scripts/G11_approval_prompter.md)** | [Telegram-Approval-SOP.md](../../30_Sops/Telegram-Approval-SOP.md) |
| Automated Restocking List | S10 Automation | [g03-cart-aggregator](../../50_Automations/scripts/G03_cart_aggregator.md) | - |
| **Execute Approvals** | **S08 Orchestrator** | **[G11_decision_handler](../../50_Automations/scripts/G11_decision_handler.md)** | [Autonomy-Rules-Runbook.md](../../40_Runbooks/G11/Autonomy-Rules-Runbook.md) |
| **Promo Price Ingestion** | **S03 Data Layer** | **[g03-promo-ingestor](../../50_Automations/scripts/G03_promo_ingestor.md)** | - |
| Mobile Shopping Checklist | S10 Automation | [g10-google-tasks-sync](../../50_Automations/scripts/G10_google_tasks_sync.md) | - |
| Predictive Meal Planning | S03 Data Layer | [g03-meal-planner](../../50_Automations/scripts/G03_meal_planner.md) | - |
| **Appliance Health Monitor** | **S07 Smart Home** | **[G03_appliance_monitor.md](../../50_Automations/scripts/G03_appliance_monitor.md)** | - |
| **Price Intelligence (Scouter)** | **S08 Orchestrator** | **[g03-price-scouter](../../50_Automations/scripts/G03_price_scouter.md)** | - |
| Digital Twin Alerting | S04 Digital Twin | [g04-digital-twin-engine](../../50_Automations/scripts/G04_digital_twin_engine.md) | - |

---
*Updated: 2026-03-27 by Digital Twin Assistant*
