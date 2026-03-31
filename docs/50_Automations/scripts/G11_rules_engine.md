---
title: "script: G11 Meta-Rules Engine"
type: "automation_spec"
status: "active"
automation_id: "G11_rules_engine"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-03-20"
---

# script: G11_rules_engine.py

## Purpose
The decision authority core of the Autonomous Living Ecosystem. It evaluates domain-specific actions against the `autonomy_policies.yaml` to decide whether an action can be performed automatically (`AUTO_ACT`) or requires human intervention (`ASK_HUMAN`).

## Triggers
- **Library Call:** Called by other scripts (e.g., `G05_budget_rebalancer.py`, `G05_llm_categorizer.py`, `G01_training_planner.py`) to validate actions.
- **Manual:** `python3 scripts/G11_rules_engine.py` for testing policy evaluation.

## Inputs
- **Config:** `scripts/autonomy_policies.yaml` (Centralized thresholds).
- **Database:** `digital_twin_michal` (Check approval history for auto-promotion).
- **Context:** Action-specific data (amounts, scores, boolean flags) passed by calling scripts.

## Processing Logic
1.  **Policy Loading:** Loads rules from YAML, checking global and domain-specific settings.
2.  **Cognitive Penalty (NEW Mar 28):** 
    - If `poor_sleep_penalty` is enabled for the policy, it queries `autonomous_health.biometrics` for today's sleep score.
    - If **Sleep Score < 70**, it applies a **50% reduction** to all numeric thresholds (e.g., `max_amount_pln`) to mitigate decision-making risks from fatigue.
3.  **Deduplication (24h Cooldown):** Before creating a `PENDING` request, it checks for any identical request (same domain, policy, and payload) processed within the last 24 hours.
3.  **Condition Evaluation:** Compares provided context against policy thresholds (e.g., `max_amount_pln`, `is_trusted`).
4.  **Confidence-Based Auto-Promotion (Relaxed History):** 
    -   If a specific request type has been approved manually 3+ times, the engine auto-promotes it to `AUTO_ACT`.
    -   **Optimization:** For `financial.auto_categorize`, the history check **ignores the amount**, allowing a merchant to be auto-promoted regardless of the specific transaction value.
5.  **Audit Logging:** Every judgment is logged to the `autonomous_decisions` table for transparency.

## Outputs
- **DecisionType (Enum):** `AUTO_ACT`, `ASK_HUMAN`, `DENIED`, or `LOG_ONLY`.
- **Database Entry:** A new row in `decision_requests` (if `ASK_HUMAN`).

## Dependencies
### Systems
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception caught | Fallback to `ASK_HUMAN` (Safe mode) | Log warning |
| Missing Policy | Policy key not found | Return `DENIED` | Log error |

---
*Governance:*
This script is the primary enforcer of the [Decision Authority Framework](../../../60_Decisions_adrs/ADR-0005-Decision-Authority-Framework.md).
