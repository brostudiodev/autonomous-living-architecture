---
title: "G08_environment_advisor: Home Context Intelligence"
type: "automation_spec"
status: "active"
automation_id: "G08_environment_advisor"
goal_id: "goal-g08"
systems: ["S04", "S07"]
owner: "Michał"
updated: "2026-03-25"
---

# G08_environment_advisor: Home Context Intelligence

## Purpose
Analyzes real-time environmental data (Indoor/Outdoor Temp, AQI, Lighting) from Home Assistant and provides proactive advice for comfort, health, and energy optimization.

## Triggers
- **Morning/Daily Briefing:** Executed via `autonomous_daily_manager.py`.
- **Global Sync:** Included in `G11_global_sync.py`.

## Inputs
- **Home Assistant API:** Real-time sensor states (`sensor.outside_temperature`, `sensor.living_room_temperature`, `switch.circadian_lighting`, etc.).
- **Time of Day:** System clock for circadian logic.

## Processing Logic
1. **Thermal Optimization:**
   - Compares outdoor vs. indoor temperatures.
   - Recommends natural cooling (opening windows) in the morning if outdoor < indoor.
   - Recommends heat mitigation (closing blinds) if high solar gain is predicted.
2. **Circadian Hygiene:**
   - Checks `switch.circadian_lighting` status.
   - Suggests enabling after 18:00 if currently OFF to optimize melatonin.
3. **Air Quality:**
   - Monitors PM2.5/AQI levels from air purifiers.
   - Recommends active purification if thresholds are breached.

## Outputs
- **Markdown Report:** Injected into the Daily Note under `%%ENVIRONMENT_START%%`.
- **System Activity Log:** Success/Failure status.

## Dependencies
### Systems
- [S07 Smart Home System](../../20_Systems/S07_Smart-Home/README.md) (Home Assistant)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### Credentials
- `HA_URL` and `HA_TOKEN` via `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| HA API Timeout | Requests timeout | Skip report, log error | Warning in Daily Note |
| Entity Missing | 404 from HA API | Skip specific sensor advice | Console warning |

## Monitoring
- Success metric: Daily environment insights generated.

## Related Documentation
- [G08_home_monitor](./G08_home_monitor.md)
- [G08_pre_bed_advisor](./G08_pre_bed_advisor.md)
