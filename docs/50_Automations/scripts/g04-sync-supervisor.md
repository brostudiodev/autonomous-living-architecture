---
title: "G04 Sync Supervisor: Autonomous Data Integrity"
type: "automation_spec"
status: "active"
automation_id: "g04-sync-supervisor"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-02-27"
---

# G04 Sync Supervisor

## Purpose
Ensures that the Digital Twin always operates on the freshest possible data. It acts as a pre-flight controller for the Daily Note generation process, proactively attempting to resolve "Data Drift" (stale databases) before the user sees their dashboard.

## Triggers
- **Implicit:** Executed automatically whenever `autonomous_daily_manager.py` is called.
- **Manual:** Can be triggered by running the Daily Manager with the `--force` flag.

## Inputs
- **Script Matrix:** List of internal sync scripts (`pantry_sync`, `G10_productivity_sync`, `G07_zepp_sync`, etc.).
- **Database Metadata:** Queries `MAX(updated_at)` or equivalent timestamps from PostgreSQL tables.

## Processing Logic
1.  **Freshness Audit:** Calculates the delta between `current_timestamp` and the last update in each domain (Finance, Health, Pantry).
2.  **Autonomous Recovery:** If a domain is identified as stale (> 24h), the Supervisor dynamically imports and executes the relevant sync function.
3.  **Error Isolation:** Each sync attempt is wrapped in an independent `try/except` block.
4.  **Status Reporting:** Captures the outcome of each sync (✅ Fresh, ❌ Failed) into a `sync_status` dictionary.
5.  **Graceful Continuation:** Regardless of sync success or failure, the Supervisor allows the Daily Note generation to proceed, ensuring the user is never without their primary mission briefing.

## Outputs
- **Fresh Data:** Updated PostgreSQL records.
- **Visual Feedback:** Injects a "Sync Status" line into the Obsidian Daily Note frontmatter/header.
- **Console Logs:** Real-time trace of recovery attempts.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Host system.
- [S11 Intelligence Router](../../20_Systems/S11_Intelligence_Router/README.md) - Parent coordinator.

### External Services
- All external APIs required by individual sync scripts (Google Sheets, Zepp Cloud, Substack).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Module Import Fail | `ImportError` | Log error, skip sync | Console |
| API Authentication Fail | `Exception` from child script | Catch exception, mark as "Failed" | Daily Note Warning |
| Database Timeout | `psycopg2.OperationalError` | Retry once, then mark as "Failed" | Console |

## Security Notes
- **Local Context:** The Supervisor runs in the same security context as the Daily Manager.
- **Credential Safety:** It does not store credentials; it relies on the `.env` configuration of the child scripts it triggers.

## Procedure
1.  **Preparation:** Ensure Obsidian is **CLOSED** on all devices to prevent background sync deletion loops.
2.  **Daily Review:** Check the "System Connectivity" line in the Daily Note.
3.  **Manual Intervention:** If a sync shows "❌ Failed" for more than 2 consecutive days, check the relevant script logs in `scripts/*.log`.

## Related Documentation
- [Goal: G04 Digital Twin Ecosystem](../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)
- [Script: autonomous_daily_manager.md](./autonomous-daily-manager.md)
