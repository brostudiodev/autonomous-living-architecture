---
title: "G05: Validate Savings Rate Calculation"
type: "runbook"
status: "draft"
goal_id: "goal-g05"
owner: "Michał"
updated: "2026-02-08"
---

# Runbook: Validate Savings Rate Calculation

## 1. Purpose
This runbook guides the validation of the PostgreSQL `v_savings_rate` view and associated logic to ensure it accurately reflects a real savings rate (e.g., 5-35%), correcting the historical "98% fake savings rate" issue.

## 2. Scope
This runbook applies to the `autonomous-living` financial data layer, specifically the PostgreSQL database and the Grafana dashboard for G05.

## 3. Prerequisites
-   Access to the PostgreSQL database (via `psql` or a GUI tool).
-   Access to the Grafana instance with the "G05 - Financial Command Center" dashboard configured.
-   The `schema.sql` (including `v_savings_rate`) has been deployed to the database.
-   Initial `accounts`, `categories`, and `transactions` tables are created.

## 4. Validation Steps

### Step 4.1: Insert Test Data

Insert a controlled set of test data into the `accounts`, `categories`, and `transactions` tables to simulate a typical month's activity. Ensure this data includes:
-   Income transactions (e.g., salary).
-   Expense transactions (categorized).
-   Internal transfers between your own accounts (e.g., checking to savings) that should *not* count towards expenses or savings rate calculation.
-   An "Initial Balance" or "INIT" transaction if applicable, to ensure it's excluded from income/expense calculations.

**Example SQL for Test Data (adjust amounts/dates as needed):**

```sql
-- Accounts
INSERT INTO accounts (account_name, account_type, balance) VALUES
('Checking Account', 'Checking', 1000.00),
('Savings Account', 'Savings', 5000.00);

-- Categories
INSERT INTO categories (category_name, category_type, budget_monthly) VALUES
('Salary', 'Income', NULL),
('Groceries', 'Expense', 300.00),
('Rent', 'Expense', 1000.00),
('Transfer to Savings', 'Transfer', NULL),
('Initial Balance', 'Income', NULL); -- Example of a category to be excluded

-- Transactions
-- Initial balance transaction (should be ignored for savings rate)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Checking Account'), '2026-01-01', 'Initial Deposit', 6000.00, 'Credit', (SELECT category_id FROM categories WHERE category_name = 'Initial Balance'));

-- Income
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Checking Account'), '2026-01-05', 'Monthly Salary', 4000.00, 'Credit', (SELECT category_id FROM categories WHERE category_name = 'Salary'));

-- Expenses
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Checking Account'), '2026-01-07', 'Supermarket run', -150.00, 'Debit', (SELECT category_id FROM categories WHERE category_name = 'Groceries')),
((SELECT account_id FROM accounts WHERE account_name = 'Checking Account'), '2026-01-10', 'Monthly Rent', -1000.00, 'Debit', (SELECT category_id FROM categories WHERE category_name = 'Rent'));

-- Transfer (should be ignored for savings rate, but reflects actual saving)
INSERT INTO transactions (account_id, transaction_date, description, amount, transaction_type, category_id) VALUES
((SELECT account_id FROM accounts WHERE account_name = 'Checking Account'), '2026-01-15', 'Transfer to Savings', -500.00, 'Debit', (SELECT category_id FROM categories WHERE category_name = 'Transfer to Savings')),
((SELECT account_id FROM accounts WHERE account_name = 'Savings Account'), '2026-01-15', 'Transfer from Checking', 500.00, 'Credit', (SELECT category_id FROM categories WHERE category_name = 'Transfer to Savings'));
```

### Step 4.2: Query `v_savings_rate` Directly

Execute a query against the `v_savings_rate` view in PostgreSQL:

```sql
SELECT * FROM v_savings_rate;
```

**Expected Result:** The `savings_rate` column should show a value reflecting `(Actual Savings / Operational Income) * 100`. Based on the example data:
-   Operational Income: 4000.00 (Salary)
-   Expenses (Groceries + Rent): 150.00 + 1000.00 = 1150.00
-   Actual Savings (Transfer to Savings): 500.00
-   Calculated Savings Rate: `(500.00 / 4000.00) * 100 = 12.5%`. This value should be within the target 5-35% range.

### Step 4.3: Verify in Grafana Dashboard

1.  Refresh the "G05 - Financial Command Center" Grafana dashboard.
2.  Locate the panel displaying the savings rate.
3.  Confirm that the displayed savings rate matches the expected value calculated in Step 4.2 and falls within the 5-35% range.

## 5. Troubleshooting
-   If the savings rate is incorrect, review the `v_savings_rate` view definition in `autonomous-living/infrastructure/database/finance/schema.sql`. Pay close attention to how income, expenses, and internal transfers are identified and excluded.
-   Ensure `is_pending` is set to `FALSE` for relevant transactions.
-   Check the categorization of transactions and account types in the test data.
