---
title: "Autonomous Finance: 2026 Data Sync"
type: "n8n_workflow"
status: "active"
owner: "Michal"
goal_id: "goal-g05"
updated: "2026-04-16"
---

# Autonomous Finance: 2026 Data Sync

## Purpose

Synchronizes financial transaction data from Google Sheets (Zestawienie_finansowe-2026) to PostgreSQL (autonomous_finance database) every 12 hours. Maintains complete transaction history with automatic merchant creation and data validation.

## Scope

### In Scope
- Scheduled synchronization (every 12 hours)
- 2026-only transaction filtering
- Automatic merchant lookup/creation
- Data integrity validation
- Error alerting via email

### Out of Scope
- Budget synchronization (see "Autonomous Finance - Budget Sync")
- Transaction categorization (handled by G05_llm_categorizer.py)
- Forecasting and analysis (see other G05 workflows)

## Inputs/Outputs

### Trigger
- **Type:** Schedule Trigger
- **Frequency:** Every 12 hours
- **Note:** Header says "Every 6 Hours" but code configures 12

### Data Sources
| Source | Type | Spreadsheet |
|--------|------|-------------|
| Transactions | Google Sheet | Zestawienie_finansowe-2026_FG_AI |

### Sheet Columns
| Column | Type | Purpose |
|--------|------|---------|
| Transaction_ID | String | Unique identifier |
| Month | Integer | Month number (1-12) |
| Day | Integer | Day number (1-31) |
| Type | String | Income/Expense |
| Amount | Number | Transaction amount |
| Currency | String | Default PLN |
| Merchant/Source | String | Source name |
| Description | String | Optional notes |
| Account_Name | String | Bank account |
| Category_Name | String | Budget category |
| Subcategory_Name | String | Budget subcategory |

### Database Operations
- `upsert_transaction_from_sheet()` - Insert/update with merchant handling

## Dependencies

### Infrastructure
- Google Sheets API
- PostgreSQL `autonomous_finance` database
- Gmail (for error alerts)

### Credentials
- Google Sheets OAuth2 (`Google Sheets account`)
- PostgreSQL (`autonomous_finance docker`)
- Gmail (`Gmail account`)

## Procedure

### Execution Flow
1. **Schedule Trigger:** Every 12 hours
2. **Read Transactions:** Load all rows from Google Sheet
3. **Filter 2026:** Code node filters for 2026-only data
4. **Transform:** Parse dates, amounts, categories
5. **Upsert DB:** Insert/update transactions via stored procedure
6. **Auto-Create Merchants:** Procedure creates missing merchants
7. **Generate Report:** Statistics on sync results
8. **Error Check:** If errors, send alert email
9. **Validation Queries:** (parallel) Health checks on DB

### Validation Checks
The workflow runs several validation queries in parallel:
- **Daily Health Check:** Verifies last sync time
- **Data Integrity:** Checks for missing foreign keys
- **Updated Data Validation:** Confirms data imported correctly
- **Category Distribution:** Verifies category mappings
- **Weekly Validation:** Monthly totals by category

### Data Transformation
```javascript
// Transaction date construction
const transactionDate = `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

// Amount parsing
const parsed = parseFloat(String(amount).replace(',', '.'));
```

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Google Sheets unreachable | API timeout | Retry next cycle |
| Invalid date format | Transform error | Skip row, log error |
| Missing merchant | DB FK error | Auto-create merchant |
| Duplicate transaction | UPSERT | Update existing |
| Partial sync | Some rows fail | Send alert with details |

## Security Notes

- Google Sheets credentials stored securely in n8n
- Database credentials use n8n credential store
- Transaction data contains financial information
- Email alerts contain sync statistics only

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (during G05 finance audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [G05 Financial Command Center](../10_Goals/G05_Autonomous-Financial-Command-Center/Roadmap.md)
- [Autonomous Finance - Budget Sync](./Autonomous%20Finance%20-%20Budget%20Sync.md)
- [G05 Bank Data Ingestion SOP](../30_Sops/SOP-Bank-Data-Ingestion.md)
- [Autonomous Finance Database Schema](../20_Systems/S03_Data-Layer/README.md)
