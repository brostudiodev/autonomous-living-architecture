---
title: "Automation Spec: G11_roadmap_enforcer.py"
type: "automation_spec"
status: "active"
automation_id: "G11_roadmap_enforcer"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-04-18"
---

# 🤖 Automation Spec: G11_roadmap_enforcer.py

## Purpose
Systematically scans all goal roadmaps for the current quarter (Q2 2026) and injects pending tasks into the Triage system as decision requests. This ensures roadmap milestones are converted into actionable tasks without manual oversight.

## Triggers
- **Daily Sync:** Part of the `G11_global_sync.py` pipeline.
- **Manual:** `python3 G11_roadmap_enforcer.py`

## Inputs
- **Roadmap Files:** `docs/10_Goals/*/Roadmap.md`.
- **Logic:** Identifies the `## Q2 (Apr–Jun)` section and extracts `- [ ]` or `- [/]` items.

## Processing Logic
1. **Goal Discovery:** Iterates through all goal folders in `docs/10_Goals/`.
2. **Parsing:** Uses regex to isolate the Q2 section of each `Roadmap.md`.
3. **Extraction:** Collects all pending and in-progress tasks.
4. **Injection:** Calls `DecisionProposer.propose_decision` with the `meta.roadmap_task_enforcement` policy.

## Outputs
- **Decision Requests:** Injected into `digital_twin_michal.decision_requests`.
- **System Activity Log:** Records the number of tasks injected.

## Dependencies
### Systems
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| File Not Found | `os.path.exists()` fails | Skip specific goal | Console warning |
| Regex Fail | No match for Q2 | Log as "No tasks found" | System Activity Log |

## Monitoring
- Success metric: Number of Q2 tasks successfully injected into Triage.
