# S12: Event-Driven Architecture (EDA)

## Overview
The Event-Driven Architecture (EDA) is the central nervous system of the Autonomous Living project. It transitions the system from a polling-based model (Cron) to a reactive, real-time model (Level 5 Autonomy).

## Core Philosophy: The Two-Loop Architecture

The EDA operates on a **"Push/Pull"** split to maximize performance while providing deep intelligence:

### 1. The Fast Loop (Native System Router) - "Push"
Deterministic logic and script orchestration run natively in Python via the **Native EDA Router** (`G11_event_listener.py`).
- **Role:** The "Nervous System" and "Fast Executioner."
- **Behavior:** Subscribes to `#` (all events), dispatches scripts via `subprocess`, and manages tiered self-healing.
- **Efficiency Standard:** 0% n8n overhead for deterministic routing (Health pivots, Sync audits, Dashboard refreshes).

### 2. The Slow Loop (Intelligence-as-a-Service) - "Pull/Webhook"
n8n is strictly reserved for high-cognitive tasks and interactive user interfaces.
- **Role:** The "CEO Office" and "Strategic Advisory."
- **Standard:** Python scripts `POST` to n8n webhooks only for **Decision Advisory** (LLM analysis) or **Human-in-the-Loop** (Telegram buttons).
- **Example:** `G11_self_healing_logic.py` only calls n8n after 3 local retry failures.

---

## Core Components

### 1. The Native EDA Router (`G11_event_listener.py`)
The primary orchestrator of the reactive nervous system.
- **Dynamic Routing:** Automatically dispatches domain-specific logic based on `routing_key` (`domain.severity.action`).
- **Tiered Self-Healing:** Integrated with `G11_self_healing_logic.py` to handle automated recovery before escalating to AI.
- **Native Triggers:**
    - `global_sync_complete` → Triggers ROI/Reliability audits.
    - `health.WARNING` → Force Pivots to Recovery Mode locally.
    - `obsidian_safe_sync_complete` → Refreshes context cache.

### 3. CEO Reallocation Engine
A Python class within the listener that maintains a "Global Priority State".
- **Logic:** Tracks physical readiness (Health) and budget breaches (Finance).
- **Trigger:** If \`budget_breach > 0\` AND \`readiness < 65\`.
- **Action:** Emits \`meta.emergency_pivot\` and triggers \`G11_task_triage_pro.py --emergency\`.

---

## Event Routing Keys
Format: \`[domain].[severity].[action]\`

| Domain | Action | Description |
|---|---|---|
| \`health\` | \`biometrics_updated\` | Fresh sleep/readiness data arrived |
| \`finance\` | \`bank_ingest_complete\` | New transactions processed |
| \`finance\` | \`budget_breach\` | Budget category exceeded |
| \`pantry\` | \`low_stock\` | Item quantity below threshold |
| \`system\` | \`resource_alert\` | Host machine stress (CPU/RAM/Disk) |
| \`meta\` | \`emergency_pivot\` | Global priority shift |
| `meta` | `db_event.*` | Raw WAL change event (Table/Action/Data) |

## Secondary Domain Scripts Migration (2026-05-15)
The system has achieved **100% EDA coverage** across all core synchronization scripts. Polling is now being decommissioned in favor of reactive signaling.

### Migrated Synchronizers
| Script | Domain | Event Emitted |
|---|---|---|
| `G11_global_sync.py` | `meta` | `meta.info.global_sync_complete` |
| `G10_task_sync.py` | `productivity` | `productivity.info.tasks_synced` |
| `G10_intelligence_sync.py` | `productivity` | `productivity.info.intelligence_synced` |
| `G09_sync_daily_goals.py` | `career` | `career.info.goal_activities_synced` |
| `training_sync.py` | `training` | `training.info.sync_complete` |
| `G13_content_idea_generator.py` | `content` | `content.info.ideas_generated` |
| `G11_obsidian_safe_sync.py` | `meta` | `meta.info.obsidian_safe_sync_complete` |

### Implementation Standard
Every sync script now follows the **"Signal on Success"** pattern via the `autonomous_sdk`:
```python
from G11_event_emitter import emit_event
emit_event("domain", "action", payload={"count": X}, severity="INFO")
```

## Specialized Reactive Loops


### 1. Peak Readiness Accelerator (G01/G10)
When fresh biometrics arrive, the system doesn't just block deep work on bad days—it **accelerates** on good days.
- **Trigger:** \`health.biometrics_updated\` with \`readiness >= 85\`.
- **Action:** Sends a high-energy Telegram prompt advising on HIT training or High-Cognitive Roadmap missions.

### 2. Predictive Decision Advisor (G11 Meta-Autonomy)
The system now suggests its own architectural evolution by analyzing long-term friction.
- **Trigger:** Recurring failures or friction points detected by \`G11_predictive_decision_advisor.py\`.
- **Logic:** Uses LLM (Gemini) to synthesize patterns from the \`friction_log\` and \`system_activity_log\`.
