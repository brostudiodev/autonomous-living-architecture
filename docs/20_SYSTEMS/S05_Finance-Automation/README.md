---
title: "S05: Finance Automation"
type: "system"
status: "active"
owner: "Michał"
updated: "2026-01-15"
---

# S05: Finance Automation

## Purpose
Transform from reactive bookkeeping to autonomous financial operations by Dec 31, 2026. Achieve 95% autonomous operation for routine financial decisions with complete visibility and optimization across all accounts serving as "capital allocation engine" for entire 2026 transformation.

## Scope
- Included: Automated transaction categorization, Waterfall capital allocation protocol, Predictive cash flow forecasting, Anomaly detection, AI-powered financial intelligence, PostgreSQL database with n8n workflows
- Excluded: Manual investment advice, Tax filing automation, Cryptocurrency trading bots, Real-time stock market analysis

## Interfaces
- Inputs: Bank transaction feeds (PSD2 APIs), Investment account data, Credit card transactions, Manual cash entries via Agent Zero, Historical spreadsheet data
- Outputs: Categorized transactions, Capital allocation recommendations, Anomaly alerts, Financial reports, Dashboard visualizations, Strategic insights
- APIs/events: Polish banking APIs (mBank, ING, PKO BP), GoCardless/Nordigen PSD2, XTB brokerage API, Claude API, Firefly III API, Google Sheets API

## Dependencies
- Services: PostgreSQL database, n8n automation platform, Firefly III (self-hosted financial management), Claude API (AI analysis), Grafana (monitoring)
- Hardware: Homelab with Docker deployment, Backup storage for financial data, VPN access for security
- Credentials (names only): postgresql_db_credentials, banking_api_keys, n8n_credentials, claude_api_key, firefly_iii_credentials, google_sheets_api

## Observability
- Logs: Transaction categorization accuracy logs, API sync failures, Capital allocation execution logs, Anomaly detection alerts
- Metrics: Daily transaction volume, Categorization accuracy rate (target 95%), Cash flow forecasting accuracy (target 90%), System uptime, Autonomous operation percentage
- Alerts: Failed bank syncs, Unusual spending patterns, Low balance warnings, API rate limiting, Security anomalies

## Runbooks / SOPs
- Related SOPs: Bank account onboarding, Transaction categorization training, Capital allocation setup, Anomaly response procedures, Database backup/recovery
- Related runbooks: Financial data migration, Monthly reconciliation process, Tax preparation data export, System maintenance windows

