---
title: "SVC: Autonomous Pantry - Data Sync"
type: "automation_spec"
status: "active"
automation_id: "SVC_Autonomous-Pantry-Data-Sync"
goal_id: "goal-g03"
systems: ["S03", "S08"]
owner: "Michal"
updated: "2026-02-25"
---

# SVC: Autonomous Pantry - Data Sync

## Purpose
Automates the synchronization of household inventory and dictionary data from the `Magazynek_domowy` Google Sheet to the `autonomous_pantry` PostgreSQL database. This service ensures that the Digital Twin has the most current view of household resources, enabling predictive restocking and expiration alerts.

## Triggers
- **Scheduled:** Runs every 6 hours via n8n Schedule Trigger.
- **Manual:** Can be executed manually within the n8n editor for immediate synchronization.

## Inputs
- **Google Sheet:** `Magazynek_domowy` (ID: `{{SPREADSHEET_ID}}`)
  - **Worksheet `Spizarka`:** Current inventory levels, units, and expiry dates.
  - **Worksheet `Slownik`:** Product categories, AI synonyms, and critical stock thresholds.
- **Credentials:** Google Sheets OAuth2 (service account or user-based).

## Processing Logic
1. **Fetch Data:** Simultaneously reads both `Spizarka` and `Slownik` worksheets.
2. **Transform Inventory:**
   - Filters out rows with empty categories.
   - **Numeric Parsing:** Converts Polish-style commas to dots and strips non-numeric characters for `Aktualna_Ilość` and `Próg_Krytyczny`.
   - **Date Normalization:** Robustly handles `Najblizsa_Waznosc` and `Ostatnia_Aktualizacja`. Specifically converts empty strings or whitespace-only cells to true `NULL` values to prevent stale dates in the database.
   - **SQL Escaping:** Escapes single quotes in categories and notes to prevent SQL injection/syntax errors.
3. **Transform Dictionary:**
   - Maps `Kategoria`, `Synonimy_AI`, and `Domyślna_Jednostka`.
   - Normalizes `Próg_Krytyczny`.
4. **Database Upsert:**
   - **Inventory:** Executes `SELECT upsert_pantry_item(...)` for each row.
   - **Dictionary:** Executes `SELECT upsert_pantry_dictionary(...)` for each row.
   - *Note: These PostgreSQL functions handle the `INSERT ... ON CONFLICT (category) DO UPDATE` logic.*
5. **Report Collection:** Merges results from both branches to generate a sync report.
6. **Error Check & Alerting:** If the `overall_status` is not `SUCCESS`, an error report is formatted and sent via Gmail.

## Outputs
- **PostgreSQL (`autonomous_pantry`):**
  - Table `pantry_inventory`: Updated quantities, status, and expiry dates.
  - Table `pantry_dictionary`: Updated thresholds and AI synonyms.
- **Alerts:** Email notifications to `{{EMAIL}}` on failure.
- **Logs:** n8n execution history.

## Dependencies
### Systems
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md): PostgreSQL instance hosting the `autonomous_pantry` database.
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md): n8n instance for workflow execution.

### External Services
- **Google Sheets API:** Source of truth for inventory data.
- **Gmail API:** For failure notifications.

### Credentials
- **Postgres:** `Postgres account autonomous_pantry docker`
- **Google Sheets:** `Google Sheets account`
- **Gmail:** `Gmail account`

## Failure Modes
| Scenario | Detection | Response | Alert |
|---|---|---|---|
| Google Auth Failure | n8n Node Error (401/403) | Check Google Cloud Console & re-auth | Email (if Gmail node lives) |
| Postgres Connection Down | n8n Node Error (Connection Refused) | Check Docker container status | Email |
| Empty Date Not Clearing | `Mleko` shows old expiry | Ensure `Transform` node converts `""` to `null` | Manual check |
| SQL Syntax Error | Node Error (Check logs) | Check for unescaped special characters | Email |

## Manual Fallback
If the automation fails, data can be manually upserted via SQL:
```sql
SELECT upsert_pantry_item(
    'Mleko', 
    4.0, 
    'szt', 
    NULL, 
    CURRENT_DATE, 
    'OK', 
    2.0, 
    'Manual sync'
);
```

## Related Documentation
- [Goal: G03 Autonomous Household Operations](../../../10_Goals/G03_Autonomous-Household-Operations/README.md)
- [System: S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- [SOP: Pantry Inventory Update](../../30_Sops/Pantry-Inventory-Update-SOP.md)

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (verify data integrity and sync reliability)
