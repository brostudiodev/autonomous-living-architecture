---
title: "G04: Agent Zero Core Strategic Logic"
type: "automation_spec"
status: "active"
automation_id: "G04_agent_zero_core"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-18"
---

# G04: Agent Zero Core Logic

## Purpose
Agent Zero is the central strategic brain of the Digital Twin ecosystem. It acts as the primary "Ask Me Anything" (AMA) interface, providing data-driven answers, logging events, and coordinating autonomous actions. Version 5.4 (Hardened Discovery Milestone).

## Capabilities

### 🩺 Unified Health Intelligence (ENHANCED Apr 18)
- **`/health`**: Provides a consolidated biological summary.
    - **Smart Fallback**: If today's biometric data is missing in `autonomous_health`, it autonomously fetches the latest bodyweight and fat percentage from the `autonomous_training` database.
- **`/hydration`**: Real-time water/coffee balance tracking and replenishment advice.

### 💰 Financial Strategy
- **`/finance` (ENHANCED Apr 21)**: Provides a detailed budget dashboard. In addition to the alert count, it now lists every active budget breach with utilization percentage and recommended action (e.g., "STOP SPENDING").
- **`/forecast`**: Predicts liquidity runway and daily burn rate based on current month performance.

### 🏋️ Training & HIT Analytics (NEW Apr 18)
- **`/workout`**: Summarizes the last 5 sessions and highlights muscular progression markers (TUT, failures).

### 🧠 Strategic Memory
- **`/memory`**: Retrieves the last 10 strategic insights and previous guidance to ensure contextual continuity.

### 🏠 Smart Home (Read-Only)
- **`/home_status`**: Aggregated environment overview (Temperature, Occupancy, Hardware Alerts).

## Changelog
| Date | Version | Author | Change Description |
|---|---|---|---|
| 2026-04-18 | 5.4 | Michał | Initial documentation of v5.4 logic (Hardened Discovery). |
| 2026-04-21 | 5.5 | Michał | Enhanced `/finance` command to return detailed alert lists and budget utilization stats. |
| 2026-04-21 | 5.6 | Michał | API Audit: Recovered and formatted `/os`, `/vision`, `/roi`, `/tasks`, `/analytics/trends`, and `/workout/stats` commands. |
| 2026-04-21 | 5.7 | Michał | Full API Sync: Implemented missing mappings for `/audit`, `/strategic_audit`, `/career`, `/decisions/pending`, `/history`, and `/best_day`. Hardened `/memory` against NoneType errors. |

## Command Processing Directory
The following commands are natively handled by the `AgentZero.ask()` method:

| Category | Commands |
|----------|----------|
| **Meta** | `/help`, `/status`, `/all`, `/sync`, `/triage`, `/repair`, `/tools` |
| **Health**| `/health`, `/hydration`, `/log_water`, `/log_coffee`, `/health_sync`, `/scale_sync` |
| **Finance**| `/finance`, `/forecast`, `/finance/details` |
| **Productivity**| `/today`, `/suggested`, `/energy`, `/mood`, `/ouch` |
| **Domain** | `/pantry`, `/workout`, `/career`, `/memory` |
| **System** | `/system_health`, `/system/activity`, `/system/gaps` |

## Resilience Patterns
1.  **Date Awareness**: All relative queries ("yesterday", "last week") are resolved to absolute ISO dates before tool execution.
2.  **Circuit Breaking**: Integrated with `G04_domain_isolator` to prevent cascading failures if a specific database is offline.
3.  **Background Tasks**: Long-running operations (Sync, Bulk Approval) are automatically delegated to FastAPI `BackgroundTasks`.

## Outputs
- **Structured JSON**: All responses follow the `{report, response_text, timestamp, data}` format for n8n compatibility.
- **Database Updates**: Writes to `strategic_memory`, `digital_friction_log`, and daily telemetry tables.
