---
title: "WF011: PROJ_Training-Intelligence-System"
type: "automation_spec"
status: "active"
automation_id: "WF011__proj-training-intelligence-system"
goal_id: "goal-g01"
systems: ["S06"]
owner: "Micha\u0142"
updated: "2026-02-13"
---

# WF011: PROJ_Training-Intelligence-System

## Purpose
Acts as a personal trainer and data analyst, specializing in High Intensity Training (HIT). It answers questions about workout data stored in a PostgreSQL database.

## Triggers
- **Workflow Call**: Triggered by another workflow (e.g., `WF002: SVC_Command-Handler`).
- **Manual**: Can be triggered manually for testing purposes.

## Inputs
- A JSON object from the router containing a `query` string and other metadata.

## Processing Logic
1.  **Normalize Input**: Cleans the user query, removes the `/training` command, and detects the language (Polish or English).
2.  **Database Query**: Fetches workouts, sets, and measurements from a PostgreSQL database for the last 60 days.
3.  **HIT Intelligence Engine**: A code node processes the data, calculating progression insights, enriching workout data, analyzing body composition changes, and evaluating recovery status based on HIT principles.
4.  **Prepare AI Context**: Merges the user's query with the analyzed training data to create a comprehensive context for the AI.
5.  **AI Agent**: A Gemini-based AI Agent answers the user's query using the provided context.
6.  **Format Response**: The AI's response is formatted into a standard JSON object.
7.  **Return to Router**: The final response is sent back to the calling workflow.

## Outputs
- A JSON object with the `response_text` and other metadata.

## Dependencies
### Systems
- [S06 Health-Performance](../../20_Systems/S06_Health-Performance/README.md)

### External Services
- PostgreSQL
- Google Gemini API
- Gmail API

### Credentials
- Postgres account autonomous_training docker (ID: `haLW6cBWakuIUaNj`)
- Google Gemini(PaLM) Api account 2 (ID: `x9Jp7ab2PivcIEj9`)
- Gmail account (ID: `ZKOV4vsgAhk74S3u`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No training data | The "IF: Has Training Data?" node finds no data. | A bilingual error message is returned to the user. | An email alert is sent via Gmail. |

## Monitoring
- **Success Metric**: A successful execution returns a valid response object.
- **Alerts**: An email alert is sent if no data is found in the database.

## Manual Fallback
If the automation fails, data can be checked by manually querying the PostgreSQL database.

## Related Documentation
- [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
