---
title: "Automation Spec: G11_hygiene_agent.py"
type: "automation_spec"
status: "active"
automation_id: "G11_hygiene_agent"
goal_id: "goal-g11"
systems: ["S11", "S08", "S10"]
owner: "Michal"
updated: "2026-04-18"
---

# 🤖 Automation Spec: G11_hygiene_agent.py

## Purpose
Ensures that Google Tasks stay clean and relevant by automatically marking them as completed when their underlying database conditions have been resolved. This eliminates the need for manual task list maintenance after an automation (or manual action) has already fixed a problem.

## Triggers
- **Daily Sync:** Executed as part of `G11_global_sync.py` (positioned after data-fetching scripts like `G05_finance_sync.py` and `pantry_sync.py`).
- **Manual:** `python3 G11_hygiene_agent.py` to scrub all task lists.

## Inputs
- **Google Tasks API:** Fetches all active tasks from all task lists.
- **Finance Database (`autonomous_finance`):** Checks `v_budget_performance` for active breaches.
- **Pantry Database (`autonomous_pantry`):** Checks `pantry_inventory` for current quantity vs. threshold.
- **Logistics Database (`autonomous_life_logistics`):** Checks `status` of specific items.
- **Environment:** `.env` for database credentials.

## Processing Logic
1.  **Task Scanning:** Retrieves all tasks with a status of `PENDING` across all task lists.
2.  **Pattern Matching:**
    -   **Budget Breaches:** Matches tasks with the phrase `Budget Breaches`. Queries the finance database. If the count of active breaches for the current month is 0, the task is marked as completed.
    -   **Pantry Restock:** Matches tasks starting with `🛒 Buy [Item]`. Queries the pantry database for that item. If the `current_quantity` is greater than the `critical_threshold`, the task is marked as completed.
    -   **Logistics Tasks:** Matches tasks with the pattern `📦 [Category]: [Item Name]`. Queries the logistics database. If the item's status is `DONE` or `Completed`, the task is marked as completed.
3.  **Completion Execution:** Calls `G10_google_tasks_sync.mark_task_completed(title)` for each matching resolved task.
4.  **Logging:** Records the number of tasks auto-resolved in the `system_activity_log`.

## Outputs
- **Google Tasks:** Updates task status to `completed` via API.
- **Activity Log:** Success/Failure status recorded in `system_activity_log`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)
- [S10 Productivity](../../20_Systems/S09_Productivity-Time/README.md)
- [S11 Meta-System](../../20_Systems/S11_Meta-System-Integration/README.md)

### External Services
- Google Tasks API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Query Error | `psycopg2` exception | Log error, skip that specific check | System Activity Log |
| Google Tasks API Error | API exception | Log error, continue scanning | System Activity Log |
| False Positive Match | Regex overlap | Log context, requires regex refinement | Manual task review |

## Manual Fallback
If tasks are not being auto-resolved:
1.  Check the `system_activity_log` for errors in DB connectivity or Google API.
2.  Manually mark tasks as completed in Google Tasks.
3.  Verify that the database state actually matches the resolution condition (e.g., query `v_budget_performance` directly).
