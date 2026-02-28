---
title: "G10_productivity_sync.py: Productivity ROI Data Flow"
type: "automation_spec"
status: "active"
automation_id: "productivity-sync"
goal_id: "goal-g10"
systems: ["S03", "S10"]
owner: "Michal"
updated: "2026-02-24"
---

# G10_productivity_sync.py: Productivity ROI Data Flow

## Purpose
Automates the extraction of productivity metrics (time saved, energy, mood, task volume) from Obsidian daily notes and persists them into the `autonomous_training` database for long-term ROI analysis.

## Triggers
- **Scheduled:** Daily (06:00 AM Weekdays / 09:00 AM Weekends) via `autonomous_daily_manager.py`.
- **Manual:** `python3 scripts/G10_productivity_sync.py`

## Inputs
- **Obsidian Daily Notes:** Markdown files in `01_Daily_Notes/`.
- **YAML Frontmatter:** `time_saved_minutes`, `energy`, `mood`.
- **Note Content:** Markdown task checkboxes (`- [x]`).

## Processing Logic
1. Iterate through the last 7 days of daily notes.
2. Parse YAML for quantitative metadata.
3. Regex-count completed tasks (`- [x]`) and completed Power Goals (`- [x] **Gxx**`).
4. Upsert data into the `productivity_logs` table.

## Outputs
- **Postgres:** Populates `productivity_logs` and updates `v_productivity_roi`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- None (Local file system and database).

## Monitoring
- **SQL View:** `SELECT * FROM v_productivity_roi;`
- **Dashboard:** Grafana Productivity Dashboard (Planned).
