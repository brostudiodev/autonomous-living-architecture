---
title: "Automation Spec: G05 Budget Friction Predictor"
type: "automation_spec"
status: "active"
system_id: "S05"
goal_id: "goal-g05"
owner: "Michal"
updated: "2026-04-18"
review_cadence: "monthly"
---

# 🤖 Automation Spec: G05 Budget Friction Predictor

## 🎯 Purpose
Predict potential monthly budget breaches *before* they occur by analyzing current spending velocity and weighted burn rates. Calculates **Safe Daily Allowance** to provide a recovery path for over-spending categories.

## 📝 Scope
- **In Scope:** Variable spending (Food, Lifestyle, etc.) via linear projection; Fixed costs (Rent, Utilities) via adjusted flat-rate projection; **Safe Daily Allowance** calculation; Ghost Schema logging.
- **Out of Scope:** Automatic execution of transfers (handled by `G05_budget_rebalancer.py`); Investment strategy.

## 🔄 Inputs/Outputs
- **Inputs:** 
  - `autonomous_finance.budgets` (Monthly targets)
  - `autonomous_finance.transactions` (Current month spend)
- **Outputs:**
  - `FRICTION` report in `autonomous_daily_manager.py`
  - Ghost Schema predictions in `digital_twin_michal.ghost_predictions`

## 🛠️ Dependencies
- **Systems:** S05 Autonomous Finance, S03 Data Layer (PostgreSQL)
- **Services:** Digital Twin Engine (for Ghost Schema)
- **Credentials:** `DB_PASSWORD` in `.env`

## ⚙️ Logic & Procedure
The script uses a two-tier projection model:
1. **Fixed Categories:** Assumes costs are mostly front-loaded. Projection = `current_spent * 1.1` (10% buffer for variable sub-fees).
2. **Variable Categories:** Uses linear velocity: `(spent / day_of_month) * days_in_month`.
3. **Safe Daily Allowance:** `(Total Budget - Current Spent) / Days Remaining`.
4. **Status Assignment:** "AT RISK" (Predicted > 105%), "BUDGET FULLY UTILIZED" (Current = 100%), vs "BREACHED" (Current > 100%).
5. **Logic Refinement (Apr 13):** Eliminates false-positive "exceeded by 0.00 PLN" alerts by strictly separating full utilization from actual breaches.
6. **Trigger:** Automated via `G11_global_sync.py`.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| DB Unreachable | Script logs `FAILURE` to `G11_log_system` | Check PostgreSQL container health |
| No Budget Found | Report shows "No budget data found" | Verify current month budgets in S05 |
| Ghost Schema Error | Python traceback in logs | Verify Digital Twin DB connectivity |

## 🔒 Security Notes
- **Access Control:** Database access restricted to local network/Docker bridge.
- **Secrets:** All DB credentials retrieved via environment variables; no plaintext passwords in code.

---
*System Hardening v5.4 - April 2026*
