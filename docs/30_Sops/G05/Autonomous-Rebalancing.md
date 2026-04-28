---
title: "SOP: Autonomous Budget Rebalancing"
type: "sop"
status: "active"
owner: "Michał"
goal_id: "goal-g05"
updated: "2026-03-26"
---

# SOP: Autonomous Budget Rebalancing (G05)

## Overview
This SOP describes the process for autonomous financial rebalancing within the Autonomous Living ecosystem. The system identifies budget breaches and surpluses across different expense categories and suggests (or executes) transfers to maintain financial health.

## Trigger
- **Scheduled:** Daily at 08:00 AM as part of the `G05_finance_sync` or `G11_global_sync`.
- **Manual:** Triggered via the Obsidian Daily Note button `💸 Execute Budget Rebalancing`.

## Automated Logic (G05_budget_rebalancer.py)
1. **Breach Identification:** The system queries the `v_budget_performance` view to find categories where actual spending exceeds the allocated budget.
2. **Surplus Discovery:** The system identifies "Low" or "Medium" priority categories with remaining funds > 50 PLN.
3. **Safety Buffer:** The system only takes up to 80% of a surplus to leave a buffer.
4. **Decision Intelligence:** 
    - Transfers < 100 PLN from "Low" priority surpluses are executed autonomously.
    - Large or critical transfers are queued for human approval via `G11_approval_prompter`.
5. **Execution:** 
    - Updates the `budgets` table in the `autonomous_finance` database.
    - Synchronizes the changes back to the Google Sheets master budget.
    - Sends a Telegram notification confirming the rebalance.

## Error Handling
- If insufficient surplus is found to cover a breach, the system flags it in the Daily Note as `Insufficient surplus`.
- Connection failures to PostgreSQL or Google Sheets trigger a `FAILURE` log in `system_activity_log`.

## Review Process
Michał reviews the `Budget Rebalancing Suggestions` section in the Daily Note every morning. If an autonomous action was taken, it is marked with 🚀.
