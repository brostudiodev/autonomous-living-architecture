---
title: "WF106: Expense Calendar Sync"
type: "automation_spec"
status: "active"
automation_id: "WF106__expense-calendar-sync"
goal_id: "goal-g05"
systems: ["S08", "S03"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-17"
---

# WF106: Expense Calendar Sync

## Purpose
Synchronizes upcoming expenses from Google Sheets "Expense Calendar" tab to PostgreSQL `upcoming_expenses` table. Includes comprehensive error handling, processing stats, and Telegram notifications.

## Triggers
- **Schedule:** Every 6 hours
- **Cron Expression:** `0 */6 * * *`
- **Manual:** Available via n8n UI

## Input
- **Source:** Google Sheet - "Expense Calendar" tab
- **Sheet ID:** `1CUhzhuPXT3EoF4m35c7SRLhhqzX3NHWG4SWosGeGPzw`
- **Sheet Name:** `Expense Calendar`
- **Sheet GID:** `708931121`
- **Range:** `A2:K` (starts from row 2 to skip header)

## Workflow Structure

```
Schedule (6h)
     ↓
Read Google Sheet (Expense Calendar)
     ↓
Process Expense Data (Code Node)
     - Validate Month/Day/Amount
     - Build expense_date
     - Generate transaction_id if missing
     - Store processing stats
     ↓
Upsert to PostgreSQL (Function)
     - upsert_expense_from_sheet()
     - continueOnFail: true
     ↓
Generate Sync Report (Code Node)
     - Aggregate success/error counts
     - Store in customData
     ↓
Check for Errors (IF Node)
     - [SUCCESS] → Notify Success
     - [PARTIAL_SUCCESS] → Notify Error
```

## Processing Logic

### Column Mapping
| Sheet Column | DB Column | Type | Notes |
|--------------|-----------|------|-------|
| A - Month | (for Date calc) | SMALLINT | 1-12 |
| B - Day | (for Date calc) | SMALLINT | 1-31 |
| C - Name | name | VARCHAR | Required |
| D - Amount (PLN) | amount | DECIMAL | Auto-cleaned |
| E - Frequency | frequency | VARCHAR | monthly/quarterly/annual/one-time |
| F - Description | description | TEXT | Optional |
| G - Transaction_ID | transaction_id | VARCHAR | Auto-generated if missing |
| H - Date | expense_date | DATE | Calculated from Month/Day |
| I - Currency | currency | VARCHAR | Default: PLN |
| J - Category | category | VARCHAR | Default: UNCATEGORIZED |
| K - Sub-Category | sub_category | VARCHAR | Default: UNCATEGORIZED |

### Data Processing Features
- **Amount Cleaning:** Removes currency symbols, converts comma to dot
- **Auto-generated transaction_id:** If missing, generates `EXP-YYYY-MM-DD-NAME` format
- **Validation:** Skips rows with invalid Month/Day/Amount
- **Processing Stats:** Tracks total rows, valid expenses, errors

## SQL Upsert
```sql
SELECT upsert_expense_from_sheet(
    {{ $json.month }},
    {{ $json.day }},
    '{{ $json.name.replace(/'/g, "''") }}',
    {{ $json.amount }},
    '{{ $json.frequency }}',
    '{{ ($json.description || "").replace(/'/g, "''") }}',
    '{{ $json.transaction_id }}',
    '{{ $json.expense_date }}'::DATE,
    '{{ $json.currency }}',
    '{{ $json.category }}',
    '{{ $json.sub_category }}'
) as result
```

## Outputs

### Success Notification (Telegram)
```
✅ Expense Calendar Synced

📊 X expenses processed
📅 DD.MM.YYYY HH:MM
```

### Error Notification (Telegram)
```
🚨 Expense Calendar Sync Alert

⏰ Time: DD.MM.YYYY HH:MM
📊 Status: PARTIAL_SUCCESS

📥 PROCESSING PHASE:
  • Total rows: X
  • Valid expenses: X
  • Processing errors: X

💾 DATABASE PHASE:
  • Successful upserts: X
  • Database errors: X

❌ ERRORS:
  • [transaction_id] error message

🔍 Check n8n execution logs for details.
```

## Error Handling
| Failure Scenario | Detection | Response | Recovery |
|------------------|-----------|----------|----------|
| No valid expenses | Transform returns 0 items | Throw error | Check sheet structure |
| Google Sheets API Error | HTTP 4xx/5xx | Log error, continue | Check sharing |
| Invalid date values | Month <1 or >31 | Skip row, log | Fix in sheet |
| Invalid amount | NaN after parse | Skip row, log | Fix in sheet |
| Database error | SQL exception | continueOnFail | Check PostgreSQL |
| Partial success | Error count > 0 | Send error notification | Review errors |

## Dependencies
- **System:** S03 Data Layer
- **Function:** `upsert_expense_from_sheet()`
- **Table:** `expense_calendar`
- **View:** `v_upcoming_expenses`
- **Credentials:**
  - Google Sheets OAuth2 (`LXYoAr7I3Ccidlg5`)
  - PostgreSQL (`zrLunD1UbOGzqNzS`)
  - Telegram Bot (`XDROmr9jSLbz36Zf`)

## Database Schema

### Table: expense_calendar
```sql
CREATE TABLE IF NOT EXISTS expense_calendar (
    id SERIAL PRIMARY KEY,
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'PLN',
    category VARCHAR(100),
    sub_category VARCHAR(100),
    frequency VARCHAR(50) DEFAULT 'one-time',
    expense_date DATE NOT NULL,
    month INTEGER,
    day INTEGER,
    description TEXT,
    is_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Indexes
```sql
CREATE INDEX idx_expense_calendar_date ON expense_calendar(expense_date);
CREATE INDEX idx_expense_calendar_frequency ON expense_calendar(frequency);
CREATE INDEX idx_expense_calendar_is_paid ON expense_calendar(is_paid);
```

### Upsert Function: upsert_expense_from_sheet
```sql
CREATE OR REPLACE FUNCTION upsert_expense_from_sheet(
    p_month INTEGER,
    p_day INTEGER,
    p_name VARCHAR,
    p_amount NUMERIC,
    p_frequency VARCHAR,
    p_description VARCHAR,
    p_transaction_id VARCHAR,
    p_expense_date DATE,
    p_currency VARCHAR,
    p_category VARCHAR,
    p_sub_category VARCHAR
)
RETURNS JSON AS $$
BEGIN
    INSERT INTO expense_calendar (
        transaction_id, name, amount, currency, category, sub_category,
        frequency, expense_date, month, day, description, updated_at
    ) VALUES (
        p_transaction_id, p_name, p_amount, p_currency, p_category, p_sub_category,
        p_frequency, p_expense_date, p_month, p_day, p_description, CURRENT_TIMESTAMP
    )
    ON CONFLICT (transaction_id) DO UPDATE SET
        name = EXCLUDED.name,
        amount = EXCLUDED.amount,
        currency = EXCLUDED.currency,
        category = EXCLUDED.category,
        sub_category = EXCLUDED.sub_category,
        frequency = EXCLUDED.frequency,
        expense_date = EXCLUDED.expense_date,
        month = EXCLUDED.month,
        day = EXCLUDED.day,
        description = EXCLUDED.description,
        updated_at = CURRENT_TIMESTAMP;
    
    RETURN json_build_object(
        'success', true,
        'transaction_id', p_transaction_id,
        'action', 'upserted',
        'name', p_name,
        'amount', p_amount
    );
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'transaction_id', p_transaction_id,
        'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;
```

### View: v_upcoming_expenses
```sql
CREATE OR REPLACE VIEW v_upcoming_expenses AS
SELECT 
    id, transaction_id, name, amount, currency, category, sub_category,
    frequency, expense_date,
    TO_CHAR(expense_date, 'FMMonth') as month_name,
    EXTRACT(DAY FROM expense_date)::INTEGER as day_of_month,
    CASE 
        WHEN expense_date = CURRENT_DATE THEN 'today'
        WHEN expense_date = CURRENT_DATE + 1 THEN 'tomorrow'
        WHEN expense_date <= CURRENT_DATE + 7 THEN 'this_week'
        ELSE 'later'
    END as urgency,
    expense_date - CURRENT_DATE as days_until,
    is_paid
FROM expense_calendar
WHERE expense_date >= CURRENT_DATE
  AND expense_date <= CURRENT_DATE + 30
  AND is_paid = FALSE
ORDER BY expense_date;
```

### Verify Setup
```sql
SELECT 'expense_calendar table created' as status, COUNT(*) as rows FROM expense_calendar
UNION ALL
SELECT 'upsert function exists', COUNT(*) FROM information_schema.routines 
WHERE routine_name = 'upsert_expense_from_sheet';
```

## Performance Metrics
- **Expected Runtime:** <10 seconds
- **Typical Records:** 5-20 per sync
- **API Calls:** 1 Google Sheets read per execution

## Manual Fallback
```sql
-- Check current expenses
SELECT * FROM expense_calendar ORDER BY expense_date;

-- View expenses due in next 30 days
SELECT * FROM v_upcoming_expenses;

-- Manual insert
INSERT INTO expense_calendar 
    (transaction_id, expense_date, name, amount, currency, frequency, category, sub_category)
VALUES 
    ('EXP-2026-03-15-CAR_INSURANCE', '2026-03-15', 'Car Insurance', 100, 'PLN', 'yearly', 'Transportation', 'Car');

-- Mark expense as paid
UPDATE expense_calendar SET is_paid = TRUE WHERE transaction_id = 'EXP-2026-03-15-CAR_INSURANCE';

-- Test the upsert function
SELECT upsert_expense_from_sheet(
    3, 15, 'Test Expense', 50, 'one-time', 'Test desc', 
    'EXP-2026-TEST-001', '2026-03-01'::DATE, 'PLN', 'UNCATEGORIZED', 'UNCATEGORIZED'
);
```

## Related Documentation
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)
- [WF107: Expense Calendar Alerts](./WF107__expense-calendar-alerts.md)
- [Google Sheets Budget](https://docs.google.com/spreadsheets/d/1CUhzhuPXT3EoF4m35c7SRLhhqzX3NHWG4SWosGeGPzw)

## n8n JSON Import
- [WF106__expense-calendar-sync.json](./WF106__expense-calendar-sync.json)
