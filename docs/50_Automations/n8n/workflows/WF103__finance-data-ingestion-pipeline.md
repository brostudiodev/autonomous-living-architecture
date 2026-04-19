---
title: "WF103: Finance Data Ingestion Pipeline"
type: "automation_spec"
status: "active"
automation_id: "WF103"
goal_id: "goal-g05"
systems: ["S05", "S03"]
owner: "Michal"
updated: "2026-03-26"
---

# WF103: Finance Data Ingestion Pipeline

## Purpose

Ingests financial data from Google Sheets (Expense Calendar, Transaction Log) into the PostgreSQL database for analysis and visualization.

## Triggers

- **Scheduled:** Every 12 hours
- **Manual:** Via n8n UI or trigger node

## Data Sources

| Source | Type | Data Retrieved |
|--------|------|----------------|
| Google Sheets | Expense Calendar | Upcoming expenses, recurring payments |
| Google Sheets | Transaction Log | Income, expenses, categories |

## Processing Logic

1. **Extract** - Fetch rows from Google Sheets
2. **Transform** - Parse amounts, dates, categories
3. **Load** - Insert/update PostgreSQL transactions table
4. **Categorize** - Run LLM categorization for uncategorized items

## Dependencies

- [G05 Finance System](../../../10_Goals/G05_Autonomous-Financial-Command-Center/README.md)
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- Google Sheets API

## Related Documentation

- [G05 Budget Rebalancer](../../scripts/G05_budget_rebalancer.md)
- [G05 LLM Categorizer](../../scripts/G05_llm_categorizer.md)

---
*Owner: Michal*
*Review Cadence: Monthly*
