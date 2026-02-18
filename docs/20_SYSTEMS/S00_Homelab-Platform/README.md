---
title: "S00: Homelab Platform"
type: "system"
status: "active"
system_id: "system-s00"
owner: "Michał"
updated: "2026-02-16"
review_cadence: "monthly"
---

# S00: Homelab Platform

## Purpose
Provide the underlying infrastructure platform hosting all autonomous living systems. Includes compute, storage, networking, and core services required for running the entire ecosystem.

## Scope
### In Scope
- Docker container orchestration
- PostgreSQL database hosting
- n8n automation engine
- Grafana/Prometheus monitoring
- Home Assistant
- Network infrastructure
- Backup systems

### Out of Scope
- Cloud services (all local)
- Enterprise features
- Multi-user access control

## Interfaces
### Inputs
- System configurations
- Container orchestration commands

### Outputs
- Running services
- API endpoints
- Monitoring data

### APIs/events
- Docker API
- Portainer UI
- SSH access

## Dependencies
### Services
- Docker Engine
- Portainer (container management)
- Traefik (reverse proxy)

### Hardware
- Physical server/NUC
- SSD storage
- Network-attached storage

## Observability
### Logs
- Container logs via Portainer
- System logs

### Metrics
- CPU, memory, disk usage
- Container health

### Alerts
- Container down alerts
- Disk space warnings

## Procedure
1. **Weekly:** Check container status
2. **Monthly:** Review resource usage, plan capacity
3. **Quarterly:** Review security, update images

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Container down | Monitor alert | Check logs, restart container |
| Disk full | Space warning | Clean up old images, expand storage |
| Network issue | Can't reach services | Check router, restart docker |

## Security Notes
- SSH restricted to local network
- No exposed ports beyond reverse proxy
- Regular image updates

## Owner & Review
- **Owner:** Michał
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-16
