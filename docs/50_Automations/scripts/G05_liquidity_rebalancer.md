---
title: "G05: Liquidity Rebalancing Agent"
type: "automation_spec"
status: "active"
automation_id: "G05_liquidity_rebalancer"
goal_id: "goal-g05"
systems: ["S05", "S11"]
owner: "Michał"
updated: "2026-03-26"
---

# G05: Liquidity Rebalancing Agent

## Purpose
Ensures operational liquidity across bank accounts by autonomously monitoring balances and proposing/executing transfers between accounts (e.g., from Savings to Checking) when safety buffers are breached.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` registry.
- **Manual:** `python3 scripts/G05_liquidity_rebalancer.py`

## Inputs
- **Database:** `autonomous_finance` (View: `v_account_balances`).
- **Policy:** `autonomy_policies.yaml` (Key: `auto_account_rebalance`).

## Processing Logic
1.  **Balance Check:** Retrieves current balances for "Checking" and "Savings" accounts.
2.  **Threshold Evaluation:** Checks if "Checking" balance is below the `LIQUIDITY_BUFFER` (default: 1000 PLN).
3.  **Gap Calculation:** If below buffer, calculates the `TARGET_REFILL` amount (default: 2000 PLN).
4.  **Authority Request:** Passes the transfer proposal to the `G11_rules_engine`.
5.  **Human-in-the-Loop:** Sends a Telegram notification with "Approve/Deny" buttons for the transfer.
6.  **Execution (Post-Approval):** Upon approval, `G11_decision_handler.py` updates the account balances in the database (simulating the physical transfer).

## Outputs
- **Database:** New entry in `decision_requests` (if human approval needed).
- **Telegram:** Interactive rebalancing proposal.
- **Database Mutation:** Updated `account_balances` table (on approval).

## Dependencies
### Systems
- [S05 Finance System](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [S11 Intelligence Router](../../20_Systems/S11_Meta-System-Router/README.md)

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Insufficient Funds | Script check | Log CRITICAL status, no proposal made |
| Database Offline | Connection error | Log FAILURE in activity log |
| Policy Missing | RulesEngine check | Default to ASK_HUMAN |

## Manual Fallback
1.  Manually check bank account balances.
2.  Perform manual transfer via bank mobile app.
3.  Update balances in PostgreSQL manually if needed.
