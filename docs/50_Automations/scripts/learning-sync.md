---
title: "G06_learning_sync.py: Certification Progress Tracker"
type: "automation_spec"
status: "active"
automation_id: "learning-sync"
goal_id: "goal-g06"
systems: ["S03", "S04"]
owner: "Michal"
updated: "2026-02-24"
---

# G06_learning_sync.py: Certification Progress Tracker

## Purpose
Automates the extraction of study sessions and certification progress from Obsidian daily notes and persists them into the dedicated `autonomous_learning` database.

## Triggers
- **Scheduled:** Daily at 06:00 AM (invoked by `autonomous_daily_manager.py`).
- **Manual:** `python3 scripts/G06_learning_sync.py`

## Inputs
- **Obsidian Daily Notes:** Markdown files in `01_Daily_Notes/`.
- **Note Content:** Regex-matched sessions like `Study: 60m [AWS]`.

## Processing Logic
1. **Note Parsing:** Scans the last 7 daily notes for study strings.
2. **Data Transformation:** Converts duration and subject into structured records.
3. **DB Persistence:** UPSERTS records into the `study_sessions` table in `autonomous_learning` database.

## Outputs
- **Postgres:** Populates `study_sessions` and updates `v_learning_progress`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### Database
- `autonomous_learning`: Dedicated database for educational metrics.

## Monitoring
- **Digital Twin:** Learning hours displayed in the unified status summary.
- **SQL View:** `SELECT * FROM v_learning_progress;`
