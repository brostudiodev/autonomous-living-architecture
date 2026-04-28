---
title: "SOP: Monthly Budget Review"
type: "sop"
status: "active"
owner: "Michał"
goal_id: "goal-g05"
updated: "2026-03-26"
---

# SOP: Monthly Budget Review

## Purpose
Monthly review of financial performance and budget alignment to ensure spending stays on track.

## Procedure
1. Open Grafana Financial Command Center dashboard
2. Review savings rate vs. target (goal: 25%+)
3. Check budget utilization by category
4. Identify any anomalies or overspending
5. Adjust budget categories if needed
6. Trigger rebalancing if savings rate drops below target

## Automated Alerts
- Daily budget alerts via Telegram (8 AM & 8 PM)
- Anomaly detection via `G05_finance_anomaly_detector.py`
- Automated rebalancing proposals via `G05_budget_rebalancer.py`

## Related Documentation
- [G05 Autonomous Financial Command Center](../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [SOP: Autonomous Rebalancing](./G05/Autonomous-Rebalancing.md)
- [G05 Finance Anomaly Detector](../50_Automations/scripts/G05_finance_anomaly_detector.md)

---
*Owner: Michał*
*Review Cadence: Monthly*
