---
title: "G05: Autonomous Finance Data & Command Center"
type: "goal"
status: "active"
goal_id: "goal-g05"
owner: "Michał"
updated: "2026-02-15"
---

# G05: Autonomous Finance Data & Command Center

## Intent
Build a **reliable, explainable, and mostly self-driving financial data layer + observability stack** using PostgreSQL + Grafana, eliminating the 98% "fake savings rate" caused by INIT positions and providing **real-time financial intelligence** for autonomous wealth building.

## Definition of Done (2026)
- [ ] PostgreSQL schema is stable, versioned, and documented with proper savings rate calculation
- [ ] Real Savings Rate shows 5-35% range (not 98% from accounting artifacts)
- [ ] Grafana dashboard provides complete financial situational awareness in <30 seconds
- [ ] n8n workflows maintain data synchronization with zero manual intervention
- [ ] Budget alerts trigger within 1 hour of threshold breach
- [ ] All financial logic is traceable to documented SQL functions

## Key Links
- Outcomes: [Outcomes.md](Outcomes.md)
- Metrics: [Metrics.md](Metrics.md)
- Systems: [Systems.md](Systems.md)
- Roadmap: [Roadmap.md](Roadmap.md)

## Database Schema
- Main Schema: [../../../infrastructure/database/finance/schema.sql](../../../infrastructure/database/finance/schema.sql)

## Notes
- **Core Innovation:** Separates "operational income" from "system transactions" (INIT/transfers)
- **Philosophy:** All intelligence in PostgreSQL functions, Grafana only visualizes
- **Current Challenge:** Fixing savings rate calculation to show real wealth-building behavior
- **Grafana Dashboard (V2) Note:** The dashboard is explicitly designed to meet Grafana's strict `rawSql` parsing requirements (single-line, no comments, unquoted aliases with underscores). Refer to [S05: Observability & Financial Dashboards](../20_SYSTEMS/S05_Observability-Dashboards/README.md) for details.
