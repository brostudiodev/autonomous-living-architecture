---
title: "SOP: Daily Task Review & Sync"
type: "sop"
status: "active"
goal_id: "goal-g10"
owner: "{{OWNER_NAME}}"
updated: "2026-02-20"
---

# SOP: Daily Task Review & Sync

## Purpose
Ensure all tasks from external sources (Google Tasks) and internal sources (Obsidian) are synchronized, prioritized, and acted upon daily to prevent "task decay" and ensure alignment with 2026 Power Goals.

## Scope
- Google Tasks (Personal/Work)
- Obsidian Daily Notes (Tasks section)
- Obsidian Roadmap MINS (Q1 Goals)

## Procedure

### 1. Morning Briefing (06:00 - 06:15)
1. Open today's Obsidian Daily Note.
2. Review the `🤖 Google Tasks Sync (External)` section.
3. Move critical external tasks into the manual planning sections:
    - **Work**
    - **Personal**
    - **Deep Work** (if high-focus required)
4. Review `🤖 Autonomous MINS Suggestions` and confirm they match your priority for the day.

### 2. Execution & Capture (Throughout Day)
1. Capture new ideas/tasks directly into **Google Tasks** (via mobile or voice) while away from the desk.
2. Check off completed items in Obsidian.

### 3. Evening Sync (21:00 - 21:15)
1. Review remaining open tasks in Obsidian.
2. **Migrate or Delete:**
    - If a task is still relevant but not done: Move to Google Tasks for future scheduling.
    - If a task is no longer relevant: Delete.
3. Run `Ctrl+Shift+G` (or `python3 sync-daily-goals.py`) to ensure all "Power Goal" progress is logged to the repository.

### 4. Weekly Cleanup (Sunday Morning)
1. Open Google Tasks and purge completed/stale items.
2. Review the `Progress-monitor.md` for active goals.
3. Update Roadmaps if milestones were achieved.

## Failure Response
- **If Sync Fails:** Check the `client_secret.json` status and ensure the `google_tasks_token.pickle` has not been deleted.
- **If Tasks Overload:** If more than 10 tasks appear in the Daily Sync, use the "Sunday Morning Admin" block to aggressively prune the backlog.

## Related Documentation
- [G10 README](../10_Goals/G10_Intelligent-Productivity-Time-Architecture/README.md)
- [G10-google-tasks-sync Automation](../50_Automations/scripts/G10-google-tasks-sync.md)
