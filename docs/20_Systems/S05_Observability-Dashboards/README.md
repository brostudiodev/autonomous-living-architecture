---
title: "S05: Observability Dashboards"
type: "system"
status: "active"
system_id: "system-s05"
owner: "Michał"
updated: "2026-04-08"
---

# S05: Observability Dashboards

## Purpose
Visualizes the state of the Digital Twin, Finance, and Health systems through interactive Grafana dashboards. Provides a high-level executive view of the 12 Power Goals progress.

## Architecture
- **Engine:** Grafana (Docker).
- **Data Sources:** PostgreSQL, Prometheus, Home Assistant (MariaDB).
- **Access:** Local network restricted.

## Key Dashboards
1. **Digital Twin Executive:** Holistic system health and goal progress.
2. **Autonomous Finance:** Real-time budget utilization and liquidity.
3. **Biological Performance:** HRV trends, recovery scores, and weight tracking.

---
*Created: 2026-04-08 | Part of G11 Meta-System Integration*
