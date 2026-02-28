---
title: "G05: Budget Alert Test Data"
type: "test_data"
status: "complete"
goal_id: "goal-g05"
created: "2026-02-10"
---

# Budget Alert Test Data

## Test Case Data Insertion Scripts

### TC-G05-BA-001: Spending exceeds 80% threshold for a category

```sql
-- Clear existing test data
TRUNCATE transactions RESTART IDENTITY CASCADE;
TRUNCATE accounts RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY CASCADE;

-- Insert test account
INSERT INTO accounts (account_name, account_type) VALUES ('Test Checking', 'Checking');

-- Insert Groceries category with $300 monthly budget, 80% alert threshold
INSERT INTO categories (category_name, category_type, budget_monthly, alert_threshold) 
VALUES ('Groceries', 'Expense', 300.00, 80);

-- Insert transactions totaling $250 (83.33% of budget - above 80% threshold)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '5 days', 'Grocery Store Visit', -120.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Groceries')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '2 days', 'Bulk Food Purchase', -130.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Groceries'));

-- Verification query
SELECT 
    c.category_name,
    c.budget_monthly,
    c.alert_threshold,
    c.budget_monthly * (c.alert_threshold/100.0) as alert_threshold_amount,
    SUM(t.amount) as spent,
    (SUM(t.amount) / c.budget_monthly) * 100 as percentage_spent
FROM categories c
LEFT JOIN transactions t ON c.category_id = t.category_id 
    AND DATE_TRUNC('month', t.transaction_date) = DATE_TRUNC('month', CURRENT_DATE)
WHERE c.category_name = 'Groceries'
GROUP BY c.category_name, c.budget_monthly, c.alert_threshold;
```

### TC-G05-BA-002: Spending exactly meets 80% threshold for a category

```sql
-- Clear and setup test data
TRUNCATE transactions RESTART IDENTITY CASCADE;
TRUNCATE accounts RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY CASCADE;

INSERT INTO accounts (account_name, account_type) VALUES ('Test Checking', 'Checking');

-- Entertainment category with $200 monthly budget, 80% alert threshold
INSERT INTO categories (category_name, category_type, budget_monthly, alert_threshold) 
VALUES ('Entertainment', 'Expense', 200.00, 80);

-- Insert transactions totaling exactly $160 (80% of budget)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '7 days', 'Movie Tickets', -60.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Entertainment')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '3 days', 'Streaming Services', -50.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Entertainment')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '1 days', 'Gaming Purchase', -50.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Entertainment'));
```

### TC-G05-BA-003: Spending exceeds 100% threshold for a category

```sql
-- Clear and setup test data
TRUNCATE transactions RESTART IDENTITY CASCADE;
TRUNCATE accounts RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY CASCADE;

INSERT INTO accounts (account_name, account_type) VALUES ('Test Checking', 'Checking');

-- Dining Out category with $150 monthly budget, 80% alert threshold
INSERT INTO categories (category_name, category_type, budget_monthly, alert_threshold) 
VALUES ('Dining Out', 'Expense', 150.00, 80);

-- Insert transactions totaling $180 (120% of budget - exceeds 100%)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '10 days', 'Restaurant Dinner', -80.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Dining Out')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '5 days', 'Lunch Meeting', -60.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Dining Out')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '2 days', 'Coffee Shop', -40.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Dining Out'));
```

### TC-G05-BA-004: Spending is below 80% threshold for all categories

```sql
-- Clear and setup test data
TRUNCATE transactions RESTART IDENTITY CASCADE;
TRUNCATE accounts RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY CASCADE;

INSERT INTO accounts (account_name, account_type) VALUES ('Test Checking', 'Checking');

-- Multiple categories with healthy spending
INSERT INTO categories (category_name, category_type, budget_monthly, alert_threshold) VALUES
('Transportation', 'Expense', 200.00, 80),
('Utilities', 'Expense', 300.00, 80),
('Shopping', 'Expense', 250.00, 80);

-- Low spending (all below 80% threshold)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '5 days', 'Gas Station', -40.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Transportation')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '3 days', 'Electric Bill', -120.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Utilities'));
-- Transportation: 40/200 = 20% (below 80%)
-- Utilities: 120/300 = 40% (below 80%)
-- Shopping: 0/250 = 0% (below 80%)
```

### TC-G05-BA-005: Category with $0 budget has spending

```sql
-- Clear and setup test data
TRUNCATE transactions RESTART IDENTITY CASCADE;
TRUNCATE accounts RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY CASCADE;

INSERT INTO accounts (account_name, account_type) VALUES ('Test Checking', 'Checking');

-- Category with no monthly budget set
INSERT INTO categories (category_name, category_type, budget_monthly, alert_threshold) 
VALUES ('Miscellaneous', 'Expense', 0.00, 80);

-- Spending in category with no budget
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '4 days', 'Miscellaneous Purchase', -75.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Miscellaneous'));
```

