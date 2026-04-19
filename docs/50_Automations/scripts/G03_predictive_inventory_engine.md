---
title: "Automation Spec: G03_predictive_inventory_engine.py"
type: "automation_spec"
status: "active"
automation_id: "G03_predictive_inventory_engine"
goal_id: "goal-g03"
systems: ["S03", "S04", "S05"]
owner: "Michal"
updated: "2026-04-16"
---

# 🤖 Automation Spec: G03_predictive_inventory_engine.py

## Purpose
Proactively manages household inventory by predicting when items will run out based on depletion rates. It bridges the gap between current stock and procurement by proposing restocks *before* critical thresholds are reached, while respecting financial budget constraints.

## Triggers
- **Daily Sync:** Part of the `G11_global_sync.py` pipeline.
- **Manual:** `python3 G03_predictive_inventory_engine.py`

## Inputs
- **Pantry Data:** `pantry_inventory` table in `autonomous_pantry`.
- **Budget Data:** `get_current_budget_alerts()` function in `autonomous_finance`.
- **System Context:** Digital Twin engine for unified state.

## Processing Logic
1. **Inventory Scan:** Retrieves all items from `pantry_inventory` where `critical_threshold` IS NOT NULL.
   - **NULL Threshold:** Item is ignored (not tracked for autonomous procurement).
   - **0 Threshold:** Item is tracked (alert/propose when current quantity is 0).
2. **Depletion Calculation:** (Q2 Heuristic) Calculates `days_left` based on current quantity vs threshold.
   - If `threshold == 0` and `qty > 0`, assumes 30 days left (safety buffer).
   - Otherwise, calculates depletion over a 14-day standard usage cycle.
3. **Budget Check:** Queries the financial system for active high/critical alerts.
4. **Decision Proposal:** If `days_left <= 7`:
   - Proposes a restock via `G11_decision_proposer`.
   - Attaches a budget warning if the financial system reports breaches.

## Outputs
- **Decision Requests:** Injected into `digital_twin_michal.decision_requests` under `household.auto_procurement`.
- **Activity Log:** Records number of restocks proposed.

## Related Documentation
- [Goal: G03 Autonomous Household](../../10_Goals/G03_Autonomous-Household-Operations/README.md)
- [System: S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
