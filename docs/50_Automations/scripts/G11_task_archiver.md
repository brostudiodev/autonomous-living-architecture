---
title: "G11_task_archiver: Stale Task Cleanup"
type: "automation_spec"
status: "active"
automation_id: "G11_task_archiver"
goal_id: "goal-g11"
systems: ["S10"]
owner: "Michał"
updated: "2026-04-28"
---

# G11_task_archiver: Stale Task Cleanup

## Purpose

Identifies and archives stale Google Tasks based on configurable rules. Prevents clutter from overdue tasks and maintains focus on current priorities. Includes intelligent approval bypass for extreme stale tasks.

## Triggers

- **Scheduled:** Sundays at 10:00 AM via crontab
- **Manual:** `python scripts/G11_task_archiver.py [--dry-run|--archive]`

### Usage Modes

| Mode | Flag | Description |
|------|------|-------------|
| Dry-run | `--dry-run` | Show what would be archived (default) |
| Archive | `--archive` | Actually delete tasks |
| Force | `--force` | Skip confirmation prompt |

## Stale Rules

| Rule | Condition | Approval Required |
|------|-----------|------------------|
| Shopping list items | Any task in "Shopping" list | ❌ Never archived (protected) |
| No due date + no #today | No date, no priority tag | ✅ Auto-approve |
| Completed > 3 days | Task completed + 3 days | ✅ Auto-approve |
| Overdue > 30 days | Due date passed + 30 days | ✅ Auto-approve |
| Overdue > 1 year | Due date passed + 365 days | ✅ Auto-approve |

## Approval Logic

Note: Tasks overdue for 7-30 days were previously flagged for approval, but this was silenced to reduce noise. Now only tasks > 30 days are actioned (auto-archived).

```
Task identified as stale
        │
        ▼
┌───────────────────────────────┐
│ Check: Shopping list item?   │
└───────────────────────────────┘
        │ Yes
        ▼
   [SKIP - Protected]

        │ No
        ▼
┌───────────────────────────────┐
│ Check: Auto-approve rules?   │
│ - No due date, no #today    │
│ - Completed > 3 days         │
│ - Overdue > 30 days         │
│ - Overdue > 1 year           │
└───────────────────────────────┘
        │ Matches
        ▼
   [AUTO-APPROVE]

        │ No match
        ▼
┌───────────────────────────────┐
│ Request Telegram approval    │
│ via Rules Engine            │
└───────────────────────────────┘
        │
        ▼
   [AWAIT RESPONSE]
```

## Inputs

| Source | Data | Used For |
|--------|------|----------|
| Google Tasks API | All task lists | Task identification |
| G10_google_tasks_sync | Authentication | Service connection |

## Processing Logic

1. **Fetch Tasks** - Get all tasks from all lists (including completed), skip Archive list
2. **Filter Shopping** - Exclude tasks from "Shopping" lists (persistent items)
3. **Analyze** - Check each task against stale rules
4. **Categorize** - Group by reason (completed, overdue, no due date)
5. **Approval Check** - Auto-approve extreme stale (>30d) or require Telegram approval (7-30d)
6. **Display/Summary** - Show results or delete based on mode

## Outputs

| Output | Destination | Format |
|--------|-------------|--------|
| Console Report | Stdout | Text |
| Activity Log | `system_activity_log` | PostgreSQL |

### Dry-Run Example Output

```
🗑️ G11_task_archiver: DRY-RUN Mode
============================================================

📋 Fetching all tasks...
✅ Using User Token
   Found 41 total tasks
⚖️  Evaluating 2 stale tasks for deletion authority...

📊 Analysis Results:
   Total tasks analyzed: 41
   Stale tasks found: 2
   Authorized for deletion: 1

📋 TASKS TO BE DELETED:

1. ⏰ Monitoring kopernika zrobic
   List: My Tasks
   Due: 2026-02-21
   Reason: Overdue 33 days

🔍 DRY-RUN MODE - No tasks were deleted.
   To archive: python scripts/G11_task_archiver.py --archive --force
```

## Dependencies

### Systems
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- Google Tasks API

### Scripts
- `G10_google_tasks_sync.py` - Authentication and API

## Crontab Configuration

```cron
# Task Archiver - Sundays 10 AM
0 10 * * 0 cd {{ROOT_LOCATION}}/autonomous-living && .venv/bin/python scripts/G11_task_archiver.py --archive --force >> _meta/daily-logs/task_archiver.log 2>&1
```

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Auth failure | Service returns None | Log failure |
| API error | Exception during fetch | Print warning, continue |
| Delete failure | Exception during delete | Count as failed, log |

## Security Notes

- No archive to Obsidian (direct delete per user request)
- Database credentials via `.env`
- No secrets in code

## Monitoring

- **Success metric:** Tasks analyzed and actioned
- **Log location:** `_meta/daily-logs/task_archiver.log`
- **Alert on:** 3 consecutive failures

## Manual Fallback

If script fails:
```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate

# Dry-run first
python scripts/G11_task_archiver.py --dry-run

# If looks good, archive
python scripts/G11_task_archiver.py --archive --force
```

Manual cleanup:
1. Open Google Tasks (web or mobile)
2. Filter by due date
3. Manually delete stale items

## Related Documentation

- [G10 Google Tasks Sync](./G10_google_tasks_sync.md)
- [G10 Productivity Sync](./G10_productivity_sync.md)
- [SOP: Daily Task Review & Sync](../../30_Sops/SOP_Daily_Task_Review.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-19 | Original archiver (overdue > 1 year) |
| 2026-03-20 | Enhanced with dry-run, multiple rules, completed task cleanup |
| 2026-03-26 | Added shopping list exclusion, auto-approve >30 days, improved approval logic |
| 2026-03-28 | Fixed bug: Added missing task/list IDs to Rules Engine context for successful deletion |
