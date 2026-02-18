---
title: "WF010: PROJ_Inventory-Management"
type: "automation_spec"
status: "active"
automation_id: "WF010__proj-inventory-management"
goal_id: "goal-g03"
systems: ["S03", "S07"]
owner: "Micha\u0142"
updated: "2026-02-13"
---

# WF010: PROJ_Inventory-Management

## Purpose
An AI-powered pantry assistant that receives queries, loads inventory from Google Sheets, uses an AI Agent to interpret the query, and returns a formatted response.

## Triggers
- **Primary**: Execute Workflow call from `WF002: SVC_Command-Handler`.
- **Type**: `executeWorkflowTrigger` (no external endpoints)

## Inputs
- A JSON object with a `query` string and router metadata.
- The "Normalize Entry" node handles various input structures to ensure consistent data for processing.

## Processing Logic
1.  **Normalize Input**: The "Normalize Entry" node extracts the query, chat ID, and other user information from the input. It sets a default query if none is provided.
2.  **Load Inventory**: Reads the current inventory data from a Google Sheet (`10knY7Tnh5iNLooAxQ8OjI0sRJ-2l0t3rH5ABdVuvFAM`).
3.  **Prepare AI Context**: Transforms the Google Sheet data into a text-based context for the AI, including categories, quantities, and low-stock items.
4.  **AI Agent Processing**: A Gemini-based AI Agent processes the user's query against the inventory context. The agent has access to the following tools:
    *   `get_inventory`: Fetches the current inventory.
    *   `update_inventory`: Updates the quantity of an existing product.
    *   `add_product`: Adds a new product to the inventory.
    *   `get_dictionary`: Retrieves a dictionary of product synonyms.
    *   `add_dictionary`: Adds new categories to the dictionary.
    *   `calculator`: Performs calculations.
5.  **Format Response**: The AI's response is formatted into a standardized JSON object.
6.  **Return to Router**: The final JSON object is returned to the calling workflow (e.g., `WF002: SVC_Command-Handler`).

## Outputs
A JSON object containing the `response_text`, `chat_id`, `source_type`, and other metadata for the response dispatcher.

## Dependencies
### Systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md)
- [S07 Smart-Home](../../20_SYSTEMS/S07_Smart-Home/README.md)

### External Services
- Google Sheets API
- Google Gemini API

### Credentials
- Google Sheets OAuth2 API Credential (ID: `LXYoAr7I3Ccidlg5`)
- Google Gemini (PaLM) API Credential (ID: `mpGimzwvKl1QVa8g`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| AI Processing Fails | The `Format Response` node receives no `output` or `text` from the AI. | A default error message "Nie udało się przetworzyć zapytania." is returned. | The workflow does not have explicit alerting. Failures are logged in n8n's execution history. |
| Invalid Input | The "Normalize Entry" node handles missing query by setting a default. | The workflow proceeds with a default query. | None. |

## Monitoring
- **Success Metric**: A successful execution of the workflow returns a valid response object to the calling workflow.
- **Alerts**: There are no built-in alerts. Monitoring is done by reviewing n8n's execution logs.

## Manual Fallback
If the automation fails, the inventory can be managed by manually editing the Google Sheet: `https://docs.google.com/spreadsheets/d/10knY7Tnh5iNLooAxQ8OjI0sRJ-2l0t3rH5ABdVuvFAM/edit`

## Related Documentation
- [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
