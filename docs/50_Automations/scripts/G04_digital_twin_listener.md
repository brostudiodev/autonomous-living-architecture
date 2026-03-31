---
title: "script: G04 Digital Twin Event Listener"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_listener"
goal_id: "goal-g04"
systems: ["S04", "S03"]
owner: "Michal"
updated: "2026-02-25"
---

# script: G04_digital_twin_listener.py

## Purpose
A real-time event processing service that moves the Digital Twin from a "polled" to an "event-driven" model. It listens for PostgreSQL `NOTIFY` events from the Pantry, Training, and Finance databases and pushes immediate Telegram alerts for critical changes.

## Triggers
- **Database Events:** Triggered via PostgreSQL `LISTEN/NOTIFY` protocol when rows are inserted or updated in:
  - `autonomous_pantry.pantry_inventory` (via `trg_log_pantry_change`)
  - `autonomous_training.workouts` & `measurements`
  - `autonomous_finance.transactions` & `budgets`
- **Continuous:** Runs as a background daemon process.

## Inputs
- **PostgreSQL Notifications:** JSON payloads containing table name, action type, and specific row data (e.g., current quantity).
- **Environment Variables:** Database connection strings and Telegram credentials (loaded from root `.env`).

## Processing Logic
1. **Connection Management:** Establishes persistent connections to all three core databases.
2. **Subscription:** Issues `LISTEN` commands for specific channels (`pantry_update`, `training_update`, `finance_update`).
3. **Polling Loop:** Uses `select.select` to efficiently wait for data on any connection without consuming high CPU.
4. **Domain Handling:**
   - **Pantry:** Monitors stock levels; sends 🚨 Alerts if 0, or ⚠️ Warnings if < 2.
   - **Training:** Notifies on new workout logs or body composition measurements.
   - **Finance:** Confirms successful data synchronization.
5. **Messaging:** Routes processed events to `G04_digital_twin_notifier.py` for Telegram delivery.

## Outputs
- **Telegram Notifications:** Instant messages to the owner's configured chat.
- **Console Logs:** Real-time event log for system monitoring.

## Dependencies
### Systems
- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL SSOT.
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Communication hub.

### External Services
- **Telegram Bot API:** For real-time alerting.

### Credentials
- PostgreSQL: `{{DB_USER}}:{{DB_PASSWORD}}@{{DB_HOST}}:{{DB_PORT}}`
- Telegram: `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB Connection Loss | `psycopg2.OperationalError` | Log error and exit (requires systemd/cron restart) | Console |
| Invalid JSON Payload | `json.JSONDecodeError` | Skip event and log warning | Console |
| Telegram API Fail | `requests.exceptions.HTTPError` | Log error via notifier | Console |

## Manual Fallback
If the listener is offline, critical alerts will still appear in the next scheduled **Morning Briefing** (06:00 AM), as the underlying data is safely persisted in the SSOT.

---
*Usage:*
```bash
export PYTHONPATH=$PYTHONPATH:{{ROOT_LOCATION}}/autonomous-living/scripts
./.venv/bin/python3 scripts/G04_digital_twin_listener.py
```
