---
title: "S11: Autonomous Weekly Manager"
type: "automation_spec"
status: "active"
automation_id: "script:autonomous_weekly_manager.py"
goal_id: "goal-g11"
systems: ["S03", "S09", "S10"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-20"
---

# script: autonomous_weekly_manager.py

## Purpose
Autonomously aggregate 7 days of daily biometric, goal, and narrative data to generate a comprehensive Weekly Review note in Obsidian, eliminating manual data collection friction.

## Triggers
- **Scheduled:** Sunday at 05:05 AM (intended)
- **Manual:** `python3 autonomous_weekly_manager.py`

## Inputs
- **Daily Notes:** `01_Daily_Notes/YYYY-MM-DD.md` (last 7 days)
- **Data Points:** Energy list, sleep duration, sleep quality, steps, goals_touched, highlight, frustration.

## Processing Logic
1. Identify the last 7 dates relative to execution.
2. Parse each daily note using `PyYAML` for frontmatter and regex for content sections.
3. Normalize values (e.g., extracting the digit from energy lists like "5 - peak").
4. Calculate averages for metrics (Sleep, Energy, Quality).
5. Compile list of all highlighted wins and frustrations.
6. Audit Power Goal frequency across the week.
7. Generate a "Strategic Focus Suggestion" identifying starved goals.

## Outputs
- **Obsidian Note:** `03_Areas/A - Systems/Reviews/YYYY-Www.md`

## Dependencies
### Systems
- **S03 Data Layer:** Source of truth for daily logs.
- **S09 Productivity & Time:** Output destination for reviews.

### Credentials
- None (Local file system access only).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Daily Note | `os.path.exists` fails | Skip day, calculate avg on remaining | Console Log |
| YAML Syntax Error | `yaml.safe_load` fails | Use regex fallback for narratives | Console Warning |
| Dir Not Found | `FileNotFoundError` | Create directory or exit gracefully | Fatal Error |

## Monitoring
- **Success metric:** Weekly Review file exists with non-zero size on Sunday morning.
