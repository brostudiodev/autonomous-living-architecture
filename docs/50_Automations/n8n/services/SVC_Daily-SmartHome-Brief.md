---
title: "SVC: Daily SmartHome Brief"
type: "service_spec"
status: "inactive"
service_id: "SVC_Daily-SmartHome-Brief"
goal_id: "goal-g08"
systems: ["S04", "S07", "S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Daily SmartHome Brief

## Purpose
Provides daily smart home status updates including indoor/outdoor temperatures, energy consumption, device states, and security status. Currently marked as inactive in n8n - may need activation. Was scheduled to run at 6:48 AM as part of the morning briefing system.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Schedule Trigger** | Cron/Interval | Daily at 06:48 (currently disabled) |

**Workflow ID:** `MNb0JIS5fbhHiLx1`

**Note:** Workflow is currently marked as inactive (`active: false`) in n8n.

## Processing Flow

```
┌─────────────────────────────────┐
│   Schedule: Daily 6:48 AM       │  Cron: Every day at 06:48 (DISABLED)
└────────────┬────────────────────┘
             │
    ┌────────┼────────┬────────┐
    ▼         ▼         ▼         ▼
┌─────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│ Outdoor │ │ Indoor │ │Energy  │ │ Device │
│  Temp   │ │  Temp  │ │   -    │ │ Status │
└────┬────┘ └───┬────┘ └───┬────┘ └──┬─────┘
     │         │         │         │
     └─────────┼─────────┼─────────┘
               ▼
┌─────────────────────────────────┐
│        Merge Data               │  Merge: Combine all sensors
└────────────┬────────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│      Format Home Brief          │  Code: Format for Telegram
└────────────┬────────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│      Send Telegram              │  Telegram: Notify user
└─────────────────────────────────┘
```

## Data Sources (Home Assistant)

| Sensor | Entity | Description |
|--------|--------|-------------|
| Outdoor Temp | `sensor.outdoor_temperature` | Outside temperature |
| Indoor Temp | `sensor.indoor_temperature` | Inside temperature |
| Energy | `sensor.energy_consumption` | Daily energy usage |
| Device Status | Various | Lights, switches, security |

**Note:** All HTTP nodes are currently disabled in the workflow.

## Detailed Processing Logic

### Stage 1: Schedule Trigger
- **Node:** `Schedule: Daily 6:48 AM`
- Would run every day at 06:48 local time
- **Currently DISABLED**

### Stage 2: Sensor Collection (Parallel, Currently Disabled)

**Outdoor Temperature:**
- **Node:** `HA: Outdoor Temp`
- **Endpoint:** `http://{{INTERNAL_IP}}:8123/api/states/sensor.outdoor_temperature`

**Indoor Temperature:**
- **Node:** `HA: Indoor Temp`
- **Endpoint:** `http://{{INTERNAL_IP}}:8123/api/states/sensor.indoor_temperature`

**Energy Consumption:**
- **Node:** `HA: Energy`
- **Endpoint:** `http://{{INTERNAL_IP}}:8123/api/states/sensor.energy_consumption`

### Stage 3: Data Merge
- **Node:** `Merge Data`
- Combines all sensor data

### Stage 4: Formatting & Delivery
- Formats data for Telegram
- Sends to user

## Outputs

```
🏠 **SMART HOME STATUS**

🌡️ **Temperatura:**
- Na zewnątrz: 12°C
- W domu: 22°C
- Różnica: +10°C

⚡ **Energia:**
- Dzisiaj: 8.5 kWh
- Stan: Normalny

🔌 **Urządzenia:**
- Oświetlenie: Włączone (3)
- Ogrzewanie: Aktywne
- Stan: Wszystko OK

🔒 **Bezpieczeństwo:**
- Bramka: Zamknięta
- Czujniki: OK
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - Data aggregation
- [S07 Smart Home System](../../../20_Systems/S07_Smart-Home/README.md) - Home Assistant integration
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution

### External Services
- **Home Assistant** - Smart home sensors and devices

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| HA timeout | HTTP timeout | Continue (continueOnFail: true) | None |
| Sensor unavailable | Null response | Skip in merge | None |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/MNb0JIS5fbhHiLx1/execute \
  -H "Content-Type: application/json"
```

### Direct HA API test:
```bash
curl -s -H "Authorization: Bearer ${HA_TOKEN}" \
  "http://{{INTERNAL_IP}}:8123/api/states"
```

## Why Disabled?

The workflow is currently disabled. Possible reasons:
1. Replaced by other services (G08 Smart Home integration)
2. Redundant with morning briefing from Digital Twin
3. Device sensors changed/renamed in Home Assistant
4. Manual activation preferred

## Security Notes

- **Hardcoded IP:** `{{INTERNAL_IP}}` - Should use `{{INTERNAL_IP}}` placeholder
- **HA Token:** Uses Long-Lived token - secure storage required
- **No Auth:** Workflow internal-only

---

*Documentation synchronized with svc_daily-smarthome-brief.json v1.0 (2026-04-10)*