---
title: "G05: Budget Rebalance Wrapper"
type: "automation_spec"
status: "active"
automation_id: "finance_rebalance.py"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Michal"
updated: "2026-03-19"
---

# G05: Budget Rebalance Wrapper

## Purpose
Acts as the execution bridge between the Obsidian Daily Note UI and the financial rebalancing engine. It allows Michal to manually trigger the full autonomous rebalancing flow (including database updates and Google Sheets sync) with a single click.

## Triggers
- **Manual (Obsidian):** `[💸 Execute Budget Rebalancing]` button in the Daily Note.
- **Manual (CLI):** `python3 scripts/finance_rebalance.py`.

## Inputs
- **Script:** `scripts/G05_budget_rebalancer.py`.
- **Environment:** Path to the Python virtual environment.

## Processing Logic
1.  **Environment Setup:** Identifies the correct Python interpreter.
2.  **Execution:** Invokes `G05_budget_rebalancer.py` with the `--execute` flag.
3.  **Reporting:** Captures the stdout/stderr of the engine and displays it to the user.
4.  **Completion:** Verifies the rebalancing action and confirms the Google Sheets sync status.

## Outputs
- **Subprocess Trigger:** Executes the core rebalancing and sync logic.
- **Console Output:** Provides immediate feedback on the rebalancing results.

## Dependencies
### Systems
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [G05 Budget Rebalancer (Engine)](G05_budget_rebalancer.md)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Engine Error | `CalledProcessError` | Log failure, display engine output | Console Error |
| Sync Timeout | Subprocess timeout | Terminate, notify user | Console Error |

## Manual Fallback
If the wrapper fails:
1.  Run the engine directly: `python3 scripts/G05_budget_rebalancer.py --execute`.
2.  Verify the `system_activity_log` for detailed failure reasons.
