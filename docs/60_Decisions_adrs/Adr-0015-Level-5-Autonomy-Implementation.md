---
title: "Adr-0015: Level 5 Autonomy Implementation (Zero-Click Loop)"
type: "decision"
status: "accepted"
date: "2026-04-04"
deciders: ["Michał", "Gemini Assistant"]
---

# Adr-0015: Level 5 Autonomy Implementation (Zero-Click Loop)

## Status
Accepted

## Context
The system was previously operating at Level 4 Autonomy, where decisions were proposed by the system but required human approval via Telegram or Obsidian (Human-in-the-loop). This created cognitive load and delays for routine, low-risk operations like predictive pantry restocks and small budget rebalances. To reach the 2026 North Star of "Automation-First Living," the system needs to move to Level 5 (Zero-Click), where routine tasks are executed autonomously based on trust thresholds.

## Decision
We will implement a "Zero-Click" autonomous loop by:
1.  Integrating `G11_decision_proposer.py` and `G11_decision_handler.py --all` directly into the `autonomous_daily_manager.py` sync cycle.
2.  Defining "Trust Thresholds" in `autonomy_policies.yaml` that allow `AUTO_ACT` for specific domains (Procurement, Rebalancing) when conditions are met.
3.  Updating the `G11_rules_engine.py` to automatically resolve decisions that fall under `full` authority without requiring user intervention.

## Consequences
- **Positive:** Significant reduction in daily cognitive load (~15 mins/day). Faster system response to low-stock or budget friction.
- **Negative:** Risk of automated errors if trust thresholds are too loose. Requires robust self-healing and logging for auditability.
- **Edge Cases:** Large price variances or unexpected bank balance drops might trigger incorrect autonomous actions if not properly bounded.

## Implementation
- **Sync Integration:** `autonomous_daily_manager.py` now runs the proposer in parallel and the handler sequentially after all proposals are generated.
- **Policy Relaxation:** `autonomy_policies.yaml` updated to allow `critical_stock_only: false` for trusted items.
- **Audit Trail:** All autonomous actions are logged to `autonomous_decisions` table with the `resolution_result = 'AUTO_ACT'`.

## Alternatives Considered
- **Keep Human-in-the-loop:** Rejected as it conflicts with the 2026 North Star goal of maximizing time reclamation.
- **Full Autonomy for all domains:** Rejected for safety reasons (Health and large Financial transfers still require human oversight).

## Related Decisions
- [Adr-0010](./Adr-0010-Hub-and-Spoke-Integration.md) - Infrastructure for cross-domain communication.
- [Adr-0014](./Adr-00{{LONG_IDENTIFIER}}.md) - Monitoring the impact of these autonomous actions.

## Metrics
- **Time Saved:** Measured via `autonomy_roi` table.
- **Decision Accuracy:** Measured via monthly manual review of `autonomous_decisions` log.
