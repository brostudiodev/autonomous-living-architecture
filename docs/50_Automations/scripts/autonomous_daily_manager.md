---
title: "Automation Spec: autonomous_daily_manager.py"
type: "automation_spec"
status: "active"
automation_id: "autonomous_daily_manager"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-03-22"
---

# 🤖 Automation Spec: autonomous_daily_manager.py

## Purpose
The primary orchestrator for the Obsidian Daily Note. It aggregates data from all 12 goals (G01-G12), executes sub-scripts, and surgically injects reports, tasks, and decisions into the daily dashboard.

## Triggers
- **CRON:** Scheduled at 06:00, 13:00, and 18:00 daily.
- **Manual:** `fill-daily.sh` or `python3 autonomous_daily_manager.py`.

## Inputs
- **Databases:** All 7 PostgreSQL databases (Finance, Health, Training, Pantry, Learning, Logistics, Digital Twin).
- **Template:** `99_System/Templates/Daily/Daily Note Template.md`.
- **Sub-scripts:** Executes 20+ G-series scripts (e.g., `G10_task_sync.py`, `G01_progress_analyzer.py`, `G11_quick_wins.py`).

## Processing Logic
1.  **Environment Setup:** Loads `.env` and checks for the 5-minute cooldown lockfile.
2.  **Surgical Restoration:** 
    -   The script identifies today's Daily Note file.
    -   If the file doesn't exist, it's created from the `Daily Note Template.md`.
    -   If the file **already exists**, the script proceeds to surgically update its content while preserving manual entries.
3.  **Sub-Script Execution:** Runs registered reports and captures Markdown output.
4.  **Data Fetching:**
    -   **Biometrics:** Retrieves sleep, readiness, and HRV.
    -   **Tasks:** Syncs Google Tasks and Roadmap missions.
    -   **Decisions:** Fetches pending and resolved requests.
    - **Primary Directive:** Fetches the concise CEO mission from `G12_context_resumer.py`.
5.  **Surgical Injection:** 
    -   **MISSION:** Injects the concise Primary Directive.
    -   **Clutter Reduction (NEW Mar 30):** The script no longer generates the technical `SYSTEM_REPORT` or the expanded `RICH_MISSION` briefing, ensuring the Daily Note remains a high-level strategic dashboard. Detailed logs remain available in the database.
6.  **Frontmatter Restoration:** Rebuilds YAML with fresh biometrics.
7.  **Git Sync:** Commits and pushes changes to the Second Brain repository.

## Outputs
- **Daily Note:** `{{ROOT_LOCATION}}/Obsidian Vault/01_Daily_Notes/YYYY-MM-DD.md` (Updated).
- **Activity Log:** Success/Failure status for every subsystem in `system_activity_log`.

## Dependencies
### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Intelligent Productivity](../../../20_Systems/S10_Intelligent-Productivity/README.md)
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Marker Missing | Regex search fails | Log warning, skip section | System Report |
| Script Crash | Subprocess non-zero exit | Log failure, inject error msg | System Report |
| Git Conflict | `git push` fails | Log error | System Report |

## Manual Fallback
If the dashboard is corrupted:
1.  Close Obsidian.
2.  Run `fill-daily.sh --force`. This recreates the note from the template and re-injects all data.
