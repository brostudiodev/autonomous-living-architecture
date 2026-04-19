---
title: "WF104: Digital Twin Data Ingestion"
type: "automation_spec"
status: "active"
automation_id: "WF104"
goal_id: "goal-g04"
systems: ["S04", "S03"]
owner: "Michal"
updated: "2026-03-26"
---

# WF104: Digital Twin Data Ingestion

## Purpose

Aggregates data from multiple sources (Google Sheets, Obsidian, PostgreSQL) and populates the Digital Twin entities in the S03 Data Layer.

## Triggers

- **Scheduled:** Every 8 hours
- **Manual:** Via n8n UI or Digital Twin API `/sync` endpoint

## Data Sources

| Source | Type | Data Retrieved |
|--------|------|----------------|
| Google Sheets | Goals Progress | Goal milestones, completion status |
| Google Sheets | Daily Activity | Tasks completed, energy levels |
| Obsidian Vault | Daily Notes | Highlights, frustrations, patterns |
| PostgreSQL | Finance | Budget alerts, spending patterns |

## Processing Logic

1. **Extract** - Fetch data from Google Sheets APIs
2. **Transform** - Map to Digital Twin entity schemas
3. **Load** - Update entities in PostgreSQL
4. **Monitor** - Generate data freshness reports

## Dependencies

- [S03 Data Layer](../../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md)
- Google Sheets API

## Related Documentation

- [Digital Twin Data Models](./Data-Models.md)
- [S04 Data Ingestion](./Data-Ingestion.md)

---
*Owner: Michal*
*Review Cadence: Monthly*
