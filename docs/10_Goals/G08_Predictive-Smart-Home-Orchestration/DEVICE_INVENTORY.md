---
title: "G08 Device Inventory"
type: "reference"
status: "active"
owner: "Michał"
goal_id: "goal-g08"
updated: "2026-03-26"
---

# G08 Smart Home Device Inventory

## Purpose

Comprehensive list of all smart home devices integrated with the autonomous living system.

## Device Categories

### Lighting
| Device | Location | Protocol | Integration |
|--------|----------|----------|-------------|
| Smart bulbs | Living room | Zigbee | Home Assistant |
| Smart bulbs | Bedroom | Zigbee | Home Assistant |
| LED strips | Kitchen | WiFi | Home Assistant |

### Climate
| Device | Location | Protocol | Integration |
|--------|----------|----------|-------------|
| Thermostat | Main | Zigbee | Home Assistant |
| AC Unit | Bedroom | IR | Home Assistant |

### Security
| Device | Location | Protocol | Integration |
|--------|----------|----------|-------------|
| Door sensor | Front door | Zigbee | Home Assistant |
| Motion sensor | Hallway | Zigbee | Home Assistant |
| Camera | Entrance | RTSP | Home Assistant |

### Power Monitoring
| Device | Location | Protocol | Integration |
|--------|----------|----------|-------------|
| Shelly EM | Main panel | WiFi | Home Assistant |
| Smart plugs | Various | WiFi | Home Assistant |

### Environmental
| Device | Location | Protocol | Integration |
|--------|----------|----------|-------------|
| Temperature sensor | Living room | Zigbee | Home Assistant |
| Humidity sensor | Bathroom | Zigbee | Home Assistant |
| CO2 sensor | Office | WiFi | Home Assistant |

## Integration Points

- **Home Assistant:** Central control hub
- **Digital Twin:** State monitoring via REST API
- **n8n:** Automation triggers
- **G08 Scripts:** Data collection and analysis

## Monitoring

Device status is tracked via:
- `G08_home_monitor.py` - Polls Home Assistant REST API
- Low battery alerts via Telegram
- Offline device detection

## Related Documentation

- [G08 Smart Home System](../../10_Goals/G08_Predictive-Smart-Home-Orchestration/README.md)
- [S07 Smart Home System](../../20_Systems/S07_Smart-Home/README.md)

---
*Owner: Michał*
*Last Updated: 2026-03-26*
