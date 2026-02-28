---
title: "script: global-sync"
type: "automation_spec"
status: "active"
automation_id: "global-sync"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-02-23"
---

# script: global-sync

## Purpose
A meta-orchestrator that triggers all registered background synchronization scripts (Withings, Pantry, Substack, Google Tasks) on demand. This ensures the Digital Twin state is consistent before high-value planning or reporting sessions.

## Triggers
- **API Call:** Triggered via the `/sync` endpoint of the Digital Twin API.
- **Manual:** `python3 G11_global_sync.py`.

## Inputs
- **Script Registry:** Orchestrates `pantry_sync.py`, `training_sync.py`, `G02_substack_sync.py`, `G10_google_tasks_sync.py`, and `autonomous_daily_manager.py`.

## Processing Logic
1. **Validation:** Checks for the existence of each target script, correctly handling scripts with command-line arguments (e.g., `--no-notify`).
2. **Environment Consistency:** Executes each script using `sys.executable` to ensure child processes stay within the same virtual environment as the parent orchestrator.
3. **Report Generation:** Collects exit codes and generates a consolidated status report (Success/Failed/Missing).
4. **Timing:** Tracks total execution duration for ROI monitoring.

## Outputs
- **Console Log:** Real-time sync progress.
- **Report Summary:** Human-readable Markdown summary delivered to the caller.

## Dependencies
### Systems
- [Meta-System Integration (S11)](../../../20_Systems/S11_Intelligence_Router/README.md)

### External Services
- All external APIs required by the sub-scripts (Google, Withings, Substack).

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Sub-script fail | Non-zero exit code | Flag as "❌ Failed" in report |
| Script missing | `os.path.exists` fail | Flag as "⚠️ Script missing" |
| Timeout | Subprocess timeout (60s) | Terminate and flag as "❌ Timeout" |

## Manual Fallback
Run each synchronization script manually from the terminal.
