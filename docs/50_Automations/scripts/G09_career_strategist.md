---
title: "G09: Career Strategist"
type: "automation_spec"
status: "active"
automation_id: "G09_career_strategist"
goal_id: "goal-g09"
systems: ["S03", "S04", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G09: Career Strategist

## Purpose
Acts as the central intelligence bridge between Learning (G06) and Career (G09). It autonomously updates the skill inventory based on study progress and correlates proficiency with market demand to drive strategic brand content (G02/G13).

## Triggers
- **Scheduled:** Daily via `G11_global_sync.py` (Tier 1).

## Inputs
- **Learning Database:** `v_learning_progress` (Total hours per subject).
- **Career Database:** `skill_inventory` (Current levels and market demand).

## Processing Logic
1. **Skill Sync:** Maps G06 study hours to G09 proficiency levels (Heuristic: 1h = 1% proficiency, max 100%).
2. **Gap Analysis:** Identifies skills with "High/Critical" market demand but <80% proficiency.
3. **Strategic Advice:** Generates actionable content themes for the Digital Twin to demonstrate market readiness.

## Outputs
- **Database Update:** Refreshed `skill_inventory` proficiency and timestamps.
- **Telegram Notification:** Strategic alerts if major gaps are detected (optional via `--notify`).
- **Content Hooks:** Provides strategic direction for `G13_content_idea_generator.py`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S11 Intelligence Router](../../20_Systems/S11_Meta-System-Integration/README.md)

### Databases
- `autonomous_learning`
- `autonomous_career`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception | Log FAILURE to G11 | None |
| LLM API Fail | Exception | Fallback to default study tracks | Log warning |

## Monitoring
- **Success metric:** "Synced X skills" in `system_activity_log`.
- **Dashboard:** Career Intelligence Dashboard.
