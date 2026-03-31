---
title: "G07: Health Anomaly Monitor"
type: "automation_spec"
status: "active"
automation_id: "G07__health_anomaly_monitor"
goal_id: "goal-g07"
systems: ["S06", "S04"]
owner: "Michal"
updated: "2026-03-21"
---

# G07: Health Anomaly Monitor

## Purpose
Proactively detects significant drops in biometric markers (HRV, Readiness) by comparing today's data against a 7-day rolling average. Triggers protective system states to prevent burnout or illness.

## Triggers
- **Scheduled:** Every 4 hours as part of `G11_global_sync.py`.

## Inputs
- **Biometrics:** Historical `hrv_ms` and `readiness_score` from `DB_HEALTH`.

## Processing Logic
1. **Data Retrieval:** Fetches biometrics for the last 14 days.
2. **Baseline Calculation:** Calculates 7-day rolling averages for HRV and Readiness Score (excluding today).
3. **Anomaly Check:** Compares today's fresh data against the baseline.
4. **Severity Assessment:** Identifies an anomaly if today's value is < 80% of the baseline average.

## Outputs
- **Telegram Alert:** Critical alert sent if an anomaly is detected.
- **Strategic Memory:** Logs an 'insight' to `strategic_memory` in `DB_TWIN` to inform other agents.
- **Activity Log:** Status logged to `system_activity_log`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S06 Health Performance](../../20_Systems/S06_Health-Performance/README.md)

### External Services
- Telegram Bot API

### Credentials
- `TELEGRAM_BOT_TOKEN` in `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Insufficient Data | Row count < 7 | Log Warning, skip analysis | None |
| Stale Data | Date mismatch | Log Warning, request fresh sync | None |
| DB Connection Fail | Exception | Log Failure | Telegram (via Heartbeat) |

## Monitoring
- Success metric: Anomaly status correctly logged daily.
- Alert on: Failure in `system_activity_log`.
