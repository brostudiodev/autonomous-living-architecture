---
title: "G04: Agent Zero Core Strategic Logic"
type: "automation_spec"
status: "active"
automation_id: "G04_agent_zero_core"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michal"
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
- **`/finance`**: High-level budget status.
- **`/forecast` (NEW Apr 18)**: Predicts liquidity runway and daily burn rate based on current month performance.

### 🏋️ Training & HIT Analytics (NEW Apr 18)
- **`/workout`**: Summarizes the last 5 sessions and highlights muscular progression markers (TUT, failures).

### 🧠 Strategic Memory
- **`/memory`**: Retrieves the last 10 strategic insights and previous guidance to ensure contextual continuity.

### 🏠 Smart Home (Read-Only)
- **`/home_status`**: Aggregated environment overview (Temperature, Occupancy, Hardware Alerts).

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
