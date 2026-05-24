---
title: "System Audit: Event-Driven Architecture (EDA) Status"
type: "audit_report"
status: "active"
owner: "Michał"
updated: "2026-05-03"
goal_id: "goal-g11"
---

# EDA Status Audit (May 2026)

## 🏗️ Current Infrastructure
The "Nervous System" of the Autonomous Living ecosystem is fully deployed and operational as of May 01, 2026.

- **Message Broker:** RabbitMQ (`3-management`) running on port `5672` (AMQP) and `15672` (Admin).
- **CDC Bridge:** `G11_db_event_bridge.py` running in Docker (`db-event-bridge`).
    - Successfully listens to PostgreSQL `NOTIFY` channels (`roi_events`) across 8 domain databases.
    - Standardizes DB triggers into `life.events` topic exchange.
- **Main Listener:** `G11_event_listener.py` running in Docker (`eda-orchestrator`).
    - Actively dispatches reactive Python scripts based on event patterns.

## ✅ Verified Reactive Loops
The following loops are confirmed working (Python-Native):
1. **Health → Productivity:** `biometric_inserted` event → `G10_schedule_optimizer.py` (Real-time Bio-Blocking).
2. **Finance → Categorization:** `transaction_inserted` event → `G05_llm_categorizer.py`.
3. **System → Self-Healing:** `FAILURE` status in activity logs → `G11_self_healing_supervisor.py`.

## 🔴 Identified Gaps (Level 5 Autonomy Path)
The system currently operates in a "Hybrid" mode. The following components still rely on polling and should be converted to EDA:

| Component | Current Trigger | Target EDA Event |
| :--- | :--- | :--- |
| **Context Cache** | Cron (10m) | `db_event.*` (Any significant state change) |
| **Pantry Manifest** | Cron (Hourly) | `low_stock` or `inventory_updated` |
| **CEO Briefing** | Cron (Sunday) | `week_completed` meta-event |

## 🚀 Strategy: "Kill the Polling"
The roadmap for Q2 is to decommission `cron` jobs where a clear database or API event can be used instead. This reduces CPU overhead and ensures the Digital Twin is always "Instant."

---
## References
- [[Goal Documentation Standard]]
- [[SPAWN.md]]
- [[Roadmap.md]]
