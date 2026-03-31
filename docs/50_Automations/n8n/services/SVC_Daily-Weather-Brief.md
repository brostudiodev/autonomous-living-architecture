---
title: "SVC_Daily-Weather-Brief"
type: "automation_n8n"
status: "active"
service_id: "svc-daily-weather"
owner: "Michal"
created: "2026-02-20"
updated: "2026-02-20"
trigger: "schedule"
schedule: "6:47 AM daily"
tags:
  - daily-brief
  - weather
  - home-assistant
---

# SVC_Daily-Weather-Brief

Automated morning weather report with forecast and Home Assistant sensor data.

## Overview

| Attribute | Value |
|-----------|-------|
| **Type** | n8n workflow |
| **ID** | `SVC_Daily-Weather-Brief` |
| **Trigger** | Schedule: Daily at 6:47 AM |
| **Status** | Active |
| **Goal** | G10 - Intelligent Productivity |

## Data Sources

1. **OpenWeatherMap API** - Current weather + 5-day forecast
   - Location: {{LOCATION_CITY}}, PL
   - API Key: Configured in HTTP node

2. **Home Assistant** - Local sensor
   - Entity: `sensor.temperatura_podworko` (backyard temperature)
   - URL: `http://[INTERNAL_IP]:8123`
   - Auth: Bearer token

## Outputs

**Telegram message** to chat `{{TELEGRAM_CHAT_ID}}` containing:

```
☀️ Weather - {{LOCATION_CITY}}

🌡️ Now: 5°C (feels like 3°C)
🏠 Backyard: 4.2°C

📊 Forecast today:
🌅 Morning: ☁️ 6°C (feels 4°C)
🌆 Evening: 🌧️ 4°C (feels 1°C)
🌙 Night: ❄️ 2°C (feels -1°C)

💧 Humidity: 78%
💨 Wind: 3.2 m/s

🌅 Sunrise: 07:15
🌇 Sunset: 17:42

👕 Dress: 🧥 Light jacket or hoodie
```

## Features

- **Current conditions**: Temperature, feels-like, humidity, wind
- **Backyard temp**: Local HA sensor for accurate local reading
- **3-day forecast**: Morning, evening, night predictions
- **Clothing suggestions**: Based on temperature and conditions
- **Resilient**: Each data source runs in parallel; failures don't block others

## Error Handling

- `continueOnFail: true` on all HTTP requests
- Graceful degradation if OWM or HA is unavailable
- Error messages included in Telegram output if data missing

## Dependencies

- **n8n credentials**:
  - `Telegram (AndrzejSmartBot)` - for sending messages
  - `Home Assistant LL Token` - for local sensor access
- **External APIs**:
  - OpenWeatherMap API key (embedded in URL)

## Related

- [[SVC_Daily-Calendar-Brief]] - Calendar morning brief
- [[SVC_Daily-Tasks-Brief]] - Tasks from Roadmaps
- [[SVC_Daily-SmartHome-Brief]] - Smart home status
- [[SVC_Daily-Workout-Suggestion]] - Training recommendation
