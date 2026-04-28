---
title: "Automation Spec: G13_content_idea_generator.py"
type: "automation_spec"
status: "active"
automation_id: "G13_content_idea_generator"
goal_id: "goal-g13"
systems: ["S12", "S13"]
owner: "Michał"
updated: "2026-04-27"
---

# G13: Content Idea Generator

## Purpose
Harvests achievements from all 12 Power Goals and synthesizes them into actionable content ideas for LinkedIn and Substack, ensuring your brand content is grounded in real-world technical wins.

## Triggers
- **Scheduled:** Part of the `autonomous_weekly_manager.py` or `G11_global_sync.py` cycles.
- **Manual:** Can be run anytime to generate a fresh content harvest.

## Inputs
- **Goal Activity Logs:** `docs/10_Goals/*/Activity-log.md` (Scans last 7 days of entries).
- **Career Intelligence:** Strategic themes from `G09_career_strategist.py` (Market Demand + Skill Gaps).

## Processing Logic
1. **Strategic Guidance:** Interrogates the Career Strategist to identify which skills need professional visibility.
2. **Achievement Extraction:** Parses markdown activity logs using regex to find `**Action:**` and `**Code:**` markers.
3. **Idea Synthesis:** 
    - Tech wins -> LinkedIn "Architecture Deep Dive"
    - Productivity wins -> Substack "Personal OS Concept"
    - Learning wins -> LinkedIn "Continuous Learning"
4. **Markdown Generation:** Compiles a formatted "Content Harvest" document with strategic focus at the top.

## Outputs
- **Content Harvest File:** `Obsidian Vault/00_Inbox/Content Ideas/YYYY-MM-DD - Content Harvest.md`.

## Dependencies
### Systems
- [S12 LinkedIn Ideas](../../20_Systems/S12_LinkedIn-Ideas-System/README.md)
- [S13 Substack Ideas](../../20_Systems/S13_Substack-Notes-Ideas-System/README.md)

### Modules
- `G09_career_strategist.py` (Internal library import).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Career Strategist Fail | Exception | Log warning, proceed without strategic guidance | None |
| Missing Activity Logs | 0 entries found | Log SUCCESS with 0 items, skip generation | None |

## Monitoring
- **Success metric:** Harvest file created in Obsidian.
