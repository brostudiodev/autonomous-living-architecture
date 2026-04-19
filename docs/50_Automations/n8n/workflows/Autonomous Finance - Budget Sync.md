---
title: "Autonomous Finance: Budget Sync"
type: "n8n_workflow"
status: "active"
owner: "Michal"
goal_id: "goal-g05"
updated: "2026-04-16"
---

# Autonomous Finance: Budget Sync

## Purpose

Synchronizes budget configuration from Google Sheets (Zestawienie_finansowe-2026) to PostgreSQL (autonomous_finance database) every 12 hours. Maintains budget categories, thresholds, and priorities for financial monitoring and alerts.

## Scope

### In Scope
- Scheduled synchronization (every 12 hours)
- Active budget filtering
- Budget threshold configuration
- Priority and type tracking
- Error alerting via email

### Out of Scope
- Transaction synchronization (see "Autonomous Finance - 2026 Data Sync")
- Spending analysis (see G05 analysis scripts)
- Alert generation (see G05 alert workflows)

## Inputs/Outputs

### Trigger
- **Type:** Schedule Trigger
- **Frequency:** Every 12 hours

### Data Sources
| Source | Type | Spreadsheet |
|--------|------|-------------|
| Budget | Google Sheet | Zestawienie_finansowe-2026_FG_AI |

### Sheet Columns
| Column | Type | Purpose |
|--------|------|---------|
| Transaction_ID | String | Budget identifier |
| Active | Boolean | Include in sync |
| Year | Integer | Budget year |
| Month | Integer | Budget month |
| Type | String | Income/Expense |
| Category | String | Budget category |
| Sub-Category | String | Budget subcategory |
| Budget_Type | String | fixed/variable |
| Priority | String | high/medium/low |
| Budget_Amount | Number | Allocated amount |
| Alert_Threshold | Number | Alert percentage |

### Database Operations
- `upsert_budget_from_sheet()` - Insert/update budget with validation

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
2. **Read Budget Sheet:** Load all budget rows
3. **Transform & Validate:**
   - Parse active status (TRUE/FALSE/1/0/YES/NO)
   - Parse amounts (European format with comma)
   - Filter active budgets only
   - Validate required fields
4. **Upsert DB:** Insert/update budgets via stored procedure
5. **Generate Report:** Statistics on sync results
6. **Error Check:** If errors, send alert email

### Data Transformation
```javascript
// Boolean parsing
parseBoolean(value) → true/false

// Amount parsing (European format)
parseAmount("1 234,56") → 1234.56

// Priority normalization
"wysoki" → "high"
"średni" → "medium"  
"niski" → "low"
```

### Validation Rules
| Field | Rule |
|-------|------|
| Transaction_ID | Required, non-empty |
| Budget_Amount | Required, > 0 |
| Year | Required, valid year |
| Month | Required, 1-12 |
| Type | Required, Income/Expense |
| Category | Required |

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Inactive budget | Active = false | Skip silently |
| Zero amount | Budget_Amount = 0 | Skip silently |
| Missing required field | Validation error | Skip row, continue |
| DB connection fail | PostgreSQL error | Send alert email |
| Duplicate budget | UPSERT | Update existing |

## Security Notes

- Google Sheets credentials stored securely in n8n
- Database credentials use n8n credential store
- No sensitive data in email alerts

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (during G05 finance audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [G05 Financial Command Center](../10_Goals/G05_Autonomous-Financial-Command-Center/Roadmap.md)
- [Autonomous Finance - 2026 Data Sync](./Autonomous%20Finance%20-%202026%20Data%20Sync.md)
- [Budget Alert SOP](./WF102__finance-budget-alerts.md)
- [Monthly Budget Review SOP](../30_Sops/Monthly-Budget-Review.md)
