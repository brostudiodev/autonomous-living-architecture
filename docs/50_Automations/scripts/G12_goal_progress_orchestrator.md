---
title: "G12_goal_progress_orchestrator: Automated Did/Next Logging"
type: "automation_spec"
status: "active"
automation_id: "G12_goal_progress_orchestrator"
goal_id: "goal-g12"
systems: ["S04", "S11", "S12"]
owner: "Michal"
updated: "2026-03-25"
---

# G12_goal_progress_orchestrator: Automatic (System-Driven) Tracking

## Purpose
Acts as the **Automatic (Suggestive) Tracker** for the ecosystem. It autonomously analyzes system data and task completion to populate the Daily Note with initial "Did" and "Next" suggestions. This reduces friction for Michal, who then uses **G09** (`ctrl+shift+G`) to verify and commit these entries to long-term storage.

## 📊 Goal Tracking Hierarchy
1.  **Level 1: Suggestion (G12)** - System runs autonomously, finds completed tasks, scans roadmaps, and populates the `%%GOAL_PROGRESS%%` section in the Daily Note.
2.  **Level 2: Verification (Michal)** - Michal reviews the suggested "Did" and "Next" fields in Obsidian, making manual adjustments if necessary.
3.  **Level 3: Commitment (G09)** - Michal triggers `ctrl+shift+G`. This executes G09, which takes the *current* state of the Daily Note and permanently logs it to the individual `Activity-log.md` files.

## Triggers
- **System Sync:** Part of the `G11_global_sync.py` pipeline (runs before the Daily Note is finalized).
- **Manual:** `python3 G12_goal_progress_orchestrator.py`

## Inputs
- **Daily Note:** Parses the current day's `.md` file in `01_Daily_Notes`.
- **Roadmaps:** Scans `docs/10_Goals/*/Roadmap.md` for upcoming tasks.
- **Task Heuristics:** Keyword-based mapping of task descriptions to Goal IDs (G01-G12).

## Processing Logic
1. **Activity Extraction:**
   - Scans for all checked tasks (`- [x]`).
   - Uses a heuristic engine to categorize tasks into goals (e.g., "workout" -> G01, "budget" -> G05).
   - Collects all activities per goal.
2. **Next Step Retrieval:**
   - For each active goal, it finds the first 2 incomplete items (`- [ ]`) in the corresponding Roadmap.
3. **Data Population:**
   - **Frontmatter:** Updates `goals_touched` (list of links) and `goals_activities` (JSON mapping) in the YAML block.
   - **Body:** Injects a formatted Markdown list into the `%%GOAL_PROGRESS%%` section.
4. **Self-Healing:**
   - If markers are missing, it attempts to surgically update individual legacy goal lines.

## Outputs
- **Updated Daily Note:** Populated frontmatter and `Goal Progress Tracking` section.
- **System Activity Log:** Number of goals auto-logged.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S12 Complete Process Documentation](../../20_Systems/S12_Complete-Process-Documentation/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Note Not Found | File check | Exit with info | Console log |
| Ambiguous Task | Heuristic failure | Skip task categorization | Logged as 'Misc' |

## Monitoring
- Success metric: Reduction in manual "Did/Next" entries.
- Accuracy: Periodically review `goals_activities` frontmatter.

## Related Documentation
- [G09_sync_daily_goals](./G09_sync_daily_goals.md)
- [G12_auto_did_logger](./G12_auto_did_logger.md)
