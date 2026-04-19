---
title: "Budget Optimization Response"
type: "runbook"
status: "active"
owner: "Michal"
goal_id: "goal-g05"
systems: ["S05", "S11"]
updated: "2026-03-26"
---

# Budget Optimization Response

## Purpose

Standard response procedures when budget optimization opportunities or anomalies are detected.

## Trigger Conditions

| Condition | Threshold | Response |
|-----------|-----------|----------|
| Category overspend | >100% utilization | Alert + propose rebalance |
| Savings rate drop | <15% for 7 days | Trigger review |
| Anomaly detected | >2x normal spend | Investigate + alert |
| Recurring payment miss | Payment not logged | Add to tracker |

## Response Procedures

### 1. Category Overspend Alert

**Detection:** Budget utilization >100% for any category

**Response:**
1. Log alert to `system_activity_log`
2. Send Telegram notification via `G05_budget_rebalancer.py`
3. Propose rebalancing from underutilized categories
4. Await approval (if >100 PLN change)

### 2. Savings Rate Drop

**Detection:** 7-day rolling savings rate <15%

**Response:**
1. Trigger comprehensive review
2. Identify top spending categories
3. Generate optimization suggestions
4. Send summary to Telegram

### 3. Spending Anomaly

**Detection:** Single transaction >2x category average

**Response:**
1. Flag transaction in `v_spending_anomalies` view
2. Send Telegram alert with details
3. Require explicit approval for similar future transactions
4. Log pattern for learning

## Automation

- `G05_finance_anomaly_detector.py` - Monitors and alerts
- `G05_budget_rebalancer.py` - Proposes and executes corrections
- `G11_decision_handler.py` - Manages approval workflow

## Related Documentation

- [G05 Financial Command Center](../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [Autonomy Rules Runbook](../40_Runbooks/G11/Autonomy-Rules-Runbook.md)

---
*Owner: Michal*
*Review Cadence: Monthly*
