---
title: "WF101: Finance Import Transactions"
type: "automation_spec"
status: "active"
automation_id: "WF101__finance-import-transactions"
goal_id: "goal-g02"
systems: ["S08", "S03"]
owner: "Michał"
updated: "2026-02-07"
---

# WF101: Finance Import Transactions

## Purpose
Automated budget optimization analysis that detects inefficient budget allocations and provides actionable suggestions for improving financial efficiency.

## Triggers
- **Schedule:** Every 6 hours (4 times daily)
- **Cron Expression:** `0 */6 * * *`

## Inputs
- **Database Function:** `get_budget_optimization_suggestions()`
- **Filter:** High confidence suggestions (confidence_score >= 0.7)

## Processing Logic
1. **Query Execution:** Call PostgreSQL function to get optimization suggestions
2. **Confidence Filtering:** Only process suggestions with 70%+ confidence
3. **Message Formatting:** Create human-readable summary with:
   - Category path and suggestion type
   - Current vs suggested budget amounts
   - Potential savings calculations
   - Detailed reasoning for each suggestion
4. **Conditional Output:** Send notification only if high-confidence suggestions exist

## Outputs
- **Success (No Suggestions):** Silent completion (no notification)
- **Suggestions Found:** Formatted message with optimization recommendations
- **Error:** Log entry with failure details

## Error Handling
| Failure Scenario | Detection | Response | Recovery |
|---|---|---|---|
| Database Connection Timeout | Query fails after 30s | Log error, retry in 1hr | Manual database check |
| Function Not Found | SQL error returned | Alert admin, skip execution | Verify schema deployment |
| No Notification Recipients | Notification fails | Log warning, continue | Update notification config |
| Low Confidence Results | All suggestions < 70% confidence | Silent completion | Natural state, no action needed |

## Manual Fallback
```sql
-- Execute directly in PostgreSQL to check current suggestions
SELECT 
    category_path,
    suggestion_type,
    ROUND(current_spending, 2) as current_spending,
    ROUND(suggested_budget, 2) as suggested_budget,
    ROUND(potential_savings, 2) as potential_savings,
    ROUND(confidence_score, 2) as confidence,
    implementation_priority
FROM get_budget_optimization_suggestions() 
WHERE confidence_score >= 0.7
ORDER BY potential_savings DESC;
```

## Dependencies
- **System:** S03 Data Layer
- **Function:** `get_budget_optimization_suggestions()`
- **Tables:** budgets, transactions, categories
- **Minimum Data:** 3+ months of transaction history for accurate analysis

## Performance Metrics
- **Expected Runtime:** <2 seconds
- **Data Processed:** Last 3 months of transactions
- **Frequency:** 4 times daily
- **Alert Volume:** 0-2 notifications per day (typical)

## Related Documentation
- Runbook: [Budget-Optimization-Response.md](../../40_RUNBOOKS/Budget-Optimization-Response.md)
- SOP: [Monthly-Budget-Review.md](../../30_SOPS/Monthly-Budget-Review.md)
- System: [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)