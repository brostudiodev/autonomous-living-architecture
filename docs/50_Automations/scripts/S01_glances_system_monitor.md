---
title: "Automation Spec: S01 Glances System Monitor"
type: "automation_spec"
status: "active"
automation_id: "S01_glances"
goal_id: "goal-g11"
systems: ["S01"]
owner: "Michał"
updated: "2026-03-28"
---

# S01: Glances System Monitor

## Purpose

Provide real-time Linux system monitoring (CPU, memory, disk, network, processes) integrated with Home Assistant via the Glances sensor integration. Enables visibility into host machine performance from the home automation dashboard.

## Scope

### In Scope
- Linux host system metrics collection
- Home Assistant integration via Glances sensor
- Real-time monitoring dashboard
- System resource alerting

### Out of Scope
- Docker container monitoring (covered by `node-exporter` + Prometheus)
- Application-level metrics
- Network device monitoring

## Inputs/Outputs

### Inputs
- System calls: `psutil`, `pluggy`
- Hardware sensors via Linux kernel

### Outputs
- **Web UI**: http://{{INTERNAL_IP}}:61208
- **Home Assistant**: Sensor entity via `glances` integration
- **JSON API**: http://{{INTERNAL_IP}}:61208/api/3/all

## Dependencies

### Systems
- [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- Home Assistant (for dashboard integration)

### Hardware
- Linux host (Debian/Ubuntu)
- Network connectivity between HA and host

### Credentials
- None required (local network)

## Service Configuration

### systemd Service

Glances runs as a systemd service (not Docker) for direct host access:

```bash
# Service file: /lib/systemd/system/glances.service
[Unit]
Description=Glances Web Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/glances -w -B {{INTERNAL_IP}}
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Status Check:**
```bash
systemctl status glances
```

### Network Configuration

| Setting | Value |
|---------|-------|
| Bind Address | {{INTERNAL_IP}} |
| Port | 61208 |
| Host IP | {{INTERNAL_IP}} |

## Home Assistant Integration

### Configuration

**Option 1: UI**
1. Configuration → Devices & Services → Add Integration
2. Search "Glances"
3. Enter: Host `{{INTERNAL_IP}}`, Port `61208`

**Option 2: YAML**
```yaml
sensor:
  - platform: glances
    host: {{INTERNAL_IP}}
    port: 61208
```

### Available Sensors

| Sensor | Description |
|--------|-------------|
| `sensor.glances_cpu` | CPU usage % |
| `sensor.glances_memory` | Memory usage % |
| `sensor.glances_disk_use_percent` | Disk usage % |
| `sensor.glances_load` | System load (1min) |
| `sensor.glances_process_count` | Running processes |
| `sensor.glances_swap` | Swap usage % |

## Monitoring Metrics

| Metric | Warning | Critical |
|--------|---------|----------|
| CPU | >70% | >90% |
| Memory | >80% | >95% |
| Disk | >85% | >95% |
| Load | >CPU cores | >2x cores |

## Failure Modes

| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Glances service down | HA sensor unavailable | `systemctl start glances` | HA notification |
| Port conflict | Bind error | Check `ss -tlnp \| grep 61208` | N/A |
| High CPU | HA sensor >90% | Check processes | HA automation |

## Maintenance

### Commands
```bash
# Check status
systemctl status glances

# Restart service
systemctl restart glances

# View logs
journalctl -u glances -f

# Test API
curl http://localhost:61208/api/3/all
```

### Updates
```bash
# Update Glances
pip install --upgrade glances

# Or system package
sudo apt update && sudo apt upgrade glances
```

## Manual Fallback

If HA integration fails:

1. **Check service**: `systemctl status glances`
2. **Test locally**: `curl http://localhost:61208/`
3. **Check firewall**: `sudo ufw allow 61208/tcp`
4. **Restart**: `systemctl restart glances`

## Related Documentation

- [S01 Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- [Service Registry - Monitoring Stack](../../20_Systems/Service-Registry.md)
- [Home Assistant Glances Integration](https://www.home-assistant.io/integrations/glances/)
- [Glances Documentation](https://glances.readthedocs.io/)
