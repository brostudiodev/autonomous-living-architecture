---
title: "Automation Spec: G09_market_scout_handler.py"
type: "automation_spec"
status: "active"
automation_id: "G09_market_scout_handler"
goal_id: "goal-g09"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-04-09"
---

# 🤖 Automation Spec: G09_market_scout_handler.py

## Purpose
Acts as the system executor for career intelligence. It receives skill gap reports from the `SVC_Career-Market-Scout` n8n workflow and translates them into actionable "Learning Sprint" proposals within the system triage.

## Triggers
- **API Call:** Triggered by n8n via the `POST /career/report_gap` endpoint.
- **Manual:** `python3 G09_market_scout_handler.py '{"skill": "..."}'`

## Inputs
- **Gap Data:** JSON object containing `skill`, `demand`, `current_level`, and `source`.

## Processing Logic
1. **Payload Extraction:** Parses the JSON data received from the API or command line.
2. **Decision Proposal:** Calls `G11_decision_proposer` to create a `career.skill_gap_alert` decision.
3. **Reasoning:** Generates a justification string based on market demand vs system baseline.

## Outputs
- **Decision Request:** A new `PENDING` request in the Digital Twin triage for a "Learning Sprint".

## Related Documentation
- [Goal: G09 Career Intelligence](../../10_Goals/G09_Automated-Career-Intelligence/README.md)
- [Workflow: Career Market Scout](../../n8n/workflows/SVC_Career-Market-Scout.md)
