---
title: "G08: Sleep Environment Auditor"
type: "automation_spec"
status: "active"
automation_id: "G08_environmental_sleep_auditor"
goal_id: "goal-g08"
systems: ["S08", "S07"]
owner: "Michal"
updated: "2026-04-18"
---

# G08: Sleep Environment Auditor

## Purpose
Proactively monitors the bedroom environment (Temperature/Humidity) to ensure optimal sleep conditions as defined by historical recovery data.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- Home Assistant API: `sensor.bedroom_temperature` (or similar).

## Processing Logic
1. **Fetch:** Get current states from Home Assistant.
2. **Filter:** Extract the bedroom-specific temperature sensor value.
3. **Compare:** Evaluate against the Ideal Sleep Zone (16.0°C - 20.5°C).
4. **Alert:** If sub-optimal, generate a warning for the Daily Note.

## Outputs
- Environmental audit report in the Daily Note.
- Activity log entry.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| HA API Unreachable | `requests.ConnectionError` | Log failure, skip | Log Warning |
| Sensor Unavailable | State is 'unknown' | Log missing data | Log Info |
