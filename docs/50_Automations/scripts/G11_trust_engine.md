---
title: "G11: Trust Engine (Autonomy Policy Promoter)"
type: "automation_spec"
status: "active"
automation_id: "G11_trust_engine"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G11: Trust Engine (Autonomy Policy Promoter)

## Purpose
Facilitates the evolution of the system from "Supervised" to "Fully Autonomous." It monitors human decision patterns and identifies opportunities to promote `ASK_HUMAN` policies to `AUTO_ACT`. It ensures the system "earns its trust" through a proven track record of accurate proposals.

## Triggers
- **Weekly:** Scheduled for Sunday maintenance (G11).
- **Manual:** `python3 G11_trust_engine.py`.

## Inputs
- **Decision History:** `decision_requests` and `resolution_result` from the `digital_twin_michal` database.
- **Thresholds:** Minimum 5 consecutive approvals.

## Processing Logic
1.  **Approval Audit:** Scans for all policy keys that have a history of manual resolutions.
2.  **Pattern Recognition:** Checks if the last 5 resolutions for a specific policy (e.g., `pantry_restock`) were all `APPROVED` without any `REJECTED` or `MODIFIED` results.
3.  **Upgrade Proposal:** If the trust threshold is met, it identifies the policy as a candidate for full autonomy.
4.  **Notification:** Sends a Telegram message to the user suggesting an upgrade to the `autonomy_policies.yaml` configuration.

## Outputs
- **Telegram:** Trust Engine suggestions (e.g., "Suggest promoting 'tax_allocation' to AUTO_ACT").
- **Activity Log:** Records the number of potential trust elevations identified.

## Dependencies
### Systems
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)
- [S04 Digital Twin Notifier](../../50_Automations/scripts/G04_digital_twin_notifier.md)

## Error Handling
| Scenario | Detection | Response |
|----------|-----------|----------|
| No History | Empty results from SQL | Logs info, skips promotion. |
| Mixed Results | Rejection found in last 5 | Resets trust counter, keeps policy as ASK_HUMAN. |
