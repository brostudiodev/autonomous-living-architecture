---
title: "SVC: LLM Decision Proposal"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-02"
---

# SVC_LLM_Decision-Proposal

## Purpose
The strategic heart of the Meta-System (G11). It evaluates autonomous proposals (e.g., budget rebalances, schedule pivots) against Michał's 2026 North Star and Autonomy Levels to determine if an action can be executed automatically or requires human intervention.

## Scope
- **In Scope:** Policy auditing, ROI evaluation, Alignment check with North Star.
- **Out Scope:** Final execution (handled by domain-specific workers).

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "domain": "finance",
  "proposal": "Rebalance 500 PLN from Fun to Groceries",
  "reason": "Inflation spike detected in dairy prices.",
  "autonomy_level": 3
}
```

### Output (JSON)
```json
{
  "decision": "APPROVED_AUTO",
  "logic": "Amount is under threshold for Level 3; alignment with 'Stability' pillar is high.",
  "adjustment_required": null
}
```

## Dependencies
- **Service:** Google Gemini SDK
- **Knowledge Base:** North Star goals (injected into prompt).
- **Trigger:** `G11_event_listener.py` (Strategic route)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Conservative Bias | LLM never approves AUTO | Adjust prompt to increase "Trust" parameters. |
| Risky Decision | Large rebalance approved AUTO | Policy guardrails in local Python script block the execution. |

## Security Notes
- This is the highest-risk service. Local scripts MUST have "Hard Guardrails" (e.g., max 200 PLN rebalance) that the LLM cannot override.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Weekly (Audit all `APPROVED_AUTO` decisions for alignment)
