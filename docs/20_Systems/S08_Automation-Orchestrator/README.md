---
title: "S08: Automation Orchestrator"
type: "system"
status: "active"
system_id: "system-s08"
owner: "Michał"
updated: "2026-05-01"
---

# S08: Automation Orchestrator

## Purpose
The execution engine for all autonomous tasks. Manages the lifecycle of scripts, workflows, and the **Reflex vs. Cortex** decision-making framework.

## Components
- **The Reflex System (EDA):** `G11_event_listener.py` and n8n RabbitMQ triggers. Handles low-latency reactivity to `LifeEvents`.
- **The Global Heartbeat:** `G11_global_sync.py`. Orchestrates scheduled batch operations, deep state analysis, and dependency management.
- **The Human Interface:** `autonomous_daily_manager.py`. Injects system intelligence into the Obsidian Daily Note.
- **Decision Engine:** `G11_rules_engine.py` and `G11_decision_handler.py`. Governs the level of autonomy (AUTO_ACT vs ASK_HUMAN).
- **Self-Healing Supervisor:** `G11_self_healing_supervisor.py`. Reactive repair engine that triggers on `*.error.#` events.

## Stability & Constraints (2026-05-05)
To ensure the orchestrator remains stable during peak event loads:
- **Resource Gating:** n8n is capped at 2GB RAM. This prevents individual node leaks from crashing the system.
- **Image Choice:** Standardized on `docker.n8n.io/n8nio/n8n` (Alpine) to ensure version currency (v2+). 
    - *Note:* Python 3 internal task runner is unavailable in this image. High-cognitive Python tasks must remain in the dedicated Python scripts/containers.
- **Storage Strategy:** Migrated to n8n v1+ filesystem standard (`/storage` instead of `/binaryData`).

---
*Created: 2026-04-08 | Part of G11 Meta-System Integration*
