---
title: "G05: Autonomous Finance Data & Command Center"
type: "goal"
status: "active"
goal_id: "goal-g05"
owner: "{{OWNER_NAME}}"
updated: "2026-02-15"
---

# G05: Autonomous Finance Data & Command Center

## Purpose
Build a reliable, explainable, and mostly self-driving financial data layer + observability stack using PostgreSQL + Grafana, providing real-time financial intelligence for autonomous wealth building.

## Scope
### In Scope
- PostgreSQL database schema for transactions, budgets, and upcoming expenses.
- Automated data synchronization from Google Sheets (Expense Calendar).
- Real-time budget alerting and optimization logic via SQL functions.
- Grafana dashboards for financial situational awareness.
- Savings rate calculation correcting the "98% fake savings" anomaly.

### Out of Scope
- Direct bank API integrations (using manual/spreadsheet imports for security).
- Automated trading or investment execution.
- External tax reporting.

## Intent
Build a **reliable, explainable, and mostly self-driving financial data layer + observability stack** using PostgreSQL + Grafana, eliminating the 98% "fake savings rate" caused by INIT positions and providing **real-time financial intelligence** for autonomous wealth building.

## Definition of Done (2026)
- [ ] PostgreSQL schema is stable, versioned, and documented with proper savings rate calculation
- [ ] Real Savings Rate shows 5-35% range (not 98% from accounting artifacts)
- [ ] Grafana dashboard provides complete financial situational awareness in <30 seconds
- [ ] n8n workflows maintain data synchronization with zero manual intervention
- [ ] Budget alerts trigger within 1 hour of threshold breach
- [ ] All financial logic is traceable to documented SQL functions

## Inputs
- Transaction logs (Manual entry in Google Sheets).
- Budget allocations (YAML/CSV).
- Upcoming expenses (Expense Calendar in Google Sheets).

## Outputs
- Real-time Grafana dashboards.
- Telegram budget alerts.
- Digital Twin state updates (finance entity).
- Savings rate and P&L reports.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL database.
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n workflows.
- [S05 Observability Dashboards](../../20_Systems/S05_Observability-Dashboards/README.md) - Grafana visualization.

### External
- Google Sheets (Source data).
- Telegram (Notification channel).

## Procedure
1. **Daily:** Review Telegram alerts for budget breaches.
2. **Weekly:** Sync latest transactions from spreadsheets to PostgreSQL.
3. **Monthly:** Review "Real Savings Rate" and adjust budget thresholds.
4. **Quarterly:** Audit database performance and backup integrity.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| DB Connection Fail | n8n workflow failure alert | Verify Docker container status. |
| Sync Lag | Dashboard shows stale date | Trigger manual n8n sync. |
| Threshold Error | Incorrect alert trigger | Review `get_current_budget_alerts()` SQL logic. |

## Security Notes
- Database credentials must never be committed to Git.
- Financial spreadsheets are private and accessed via restricted service accounts.
- Dashboard access is limited to local network/VPN.

## Owner & Review
- **Owner:** {{OWNER_NAME}}
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-19

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)

## Database Schemas
- **Reference Folder:** [database_schemas/](./database_schemas/)
- Financial Schema: [database_schemas/autonomous_finance_schema.sql](./database_schemas/autonomous_finance_schema.sql)
- Training Schema: [database_schemas/autonomous_training_schema.sql](./database_schemas/autonomous_training_schema.sql)
- Pantry Schema: [database_schemas/autonomous_pantry_schema.sql](./database_schemas/autonomous_pantry_schema.sql)
- Main Dev Schema: [../../../infrastructure/database/finance/schema.sql](../../../infrastructure/database/finance/schema.sql)

## Notes
- **Core Innovation:** Separates "operational income" from "system transactions" (INIT/transfers)
- **Philosophy:** All intelligence in PostgreSQL functions, Grafana only visualizes
- **Current Challenge:** Fixing savings rate calculation to show real wealth-building behavior
- **Grafana Dashboard (V2) Note:** The dashboard is explicitly designed to meet Grafana's strict `rawSql` parsing requirements (single-line, no comments, unquoted aliases with underscores). Refer to [S05: Observability & Financial Dashboards](../20_Systems/S05_Observability-Dashboards/README.md) for details.
