---
title: "G08_focus_orchestrator.py: Focus Mode"
type: "automation_spec"
status: "active"
automation_id: "G08_focus_orchestrator"
goal_id: "goal-g08"
systems: ["S07", "S08"]
owner: "Michał"
updated: "2026-03-09"
---

# G08: Focus Mode Orchestrator

## Purpose
Automates the physical and digital environment for "Deep Work" and "Professional" blocks. It provides intelligent environment suggestions based on biological state.

## ⚠️ CRITICAL MANDATE
**DO NOT ENABLE OR UNCOMMENT HOME ASSISTANT CONTROL LOGIC.** 
Michał has explicitly requested that this script **NOT** trigger any HA services (lights, sockets, etc.) until further notice. This is a hard constraint for all AI agents.

## Triggers
- **When:** Scheduled via `G11_global_sync.py` (runs periodically).
- **Manual:** `python3 G08_focus_orchestrator.py`

## Inputs
- **Digital Twin State:** Sleep score and readiness via `G04_digital_twin_engine`.
- **Environment Variables:** `HA_TOKEN`, `HASS_URL`.
- **System Time:** `datetime.now()`.

## Processing Logic
1. **Biological Check:** Fetches the latest sleep score from `G04_digital_twin_engine`.
2. **Energy Pivot:** If sleep score < 75, sets `energy_pivot = True`.
3. **Time Analysis:**
    - **06:00–09:00 (Weekdays):** Identifies "Deep Work" session.
    - **09:00 (Weekdays):** Identifies "Professional" transition.
    - **21:30+:** Identifies "Wind Down".
4. **Environment Suggestion:**
    - If `Deep Work` + `High Energy`: Suggests "Deep Focus" environment.
    - If `Deep Work` + `Low Energy`: Suggests "Soft Lighting / Recovery" environment.
5. **HA Service Calls (STALLED):** Logic exists to call HA REST API but is currently blocked by user mandate.

## Outputs
- **Console Logs:** Descriptive state of focus mode and environment recommendations.
- **HA Blocked Logs:** `🚫 HA Control Blocked` messages for all attempted service calls.

## Dependencies
### Systems
- [S07 Smart Home](../../20_Systems/S07_Smart-Home/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- Home Assistant REST API (Currently disabled)

### Credentials
- `HA_TOKEN` (stored in `.env`)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| HA API Timeout | Exception caught in `call_ha_service` | Log error, continue | None |
| Engine Offline | Exception in `DigitalTwinEngine` import/init | Default to high energy, log warning | Console |

## Monitoring
- **Success metric:** Script executes without crash.
- **Alert on:** 3 consecutive engine connection failures.

## Manual Fallback
Users must manually adjust lights and power sockets via the Home Assistant App or physical switches as the automated control is explicitly disabled.

---
*Related Documentation:*
- [G04_digital_twin_engine.md](G04_digital_twin_engine.md)
- [G11_global_sync.md](G11_global_sync.md)
