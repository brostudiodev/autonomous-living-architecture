---
title: "Adr-0007: Multi-Channel Data Ingestion"
type: "decision"
status: "accepted"
date: "2025-08-15"
deciders: ["Michał"]
---

# Adr-0007: Multi-Channel Data Ingestion

## Status
Accepted

## Context
The ecosystem requires data from multiple sources: physical sensors (Amazfit, Withings), manual user input (Telegram, Google Sheets), and system logs. We need a consistent strategy to ingest this data into the central PostgreSQL Data Layer (S03).

## Decision
We implement a "Spoke-to-Hub" ingestion model:
1.  **Cloud APIs:** G-series scripts (Python) fetch from Zepp, Withings, and OpenWeather.
2.  **User Input:** n8n Webhooks handle incoming Telegram commands and Google Sheets updates.
3.  **Flat Files:** `G10_intelligence_sync.py` parses Obsidian daily notes.
4.  **Local IoT:** `G08_home_monitor.py` queries the Home Assistant REST API.

## Consequences
- **Positive:** Diverse data sources are unified in a single schema. Enables cross-domain AI analysis.
- **Negative:** Multiple points of failure if external APIs change. Requires robust error handling in n8n.

## Implementation
- `docs/20_Systems/S03_Data-Layer/Data-Ingestion.md` (Technical Spec)
- n8n Workflows in `WF100-series`.
