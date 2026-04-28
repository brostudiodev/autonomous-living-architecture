---
title: "G05: Budget Rebalancer (v2.0)"
type: "automation_spec"
status: "active"
automation_id: "G05_budget_rebalancer"
goal_id: "goal-g05"
systems: ["S05", "S11"]
owner: "Michał"
updated: "2026-04-28"
---

# G05: Budget Rebalancer (v2.1)

## Purpose
Identifies budget breaches and generates resolution suggestions using a tiered priority system. It first attempts to use global income surplus (Buffer-First) before raiding other planned categories. **As of v2.1, all rebalancing actions require human-in-the-loop approval to prevent unauthorized threshold increases.**

## Triggers
- **Daily Manager:** Part of the `autonomous_daily_manager.py` cycle (Suggestion mode).
- **Global Sync:** Executed as a consumer script in `G11_global_sync.py` (Suggestion mode).
- **Manual Execute:** `python3 G05_budget_rebalancer.py --execute` for forced database and sheet update (Human-triggered).

## Tiered Resolution Logic (v2.1)

### 🔴 Breach Detection
Identifies categories where actual spending (`actual_amount`) exceeds the monthly budget (`budget_amount`).

### 🛡️ Tier 1: Buffer-First (Income Surplus Suggestion)
- **Source:** Fetches `net_savings` from `v_monthly_pnl` (Income - Expenses).
- **Rule:** If a breach is detected and a global surplus exists, the system suggests increasing the target budget using these unallocated funds.
- **Safety:** Leaves a minimum **500 PLN** safety floor in the income buffer.
- **Authority:** **LIMITED** (Human-in-the-loop). Even buffer usage must be approved via Telegram command `/approve [id]`.

### 💸 Tier 2: Category Reallocation (Surplus Raiding)
- **Source:** Finds `Low/Medium` priority categories with remaining funds.
- **Spending Floor Safeguard:** **CRITICAL:** The system can only take from the **REMAINING** surplus (Budget - Spent). It is physically impossible for the system to reduce a budget below what has already been spent in that month.
- **Rule:** Leaves a 20% safety buffer in the source category.
- **Policy:** Evaluates amount and priority via `G11_rules_engine` (set to `Limited` authority).

## Processing Logic
1.  **Ingestion:** Loads transactions and budget states from `autonomous_finance`.
2.  **PnL Context:** Fetches current month Net Savings and Savings Rate.
3.  **Resolution Loop:** For each breach, applies Tier 1 then Tier 2 logic and generates a `Decision Request`.
4.  **Database Update:** Only executed if `--execute` flag is present (via manual approval handler).
5.  **Synchronization:** Calls `G05_finance_sync.py` after a successful update.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-20 | Initial budget rebalancing logic |
| 2026-03-28 | Implemented Sleep-Driven Safety thresholds |
| 2026-04-13 | v2.0: Implemented Buffer-First logic and Spending Floor Safeguard. |
| 2026-04-21 | **v2.1: Disabled autonomous execution. Shifted to 'Human-in-the-Loop' suggestion model.** |

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
- [autonomy_policies.yaml](../../../scripts/autonomy_policies.yaml)
