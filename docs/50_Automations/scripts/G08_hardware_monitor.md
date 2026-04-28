---
title: "G08_hardware_monitor: Host Machine Resilience"
type: "automation_spec"
status: "active"
automation_id: "G08_hardware_monitor"
goal_id: "goal-g08"
systems: ["S01", "S08"]
owner: "Michał"
updated: "2026-04-28"
---

# G08_hardware_monitor: Host Machine Resilience

## Purpose
Monitors the physical host machine's health and performance metrics to ensure system uptime and prevent data corruption during resource-exhaustion events. Integrated with Glances for real-time telemetry.

## Triggers
- **Scheduled:** Part of the daily global sync.
- **Manual:** `python scripts/G08_hardware_monitor.py`

## Inputs
- **Glances API:** `http://localhost:61208/api/3` (CPU, RAM, Disk, Swap).
- **Home Assistant:** (Legacy fallback for power monitoring).

## Thresholds & Alerts
| Metric | Critical Threshold | Action |
|--------|-------------------|--------|
| **CPU** | > 90% | Telegram Alert + Critical Log |
| **RAM** | > 90% | Telegram Alert + Critical Log |
| **Disk (/)** | > 90% | Telegram Alert + Critical Log |
| **Swap** | > 80% | Warning Log |

## Processing Logic
1. **Metric Retrieval:** Queries the local Glances REST API for host-level performance data.
2. **Threshold Audit:** Compares metrics against the critical thresholds defined above.
3. **Alerting:**
    - If thresholds are breached: Sends a detailed Telegram notification via `G04_digital_twin_notifier`.
    - Logs a `CRITICAL` status to the `system_activity_log` for visibility in the Daily Note.
4. **Resilience Policy:** Triggers the `behavioral.hardware_stress_alert` policy in the Rules Engine for potential automated load-shedding.

## Outputs
- **Activity Log:** `system_activity_log` (PostgreSQL).
- **Telegram:** Real-time stress alerts.
- **Quick Wins:** Critical issues appear in the "System Health" section of the Daily Note.

## Dependencies
### Services
- **Glances:** Must be running as a systemd service on port 61208.
- **Digital Twin Notifier:** For Telegram delivery.

## Error Handling
| Scenario | Detection | Response |
|----------|-----------|----------|
| Glances API Down | HTTP Connection Error | Log failure, notify via backup channel |
| Missing Thresholds | YAML loading error | Use hardcoded defaults |

## Monitoring
- **Success metric:** 100% detection of CPU spikes during heavy LLM testing.
- **ROI:** Prevents manual system reboots by proactive load-shedding.

## Changelog
| Date | Change |
|------|--------|
| 2026-03-05 | Initial hardware monitoring (basic free -m) |
| 2026-03-28 | Switched to Glances API for comprehensive host telemetry and automated Telegram alerts |
