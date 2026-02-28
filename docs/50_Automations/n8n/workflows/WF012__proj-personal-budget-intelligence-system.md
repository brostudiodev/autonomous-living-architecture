---
title: "WF012: PROJ_Personal-Budget-Intelligence-System"
type: "automation_spec"
status: "active"
automation_id: "WF012__proj-personal-budget-intelligence-system"
goal_id: "goal-g05"
systems: ["S05"]
owner: "Micha\u0142"
updated: "2026-02-13"
---

# WF012: PROJ_Personal-Budget-Intelligence-System

## Purpose
Provides a personal budget and financial intelligence report. It can be triggered in multiple ways and generates a report using data from Google Sheets and a Gemini LLM.

## Triggers
- **Workflow Call**: Triggered by another workflow (e.g., `WF002: SVC_Command-Handler`).
- **Schedule**: Runs daily at 6:50 AM.
- **Manual**: Can be triggered manually for on-demand reports.
- **Telegram (Disabled)**: A disabled trigger exists for the `/expenses` command.

## Inputs
The workflow does not take direct inputs via its trigger. Instead, it reads data from a Google Sheet.

## Processing Logic
1.  **Data Ingestion**: The workflow fetches transaction and budget data from a Google Sheet (`1CUhzhuPXT3EoF4m35c7SRLhhqzX3NHWG4SWosGeGPzw`).
2.  **Financial Analysis**: A "Financial Analysis Engine" node processes the data, calculating metrics like income, expenses, balance, savings rate, spending patterns, budget comparisons, and alerts.
3.  **LLM Reporting**: The analyzed data is passed to a Gemini LLM to generate a human-readable financial report with actionable insights.
4.  **Output**: The final report is sent as a Telegram message.

## Outputs
- A formatted financial report sent as a Telegram message.

## Dependencies
### Systems
- [S05 Finance-Automation](../../20_Systems/S05_Finance-Automation/README.md)

### External Services
- Google Sheets API
- Google Gemini API
- Telegram Bot API

### Credentials
- Google Sheets account (ID: `LXYoAr7I3Ccidlg5`)
- Google Gemini(PaLM) Api account 2 (ID: `x9Jp7ab2PivcIEj9`)
- Telegram (AndrzejSmartBot) (ID: `XDROmr9jSLbz36Zf`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No Data in Google Sheet | The "IF: Has Data?" node finds no data. | A "No Data Warning" is sent via Telegram. | The user is notified directly via Telegram. |

## Monitoring
- **Success Metric**: A financial report is successfully generated and sent to Telegram.
- **Alerts**: No automated alerts are configured. Monitoring is done by checking n8n's execution logs.

## Manual Fallback
If the automation fails, the financial data can be reviewed by manually opening the Google Sheet: `https://docs.google.com/spreadsheets/d/1CUhzhuPXT3EoF4m35c7SRLhhqzX3NHWG4SWosGeGPzw/edit`

## Related Documentation
- [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
