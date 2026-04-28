---
title: "G05: Autonomous Budget Rebalance Trigger"
type: "automation_spec"
status: "active"
automation_id: "G05_auto_rebalance_trigger.py"
goal_id: "goal-g05"
systems: ["S03", "S05"]
owner: "Michał"
updated: "2026-04-28"
---

# G05: Autonomous Budget Rebalance Trigger

## Purpose
Monitors the `autonomy_policies.yaml` configuration and automatically executes budget rebalancing if `FULL` authority is granted. This transitions budget management from "manual review" to "autonomous execution."

## Triggers
- **Scheduled:** Part of the `G11_global_sync.py` daily synchronization cycle.
- **Manual:** `python3 scripts/G05_auto_rebalance_trigger.py`

## Inputs
- **Autonomy Policy:** `scripts/autonomy_policies.yaml` (Checks `financial.auto_budget_rebalance`).
- **Scripts:** `G05_budget_rebalancer.py` (The execution engine).

## Processing Logic
1.  **Policy Check:** Reads `autonomy_policies.yaml`.
2.  **Authority Validation:** Verifies if `enabled: true` and `authority_level: "full"`.
3.  **Execution:** If authorized, runs `G05_budget_rebalancer.py --execute` in a subprocess.
4.  **Reporting:** Logs success/failure to `system_activity_log`.

## Outputs
- **Subprocess Trigger:** Executes the rebalancing script which updates DB and Google Sheets.
- **System Activity Log:** Records the autonomous action.

## Dependencies
### Systems
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [G11 Rules Engine](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Policy Disabled | `enabled: false` | Script exits gracefully | Log Info |
| Subprocess Error | `CalledProcessError` | Log failure | System Activity Log |
| Policy Missing | `KeyError` | Log error | System Activity Log |

## Manual Fallback
To run rebalancing without full autonomy enabled:
1.  Use the `[💸 Execute Budget Rebalancing]` button in the Obsidian Daily Note.
2.  Or manually run `python3 scripts/G05_budget_rebalancer.py --execute`.
