---
title: "G05: Systems"
type: "goal_systems"
status: "active"
owner: "Michał"
updated: "2026-03-16"
goal_id: "goal-g05"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_Systems/README.md) - Primary storage via `autonomous_finance` database.
- [S04 Digital Twin Hub](../../20_Systems/README.md) - Financial alerting and anomaly detection.
- [S11 Intelligence Router](../../20_Systems/README.md) - Global synchronization orchestrator.

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Centralized Transaction Ledger | S03 Data Layer | PostgreSQL: `transactions` | - |
| **Unified Finance Data Sync** | **S03 Data Layer** | **[G05_finance_sync.py](../../50_Automations/scripts/G05_finance_sync.md)** (Native) | - |
| Bi-directional Budget Sync | S03 Data Layer | [G05_finance_sync.py](../../50_Automations/scripts/G05_finance_sync.md) | - |
| **AI Breach Analysis** | **S11 Router** | **[SVC_LLM_Categorize](../../50_Automations/n8n/workflows/SVC_LLM_Categorize.md)** (via Webhook) | [Budget-Alert-Response.md](../../40_Runbooks/G05/Budget-Alert-Response.md) |
| AI-Powered Categorization | S03 Data Layer | [G05_llm_categorizer.md](../../50_Automations/scripts/G05_llm_categorizer.md) | - |
| **Real-time Budget Alerting** | **S11 Router** | **G11_event_listener.py** (Trigger: `budget_breach`) | [Budget-Alert-Response.md](../../40_Runbooks/G05/Budget-Alert-Response.md) |
| **Decision Prompting** | **S11 Router** | **n8n Webhook Layer** (Decision Advisory) | [Telegram-Approval-SOP.md](../../30_Sops/Telegram-Approval-SOP.md) |
| Autonomous Budget Rebalancing | S05 Finance | [G05_budget_rebalancer.md](../../50_Automations/scripts/G05_budget_rebalancer.md) | [SOP: Autonomous Rebalancing](../../30_Sops/G05/Autonomous-Rebalancing.md) |
| **Execute Rebalance Action** | **S08 Orchestrator** | **[G11_decision_handler](../../50_Automations/scripts/G11_decision_handler.md)** | [Autonomy-Rules-Runbook.md](../../40_Runbooks/G11/Autonomy-Rules-Runbook.md) |
| Bidirectional Sheets Sync (AI Tracking) | S03 Data Layer | [G05_finance_sync.md](../../50_Automations/scripts/G05_finance_sync.md) | - |
| Manual Rebalance Execution | S05 Finance | [finance_rebalance.md](../../50_Automations/scripts/finance_rebalance.md) | - |
| **Net Worth & FIRE Tracking** | S05 Finance | [G05_net_worth_snapshot.md](../../50_Automations/scripts/G05_net_worth_snapshot.md) | [Daily Mission Briefing] |
| **FIRE Progress Monitor** | S05 Finance | [G11_mission_aggregator.md](../../50_Automations/scripts/G11_mission_aggregator.md) | [Golden Mission List] |
| **Liquidity Rebalancing Agent** | S05 Finance | [G05_liquidity_rebalancer.md](../../50_Automations/scripts/G05_liquidity_rebalancer.md) | - |
| **Execute Account Transfer** | S08 Orchestrator | [G11_decision_handler.md](../../50_Automations/scripts/G11_decision_handler.md) | - |
| Historical Finance Persistence | S03 Data Layer | PostgreSQL: `finance_entries` | - |

---
*Updated: 2026-03-05 by Digital Twin Assistant*
