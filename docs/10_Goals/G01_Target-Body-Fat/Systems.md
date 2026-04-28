---
title: "G01: Systems"
type: "goal_systems"
status: "active"
owner: "Michał"
updated: "2026-03-28"
goal_id: "goal-g01"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Training logs and measurements.
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md) - Progressive overload logic.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Weight & Body Fat Tracking | S03 Data Layer | [G07_weight_sync.md](../../50_Automations/scripts/G07_weight_sync.md) | [Runbook: Validate-Savings-Rate](../../40_Runbooks/G05/Validate-Savings-Rate.md) |
| Strength Gains Monitoring | S06 Health | [G01_strength_gains_reporter.md](../../50_Automations/scripts/G01_strength_gains_reporter.md) | - |
| Progressive Overload Suggestions | S06 Health | [G01_progressive_overload.md](../../50_Automations/scripts/G01_progressive_overload.md) | - |
| Training Readiness Audit | S06 Health | [G01_training_planner.md](../../50_Automations/scripts/G01_training_planner.md) | - |
| **Performance Nutrition Auto-Pilot** | **S03 Data Layer** | **[G03_cart_aggregator.md](../../50_Automations/scripts/G03_cart_aggregator.md)** | - |
| Monthly Progress Summary | S01 Observability | [G01_monthly_reporter.md](../../50_Automations/scripts/G01_monthly_reporter.md) | - |

---
*Updated: 2026-03-28 by Digital Twin Assistant*
