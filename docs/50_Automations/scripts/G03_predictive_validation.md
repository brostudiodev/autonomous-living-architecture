---
title: "WF: G03 Predictive Accuracy Validation"
type: "automation_spec"
status: "active"
automation_id: "G03_predictive_validation"
goal_id: "goal-g03"
systems: ["S04"]
owner: "Michał"
updated: "2026-03-27"
---

# G03: Predictive Accuracy Validation

## Purpose
Provides an audit of the pantry forecasting system by comparing Ghost Schema predictions against actual inventory levels over a 30-day period.

## Triggers
- **Manual:** User runs `python3 scripts/G03_predictive_validation.py`.
- **Scheduled:** Part of the weekly review cycle (Future).

## Inputs
- **Database:** `digital_twin_michal.ghost_predictions` (Filter: `domain = 'pantry'`)

## Processing Logic
1. Script queries `ghost_predictions` for the last 30 days.
2. Groups results by `prediction_key` (item category).
3. Calculates:
    - Total number of resolved predictions.
    - Average accuracy percentage.
    - Minimum and maximum accuracy encountered.
4. Formats results into a Markdown table for display.

## Outputs
- **Console:** Markdown table summarizing accuracy per item.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

## Monitoring
- Success metric: Average Accuracy > 90% across all top items.
- Alert on: Any item where accuracy consistently drops below 70% (indicates volatile burn rate or data sync issues).

## Manual Fallback
If the validation script fails:
1. Manually query the `ghost_predictions` table in PostgreSQL.
2. Review the `v_pantry_burn_rate` view to check for calculation anomalies.
