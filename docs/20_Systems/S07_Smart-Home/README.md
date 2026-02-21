---
title: "S07: Smart Home"
type: "system"
status: "active"
system_id: "system-s07"
owner: "{{OWNER_NAME}}"
updated: "2026-02-16"
review_cadence: "monthly"
---

# S07: Smart Home

## Purpose
Transform from reactive automation to predictive environmental intelligence. Achieve predictive action rate and Zero Manual Interaction (ZMI) days with context-aware home environment requiring zero manual interaction for routine operations.

## Scope
### In Scope
- Comprehensive sensing network
- Analytics engine
- External context integration
- AI decision engine
- Circadian lighting
- Presence tracking
- Energy optimization

### Out of Scope
- Security system integration
- Voice assistant integration beyond basic control
- Guest access automation

## Interfaces
### Inputs
- Motion/presence sensors
- Environmental sensors (temp/humidity/CO2)
- Power consumption data
- Calendar events
- Weather forecasts

### Outputs
- Automated lighting control
- HVAC adjustments
- Energy optimization
- Presence-based automation

### APIs/events
- Home Assistant core
- mmWave sensor APIs
- Shelly EM power monitoring
- Weather APIs
- Ollama for local AI

## Dependencies
### Services
- Home Assistant (central platform)
- InfluxDB (analytics)
- Ollama (local AI)
- Weather APIs

### Hardware
- mmWave sensors
- ESP32 Bluetooth proxies
- Shelly EM monitors
- Environmental sensors

## Observability
### Logs
- Automation trigger logs
- Sensor data quality logs
- AI decision reasoning
- Failed automations

### Metrics
- Predictive action accuracy
- ZMI days count
- Energy savings
- Automation success rate

## MariaDB Integration
Home Assistant stores all data in MariaDB. See [MariaDB.md](MariaDB.md) for connection details and useful queries.

## Procedure
1. **Daily:** Check automation triggers
2. **Weekly:** Review energy usage, tune automation
3. **Monthly:** Analyze sensor performance
4. **Quarterly:** Review predictive accuracy

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Sensor offline | No data from device | Check connectivity, replace battery |
| HA unreachable | Can't access UI | Check container, restart |
| Automation fails | Unexpected state | Debug trigger, disable if needed |

## Security Notes
- Home Assistant behind authentication
- IoT devices on separate VLAN
- No external access to local network

## Owner & Review
- **Owner:** {{OWNER_NAME}}
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-16
