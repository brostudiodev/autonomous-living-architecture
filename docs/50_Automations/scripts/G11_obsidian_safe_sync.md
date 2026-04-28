---
title: "G11: Obsidian-Safe Sync Wrapper"
type: "automation_spec"
status: "active"
automation_id: "G11_obsidian_safe_sync"
goal_id: "goal-g11"
systems: ["S11", "S08"]
owner: "Michał"
updated: "2026-03-19"
---

# G11: Obsidian-Safe Synchronization Wrapper

## Purpose
Ensures that the Obsidian application is closed during global synchronization to prevent data corruption or file "clobbering" in the Daily Notes. It manages the application lifecycle to guarantee a safe environment for file-system modifications.

## Triggers
- **When:** Scheduled via Crontab:
    - **Daily:** 06:00, 13:00, 16:00 (Ensures data freshness throughout the day).
- **Manual:** `python3 G11_obsidian_safe_sync.py`

## Inputs
- **Process Name:** `obsidian` (Target process for monitoring and termination).
- **Lock File:** `/tmp/obsidian_sync.lock` (Used to coordinate the background enforcer).
- **Sync Script:** `G11_global_sync.py` (The actual workload orchestrator).

## Processing Logic
1. **Initial Closure:** Checks if Obsidian is running using `pgrep`. If found, it sends a `SIGTERM` (graceful) and then `SIGKILL` (forced) via `pkill`.
2. **Enforcement Start:** Creates a lock file and spawns a background `bash` loop that executes `pkill -x obsidian` every second. This prevents the user or system from reopening Obsidian while synchronization is active.
3. **Synchronization Execution:** Runs `G11_global_sync.py` using the project's virtual environment. It passes the current script directory to `PYTHONPATH` to ensure internal imports function correctly.
4. **Cleanup & Unlock:** 
    - Removes the lock file to stop the background enforcer.
    - Terminates the enforcer process.
    - Signals that Obsidian is now safe to open.

## Outputs
- **Console Log:** Real-time status of Obsidian closure and synchronization progress.
- **Log File:** Append-only log at `_meta/daily-logs/safe_sync.log` (when run via cron).
- **Unlocked State:** Obsidian process is allowed to persist again.

## Dependencies
### Systems
- [S11 Meta-System Integration](../../20_Systems/S11_Meta-System-Integration/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- `pgrep` and `pkill` (Linux system utilities).
- Python 3 with `python-dotenv`.

### Credentials
- None (inherits from `G11_global_sync.py`).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Force Kill fails | `pgrep` still returns PID | Log error, attempt sync anyway (high risk) | Console Error |
| Sync Script Missing | `os.path.exists` check | Exit with error code 1 | Log entry |
| Enforcer Crash | Lock file exists but process dead | Logic proceeds, but reopening risk exists | - |

## Monitoring
- **Success metric:** "✅ Global Synchronization completed safely" in logs.
- **Log Location:** `autonomous-living/_meta/daily-logs/safe_sync.log`.

## Manual Fallback
If the wrapper fails to close Obsidian, manually close the application before running `python3 G11_global_sync.py`.

---
*Related Documentation:*
- [G11_global_sync.md](G11_global_sync.md)
- [autonomous_daily_manager.md](autonomous_daily_manager.md)
