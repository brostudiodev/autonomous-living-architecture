---
title: "G11: Centralized System Logger"
type: "automation_spec"
status: "active"
automation_id: "G11_log_system.py"
goal_id: "goal-g11"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G11: Centralized System Logger

## Purpose
Provides a unified interface for all autonomous scripts to report their operational status. This enables high-fidelity system observability and replaces manual fallback instructions with definitive SUCCESS/FAILURE/WARNING telemetry.

## Usage (Python)
### Logging an activity
```python
from G11_log_system import log_activity
log_activity("script_name", "SUCCESS", items=10, details="Synced successfully.")
```

### Checking for daily success (Persistence)
```python
from G11_log_system import was_successful_today
if was_successful_today("morning_briefing"):
    print("Already sent today.")
    return
```

## Inputs
- Function Arguments: `script_name`, `status`, `items_processed`, `details`.
- Environment Variables: `DB_PASSWORD`, `DB_HOST`.

## Processing Logic
1.  **Context Assembly:** Captures the current timestamp and script metadata.
2.  **Database Insert:** Performs a non-blocking `INSERT` into the `system_activity_log` table in the `digital_twin_michal` database.
3.  **Proactive Notification:** If the status is `FAILURE`, it automatically triggers a Telegram alert via `G04_digital_twin_notifier.py`.
4.  **Daily Success Check (`was_successful_today`):** Performs a `SELECT COUNT(*)` on the current date for a given script name where status is `SUCCESS` or `WARNING`. This enables state-aware de-duplication of notifications.
5.  **Error Handling:** If the database insert fails, it falls back to printing the log to `stderr` to ensure the information is not lost.

## Outputs
- **Database:** A new row in `system_activity_log`.
- **Telegram:** Real-time failure alerts for script crashes.
- **UI Integration:** Feeds the `/system_health` endpoint and the Mission Control status light.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)

## Status Types
| Status | Meaning | UI Indicator |
|---|---|---|
| `STARTED` | Script began execution | ⚪ Grey |
| `SUCCESS` | Completed without issues | ✅ Green |
| `WARNING` | Completed but with minor issues | ⚠️ Yellow |
| `FAILURE` | Script crashed or hit critical error | ❌ Red |
| `PARTIAL` | Some sub-tasks succeeded, others failed | ⚠️ Yellow |

## Monitoring
- **Primary Source:** `digital_twin_michal.system_activity_log`.
- **API View:** `GET /system_health`.
