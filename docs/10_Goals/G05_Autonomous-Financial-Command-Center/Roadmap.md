---
title: "G05: Roadmap"
type: "goal_roadmap"
status: "active"
goal_id: "goal-g05"
owner: "Michal"
updated: "2026-04-19"
---

# Roadmap (2026)

## Q1 2026 (Foundation Phase)
- [x] Deploy PostgreSQL schema with corrected savings rate calculation
- [x] Create and import Grafana dashboard with real-time visualization
- [x] Implement n8n workflows for budget alerts and optimization
- [x] Validate savings rate shows 5-35% range (not 98%) ([Runbook](../../40_Runbooks/G05/Validate-Savings-Rate.md))
- [x] Test autonomous alerting system with threshold breaches ([Runbook](../../40_Runbooks/G05/Test-Budget-Alerts.md))
- [x] Establish initial data ingestion pipelines for bank statements and credit card data ✅ (G05_bank_ingest.py)
- [x] Develop basic categorization rules for financial transactions ✅ (G05_llm_categorizer.py)
- [x] Integrate financial metrics into a central data warehouse (S03) ✅ (Mar 02)
- [x] Set up continuous monitoring for data integrity in financial pipelines ✅ (Mar 03)

## Q2 2026 (Optimization Phase)

> [!tip] 🚀 **NEW: Financial Wealth & Autonomy Layer (Q3 Focus)**
- [ ] **Financial Wealth Dashboard (G05-FWD):** Track Net Worth and FIRE milestones using historical savings rate and asset performance.
- [ ] **FIRE Calculator:** Multi-year projections based on current burn rate vs investment growth.
- [ ] **Asset Allocation Audit:** Monthly AI-powered review of diversification strategies.

> [!tip] 🚀 **Q2 Focus: System Stability & Minor Improvements**
- [ ] **System Stability Audit:** Verify all financial automations working reliably
  - [ ] **Sub-task: Transaction Sync Check** - Ensure bank data imports without gaps
  - [ ] **Sub-task: Budget Alert Check** - Verify notifications trigger correctly
  - [ ] **Sub-task: Rebalancer Check** - Test automated budget movements
- [ ] **Minor Improvements:**
  - [ ] **Sub-task: Categorization Accuracy** - Review and improve transaction categorization
  - [ ] **Sub-task: Forecast Calibration** - Adjust predictive models based on recent accuracy

> [!tip] 🚀 **NEW: Financial Deep Metrics (Wealth Layer)**
> **Gap:** G05 tracks cash flow but missing wealth-building visibility for true financial autonomy.
- [ ] **Net Worth Tracking:** Create `net_worth_snapshots` table with monthly snapshots
  - [ ] **Sub-task: Asset Categories** - Define stock/bond/cash/real estate categories
  - [ ] **Sub-task: Liability Tracking** - Add loans, mortgages, credit balances
  - [ ] **Sub-task: Auto-snapshot** - Automate monthly net worth calculation (1st of month)
- [ ] **Asset Allocation Dashboard:** Visualize diversification across investment types
- [ ] **Debt Payoff Progress:** Track贷款还款进度, show payoff timeline
- [ ] **FIRE Calculator:** Time-to-financial-freedom projection based on current savings rate
- [ ] **Investment Performance:** Track vs. benchmark (e.g., S&P 500) for accountability

> [!tip] 🚀 **NEW: Income Diversification Tracking**
> **Gap:** G05 tracks total income but missing source breakdown for career resilience.
- [ ] **Income Sources Database:** Create `income_sources` table
  - [ ] **Sub-task: Source Types** - Salary, freelance, investment, rental, passive
  - [ ] **Sub-task: Active Tracking** - Monthly amounts and frequency
- [ ] **Diversification Ratio:** Calculate (non_salary_income / total_income) * 100
- [ ] **Passive Income Tracker:** Separate passive vs active income streams
- [ ] **Financial Stress Correlation:** Link income stability to sleep/stress metrics (G07)

> [!tip] 🚀 **High-Impact Autonomy Tasks**
> - [x] **Anomaly detection** - Auto-detect unusual spending patterns, send alert ✅ (Mar 20 - G05_finance_anomaly_detector.py)
- [x] **Cash flow forecasting** - Predict financial needs, notify ahead of time ✅ (Mar 23)
- [x] **Predictive month-end projections** - Know your financial position in advance ✅ (Mar 23)
- [x] **Manual "Nuclear" Rebalance:** Forced SQL override to achieve zero-deficit state across categories ✅ (Mar 27)
> 
> **Architecture:** System analyzes → Sends notification/webhook to user → User approves or HA handles

- [x] Implement automated transaction categorization (≥95% accuracy) ✅ (Mar 06 - LLM + Regex + Memory)
- [x] Cash flow forecasting (Prophet/ARIMA) trained on historical data ✅ (Mar 23)
- [x] Implement Decision Intelligence Framework (decision matrix with thresholds) ✅ (Mar 06 - G05 Learner)
- [x] **Ollama Wrapper Created** (G05_ollama_wrapper.py) - DISABLED due to hardware limitations (PC too slow for LLMs) ⚠️
  - Status: Wrapper ready, disabled by default
  - To enable: Set `OLLAMA_ENABLED=true` in `.env`
  - Docs: [G05_ollama_wrapper.md](../../50_Automations/scripts/G05_ollama_wrapper.md)
  - Hardware: See [Infrastructure README](../../../infrastructure/architecture/README.md#hardware-limitations)
- [x] Add anomaly detection for unusual spending patterns (v_spending_anomalies) ✅ (Mar 20)
- [x] Deploy predictive models for month-end projections ✅ (Mar 23)
- [x] **Agentic Rebalancing:** Interactive Telegram approvals for budget movements ✅ (Mar 25)
- [x] **Autonomous Account Movement:** Liquidity Rebalancing Agent for inter-account transfers ✅ (Mar 26)
- [x] **Pre-emptive Financial Rebalancer (G05-PFR):** Automated budget reallocations based on friction forecasts ✅ (Apr 03)
- [x] **n8n Finance Workflows:** Autonomous Finance - Budget Sync, 2026 Data Sync, Daily Budget Alerts ✅ (Apr 10)
- [x] **PROJ_Expense_Calendar:** AI-powered expense calendar with Gemini agent ✅ (Apr 10)
- [x] **PROJ_Personal-Budget-Intelligence:** AI-powered expense tracking and budget insights ✅ (Apr 10)
- [x] **Unlimited Financial History Unlock (G05-UHU):** Standardized 10-year lookback and removed data retrieval limits across all agents and endpoints ✅ (Apr 19)

## Q3 2026 (Intelligence Phase)
- [x] Implement Financial "Rebalancing Agent" (Autonomous movement between accounts) ✅ (Mar 26)
- [x] Predictive Cash Flow Simulator (Gemini-driven multi-year forecasting) ✅ (Foundation via Ghost Schema)
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
