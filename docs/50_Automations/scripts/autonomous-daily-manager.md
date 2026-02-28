---
title: "G10_autonomous_daily_manager.py: Dashboard Orchestrator"
type: "automation_spec"
status: "active"
automation_id: "autonomous-daily-manager"
goal_id: "goal-g10"
owner: "Michal"
updated: "2026-02-27"
---

# G10_autonomous_daily_manager.py

## Purpose
Orchestrates the generation of the Obsidian Daily Note, triggers all system syncs, and delivers the morning Telegram briefing.

## Safety & Integrity Features
- **Lockfile Protection:** Uses `/tmp/autonomous_daily_manager.lock` with a 5-minute cool-down.
- **Pre-Overwrite Backup:** Creates a timestamped copy of the current Daily Note in `01_Daily_Notes/_backups/` before performing any updates.
- **Git Enforcement:** Automatically performs `git add`, `git commit`, and `git push` for the Daily Note to prevent external sync processes from deleting system-generated content.

## Critical Logic
1.  **Biometric Sync:** Calls `G07_zepp_sync` to populate `autonomous_health`.
2.  **Frontmatter Injection:** Fetches `sleep_start`, `sleep_end`, and `sleep_quality` from the DB and injects them into the note's YAML (ensuring time values are quoted).
3.  **Dashboard Refresh:** Re-generates the Connectivity, Insights, Schedule, and Missions blocks.
4.  **Version Control:** Pushes changes to the remote repository immediately.
