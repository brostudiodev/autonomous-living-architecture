---
title: "Automation Spec: G08 Focus Readiness Pre-Flight"
type: "automation_spec"
status: "active"
system_id: "S08"
goal_id: "goal-g08"
owner: "Michal"
updated: "2026-04-01"
review_cadence: "monthly"
---

# 🤖 Automation Spec: G08 Focus Readiness Pre-Flight

## 🎯 Purpose
Optimize cognitive performance by monitoring physical workspace variables (CO2, Temperature) in the home office 15 minutes before any scheduled "Deep Work" or "Focus" block.

## 📝 Scope
- **In Scope:** Scanning Google Calendar for upcoming focus blocks; Querying Home Assistant sensors; Sending Telegram alerts.
- **Out of Scope:** Automatic control of smart home devices (handled by G08 Home Automation); Modification of calendar events.

## 🔄 Inputs/Outputs
- **Inputs:** 
  - Google Calendar Events (via `G10_calendar_client.py`)
  - `sensor.gabinet_co2`, `sensor.gabinet_temperature` (via Home Assistant API)
- **Outputs:**
  - Telegram alert via `G04_digital_twin_notifier.py`
  - Activity log in `G11_log_system`

## 🛠️ Dependencies
- **Systems:** S08 Smart Home Orchestration, S09 Productivity & Time
- **Services:** Home Assistant, Google Calendar API, Telegram Bot API
- **Credentials:** `HA_TOKEN` and `TELEGRAM_BOT_TOKEN` in `.env`

## ⚙️ Logic & Procedure
1. **Scanning:** Identifies calendar events starting within 15 mins with keywords "Deep Work" or "Focus".
2. **Threshold Monitoring:** 
   - **CO2:** Critical > 1000ppm, Warning > 800ppm.
   - **Temp:** Alert if outside 20-22°C (Optimal focus range).
3. **Procedure:** Script is called automatically via `G11_global_sync.py` every 15 mins.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| HA Unreachable | Timeout error in logs | Check Home Assistant container/network |
| Calendar Empty | "No events found" in log | Verify G10 Calendar sync/OAuth tokens |
| Missing Sensor | Sensor state is "unavailable" | Check Zigbee/WiFi sensor connectivity |

## 🔒 Security Notes
- **Access Control:** HA API requires Long-Lived Access Token.
- **Secrets:** All tokens stored in `.env`. No internal IPs in public documentation.

---
*System Hardening v5.4 - April 2026*
