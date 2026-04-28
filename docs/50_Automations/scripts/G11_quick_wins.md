---
title: "G11: Quick Wins"
type: "automation_spec"
status: "active"
automation_id: "G11_quick_wins"
goal_id: "goal-g11"
systems: ["S04", "S10"]
owner: "Michał"
updated: "2026-04-02"
---

# G11: Quick Wins

## Purpose
Aggregates the top 3 most urgent and actionable items across multiple domains (Logistics, Pantry, Roadmap Tasks) to provide a "Zero-Thought Execution Zone" at the top of the Daily Note.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` cycle (06:00 daily).
- Manual: Running `G11_quick_wins.py` directly.

## Inputs
- `autonomous_life_logistics` table (PostgreSQL)
- `pantry_inventory` table (PostgreSQL)
- Google Tasks API (via `G10_google_tasks_sync.py`)

## Processing Logic
1.  **Logistics:** Fetch top 2 items due soonest (ascending order) that are due within the next **3 days**.
2.  **Pantry:** Fetch top 1 item with lowest stock ratio (quantity/threshold).
3.  **Course Prep (NEW Mar 28):** Fetch upcoming courses starting within 3 days.
4.  **Finance (NEW Mar 28):** Fetch the most severe financial anomaly (e.g., fraudulent/unusual spend).
5.  **Missions:** Fetch top 1 task tagged with `#deep` or `#roadmap` from Google Tasks.
6.  Combine into a Markdown checklist format.

## Outputs
- Markdown string injected into the `%%QUICK_WINS%%` marker in the Daily Note.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Google Tasks API

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Fail | Exception caught | Log error, return empty string | System Activity Log |
| API Fail | Exception caught | Skip task injection | Log warning |

## Monitoring
- Success metric: Section populated in Daily Note.
- Dashboard: G11 Connectivity Matrix.
