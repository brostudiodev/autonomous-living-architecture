---
title: "SVC: Google Sheets Reader"
type: "automation_spec"
status: "inactive"
automation_id: "SVC_Google-Sheets-Reader"
goal_id: "goal-g04"
systems: ["S08", "S03"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Google-Sheets-Reader

## Purpose
Generic, reusable Google Sheets reader service that can be called by other workflows to read data from any Google Sheet with filtering and options.

**Status:** Currently inactive (active=false in n8n).

## Inputs
- **Workflow Input:** JSON with parameters:
  - `sheet_id` (required): Google Sheet ID
  - `sheet_name`: Sheet name (default: "Sheet1")
  - `range`: Cell range (default: "A:Z")
  - `filters`: Object with column/value filters
  - `options`: { include_empty, limit, skip_header }

## Example Input
```json
{
  "sheet_id": "your-sheet-id",
  "sheet_name": "Sheet1",
  "range": "A:Z",
  "filters": {
    "column": "Category",
    "value": "Dairy"
  },
  "options": {
    "include_empty": false,
    "limit": 100
  }
}
```

## Processing Logic
1. **Validate Input** (Code node, lines 23-33): Validates required parameters, sets defaults.
2. **IF: Has sheet_id** (IF node, lines 35-50): Branches based on valid input.
3. **Read Google Sheet** (Google Sheets node): Reads data from specified sheet/range.
4. **Apply Filters** (Code node): Filters rows based on filter parameters.
5. **Format Output** (Code node): Formats response with success/error status.

## Outputs
```json
{
  "success": true,
  "data": [...],
  "meta": {
    "total_rows": 25,
    "filtered_rows": 10,
    "sheet_name": "Sheet1"
  }
}
```

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md) - Google Sheets storage.

### External Services
- Google Sheets API (OAuth2).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing sheet_id | Validation check | Returns success: false, error message | None |
| Sheet access error | Google Sheets node error | Returns success: false, error details | n8n Execution log |

## Security Notes
- Google Sheets credentials stored in n8n credential store.

## Manual Fallback
Read Google Sheet directly via Google Sheets UI.