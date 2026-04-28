---
title: "Automation Spec: G09_market_scout_handler.py"
type: "automation_spec"
status: "active"
automation_id: "G09_market_scout_handler"
goal_id: "goal-g09"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-04-27"
---

# 🤖 Automation Spec: G09_market_scout_handler.py

## Purpose
Acts as the system executor for career intelligence. It receives skill gap reports from the `SVC_Career-Market-Scout` n8n workflow, autonomously updates system-wide market demand metadata, and translates findings into actionable "Learning Sprint" proposals.

## Triggers
- **API Call:** Triggered by n8n via the `POST /career/report_gap` endpoint.
- **Manual:** `python3 G09_market_scout_handler.py '{"skill": "...", "demand": "..."}'`

## Inputs
- **Gap Data:** JSON object containing `skill`, `demand`, `current_level`, and `source`.

## Processing Logic
1. **System Intelligence Update:** Autonomously updates the `skill_inventory` in `autonomous_career` with fresh market demand (Low/Med/High/Critical).
2. **Trend Tracking:** Logs an entry to `market_pulse` for historical analysis of skill desirability.
3. **Decision Proposal:** Calls `G11_decision_proposer` to create a `career.skill_gap_alert` decision.
4. **Reasoning:** Generates a justification string based on market demand vs system baseline.

## Outputs
- **Database Update:** Updated `market_demand` in skill inventory.
- **Trend Record:** Historical demand point in `market_pulse`.
- **Decision Request:** A new `PENDING` request in the Digital Twin triage for a "Learning Sprint".

## Related Documentation
- [Goal: G09 Career Intelligence](../../10_Goals/G09_Automated-Career-Intelligence/README.md)
- [Workflow: Career Market Scout](../n8n/workflows/SVC_Career-Market-Scout.md)
