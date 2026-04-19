---
title: "S01: Observability & Monitoring"
type: "system"
status: "active"
system_id: "system-s01"
owner: "Michal"
updated: "2026-04-08"
---

# S01: Observability & Monitoring

## Purpose
Provides real-time visibility into the health, performance, and reliability of the Autonomous Living infrastructure. It ensures that failures are detected and reported before they impact daily operations.

## Architecture
- **Infrastructure Monitoring:** Grafana & Prometheus (Container health, Disk, RAM).
- **Automation Monitoring:** `system_activity_log` (PostgreSQL).
- **System Vitals:** [G11_system_vital_sentinel.py](../../50_Automations/scripts/G11_system_vital_sentinel.md).
- **Reliability Metrics:** [G11_system_reliability_auditor.py](../../50_Automations/scripts/G11_system_reliability_auditor.md).

## Key Components
- **Dashboard:** Grafana (Internal only).
- **Alerting:** Telegram notifications for CRITICAL script failures.
- **Heartbeat:** `G11_system_heartbeat.py` ensures the core loop is running.

## Procedure
- **Daily:** Check "System Health" section in Obsidian Daily Note.
- **Weekly:** Review reliability score via `G11_system_reliability_auditor.py`.

---
*Created: 2026-04-08 | Part of G11 Meta-System Integration*
