---
title: "G11_failure_predictor.py: Proactive Failure Detection"
type: "automation_spec"
status: "active"
automation_id: "G11_failure_predictor"
goal_id: "goal-g11"
systems: ["S11"]
owner: "Michal"
updated: "2026-04-18"
---

# G11: Proactive Failure Predictor

## Purpose
Identifies scripts with a high probability of future failure by analyzing historical activity logs. This allows for proactive maintenance and dependency investigation before critical system failures occur.

## Analysis Logic
1. **Trend Analysis**: Detects scripts with an increasing failure rate over the last 7 days (e.g., >3 failures or >30% failure rate).
2. **Sequential Failure Analysis**: Flags scripts that have failed in their last 3 consecutive runs as "CRITICAL".
3. **Probability Scoring**: Categorizes risks as HIGH or CRITICAL based on the severity of the trend.

## Outputs
- **Predictions**: JSON object detailing the script, failure probability, reason, and recommended action.
- **Reporting**: Integrated into the Unified Health Dashboard.

---
*Related Documentation:*
- [G11_system_reliability_auditor.md](G11_system_reliability_auditor.md)
- [G11_unified_health_dashboard.md](G11_unified_health_dashboard.md)
