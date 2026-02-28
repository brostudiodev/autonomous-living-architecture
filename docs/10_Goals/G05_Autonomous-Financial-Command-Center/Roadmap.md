---
title: "G05: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g05"
owner: "Michal"
updated: "2026-02-07"
---

# Roadmap (2026)

## Q1 2026 (Foundation Phase)
- [x] Deploy PostgreSQL schema with corrected savings rate calculation
- [x] Create and import Grafana dashboard with real-time visualization
- [x] Implement n8n workflows for budget alerts and optimization
- [x] Validate savings rate shows 5-35% range (not 98%) ([Runbook](../../40_Runbooks/G05/Validate-Savings-Rate.md))
- [x] Test autonomous alerting system with threshold breaches ([Runbook](../../40_Runbooks/G05/Test-Budget-Alerts.md))
- [ ] Establish initial data ingestion pipelines for bank statements and credit card data
- [ ] Develop basic categorization rules for financial transactions
- [ ] Integrate financial metrics into a central data warehouse (S03)
- [ ] Set up continuous monitoring for data integrity in financial pipelines

## Q2 2026 (Optimization Phase)
- [ ] Implement automated transaction categorization (≥95% accuracy)
- [ ] Cash flow forecasting (Prophet/ARIMA) trained on historical data
- [ ] Implement Decision Intelligence Framework (decision matrix with thresholds)
- [ ] Deploy Ollama with Mistral-7B for financial query interface
- [ ] Add anomaly detection for unusual spending patterns (v_spending_anomalies)
- [ ] Deploy predictive models for month-end projections

## Q3 2026 (Intelligence Phase)
- [ ] Implement Financial "Rebalancing Agent" (Autonomous movement between accounts)
- [ ] Predictive Cash Flow Simulator (Gemini-driven multi-year forecasting)
- [ ] Automated Tax & Savings Allocation (Agent executes based on monthly net)
- [ ] Transition from "Budget Monitoring" to "Active Treasury Management"
- [ ] Automated monthly financial reports and mobile-friendly approvals
- [ ] Integrate bank APIs for automatic transaction import (PSD2 compliance)

## Q4 2026 (Autonomy Phase)
- [ ] Deploy governance & safety framework (kill switches, approval workflows)
- [ ] Advanced AI Capabilities: Conversational AI for financial advice
- [ ] Automated investment rebalancing suggestions
- [ ] Full validation of decision accuracy against historical baseline
- [ ] Achieve 95% operational autonomy milestone

## Dependencies
- **S03 Data Layer:** PostgreSQL deployment with financial schema
- **S05 Observability:** Grafana server configuration
- **S08 Automation:** n8n container with database connectivity
- **Infrastructure:** Docker host with sufficient resources
- **External APIs:** Bank integrations (Q3 onwards)
- **Other goals:** G09 (Documentation Standard) for consistent financial process documentation.