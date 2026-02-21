---
title: "G05: Test Budget Alerting System"
type: "runbook"
status: "complete"
goal_id: "goal-g05"
owner: "{{OWNER_NAME}}"
updated: "2026-02-08"
---

# Runbook: Test Budget Alerting System

## 1. Purpose
This runbook guides the testing of the `WF_Finance_Budget_Alerts` n8n workflow and its associated PostgreSQL `get_current_budget_alerts()` function to ensure alerts are triggered and received correctly under various threshold breach conditions.

## 2. Scope
This runbook applies to the `autonomous-living` financial automation layer, specifically the PostgreSQL database, n8n instance, and the configured alert notification channels.

## 3. Prerequisites
-   Access to the PostgreSQL database (via `psql` or a GUI tool).
-   Access to the n8n instance where `WF_Finance_Budget_Alerts` is deployed.
-   Access to the configured alert notification channel (e.g., Telegram, Email).
-   The `schema.sql` (including budget tables and functions) has been deployed.
-   The `WF_Finance_Budget_Alerts.json` workflow is imported and active in n8n.
-   The PostgreSQL data source in n8n is correctly configured with credentials.
-   The notification node in n8n (e.g., Telegram) is correctly configured with credentials.

## 4. Test Cases

| Test Case ID | Description                                                              | Expected Trigger Condition                                                                            | Expected Outcome                                                                                                                                                                                           |
| :----------- | :----------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TC-G05-BA-001| Spending exceeds 80% threshold for a category.                           | `SUM(amount)` for a category > `budget_monthly * 0.8`                                                 | An alert is received for the specific category, indicating spending is over 80% and suggesting to "SLOW DOWN". Severity: HIGH.                                                              |
| TC-G05-BA-002| Spending exactly meets 80% threshold for a category.                     | `SUM(amount)` for a category = `budget_monthly * 0.8`                                                 | An alert is received for the specific category, indicating spending is at 80%. Severity: HIGH.                                                                                             |
| TC-G05-BA-003| Spending exceeds 100% threshold for a category.                          | `SUM(amount)` for a category > `budget_monthly`                                                       | A CRITICAL alert is received for the specific category, indicating the budget is "exceeded".                                                                                               |
| TC-G05-BA-004| Spending is below 80% threshold for all categories.                      | `SUM(amount)` for all categories < `budget_monthly * 0.8`                                             | No alert is received, or a "ON TRACK" message is received for the category (if the workflow is configured to send passive updates).                                                          |
| TC-G05-BA-005| Category with `budget_monthly = 0` (no budget) has spending.             | No `budget_monthly` defined or set to 0.                                                              | No alert related to budget threshold is received for this category.                                                                                                                        |
| TC-G05-BA-006| Projected month-end spending exceeds budget, even if current is below 80%.| `projected_total` > `budget_monthly` (as calculated by `get_current_budget_alerts` based on daily burn)| An alert is received for the specific category, indicating "PROJECTED OVERSPEND". Severity: MEDIUM.                                                                                    |

## 5. Test Steps

### Step 5.1: Prepare Test Data

1.  **Clear existing test data (Optional but recommended for clean tests):**
    ```sql
    TRUNCATE transactions RESTART IDENTITY CASCADE;
    TRUNCATE accounts RESTART IDENTITY CASCADE;
    TRUNCATE categories RESTART IDENTITY CASCADE;
    -- Re-insert base accounts and categories if truncated
    -- (refer to schema.sql or previous test data scripts)
    ```
2.  **Insert specific test data for each test case.** For each `TC-G05-BA-XXX`, insert `accounts`, `categories` (with `budget_monthly` and `alert_threshold`), and `transactions` that will explicitly trigger the "Expected Trigger Condition" for that test case.

    **Complete test data scripts are available in** `Budget-Alert-Test-Data.md` **with ready-to-run SQL for each test case.**

    *Example for TC-G05-BA-001 (Spending exceeds 80% threshold):*
    ```sql
    -- From Budget-Alert-Test-Data.md
    -- Total spent: $250.00 on $300 budget = 83.33% (triggers 80% alert)
    ```
    *(All test scripts include verification queries and use dates within the current month for the n8n workflow's `DATE_TRUNC` logic.)*

### Step 5.2: Manually Run n8n Workflow

1.  In your n8n instance, locate the `WF_Finance_Budget_Alerts` workflow.
2.  Click the "Execute Workflow" button (usually a "Play" icon).
3.  Observe the execution results in n8n for any errors or unexpected outputs from the nodes.

### Step 5.3: Verify Alert Reception

1.  Check your configured notification channel (e.g., Telegram chat, email inbox).
2.  Confirm that an alert message was received.
3.  Verify that the content of the alert message matches the "Expected Outcome" for the test case you are running (e.g., category name, amount spent, and the severity/message text).

## 6. Troubleshooting
-   **No Alert Received:**
    *   Check n8n workflow execution history for errors in the PostgreSQL query or notification node.
    *   Verify the PostgreSQL query logic in the "Query Monthly Spending" node.
    *   Ensure the notification node's credentials are correct and the service is operational.
-   **Incorrect Alert Content:**
    *   Review the expression used in the notification node's message to ensure it correctly references the data from previous nodes.
    *   Double-check the test data to ensure it accurately represents the scenario you intend to test.
-   **Wrong Trigger Condition:**
    *   Inspect the "Check Budget Threshold" node's configuration.
    *   Verify the `get_current_budget_alerts()` function in PostgreSQL if the n8n logic relies heavily on its output for triggering.