### TC-G05-BA-006: Projected month-end spending exceeds budget

```sql
-- Clear and setup test data
TRUNCATE transactions RESTART IDENTITY CASCADE;
TRUNCATE accounts RESTART IDENTITY CASCADE;
TRUNCATE categories RESTART IDENTITY CASCADE;

INSERT INTO accounts (account_name, account_type) VALUES ('Test Checking', 'Checking');

-- Amazon category with $200 monthly budget
INSERT INTO categories (category_name, category_type, budget_monthly, alert_threshold) 
VALUES ('Amazon Purchases', 'Expense', 200.00, 80);

-- Current spending of $100 on day 20 of month (50% spent in 2/3 of month)
-- Projected daily burn: $100/20 = $5/day
-- Projected month-end: $100 + ($5 * 10) = $150 (75% of budget) - let's make it higher

-- Actually, let's create spending that projects to exceed
-- Current spending of $180 on day 25 of month (90% spent in 5/6 of month)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '25 days', 'Large Amazon Order', -120.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Amazon Purchases')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '10 days', 'Amazon Subscribe & Save', -60.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Amazon Purchases'));

-- Current: $180/200 = 90% (above 80% so alert would trigger anyway)
-- Let's adjust for a better projected overspend scenario:

-- Clear and recreate with better projection
TRUNCATE transactions RESTART IDENTITY CASCADE;

-- Current spending of $120 on day 15 of month (60% spent in half month)
-- Daily burn: $120/15 = $8/day
-- Projected month-end: $120 + ($8 * 15) = $240 (120% - exceeds budget!)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '15 days', 'Amazon Order 1', -80.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Amazon Purchases')),
((SELECT account_id FROM accounts WHERE account_name = 'Test Checking'), 
 CURRENT_DATE - INTERVAL '8 days', 'Amazon Order 2', -40.00, 'Debit', 
 (SELECT category_id FROM categories WHERE category_name = 'Amazon Purchases'));
```

## Test Execution Order

1. **Run TC-G05-BA-001** - Verify HIGH severity alert for 80% breach
2. **Run TC-G05-BA-002** - Verify HIGH severity alert exactly at 80%
3. **Run TC-G05-BA-003** - Verify CRITICAL severity alert for 100%+ breach
4. **Run TC-G05-BA-004** - Verify no alerts for healthy spending
5. **Run TC-G05-BA-005** - Verify no alerts for category with $0 budget
6. **Run TC-G05-BA-006** - Verify MEDIUM severity alert for projected overspend

## Verification Scripts

After each test case, run this verification query to confirm expected conditions:

```sql
-- Test budget alert function output
SELECT * FROM get_current_budget_alerts();

-- Manual verification of calculations
SELECT 
    c.category_name,
    c.budget_monthly,
    c.alert_threshold,
    c.budget_monthly * (c.alert_threshold/100.0) as alert_threshold_amount,
    SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) as spent,
    CASE 
        WHEN SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) = 0 THEN 0
        ELSE (SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) / c.budget_monthly) * 100 
    END as percentage_spent,
    CASE 
        WHEN c.budget_monthly = 0 THEN 'No Budget'
        WHEN SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) = 0 THEN 'No Spending'
        WHEN (SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) / c.budget_monthly) * 100 >= 100 THEN 'CRITICAL - BUDGET EXCEEDED'
        WHEN (SUM(CASE WHEN t.amount < 0 THEN ABS(t.amount) ELSE 0 END) / c.budget_monthly) * 100 >= c.alert_threshold THEN 'HIGH - SLOW DOWN'
        ELSE 'ON TRACK'
    END as alert_status
FROM categories c
LEFT JOIN transactions t ON c.category_id = t.category_id 
    AND DATE_TRUNC('month', t.transaction_date) = DATE_TRUNC('month', CURRENT_DATE)
GROUP BY c.category_name, c.budget_monthly, c.alert_threshold
ORDER BY c.category_name;
```

## Expected n8n Workflow Triggers

Each test case should trigger the following in n8n:

- **TC-G05-BA-001/002**: "Check Budget Threshold" node → "Send Alert" node → HIGH severity
- **TC-G05-BA-003**: "Check Budget Threshold" node → "Send Critical Alert" node → CRITICAL severity  
- **TC-G05-BA-004**: No trigger (or "Send On Track Update" if configured)
- **TC-G05-BA-005**: No trigger (budget = 0)
- **TC-G05-BA-006**: "Check Projected Overspend" node → "Send Alert" node → MEDIUM severity