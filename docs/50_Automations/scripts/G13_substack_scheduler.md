---
title: "Automation Spec: G13_substack_scheduler.py"
type: "automation_spec"
status: "active"
automation_id: "G13_substack_scheduler"
goal_id: "goal-g13"
systems: ["S02", "S04"]
owner: "Michał"
updated: "2026-04-09"
---

# 🤖 Automation Spec: G13_substack_scheduler.py

## Purpose
Bridges the gap between n8n content generation and final publication. It allows the user to "Schedule" an Obsidian Substack draft for publication by converting it into a high-priority Google Task with a direct link and target time.

## Triggers
- **Command:** Triggered via Telegram/API `/schedule_substack [draft_name]`.
- **Manual:** `python3 G13_substack_scheduler.py [filename]`

## Inputs
- **Obsidian Drafts:** `Obsidian Vault/00_Inbox/Substack Drafts/*.md`.
- **Target Time:** Logic defaults to the next available 09:00 AM.

## Processing Logic
1. **File Search:** Locates the specific draft in the Substack Drafts folder.
2. **Metadata Extraction:** Extracts the title from the file's YAML frontmatter.
3. **Task Creation:** Calls the Google Tasks API via `G10_google_tasks_sync.py` to create a "PUBLISH" task.
4. **Visibility:** Injects the task into the "Content (Autonomous)" list.

## Outputs
- **Google Task:** A "🚀 PUBLISH: Substack - [Title]" task.
- **System Activity Log:** Records the scheduling success.

## Dependencies
### Systems
- [S02 Brand System](../../20_Systems/S12_LinkedIn-Ideas-System/README.md)
- [S10 Productivity System](../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- Google Tasks API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Draft Not Found | `os.path.exists()` fails | Return error to API | Telegram alert |
| API Error | Google Tasks fail | Mark as failure | System Activity Log |

## Monitoring
- Success metric: Number of content drafts successfully moved to the "Scheduled" state.
