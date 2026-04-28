---
title: "SVC: AI Agent Interactive (G11)"
type: "service_spec"
status: "active"
service_id: "SVC_AI-Agent-Interactive"
goal_id: "goal-g11"
systems: ["S04", "S08"]
owner: "Michał"
updated: "2026-04-15"
---

# SVC_AI-Agent-Interactive (v2.9 - Agent Zero)

## Purpose
The **Interactive AI Agent (Agent Zero)** is the central autonomous supervisor of Michał's life ecosystem. It acts as a multi-tool orchestrator, coordinating 9 specialized domain agents to manage health, finance, productivity, and knowledge. It maintains long-term strategic memory and real-time system awareness.

## Key Features (v2.9)
- **Agent Zero Model:** Acts as a high-level supervisor with a "Survive → Perform → Grow" priority hierarchy.
- **9-Tool Orchestration:** Directly delegates complex queries to specialized sub-agents (Health, Training, Inventory, Finance, Knowledge, Meta, Relationships, Learning, and Personal).
- **Pre-Agent Status Snapshot:** Automatically fetches real-time biometrics, tasks, and system health before every interaction to ensure grounded reasoning.
- **Decisive Task Management:** Integrated with the `PersonalAgent` for zero-friction Google Calendar and Tasks execution ("Assume & Act" protocol).
- **Unified Input Normalization:** Supports 60+ routing rules and multiple input sources (Telegram, Webhook, Workflow).

## Triggers
- **Central Router:** Triggered by `ROUTER_Intelligent_Hub` for all conversational and multi-domain requests.
- **Webhook Entry:** Direct API access for external integrations.

## 9-Tool Delegation Model
| Tool | Domain | Purpose |
|------|--------|---------|
| **DigitalTwinAPI** | Health | Real-time biometrics, sleep, HRV, steps, water. |
| **TrainingIntelligence** | HIT Training | Workout history, plans, HIT methodology. |
| **InventoryManagement** | Household | Pantry stock, shopping lists, supplies. |
| **FinanceIntelligence** | Finance | Budget, expenses, savings, spending patterns. |
| **KnowledgeIntelligence** | Knowledge | Documentation, architecture, G-series info. |
| **MetaIntegration** | System | Reliability, automation health, script execution. |
| **RelationshipIntelligence** | Logistics | Contacts, family/friend frequency, health score. |
| **LearningIntelligence** | Learning | Certifications, study sessions, skill gaps. |
| **PersonalAgent** | Productivity | Calendar events, Google Tasks management. |

## Processing Logic
1. **Normalization:** Standardizes input from various sources and resolves user identity.
2. **Session Initialization:** Generates unique `session_id` and `trace_id`.
3. **Status Pre-fetch:** Retrieves a real-time system snapshot (water, calories, steps, sleep, readiness, tasks).
4. **Merge & Context:** Combines session data with the snapshot for the LLM.
5. **Memory Retrieval:** Fetches conversation history from `strategic_memory` (PostgreSQL).
6. **Agent Zero Reasoning:** Google Gemini evaluates the query against the "Operational Priorities" and delegates to the appropriate tool(s).
7. **Dispatcher:** Formats and sends the final response via the `SVC_Response-Dispatcher`.

## AI Agent Configuration
- **Model:** Google Gemini (v1.5 Pro).
- **Memory:** `PostgresChatMemory` (strategic_memory table).
- **Role:** Agent Zero — Central Life Supervisor.

## Dependencies
- **Infrastructure:** n8n, PostgreSQL (`digital_twin_michal`).
- **APIs:** Google Gemini, Digital Twin API (Local), Google Calendar/Tasks.

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| Stale Snapshot | Timestamp check (>6h) | Agent mentions data might be stale. |
| Tool Timeout | HTTP Timeout | Agent reports specific domain unavailability. |
| Format Error | Dispatcher failure | Logs raw response for admin review. |

---

*Documentation updated for SVC_AI-Agent-Interactive.json v2.9 (2026-04-15)*
