---
title: "G08_pre_bed_advisor: Proactive Sleep Environment Advisor"
type: "automation_spec"
status: "active"
automation_id: "G08_pre_bed_advisor"
goal_id: "goal-g08"
systems: ["S07", "S08"]
owner: "Michał"
updated: "2026-04-28"
---

# G08_pre_bed_advisor: Proactive Sleep Environment Advisor

## Purpose

Predicts and optimizes sleep recovery by auditing the bedroom environment before bedtime. Sends proactive Telegram alerts at 21:00 if conditions (temperature) are sub-optimal, allowing the user to adjust the environment (ventilation/cooling) before 22:30.

## Triggers

- **Scheduled:** Daily at 21:00 via **crontab**
- **Manual:** `python scripts/G08_pre_bed_advisor.py`

## Inputs

| Source | Data | Used For |
|--------|------|----------|
| Home Assistant | Bedroom temperature sensor | Environment audit |
| System Clock | Current hour | Trigger validation |
| PostgreSQL | `digital_twin_michal` database | System activity logging |

## Processing Logic

1. **Check Hour** - Logic ensures advice is relevant to pre-bed window (typically 21:00).

2. **Fetch Temperature** - Query Home Assistant for `sensor.temperature_humidity_sensor_8700_temperature`.
   - Fallback to generic temperature sensors if specific ID is missing.

3. **Audit Against Ideal Range** - Target range is 16.0°C - 20.0°C.
   - Temp > 20.0°C → "Bedroom too warm" (Action required).
   - Temp < 16.0°C → "Bedroom too cold" (Action required).
   - Within range → "Environment optimal" (No action required).

4. **Proactive Advice** - If action is required, send Telegram alert with specific instructions (e.g., "Open a window now").

## Outputs

| Output | Location | Format |
|--------|----------|--------|
| Sleep Prep Alert | Telegram Messenger | Push Notification |
| Activity Log | `system_activity_log` table | PostgreSQL |

### Example Alert

```text
🌙 **PRE-BED SLEEP ADVISOR** 🌙

⚠️ **Bedroom is too warm:** 22.4°C
Ideal range is 16.0-20.0°C.
👉 **Action:** Open a window or turn on the AC/Fan now to cool it down before 22:30.
```

## Dependencies

### Systems
- [S07 Smart Home](../../20_Systems/S07_Smart-Home/README.md) - Temperature sensors
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - Integration

### Scripts
- `G08_home_monitor.py` - Home Assistant data fetcher
- `G04_digital_twin_notifier.py` - Telegram notification engine
- `G11_log_system.py` - Activity logging

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| HA unreachable | Exception in `get_ha_states()` | Log failure, no alert |
| Sensor missing | `temp is None` after search | Log warning |
| Telegram API error | Return `False` from `send_telegram_message()` | Log failure |

## Security Notes

- No direct device control (notification-only)
- Respects Mandate G08: No automated environmental control
- HA token stored in `.env`

## Monitoring

- **Success metric:** Advisor runs and evaluates conditions nightly
- **Alert on:** Failure to reach Home Assistant
- **Dashboard:** Check `system_activity_log` for `G08_pre_bed_advisor`

## Manual Fallback

If script fails:
```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate
python scripts/G08_pre_bed_advisor.py
```

## Related Documentation

- [G08 Roadmap](../../10_Goals/G08_Predictive-Smart-Home-Orchestration/Roadmap.md)
- [G08 Environmental Sleep Auditor](./G08_environmental_sleep_auditor.md)
- [G08 Home Monitor](./G08_home_monitor.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-23 | Initial implementation (v1.0) |
| 2026-03-23 | Integrated into `G11_global_sync.py` |
| 2026-03-27 | Moved to 21:00 crontab to prevent early morning alerts. |
