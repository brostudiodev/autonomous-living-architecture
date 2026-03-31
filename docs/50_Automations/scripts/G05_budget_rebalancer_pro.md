---
title: "G05: Budget Rebalancer Pro"
type: "automation_spec"
status: "active"
automation_id: "G05_budget_rebalancer_pro"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Michal"
updated: "2026-03-12"
---

# G05: Budget Rebalancer Pro

## Purpose
Proactively identifies budget breaches and provides a "One-Click Approve" rebalancing strategy to maintain financial integrity without manual calculation.

## Triggers
- Triggered by `G05_llm_categorizer.py` whenever a new transaction causes a category breach (>100% budget).

## Inputs
- Database: `autonomous_finance.budgets` and `autonomous_finance.transactions`.
- Rebalancing Rules: Priority-based (Critical > High > Med > Low).

## Processing Logic
1. **Detect:** Identify categories exceeding monthly budget.
2. **Scan Surpluses:** Find 'Low' or 'Medium' priority categories with remaining budget.
3. **Calculate:** Propose a transfer amount that covers the breach while leaving a 20% buffer in the source category.
4. **Notify:** Send a Telegram message with "Approve Rebalance" and "Ignore" buttons.
5. **Execute:** If approved, update the `budgets` table to reflect the new allocation for the current month.

## Outputs
- Telegram Notification with Action Buttons.
- Updated budget records in PostgreSQL.
