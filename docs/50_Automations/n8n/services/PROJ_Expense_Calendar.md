---
title: "n8n Service: PROJ_Expense_Calendar"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Expense_Calendar"
goal_id: "goal-g05"
systems: ["S03", "S04", "S05"]
owner: "Michal"
updated: "2026-03-02"
review_cadence: "Monthly"
---

# PROJ_Expense_Calendar

## Purpose
An AI-powered financial assistant that manages an Expense Calendar spreadsheet. It allows the user to query, add, and update planned expenses using natural language in multiple languages (Polish, English, German, etc.). It provides intelligent forecasting and grouping of expenses by month or category.

## Scope
### In Scope
- Natural language querying of planned expenses for 2026.
- Adding new expense items to the Google Sheet.
- Updating existing expenses (amount, date, description) via Transaction_ID.
- Multi-language support (Gemini-driven).
- Monthly and Annual total calculations.

### Out of Scope
- Real-time bank transaction categorization (handled by G05_llm_categorizer).
- Automated payment execution.
- Multi-year forecasting beyond the current 2026 dataset.

## Triggers
- **Sub-workflow Trigger:** Executed from a main "Router" or "Inbox" workflow (e.g., G11 Inbox Router).
- **Manual Execution:** Via the n8n editor for testing.

## Inputs
- **Natural Language Query:** User message via `Execute Workflow Trigger`.
- **Context Metadata:** `chat_id`, `user_id`, `source_type`.
- **Google Sheet Data:** Full content of the `Expense Calendar` tab from the `Zestawienie_finansowe-2026_FG_AI` spreadsheet.

## Processing Logic
1.  **Normalize Entry:** Standardizes the incoming query and metadata.
2.  **Load Expense Calendar:** Fetches all rows from the Google Sheet.
3.  **Prepare AI Context:** Parses rows into structured JSON, groups by month, and calculates the next available `Transaction_ID`.
4.  **Forecasting AI Agent (LangChain):** Uses Gemini 1.5 to process intent, access tools (`get_expense_data`, `add_data`, `update_expense_data`), and format responses based on strict scope rules.
5.  **Format/Return:** Wraps output for the Router.

## Outputs
- **Response Object:** `response_text`, `chat_id`, and success status.
- **Spreadsheet Update:** Modified rows in the `Expense Calendar` tab.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Google Sheets persistence.
- [S05 Intelligent Routing Hub](../../20_Systems/S05_Intelligent-Routing-Hub/README.md) - Router integration.

### External Services
- **Google Gemini API:** AI reasoning.
- **Google Sheets API:** Spreadsheet operations.

### Credentials
- **Google Sheets OAuth2:** `Google Sheets account` (ID: `LXYoAr7I3Ccidlg5`).
- **Google Gemini API Key:** `Google Gemini(PaLM) Api account` (ID: `mpGimzwvKl1QVa8g`).

## Procedure
### Monthly Maintenance
1. Review the "Expense Calendar" sheet for any duplicate `Transaction_IDs`.
2. Verify that the "Total" calculated by the AI matches a manual sum of the "Amount (PLN)" column.
3. Archive rows from the previous month to a "History" tab if performance degrades.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Sheet Access Denied | Google Sheets node fails | Return error text to user | n8n Execution Log |
| AI Hallucination | User review | Memory buffer allows for correction | None |
| Invalid ID for update | `update_expense_data` tool fails | AI reports inability to find transaction | None |
| Gemini API Timeout | LangChain node timeout | Return "Could not process request" | n8n Execution Log |

## Security Notes
- **Access Control:** Access is limited to the defined Telegram `chat_id` via the Router.
- **Data Privacy:** Financial data is processed by Google Gemini. No PII (Personally Identifiable Information) other than merchant names should be stored in the sheet.

## Monitoring
- **Success Metric:** High accuracy in adding/retrieving data.
- **Audit Trail:** Spreadsheet version history tracks all changes.

## Manual Fallback
Edit the Google Sheet manually:
- **Sheet:** `Zestawienie_finansowe-2026_FG_AI`
- **Tab:** `Expense Calendar`

## Related Documentation
- [Goal: G05 Autonomous Financial Command Center](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [System: S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
