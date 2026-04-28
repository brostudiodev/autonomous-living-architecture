---
title: "Agent Zero: Digital Twin API Agent"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Digital-Twin-API-Agent"
goal_id: "goal-g04"
systems: ["S04", "S08", "S11"]
owner: "Michał"
updated: "2026-04-13"
---

# Agent Zero: Digital Twin API Agent

## Purpose
**Agent Zero** is the primary strategic interface for Michał's Digital Twin. It is a high-density analytical system designed as a peer-level engineering partner. Unlike standard chatbots, Agent Zero has direct access to 40+ API endpoints in the autonomous ecosystem, allowing it to provide proactive, data-driven advice and execute system-wide actions.

## Triggers
- **Sub-workflow:** Primary entry point from `ROUTER_Intelligent_Hub`.
- **Manual Trigger:** Used for internal system testing and debugging.

## Inputs
- **Query:** Natural language string containing the user's intent or question.
- **Context:** Automatically pre-fetched system status snapshot (via `/status`).
- **Metadata:** Trace ID, Chat ID, User ID, and Source Type for orchestration.

## Architecture: "The Orchestrator"
1. **Normalization:** Resolve session IDs, trace IDs, and user context.
2. **Initialization:** Set API base URL and session timestamps.
3. **Pre-fetch:** Automatically calls `Fetch System Status` to inject current system telemetry into the agent's prompt.
4. **Reasoning:** Google Gemini (v1.5 Pro) processes the query using pre-loaded context and 35+ specialized HTTP tools.
5. **Execution:** Agent Zero can call various domain-specific tools (Health, Finance, Logistics, etc.) to fetch deep data or mutate system state.
6. **Dispatch:** Final response is formatted and sent back via `SVC_Response-Dispatcher`.

## Tools (Capabilities)
Agent Zero possesses 37+ specialized tools, including:
- **Telemetry:** `GetFullSystemState`, `GetTodayDashboard`, `GetHealthTelemetry`, `GetFinanceDashboard`, `GetCareerMetrics`.
- **Sync/Operations:** `TriggerGlobalSync`, `TriggerHealthSync`, `TriggerLogisticsSync`.
- **Mutations:** `LogCoffee`, `LogWater`, `LogReflection`, `UpdateDailyReflection`, `LogCustomEvent`.
- **Analytics:** `AnalyzeCorrelation`, `GetBestDayAnalysis`, `RunMonteCarloSimulation`, `GetFinancialForecast`.
- **System Admin:** `RunSystemAudit`, `GetSystemMap`, `ExecuteSystemRepair`.
- **Database:** `QueryAutonomousData` (PostgreSQL read-only access).

## Dependencies
### Systems
- [Digital Twin Ecosystem (G04)](../../../10_Goals/G04_Digital-Twin-Ecosystem/README.md)
- [Automation Orchestrator (S08)](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n engine.
- [Data Layer (S03)](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL databases.

### External Services
- **Google Gemini API:** Core LLM reasoning.
- **Digital Twin API:** Local endpoint providing access to G-series scripts.

## Processing Rules
- **Date Protocol:** Always uses the session start date as the reference for relative time (e.g., "yesterday").
- **Language Protocol:** Detects and responds in the user's language (Polish or English).
- **Data Hierarchy:** Prioritizes pre-fetched snapshots, then live API tools, then historical database queries.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| API Unavailable | HTTP Tool node error (500/Timeout) | Agent reports technical difficulty and suggests manual audit. |
| Stale Snapshot | Rule #1 detects old timestamp | Agent calls `RefreshSystemStatus` tool before answering. |
| Tool Timeout | LangChain node timeout | Returns partial response based on pre-fetched context. |

## Security Notes
- **Authentication:** Inherited from the Router (only authorized users can reach this agent).
- **SQL Access:** `QueryAutonomousData` is restricted to SELECT queries; credentials are managed in n8n.
- **Repair Protocols:** State-mutating actions (e.g., `ExecuteSystemRepair`) are logged to `system_activity_log`.

---

*Documentation synchronized with PROJ_Digital-Twin-API-Agent.json v1.0 (2026-04-13)*
