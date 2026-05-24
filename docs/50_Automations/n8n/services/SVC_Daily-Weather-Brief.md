---
title: "SVC: Daily Weather Brief"
type: "service_spec"
status: "active"
service_id: "SVC_Daily-Weather-Brief"
goal_id: "goal-g08"
systems: ["S04", "S07", "S08"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC: Daily Weather Brief

## Purpose
Provides daily weather updates by combining data from OpenWeatherMap API (current weather + 5-day forecast) and local Home Assistant sensors (outdoor temperature). Runs automatically at 6:47 AM as part of the morning briefing system.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Schedule Trigger** | Cron/Interval | Daily at 06:47 |
| **Workflow Trigger** | Execute Workflow | Manual execution |

**Workflow ID:** `pAGuUm0mSVznnuz9`

## Processing Flow

```
┌─────────────────────────────────┐
│   Schedule: Daily 6:47 AM       │  Cron: Every day at 06:47
└────────────┬────────────────────┘
             │
    ┌────────┼────────┬─────────┐
    ▼         ▼         ▼
┌─────────┐ ┌────────┐ ┌─────────┐
│ Weather │ │Forecast│ │  HA     │
│  (now)  │ │ (5day) │ │  Temp   │
└────┬────┘ └───┬────┘ └──┬─────┘
     │         │         │
     └─────────┼─────────┘
               ▼
┌─────────────────────────────────┐
│      Merge All Sources          │  Merge: Combine 3 data sources
└────────────┬────────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│      Format Weather Brief       │  Code: Format for Telegram
└────────────┬────────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│      Send Telegram              │  Telegram: Notify user
└─────────────────────────────────┘
```

## Data Sources

| Source | Endpoint | Data |
|--------|-----------|------|
| OpenWeatherMap (Current) | `weather?q={{LOCATION_CITY_SHORT}}+Wielkie,PL` | Temperature, humidity, conditions |
| OpenWeatherMap (Forecast) | `forecast?q={{LOCATION_CITY_SHORT}}+Wielkie,PL` | 5-day forecast |
| Home Assistant | `api/states/sensor.temperatura_podworko` | Local outdoor temp |

## Detailed Processing Logic

### Stage 1: Schedule Trigger
- **Node:** `Schedule: Daily 6:47 AM`
- Runs every day at 06:47 local time
- Activates the workflow for morning briefing

### Stage 2: Data Collection (Parallel)

**Weather - Current:**
- **Node:** `OpenWeatherMap: Get Weather`
- **Endpoint:** `https://api.openweathermap.org/data/2.5/weather`
- **Location:** {{LOCATION_CITY}}, PL
- **Units:** Metric
- **Note:** API key hardcoded - should use env variable

**Weather - Forecast:**
- **Node:** `OpenWeatherMap: Get Forecast`
- **Endpoint:** `https://api.openweathermap.org/data/2.5/forecast`
- **Returns:** 5-day forecast (40 items, 3-hour intervals)

**Home Assistant Local:**
- **Node:** `HA: Get Outdoor Temp`
- **Endpoint:** `http://{{INTERNAL_IP}}:8123/api/states/sensor.temperatura_podworko`
- **Auth:** Bearer token (LL Token)
- **Note:** IP should be `{{INTERNAL_IP}}` placeholder

### Stage 3: Data Merge
- **Node:** `Merge All Sources`
- Combines all three data sources into unified structure

### Stage 4: Formatting
- **Node:** `Format Weather Brief`
- Formats data for Telegram display

### Stage 5: Delivery
- **Node:** `Send Telegram`
- Sends weather brief to user's chat

## Outputs

```
🌤️ **POGODA NA DZISIAJ**
📍 {{LOCATION_CITY}}

🌡️ **Temperatura:**
- Odczuwalna: 18°C
- Min: 12°C / Max: 22°C
- Wilgotność: 65%

🌤️ **Warunki:**
- Partly cloudy
- Wiatr: 12 km/h

🏠 **Lokalna temp (HA):**
- 19.5°C

📅 **Prognoza (5 dni):**
- Pon: ⛅ 20°C
- Wt: 🌧️ 17°C
- Śr: ⛅ 19°C
...
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/README.md) - Data aggregation
- [S07 Smart Home System](../../../20_Systems/README.md) - Local sensors
- [S08 Automation Orchestrator](../../../20_Systems/README.md) - Workflow execution

### External Services
- **OpenWeatherMap API** - Weather data
- **Home Assistant** - Local temperature sensor

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| OpenWeatherMap timeout | HTTP timeout (10s) | Continue (continueOnFail: true) | None |
| Home Assistant timeout | HTTP timeout (10s) | Continue (continueOnFail: true) | None |
| API key invalid | HTTP 401 | Continue, missing data | Log to console |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/pAGuUm0mSVznnuz9/execute \
  -H "Content-Type: application/json"
```

### Direct API test:
```bash
curl -s "https://api.openweathermap.org/data/2.5/weather?q={{LOCATION_CITY_SHORT}}+Wielkie,PL&units=metric&appid=${API_KEY}"
```

## Security Notes

- **Hardcoded API Key:** `[API_KEY]` - Should use env variable
- **Hardcoded IP:** `{{INTERNAL_IP}}` - Should use `{{INTERNAL_IP}}` placeholder
- **HA Token:** Uses Long-Lived token - secure storage required

## Related Services

- [SVC_Daily-Calendar-Brief.md](SVC_Daily-Calendar-Brief.md) - Calendar morning brief
- [SVC_Daily-Tasks-Brief.md](SVC_Daily-Tasks-Brief.md) - Tasks from Roadmaps
- [SVC_Daily-SmartHome-Brief.md](SVC_Daily-SmartHome-Brief.md) - Smart home status
- [SVC_Daily-Workout-Suggestion.md](SVC_Daily-Workout-Suggestion.md) - Training recommendation

---

*Documentation synchronized with svc_daily-weather-brief.json v1.0 (2026-04-10)*