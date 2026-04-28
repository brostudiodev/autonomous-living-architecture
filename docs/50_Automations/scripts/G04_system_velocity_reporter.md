---
title: "G04: System Velocity Reporter"
type: "automation_spec"
status: "active"
automation_id: "G04__system_velocity_reporter"
goal_id: "goal-g04"
systems: ["S04", "S01"]
owner: "Michał"
updated: "2026-03-21"
---

# G04: System Velocity Reporter

## Purpose
Generates a weekly "Momentum Report" by comparing the current state of the Digital Twin with historical snapshots from 7 days ago. Tracks velocity in Finance, Health, Productivity, and Logistics.

## Triggers
- **Scheduled:** Weekly on Saturdays at 07:00 AM via `G11_global_sync.py`.
- **Manual:** Can be run on-demand to gauge current momentum.

## Inputs
- **Snapshots:** `context_snapshot` (JSONB) from `strategic_memory` table in `DB_TWIN`.
- **Activity Logs:** Task completion data from `system_activity_log`.

## Processing Logic
1. **Snapshot Retrieval:** Fetches today's latest context and the context from exactly 7 days ago.
2. **Metric Comparison:**
    - **Finance:** Calculates Net Worth delta and change in active budget breaches.
    - **Health:** Compares latest Readiness Score against the previous week's score.
    - **Productivity:** Aggregates `items_processed` from activity logs for the last 7 days.
    - **Household:** Compares the number of low-stock pantry items.
3. **Trend Classification:** Assigns status icons (📈, 📉, ⚖️) based on the direction of change.

## Outputs
- **Markdown Report:** A dedicated file `Velocity-Report-YYYY-WW.md` saved to the Obsidian Vault.
- **Activity Log:** Success/Failure logged to `system_activity_log`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)

### External Services
- Obsidian (File system access)

### Credentials
- Database credentials in `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing Snapshot | Query returns 0 rows | Log Warning, abort report | None |
| JSON Parse Error | malformed JSONB | Log Failure | Log Warning |
| File Write Error | OS Exception | Log Failure | Log Warning |

## Monitoring
- Success metric: Weekly report file exists in Obsidian.
- Alert on: Failure in `system_activity_log`.
