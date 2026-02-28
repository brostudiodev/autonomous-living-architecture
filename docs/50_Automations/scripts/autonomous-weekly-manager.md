---
title: "S11: Autonomous Weekly Manager"
type: "automation_spec"
status: "active"
automation_id: "script:autonomous_weekly_manager.py"
goal_id: "goal-g11"
systems: ["S03", "S09", "S10"]
owner: "Michal"
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
1.  **Date Window Calculation**: Identifies the last 7 dates relative to execution.
2.  **Daily Note Parsing**: Extracts frontmatter (vitals, ROI) and narratives using `PyYAML` and regex.
3.  **Autonomy ROI Aggregation**: Sums `time_saved_minutes` across the week to quantify reclaimed time.
4.  **Activity Log Deep-Scan**: Parses every goal's `Activity-log.md` for entries within the range to extract specific action wins.
5.  **Goal Frequency Audit**: Uses a robust project-to-ID mapping to count sessions and flag starved goals.
6.  **Director's Report Generation**: Constructs a structured review note in `03_Areas/A - Systems/Reviews/`.
7.  **Strategic Recommendations**: Automatically identifies the top 3 neglected goals for the coming week.

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
