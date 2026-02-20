---
title: "WF102: Finance Budget Alerts"
type: "automation_spec"
status: "active"
automation_id: "WF102__finance-budget-alerts"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# WF102: Finance Budget Alerts

## Purpose
Autonomous budget monitoring system that detects spending threshold breaches and projects month-end overruns, providing immediate notifications for corrective action.

## Triggers
- **Schedule:** Every 12 hours at 8:00 AM and 8:00 PM UTC
- **Cron Expression:** `0 8,20 * * *`

## Inputs
- **Database Function:** `get_current_budget_alerts()`
- **Filter:** Only CRITICAL and HIGH severity alerts

## Processing Logic
1. **Query Execution:** Call PostgreSQL function to get active alerts
2. **Severity Filtering:** Process only CRITICAL and HIGH priority alerts
3. **Message Formatting:** Create human-readable alert summary with:
   - Alert count by severity (CRITICAL separated from HIGH)
   - Category names with utilization percentages
   - Specific recommended actions for each alert
   - Timestamp in Polish locale
   - Total alert count
4. **Conditional Output:** Send notification only if alerts exist

## Outputs
- **Success (No Alerts):** Silent completion (no notification)
- **Alerts Found:** Urgent formatted message to notification system
- **Error:** Log entry with failure details

## Error Handling
| Failure Scenario | Detection | Response | Recovery |
|---|---|---|---|
| Database Connection Timeout | Query fails after 30s | Log error, retry in 5min | Manual database check |
| Function Not Found | SQL error returned | Alert admin, skip execution | Verify schema deployment |
| No Alert Recipients | Notification fails | Log warning, continue | Update notification config |
| All Alerts Low Priority | No CRITICAL/HIGH alerts found | Silent completion | Expected behavior |

## Alert Prioritization
- **CRITICAL:** Budget exceeded (>100% utilization)
- **HIGH:** Above alert threshold (typically 80%+)
- **MEDIUM:** Projected month-end overrun
- **LOW:** Monitoring warnings (excluded from notifications)

## Manual Fallback
```sql
-- Execute directly in PostgreSQL to check current alerts
SELECT 
    alert_severity,
    category_path,
    ROUND(utilization_pct, 1) as usage_pct,
    recommended_action,
    priority
FROM get_current_budget_alerts() 
WHERE alert_severity IN ('CRITICAL', 'HIGH')
ORDER BY utilization_pct DESC;

-- Quick alert summary
SELECT 
    alert_severity,
    COUNT(*) as alert_count
FROM get_current_budget_alerts() 
GROUP BY alert_severity
ORDER BY alert_severity DESC;
```

## Dependencies
- **System:** S03 Data Layer
- **Function:** `get_current_budget_alerts()`
- **Tables:** budgets, transactions, categories
- **Prerequisites:** Budget data must exist for current month

## Performance Metrics
- **Expected Runtime:** <1 second
- **Alert Volume:** 0-5 notifications per day (typical)
- **False Positive Rate:** <5% (with proper threshold configuration)
- **Response Time:** <5 minutes from threshold breach

## Notification Channels
- **Primary:** Slack #finance-alerts channel
- **Secondary:** Email backup (configurable)
- **Escalation:** SMS for CRITICAL alerts (future enhancement)

## Related Documentation
- Runbook: [Budget-Alert-Response.md](../../40_RUNBOOKS/Budget-Alert-Response.md)
- SOP: [Daily-Financial-Review.md](../../30_SOPS/Daily-Financial-Review.md)
- System: [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)