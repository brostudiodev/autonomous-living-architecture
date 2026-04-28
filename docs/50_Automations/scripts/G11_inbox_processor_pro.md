---
title: "G11: Inbox Processor Pro"
type: "automation_spec"
status: "active"
automation_id: "G11_inbox_processor_pro"
goal_id: "goal-g11"
systems: ["S04", "S10"]
owner: "Michał"
updated: "2026-04-28"
---

# G11: Inbox Processor Pro

## Purpose
Automatically processes the `00_Inbox/` directory to clear "Inbox Debt" by categorizing files using Gemini 1.5, moving them to appropriate project folders, extracting strategic insights, and syncing high-priority tasks to Google Tasks.

## Triggers
- **Scheduled:** Part of the daily `G11_global_sync.py` cycle.
- **Manual:** Triggered via Telegram command `/process_inbox`.

## Inputs
- Files in `Obsidian Vault/00_Inbox/*.md`.
- Current Daily Note: `01_Daily_Notes/YYYY-MM-DD.md`.
- Gemini API for technical and strategic classification.

## Processing Logic
1. **Self-Cleaning (NEW Mar 28):** Automatically identifies and deletes files < 50 bytes (empty or redundant notes).
2. **Scan:** Identifies all markdown files in the Inbox, processing newer files first. (Limit: 50 files per run, optimized for high throughput).
3. **Analyze (Gemini):** For each file, determine the primary Goal ID (G01-G12) and extract:
   - A 1-sentence strategic "takeaway".
   - Actionable tasks with priority levels.
4. **Google Tasks Sync (NEW Mar 28):** Automatically pushes High-priority or `#urgent` tasks to the "Inbox (Autonomous)" list.
5. **Daily Note Integration:** 
   - Add the insight to the "Director's Summary" of the Daily Note.
6. **Route:** Move the original file to the corresponding `02_Projects/Goal-GXX/` or `04_Resources/` folder.
7. **Collision Handling:** Renames files if a target with the same name already exists.

## Outputs
- Moved files in Obsidian Vault.
- Updated Daily Note with new insights.
- New entries in Google Tasks for urgent items.
- Log entry in `digital_twin_michal.system_activity_log`.

## Dependencies
- Google Gemini API
- Google Tasks API (via `G10_google_tasks_sync.py`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Low Confidence | Score < 0.4 | Skip file, leave in inbox | Log warning |
| Gemini API Fail | Script exception | Skip file | Log error |
| Move Failure | Write error | Leave in inbox | Log error |

## Changelog
| Date | Change |
|------|--------|
| 2026-03-12 | Initial AI triage script |
| 2026-03-28 | Consolidated router logic, added Google Tasks sync, and self-cleaning for empty files |
| 2026-04-13 | Increased processing limit from 15 to 50 files for rapid debt elimination. |
