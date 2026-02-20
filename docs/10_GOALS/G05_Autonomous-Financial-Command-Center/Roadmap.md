---
title: "G05: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g05"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Roadmap (2026)

## Q1 2026 (Foundation Phase)
- [x] Deploy PostgreSQL schema with corrected savings rate calculation
- [x] Create and import Grafana dashboard with real-time visualization
- [x] Implement n8n workflows for budget alerts and optimization
- [x] Validate savings rate shows 5-35% range (not 98%) ([Runbook](../../40_RUNBOOKS/G05/Validate-Savings-Rate.md))
- [x] Test autonomous alerting system with threshold breaches ([Runbook](../../40_RUNBOOKS/G05/Test-Budget-Alerts.md))
- [ ] Establish initial data ingestion pipelines for bank statements and credit card data
- [ ] Develop basic categorization rules for financial transactions
- [ ] Integrate financial metrics into a central data warehouse (S03)
- [ ] Set up continuous monitoring for data integrity in financial pipelines

## Q2 2026 (Optimization Phase)
- [ ] Implement automated transaction categorization (≥90% accuracy)
- [ ] Add anomaly detection for unusual spending patterns
- [ ] Create weekly intelligence summary reports
- [ ] Deploy predictive models for month-end projections
- [ ] Optimize database queries for sub-second performance
- [ ] Explore external financial APIs for additional data sources (e.g., investment, loans)
- [ ] Develop automated reconciliation processes for accounts

## Q3 2026 (Intelligence Phase)
- [ ] Integrate external data sources (bank APIs, investment accounts)
- [ ] Implement ML-based spending optimization recommendations
- [ ] Deploy autonomous budget rebalancing suggestions
- [ ] Create comprehensive financial scenario modeling
- [ ] Add mobile-responsive dashboard views
- [ ] Begin integrating financial health metrics into G07 (Predictive Health Management)
- [ ] Contribute financial forecasts and budget insights to G12 (Meta-System)

## Q4 2026 (Autonomy Phase)
- [ ] Deploy autonomous financial decision-making framework
- [ ] Implement proactive budget adjustments based on patterns
- [ ] Create financial health scoring system
- [ ] Add integration with tax planning tools
- [ ] Full validation of 99.9% uptime requirement
- [ ] Refine financial health and prediction models based on year-long data

## Dependencies
- **S03 Data Layer:** PostgreSQL deployment with financial schema
- **S05 Observability:** Grafana server configuration
- **S08 Automation:** n8n container with database connectivity
- **Infrastructure:** Docker host with sufficient resources
- **External APIs:** Bank integrations (Q3 onwards)
- **Other goals:** G09 (Documentation Standard) for consistent financial process documentation.