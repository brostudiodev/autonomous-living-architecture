---
title: "G08: Smart Home Device Inventory"
type: "device_inventory"
goal_id: "goal-g08"
updated: "2026-02-18"
---

# Smart Home Device Inventory

## Last Updated: 2026-02-18

## Sensors

| ID | Name | Location | Type | Model | Battery | Integration |
|----|------|----------|------|-------|---------|-------------|
| sensor.temp_11d2 | Temperature/Humidity Sensor 11D2 | - | temp/humidity | Xiaomi LYWSD03MMC | 10% | Xiaomi BLE |
| sensor.temp_500c | Temperature/Humidity Sensor 500C | - | temp/humidity | Xiaomi LYWSD03MMC | 10% | Xiaomi BLE |
| sensor.temp_903f | Temperature/Humidity Sensor 903F | - | temp/humidity | Xiaomi LYWSD02 | - | Xiaomi BLE |
| sensor.temp_8700 | Temperature/Humidity Sensor 8700 | Oliwia pokój | temp/humidity | Xiaomi LYWSD03MMC | - | Xiaomi BLE |
| sensor.temp_a96f | Temperature/Humidity Sensor A96F | - | temp/humidity | Xiaomi LYWSD03MMC | 100% | Xiaomi BLE |
| sensor.temp_b515 | Temperature/Humidity Sensor B515 | Podwórko | temp/humidity | Xiaomi LYWSD03MMC | 50% | Xiaomi BLE |

## Cameras

| ID | Name | Location | Model | Integration |
|----|------|----------|-------|-------------|
| camera.garage | Sypialnia garaz | Garaż | Hikvision | Hikvision |
| camera.terrace | Taras Tyl | - | - | Frigate 5.14.1/0.16.1 |

## Smart Plugs

| ID | Name | Location | Model | Integration |
|----|------|----------|-------|-------------|
| switch.plug_kitchen | Smart plug | Kuchnia | Tuya | Tuya |
| switch.plug_rack | Szafa Rack HA | Garaż | Tuya | Tuya |

## Doorbells

| ID | Name | Location | Model | Integration |
|----|------|----------|-------|-------------|
| doorbell.ipbox | SmartDoorBell-IPBox | Podwórko | Tuya | Tuya |

## Air Quality

| ID | Name | Location | Source | Integration |
|----|------|----------|--------|-------------|
| sensor.air_jelenia | Stacja Jelenia Góra | - | GIOŚ | GIOŚ |

## Infrastructure

| ID | Name | Type | Notes |
|----|------|------|-------|
| coordinator.zigbee | Texas Instruments CC2652 | Zigbee Coordinator | Garage |
| assistant.snowboy | snowboy | Voice Assistant | - |

## Add-ons & Integrations

| Name | Type | Version |
|------|------|---------|
| Home Assistant | Core | Latest |
| HACS | Integration | - |
| Sonoff LAN | Integration | - |
| Frigate | Add-on | 5.14.1/0.16.1-e664cb2 |
| Tailscale | Add-on | - |
| ZeroTier One | Add-on | - |
| Whisper | Add-on | - |
| Rhasspy | Add-on | - |
| TasmoAdmin | Add-on | - |
| SpeedTest | Integration | - |

## Planned Additions

- [ ] More smart plugs
- [ ] Motion sensors
- [ ] Smart lights (Zigbee)
- [ ] Thermostat control
