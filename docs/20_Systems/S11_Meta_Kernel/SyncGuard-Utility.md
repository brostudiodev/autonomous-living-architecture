---
title: "S11: SyncGuard Utility"
type: "system_specification"
status: "active"
owner: "Michał"
updated: "2026-05-23"
---

# S11: SyncGuard Utility

## Purpose
The `SyncGuard` utility provides a centralized mechanism for managing high-frequency synchronization tasks that interact with rate-limited external APIs (primarily Google Sheets). It prevents redundant API calls and adds resilience to transient failures through exponential backoff.

## Scope
- **In Scope:** Google Sheets API calls, sync cooldown management, 429 error handling.
- **Out Scope:** Local database locks (handled by `fcntl`), network-level firewall rules.

## Inputs/Outputs
- **Inputs:** Domain name (e.g., `pantry`, `finance`), cooldown duration, `gspread` worksheet objects.
- **Outputs:** Boolean status (`should_sync`), retry-wrapped data records.

## Dependencies
- **SDK:** `autonomous_sdk.db_config` (for logging)
- **External:** `gspread` library, Linux filesystem (for `/tmp` locks).

## Procedure

### Using SyncGuard in a Module
```python
from autonomous_sdk.utils.sync_helpers import SyncGuard

guard = SyncGuard("my_domain", cooldown_minutes=60)
if guard.should_sync(force=False):
    # Perform sync...
    guard.mark_sync_complete()
```

### Implementing Retry Logic
```python
records = SyncGuard.get_all_records_with_retry(worksheet)
```

## System-Wide Impact (May 23 Audit)
- **Log Integrity:** Permission issues on `sdk:events.json.log` were resolved by standardizing ownership to the `michal` user, ensuring `SyncGuard` events are correctly emitted to the EDA bus.
- **Query Stability:** CTE syntax errors in health-related scripts (`G11_unified_health_dashboard.py`, `G11_failure_predictor.py`) were corrected, allowing the system to accurately track `SyncGuard` effectiveness.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Persistent 429 Error | `max_retries` reached | Log `FAILURE` and notify user via Telegram. |
| Lockfile Permission Error | `OSError` in `/tmp` | Log `WARNING`, proceed with sync (fail-open). |
| Clock Drift | Inconsistent `elapsed` time | Clean up `/tmp/sync_guards/` manually. |

## Security Notes
- **Access Control:** Relies on standard filesystem permissions for `/tmp`.
- **Sensitive Data:** Does not log or store API tokens or spreadsheet content.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Quarterly or upon Google Cloud Quota policy changes.
