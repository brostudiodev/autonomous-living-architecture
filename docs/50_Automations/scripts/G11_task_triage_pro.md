---
title: "G11: Task Triage Pro"
type: "automation_spec"
status: "active"
automation_id: "G11_task_triage_pro"
goal_id: "goal-g11"
systems: ["S04", "S10"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Task Triage Pro

## Purpose
Surgically triages Google Tasks into actionable categories. It prevents decision fatigue by dynamically adjusting task priority. It supports both high-intelligence n8n/LLM processing and a robust Python-based local fallback to ensure tasks are never missed if the n8n layer is unavailable.

## Triggers
- **Scheduled (Intelligence):** `SVC_Task-Triage` n8n workflow runs daily at 07:00 (when available).
- **Scheduled (Execution):** Runs as a dependency within `autonomous_daily_manager.py` every time the dashboard is updated.
- **Manual:** `python3 scripts/G11_task_triage_pro.py`.

## Inputs
- **Google Tasks API:** Fetches current tasks (Limit increased to 50 for depth).
- **biometrics table:** Readiness scores for energy-based prioritizing.
- **triaged_tasks.json (n8n):** Optional input from the LLM layer.

## Processing Logic
1.  **Context Fetching:** Retrieves today's readiness detail and current task list from Google API.
2.  **Local Triage Fallback (Python):**
    - Categorizes tasks based on list name and due date.
    - **URGENT_TODAY:** Includes all tasks from 'My Tasks' due today (or undated) and all tasks from 'Missions (Autonomous)' due today.
    - **HABIT:** Groups tasks from lists containing 'Habit' or 'Recurring'.
    - **BACKLOG:** All other upcoming tasks.
3.  **Intelligence Merge (n8n):** If fresh triage data from n8n exists, it processes explicit commands like `NOTE_TO_OBSIDIAN`.
4.  **Persistence:** Writes results to `_meta/triaged_tasks.json` for consumption by the Daily Manager and Digital Twin Engine.

## Outputs
- **JSON File:** `_meta/triaged_tasks.json`.
- **Obsidian Notes:** Markdown files in `00_Inbox/Notes_from_Tasks/` (for triaged notes).
- **Google Tasks Update:** Marks triaged notes as "Completed".

## Dependencies
- **n8n Workflow:** `SVC_Task-Triage` (Optional/Intelligence layer)
- **Database:** `digital_twin_michal`
- **Credentials:** `google_tasks_token.pickle`.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| n8n Offline | Missing JSON | Executes Local Triage Fallback |
| API Error | `googleapiclient` Exception | Logs failure; skips sync |

## Monitoring
- **Activity Log:** SUCCESS/FAILURE logged via `G11_log_system.py`.
- **Triage Summary:** Printed to console during `global_sync`.

---
*Updated: 2026-04-15 | Added Python-based Local Triage Fallback for system autonomy.*
