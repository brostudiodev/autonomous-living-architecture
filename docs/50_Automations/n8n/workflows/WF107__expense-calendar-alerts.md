---
title: "WF107: Expense Calendar Alerts (SVC_Expense-Calendar-Alerts)"
type: "automation_spec"
status: "active"
automation_id: "WF107__expense-calendar-alerts"
workflow_name: "SVC_Expense-Calendar-Alerts"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-02-17"
---

# WF107: Expense Calendar Alerts

## Purpose
Sends daily Telegram notification with upcoming expenses for the next 30 days. Provides proactive awareness of known expenses to prevent financial surprises. Groups expenses by urgency (today, tomorrow, this week, later).

## Triggers
- **Schedule:** Daily at 08:00 AM UTC
- **Cron Expression:** `0 8 * * *`

## Workflow Structure

```
Daily 8 AM (Schedule Trigger)
     ↓
Query Upcoming Expenses (PostgreSQL)
     ↓
Format Alert Message (Code Node)
     ↓
Has Error? (IF)
     ├─[true]→ Send Error Alert (Telegram)
     └─[false]→ Has Expenses? (IF)
                   ├─[true]→ Send Expense Alert (Telegram)
                   └─[false]→ Log Skipped
```

## Nodes

| Node | Type | Description |
|------|------|-------------|
| Daily 8 AM | Schedule Trigger | Cron: `0 8 * * *` |
| Query Upcoming Expenses | PostgreSQL | Query `v_upcoming_expenses` view |
| Format Alert Message | Code | Groups by urgency, formats message |
| Has Error? | IF | Check for database errors |
| Has Expenses? | IF | Check if any expenses found |
| Send Expense Alert | Telegram | Send to chat {{TELEGRAM_CHAT_ID}} |
| Send Error Alert | Telegram | Send error notification |
| Log Skipped | Code | Log when no expenses |

## Processing Logic

### Query
```sql
SELECT 
    name,
    amount,
    currency,
    category,
    sub_category,
    frequency,
    expense_date,
    month_name,
    day_of_month as day,
    urgency,
    days_until
FROM v_upcoming_expenses
ORDER BY expense_date;
```

### Urgency Groups
- **Today:** `expense_date = CURRENT_DATE`
- **Tomorrow:** `expense_date = CURRENT_DATE + 1`
- **This Week:** `expense_date <= CURRENT_DATE + 7`
- **Later:** `expense_date > CURRENT_DATE + 7`

## Outputs

### Success Message (with expenses)
```
📅 *Upcoming Expenses Alert*
━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 *TODAY* (250.00 PLN):
  • Netflix: 30.00 PLN
  • Gym: 220.00 PLN

🟠 *TOMORROW* (100.00 PLN):
  • Car Insurance: 100.00 PLN

🟡 *THIS WEEK* (500.00 PLN):
  • 15 Feb - Rent: 500.00 PLN

🟢 *NEXT 30 DAYS* (1200.00 PLN):
  • 20 Feb - Internet: 80.00 PLN
  • 1 Mar - Phone: 120.00 PLN
  • ... and 3 more

━━━━━━━━━━━━━━━━━━━━━━━━━━
💰 *This Week:* 850.00 PLN
📊 *30-Day Total:* 2050.00 PLN
📈 *Count:* 9
```

### Error Message
```
🚨 *Expense Alert Error*

❌ `error message here`

⏰ 2026-02-17 08:00
```

### No Expenses
- Silent completion (no notification sent)

## Error Handling
| Failure Scenario | Detection | Response | Recovery |
|------------------|-----------|----------|----------|
| Database Connection | Query timeout/error | Send Error Alert | Check PostgreSQL |
| Telegram API Error | HTTP 4xx/5xx | Log error | Check bot token |
| Empty Result | 0 rows | Silent completion | Expected behavior |

## Dependencies
- **System:** S03 Data Layer
- **View:** `v_upcoming_expenses`
- **Workflow:** WF106 (Expense Calendar Sync must run first)
- **Credentials:**
  - PostgreSQL (`zrLunD1UbOGzqNzS`)
  - Telegram Bot (`XDROmr9jSLbz36Zf`)

## Performance Metrics
- **Expected Runtime:** <5 seconds
- **Typical Expenses:** 3-15 items per day
- **Message Size:** <1000 characters

## Manual Fallback
```sql
-- Manual check with urgency
SELECT 
    name,
    amount,
    currency,
    expense_date,
    urgency,
    days_until,
    CASE frequency
        WHEN 'monthly' THEN 'miesięcznie'
        WHEN 'quarterly' THEN 'kwartalnie'
        WHEN 'yearly' THEN 'rocznie'
        WHEN 'one-time' THEN 'jednorazowo'
    END as częstotliwość
FROM v_upcoming_expenses
ORDER BY expense_date;

-- Total upcoming
SELECT 
    SUM(CASE WHEN urgency IN ('today', 'tomorrow', 'this_week') THEN amount ELSE 0 END) as this_week,
    SUM(amount) as total_30_days
FROM v_upcoming_expenses;
```

## Alert Timing
- **08:00 UTC:** Morning awareness before day starts
- **30-day window:** Covers all recurring and one-time expenses

## Related Documentation
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- [WF106: Expense Calendar Sync](./WF106__expense-calendar-sync.md)
- [G05 Autonomous Financial Command Center](../../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)

## n8n JSON Import
- [WF107__expense-calendar-alerts.json](./WF107__expense-calendar-alerts.json)
