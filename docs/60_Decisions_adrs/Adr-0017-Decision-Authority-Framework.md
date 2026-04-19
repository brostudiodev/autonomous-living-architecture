---
title: "Adr-0007: Decision Authority Framework"
type: "decision"
status: "accepted"
date: "2026-03-20"
deciders: ["Michal"]
---

# Adr-0007: Decision Authority Framework

## Status
Accepted

## Context
As the system moves towards Level 5 autonomy, it needs a clear framework to determine which actions require human approval and which can be executed autonomously. Without this framework, there is a risk of either overwhelming the user with redundant requests or allowing high-risk actions to occur without oversight.

## Decision
We implement a multi-tiered Decision Authority Framework managed by the `G11_rules_engine.py`.

### **Authority Levels**
1. **FULL (AUTO_ACT):** Routine, low-risk actions (e.g., small budget rebalances < 100 PLN, pantry restocks).
2. **RESTRICTED (ASK_HUMAN):** High-risk or sensitive actions (e.g., large financial transfers, health-impacting workout changes).
3. **AUDIT (LOG_ONLY):** Observability actions that don't change state but should be recorded.
4. **DENIED:** Explicitly forbidden actions.

### **Key Rules**
- **Trust-Based Promotion:** If a specific action type is approved manually 3 times, it is eligible for promotion to `FULL` authority.
- **Fatigue Penalty:** If today's Sleep Score is < 70, the engine automatically reduces all monetary thresholds by 50% to mitigate risk.
- **Centralized Policy:** All thresholds are defined in `scripts/autonomy_policies.yaml`.

## Consequences
- **Reclaimed Time:** Reduces manual approvals for routine tasks.
- **Safety:** Ensures human oversight for significant life decisions.
- **Auditability:** Every decision is logged with the reasoning and context.

## Implementation
- Implemented in `G11_rules_engine.py`.
- Policies defined in `autonomy_policies.yaml`.
- Approval history tracked in `digital_twin_michal.decision_requests`.

## Related Decisions
- [Adr-0015](./Adr-0015-Level-5-Autonomy-Implementation.md) - The transition to Zero-Click loop.
- [Adr-0012](./Adr-0012-Rule-Based-Intent-Classification.md) - How intents are identified before evaluation.
