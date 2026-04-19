---
title: "G05: Systems"
type: "goal_systems"
status: "active"
owner: "Michal"
updated: "2026-03-16"
goal_id: "goal-g05"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Primary storage via `autonomous_finance` database.
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md) - Financial alerting and anomaly detection.
- [S11 Intelligence Router](../../20_Systems/S11_Meta-System-Integration/README.md) - Global synchronization orchestrator.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Centralized Transaction Ledger | S03 Data Layer | PostgreSQL: `transactions` | - |
| Automated Transaction Ingest | S03 Data Layer | [G05_finance_sync.py](../../50_Automations/scripts/G05_finance_sync.md) | - |
| **AI Transaction Categorization** | **S03 Data Layer** | **[SVC_Financial-AI-Categorizer](../../50_Automations/n8n/services/SVC_Financial-AI-Categorizer.md)** | - |
| AI-Powered Categorization | S03 Data Layer | [G05_llm_categorizer.md](../../50_Automations/scripts/G05_llm_categorizer.md) | - |
| Real-time Budget Monitoring | S03 Data Layer | [view: v_budget_performance](../../20_Systems/S03_Data-Layer/README.md) | - |
| Automated Budget Alerts | S04 Digital Twin | [G04_digital_twin_engine.md](../../50_Automations/scripts/G04_digital_twin_engine.md) | - |
| Spending Anomaly Detection | S03 Data Layer | [view: v_spending_anomalies](../../20_Systems/S03_Data-Layer/README.md) | - |
| Budget Rebalancing Suggestions | S05 Finance | [G05_budget_rebalancer.md](../../50_Automations/scripts/G05_budget_rebalancer.md) | - |
| **Proactive Rebalance Approval** | **S04 Digital Twin** | **[G11_approval_prompter](../../50_Automations/scripts/G11_approval_prompter.md)** | [Telegram-Approval-SOP.md](../../30_Sops/Telegram-Approval-SOP.md) |
| Autonomous Budget Rebalancing | S05 Finance | [G05_budget_rebalancer.md](../../50_Automations/scripts/G05_budget_rebalancer.md) | [SOP: Autonomous Rebalancing](../../30_Sops/G05/Autonomous-Rebalancing.md) |
| **Execute Rebalance Action** | **S08 Orchestrator** | **[G11_decision_handler](../../50_Automations/scripts/G11_decision_handler.md)** | [Autonomy-Rules-Runbook.md](../../40_Runbooks/G11/Autonomy-Rules-Runbook.md) |
| Bidirectional Sheets Sync (AI Tracking) | S03 Data Layer | [G05_finance_sync.md](../../50_Automations/scripts/G05_finance_sync.md) | - |
| Manual Rebalance Execution | S05 Finance | [finance_rebalance.md](../../50_Automations/scripts/finance_rebalance.md) | - |
| **Liquidity Rebalancing Agent** | S05 Finance | [G05_liquidity_rebalancer.md](../../50_Automations/scripts/G05_liquidity_rebalancer.md) | - |
| **Execute Account Transfer** | S08 Orchestrator | [G11_decision_handler.md](../../50_Automations/scripts/G11_decision_handler.md) | - |
| Historical Finance Persistence | S03 Data Layer | PostgreSQL: `finance_entries` | - |

---
*Updated: 2026-03-05 by Digital Twin Assistant*
