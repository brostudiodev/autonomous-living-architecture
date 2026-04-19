---
title: "G05: Budget Rebalancer (v2.0)"
type: "automation_spec"
status: "active"
automation_id: "G05_budget_rebalancer"
goal_id: "goal-g05"
systems: ["S05", "S11"]
owner: "Michal"
updated: "2026-04-18"
---

# G05: Budget Rebalancer (Buffer-First)

## Purpose
Identifies budget breaches and resolves them using a tiered priority system. It first attempts to use global income surplus (Buffer-First) before raiding other planned categories, ensuring that categories with actual spending are protected from unrealistic budget cuts.

## Triggers
- **Daily Manager:** Part of the `autonomous_daily_manager.py` cycle.
- **Global Sync:** Executed as a consumer script in `G11_global_sync.py`.
- **Manual Execute:** `python3 G05_budget_rebalancer.py --execute` for forced database and sheet update.

## Tiered Resolution Logic (v2.0)

### 🔴 Breach Detection
Identifies categories where actual spending (`actual_amount`) exceeds the monthly budget (`budget_amount`).

### 🛡️ Tier 1: Buffer-First (Income Surplus)
- **Source:** Fetches `net_savings` from `v_monthly_pnl` (Income - Expenses).
- **Rule:** If a breach is detected and a global surplus exists, the system increases the target budget directly using these unallocated funds.
- **Safety:** Leaves a minimum **500 PLN** safety floor in the income buffer.
- **Autonomy:** Buffer-First increases are considered **Full Autonomy** (Auto-Act) as they don't impact other planned categories.

### 💸 Tier 2: Category Reallocation (Surplus Raiding)
- **Source:** Finds `Low/Medium` priority categories with remaining funds.
- **Spending Floor Safeguard:** **CRITICAL:** The system can only take from the **REMAINING** surplus (Budget - Spent). It is physically impossible for the system to reduce a budget below what has already been spent in that month.
- **Rule:** Leaves a 20% safety buffer in the source category.
- **Policy:** Evaluates amount and priority via `G11_rules_engine`.

## Processing Logic
1.  **Ingestion:** Loads transactions and budget states from `autonomous_finance`.
2.  **PnL Context:** Fetches current month Net Savings and Savings Rate.
3.  **Resolution Loop:** For each breach, applies Tier 1 then Tier 2 logic.
4.  **Database Update:** Surgically updates the `budgets` table (single entry per ID).
5.  **Synchronization:** Calls `G05_finance_sync.py` to push changes to Google Sheets.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-20 | Initial budget rebalancing logic |
| 2026-03-28 | Implemented Sleep-Driven Safety thresholds |
| 2026-04-13 | **v2.0: Implemented Buffer-First logic and Spending Floor Safeguard.** |

## Dependencies
- **Database:** `autonomous_finance` (PostgreSQL).
- **Views:** `v_budget_performance`, `v_monthly_pnl`.
- **Sync:** `G05_finance_sync.py`.

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| Buffer Exhausted | `income_buffer < 50` | Fall back to Tier 2 (Category Reallocation). |
| Total Insolvency | All surpluses < 1 PLN | Report breach as "Unresolved" in Daily Note. |
| Duplicate IDs | Repo logic check | Duplicate budget IDs (with spaces) are ignored or cleaned. |

---
*Related Documentation:*
- [G05_budget_rebalancer_pro.md](G05_budget_rebalancer_pro.md)
- [autonomy_policies.yaml](../autonomy_policies.yaml)
