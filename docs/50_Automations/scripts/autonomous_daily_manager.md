---
title: "Daily Note Manager (S10/G12)"
type: "automation_spec"
status: "active"
owner: "Michal"
updated: "2026-04-18"
---

# Purpose
The **Daily Note Manager** (`autonomous_daily_manager.py`) is the core orchestrator of the daily "Single Source of Truth." It executes all sub-scripts in parallel, fetches system state, and surgically injects data into the Obsidian Daily Note.

# Scope
- **In Scope:** Parallel script execution, YAML frontmatter restoration, surgical marker injection, goal refraction logic.
- **Out Scope:** Long-running background processes or external API listeners.

# Core Logic Enhancements (Apr 13)
1.  **Parallel Execution:** Uses `ThreadPoolExecutor` to run 50+ scripts concurrently, reducing sync time by ~70%.
2.  **Manual Approval Processing:** Executes `G11_decision_handler.py` to scan the Daily Note for manual `#approve_[ID]` markers. Bulk auto-approval (`--all`) is disabled to prevent race conditions and ensure human-in-the-loop for sensitive actions.
3.  **Nutrition Auto-fill:** Automatically populates `calories` and `protein` frontmatter fields using `selected_meal.json` (G03 integration).
4.  **Golden Mission Integration:** Injects the Top 5 ranked missions from `G11_mission_aggregator.py`.

# Inputs/Outputs
- **Inputs:** `selected_meal.json`, `triaged_tasks.json`, PostgreSQL `digital_twin_michal`.
- **Outputs:** Fully populated `YYYY-MM-DD.md` in Obsidian Vault.

# Dependencies
- **Systems:** S04, S10, S11
- **Files:** Obsidian Daily Note Template, `.env`

# Procedure
- Triggered by file-watchers or manual execution.
- **Locking:** Uses `/tmp/autonomous_daily_manager.lock` to prevent recursive loops and has a 5-minute cooldown.

# Failure Modes
| Scenario | Response |
|----------|----------|
| Script Failure | Parallel executor logs failure; dashboard shows ⚠️ status. |
| Template Missing | Script aborts to prevent corrupted note creation. |
| DB Offline | Frontmatter restoration skips dynamic fields; logs error. |

# Security Notes
- Sanitizes all injected strings to prevent Markdown/YAML breakage.
- Uses absolute paths for reliability in different execution environments.

# Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (Audit dashboard markers and performance)
