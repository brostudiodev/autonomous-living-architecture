---
title: "script: today-status"
type: "automation_spec"
status: "active"
automation_id: "today-status"
goal_id: "goal-g10"
systems: ["S04", "S09"]
owner: "Michal"
updated: "2026-02-22"
---

# script: today-status

## Purpose
Parses the current Obsidian Daily Note to provide a real-time "Mobile Dashboard" of today's biometrics, goal completion status, and active manual tasks.

## Triggers
- **API Call:** Triggered via the `/today` endpoint of the Digital Twin API.

## Inputs
- **Obsidian Daily Note:** The Markdown file for the current date (e.g., `2026-02-22.md`).

## Processing Logic
1. **Frontmatter Parsing:** Extracts Mood, Energy, Sleep, and ROI metrics from the YAML block.
2. **Goal Tracking:** Scans the "Power Goals" section for `[x]` checkmarks and "Did" descriptions.
3. **Task Extraction:** Pulls manual tasks from categorized sections (Work, Personal, etc.).
4. **Emoji Mapping:** Applies status icons (✅/⚪) for quick visual scanning on mobile.

## Outputs
- **JSON Object:** Full structured data of the day's progress.
- **Markdown Text:** A simplified, Telegram-safe dashboard view.

## Dependencies
### Systems
- [Digital Twin System](../../20_Systems/S04_Digital-Twin/README.md)
- [Productivity & Time](../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- **Obsidian Vault:** Local file system access required.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Note not generated | "Note not found" status | Prompt user to run `/start` or generate note |
| Regex Miss | Missing data fields | Return "N/A" for specific vitals |

## Manual Fallback
Open the Obsidian mobile app to view the Daily Note directly.
