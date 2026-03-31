---
title: "G04: Digital Twin System Monitor"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_monitor.py"
goal_id: "goal-g04"
systems: ["S04", "S01"]
owner: "Michal"
updated: "2026-03-20"
---

# G04: Digital Twin System Monitor

## Purpose
The primary watchdog for the ecosystem's infrastructure and logical health. It performs proactive checks on both the underlying system (databases, disk space) and the high-level system states (budget, pantry, health) to alert Michal of critical issues before they impact autonomy.

## Key Features
- **Infrastructure Sentinels:** 
    - **DB Connectivity:** Actively tests each of the 7 PostgreSQL databases.
    - **Disk Space:** Monitors host storage and alerts if usage exceeds 90%.
- **Proactive Alerting:** Detects critical biological readiness (<65), budget breaches, and low pantry stock.
- **State Management:** Uses `monitor_state.json` to track sent alerts and prevent notification spam.
- **Telegram Integration:** Sends rich-text formatted alerts directly to the Digital Twin mobile bot.

## Triggers
- **Automated:** Part of the `G11_global_sync.py` registry (3x daily).
- **Manual:** `python3 scripts/G04_digital_twin_monitor.py`

## Inputs
- **Engine:** `DigitalTwinEngine` for high-level state data.
- **System Metadata:** `shutil` for disk usage and `psycopg2` for database pings.

## Processing Logic
1.  **Infrastructure Audit:** Pings all configured database connections and checks disk availability.
2.  **Domain Audit:** Requests the current system state from the `DigitalTwinEngine`.
3.  **Threshold Analysis:** Compares current metrics against critical "hardened" thresholds.
4.  **Deduplication:** Compares current alerts against `last_alerts` in the state file.
5.  **Dispatch:** Sends any *new* alerts to Telegram and updates the local state.

## Outputs
- **Telegram:** Real-time proactive alerts.
- **System Activity Log:** `SUCCESS` or `FAILURE` of the monitoring cycle.

## Dependencies
### Systems
- [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)

## Manual Fallback
If the monitor fails:
1. Verify Telegram bot connectivity via `G04_telegram_bot.py`.
2. Check database status manually via `G11_system_audit.py`.
3. Verify disk space using `df -h`.
---
*Hardened 2026-03-20 with infrastructure sentinels.*
