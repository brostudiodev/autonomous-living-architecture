---
title: "PROJ: Finance Intelligence System (G05)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Finance-Intelligence-System"
goal_id: "goal-g05"
systems: ["S03", "S08"]
owner: "Michal"
updated: "2026-04-13"
---

# PROJ_Finance-Intelligence-System

## Purpose
The **Finance Intelligence System** is an AI-powered agent designed to manage and retrieve financial information from the `autonomous_finance` PostgreSQL database. It provides expense summaries, budget utilization tracking, and strategic spending insights using natural language (Polish or English).

## Triggers
- **Sub-workflow:** Executed by another workflow (typically `ROUTER_Intelligent_Hub`).
- **Manual Trigger:** Used for system testing and data validation.

## Inputs
- **Query:** Natural language financial query (e.g., "Ile wydałem na jedzenie w tym miesiącu?", "Show my upcoming bills").
- **Days Lookback:** Configurable window (default 90 days).
- **Metadata:** Chat ID, User ID, and Source Type.

## Processing Logic
1. **Normalization:** Resolve session IDs, extraction method, and determine the `days_lookback` based on keywords (e.g., "year", "quarter").
2. **PostgreSQL Ingestion:**
   - `Get Transactions`: Fetches recent transactions with category and account details.
   - `Get Budget Performance`: Fetches current month utilization from `v_budget_performance`.
   - `Get Monthly PnL`: Fetches last 12 months of income/expense data.
   - `Get Upcoming Expenses`: Fetches next 30 days of projected bills.
3. **Merging:** All four financial data streams are converged into a unified context.
4. **Context Construction:** `Build AI Context` (JS Code) wraps the data in `<finance_context>` tags and calculates high-level summaries (total spent, top category).
5. **Intelligence Layer:** Google Gemini (v1.5 Pro) processes the query using the provided context and historical memory.
6. **Output:** Returns a formatted financial answer via the `Response Dispatcher`.

## AI Agent Configuration
- **Role:** Personal Financial Advisor.
- **Language:** Polish or English (auto-detected).
- **Model:** Google Gemini (Temp 0.1).
- **Memory:** Windowed buffer for session persistence.

## Dependencies
### Systems
- [Autonomous Finance (G05)](../../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [Data Layer (S03)](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL storage (`autonomous_finance`).

### External Services
- **PostgreSQL Database:** Primary source of truth for transactions and budgets.
- **Google Gemini API:** Core reasoning engine.

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| DB Connection Loss | Node error in PostgreSQL nodes | Returns "cannot retrieve financial data" message. |
| Missing Category Data | SQL JOIN returns nulls | Agent informs user about uncategorized transactions. |
| API Rate Limit | Gemini API quota error | Returns a concise, non-AI summary of the raw data. |

## Security Notes
- **Authority:** This agent has read-only access to the finance database.
- **Credential:** `zrLunD1UbOGzqNzS` (n8n managed).
- **Data Privacy:** Raw transaction IDs are sanitized before being processed by the LLM.

## Manual Fallback
```bash
# Check current month budget performance
psql -U root -d autonomous_finance -c "SELECT * FROM v_budget_performance WHERE budget_month = EXTRACT(MONTH FROM CURRENT_DATE);"
```

---

*Documentation updated to PROJ_Finance-Intelligence-System.json v2.0 (2026-04-13)*