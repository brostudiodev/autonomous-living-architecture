---
title: "G05: Budget Rebalancer Pro"
type: "automation_spec"
status: "active"
automation_id: "G05_budget_rebalancer_pro"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Michał"
updated: "2026-04-13"
---

# G05: Budget Rebalancer Pro

## Purpose
Advanced budget rebalancing agent that proactively identifies breaches and resolves them using a multi-tiered strategy. It prioritizes global income bandwidth before suggesting category-to-category transfers.

## Triggers
- **Autonomous Trigger:** Triggered by the Finance Hub whenever a transaction breach is detected.
- **Manual Trigger:** `/approve rebalance` command in Telegram.

## Tiered Resolution Logic
1.  **Tier 1: Income Buffer:** Checks `v_monthly_pnl` for unallocated income (`net_savings`). If available, it increases the budget directly from the buffer (maintaining a 500 PLN floor).
2.  **Tier 2: Surplus Reallocation:** Identifies `Low/Medium` priority categories with available funds.
    - **Spending Floor Safeguard:** Only funds from the *remaining* amount (Budget - Spent) can be reallocated. The system cannot cut a budget below actual spending.

## Processing Logic
1.  **Detection:** Scan all active budgets for the current month.
2.  **Context Loading:** Fetch global PnL state to determine "Income Buffer" availability.
3.  **Plan Generation:** Create a resolution plan prioritizing Tier 1 then Tier 2.
4.  **Auto-Approval:** If configured with `--auto`, it executes the plan immediately. Otherwise, it generates a proposal for Telegram.
5.  **Execution:** Performs atomic updates to the `budgets` table and triggers a sync to Google Sheets.

## Outputs
- Telegram Notification with proposal details.
- Updated budget records in PostgreSQL.
- Synced state in Google Sheets.

---
*Related Documentation:*
- [G05_budget_rebalancer.md](G05_budget_rebalancer.md)
