---
title: "G05_llm_categorizer.py: AI Transaction Categorization"
type: "automation_spec"
status: "active"
automation_id: "g05-llm-categorizer"
goal_id: "goal-g05"
systems: ["S03", "S04"]
owner: "Michal"
updated: "2026-02-27"
---

# G05_llm_categorizer.py

## Purpose
Automates the classification of "problematic" financial transactions (those marked as 'Other' or with low confidence) using the Google Gemini 1.5 Flash model. This ensures a highly accurate and clean data layer for financial reporting and budget optimization.

## Triggers
- **On-Demand:** Can be executed manually to clean up recent transaction history.
- **Scheduled:** Intended to be run weekly as part of the `autonomous_weekly_manager.py` lifecycle.

## Inputs
- **PostgreSQL (`autonomous_finance`):** 
    - Fetches the last 90 days of transactions categorized in 'Other' buckets (IDs 24, 37).
    - Retrieves the list of active categories to provide context to the LLM.
- **Environment Variables:** `GEMINI_API_KEY` for AI processing.

## Processing Logic
1.  **Data Extraction:** Queries the database for up to 20 uncategorized transactions and all active budget categories.
2.  **AI Prompting:** Construct a detailed prompt for Gemini 1.5 Flash containing the transaction list and category definitions.
3.  **JSON Response Parsing:** Requests a structured JSON response from Gemini mapping `transaction_id` to `category_id`.
4.  **Database Update:**
    - Updates the `category_id` for each successfully mapped transaction.
    - **Merchant Rule Persistence:** Upserts the mapping into the `merchants` table to ensure future transactions from the same source are automatically categorized without AI intervention.

## Outputs
- **Database Updates:** Modified `transactions` and `merchants` tables in `autonomous_finance`.
- **Console Logs:** Detailed trace of AI reasoning and update status.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL persistence.
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Provides state for context.

### External Services
- **Google Gemini API (1.5 Flash):** AI reasoning engine.
- **psycopg2:** PostgreSQL adapter.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Key Missing | Script Startup | Exit with error message | Console |
| Gemini API Timeout | `requests.raise_for_status()` | Exponential backoff (if handled by caller) | Log: "AI Error" |
| DB Connection Fail | `psycopg2.connect()` | Exit with connection error | Console |
| Invalid AI JSON | `json.loads()` failure | Skip current batch and log raw response | Console |

## Security Notes
- **API Security:** `GEMINI_API_KEY` is loaded from a restricted `.env` file.
- **Data Privacy:** Only transaction descriptions and amounts are sent to the AI; no personal identifiers are shared.

## Manual Fallback
If the AI categorization fails, transactions must be manually updated via the Google Sheets `Finance` tab, which will then be synced to Postgres via `pantry_sync.py` or equivalent.

## Related Documentation
- [Goal: G05 Autonomous Financial Command Center](../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [System: S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
