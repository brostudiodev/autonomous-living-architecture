---
title: "G12_goal_progress_orchestrator: Automated Did/Next Logging"
type: "automation_spec"
status: "active"
automation_id: "G12_goal_progress_orchestrator"
goal_id: "goal-g12"
systems: ["S04", "S11", "S12"]
owner: "Michal"
updated: "2026-04-18"
---

# G12_goal_progress_orchestrator: Automatic (System-Driven) Tracking

## Purpose
Acts as the **Automatic (Suggestive) Tracker** for the ecosystem. It autonomously analyzes system data and task completion to populate the Daily Note with initial "Did" and "Next" suggestions. This reduces friction for Michal, who then uses **G09** (`ctrl+shift+G`) to verify and commit these entries to long-term storage.

## 🛠️ Implementation Notes (Apr 14 Update)
- **Path Management:** Standardized path resolution using `OBSIDIAN_VAULT`, `BASE_DIR`, and `GOALS_PATH` constants to ensure cross-environment reliability.
- **Resilience:** Fixed a critical `NameError` where `OBSIDIAN_VAULT` was used without being defined in the global scope.
- **Goal Mapping:** Renamed internal mapping to `POWER_GOALS` for consistency with system-wide nomenclature.

## 📊 Goal Tracking Hierarchy
1.  **Level 1: Suggestion (G12)** - System runs autonomously, finds completed tasks, scans roadmaps, and populates the `%%GOAL_PROGRESS%%` section in the Daily Note.
2.  **Level 2: Verification (Michal)** - Michal reviews the suggested "Did" and "Next" fields in Obsidian, making manual adjustments if necessary.
3.  **Level 3: Commitment (G09)** - Michal triggers `ctrl+shift+G`. This executes G09, which takes the *current* state of the Daily Note and permanently logs it to the individual `Activity-log.md` files.

## Triggers
- **System Sync:** Part of the `G11_global_sync.py` pipeline (runs before the Daily Note is finalized).
- **Manual:** `python3 G12_goal_progress_orchestrator.py`

## Inputs
| Source | Data | Used For |
|--------|------|----------|
| Git Logs | Commits from Code & Vault repos | Development/Documentation progress |
| Google Tasks | Completed tasks (last 24h) | Execution tracking |
| domain_health | Sleep, Readiness, HRV | Biological wins (G01/G07) |
| domain_finance | Transaction counts | Financial sync progress (G05) |
| activity_log | Success signals from scripts | System automation wins (G11/G04) |
| Daily Note | Manual checkboxes (`- [x]`) | Human-driven activities |

## Processing Logic
1. **Activity Aggregation (NEW Apr 07):** Scans 5 distinct sources (Git, DB, Tasks, System, Notes) to build a comprehensive view of the day's achievements.
2. **Goal Mapping:** Uses an enhanced heuristic engine with priority weighting to assign activities to G01-G12 based on keywords and tags.
    - **Logic Refinement (Apr 13):** Implemented safety checks for `None` task descriptions to prevent `AttributeError` crashes during classification.
3. **Next Step Retrieval:** Fetches top 2 incomplete items from roadmap for each touched goal.
4. **Data Population:**
   - **Frontmatter:** Updates `goals_touched` and `goals_activities` YAML fields.
   - **Body:** Injects formatted Markdown into `%%GOAL_PROGRESS%%` section.
5. **Resilience & Self-Healing:** If markers are missing, the script automatically creates the section under the Reflection header to ensure logging continues.

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
