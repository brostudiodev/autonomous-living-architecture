---
title: "Automation Spec: G04 Ghost Schema Accuracy Reporter"
type: "automation_spec"
status: "active"
automation_id: "G04_ghost_schema_reporter"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-03-25"
---

# G04: Ghost Schema Accuracy Reporter

## Purpose
The "Self-Calibration" engine of the Digital Twin. It compares historical predictions (the "Ghost" values) with actual data to quantify system accuracy. If accuracy drops below thresholds, it automatically adjusts autonomy policies.

## Triggers
- **Daily Manager:** Executed as part of `autonomous_daily_manager.py`.
- **Manual:** `python3 G04_ghost_schema_reporter.py`

## Inputs
- **Predictions:** `ghost_predictions` table in `digital_twin_michal`.
- **Actuals:** Queried from `autonomous_finance`, `autonomous_health`, and `autonomous_pantry`.
- **Policies:** `autonomy_policies.yaml`.

## Processing Logic
1.  **Resolution:** Identifies pending predictions where the target date has reached.
2.  **Comparison:** Fetches the actual value for the predicted domain/key.
3.  **Accuracy Calculation:** Uses normalized error calculation: `1 - (|predicted - actual| / actual)`.
4.  **Self-Calibration:**
    *   **Finance:** If accuracy < 80%, reduces `max_rebalance_amount_pln` by 10% to require more human oversight.
    *   **Health:** If accuracy < 85%, reduces `max_weight_increase_kg` to prevent aggressive overloading based on faulty trends.
5.  **Persistence:** Updates the `ghost_predictions` table with results.

## Outputs
- **Accuracy Report:** Markdown summary injected into the Daily Note.
- **Policy Updates:** Direct modifications to `autonomy_policies.yaml`.
- **Activity Log:** Records calibration events.

## Dependencies
### Systems
- [S04 Digital Twin Ecosystem](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Actual Fetch Fail | Exception | Keeps prediction pending | Console |
| YAML Write Fail | Exception | Logs failure | System Activity Log |

## Monitoring
- **Dashboard:** "Ghost Schema: Prediction Accuracy" section in the Daily Note.
