---
title: "Adr-0009: Centralized Observability Stack"
type: "decision"
status: "accepted"
date: "2026-04-29"
deciders: ["Michał"]
---

# Adr-0009: Centralized Observability Stack

## Status
Accepted

## Context
As the autonomous ecosystem grows, we need a unified way to monitor system health, script execution performance, and goal progress. Relying on scattered log files makes it difficult to detect trends or multi-domain failures (e.g., a database connection issue affecting both Health and Finance).

## Decision
We implement a centralized observability stack using industry-standard tools:
1.  **Prometheus:** Acts as the central time-series database for all metrics.
2.  **Grafana:** Provides the visualization layer for system and domain-specific dashboards.
3.  **Custom Exporters:** Python scripts (`g01-exporter.py`, `goals-exporter.py`) expose domain metrics via HTTP `/metrics` endpoints for Prometheus scraping.
4.  **Health Probes:** `G11_startup_probe.py` and `G04_digital_twin_monitor.py` provide real-time liveness/readiness signals.

## Consequences
- **Positive:** Single pane of glass for system health. Proactive alerting (via n8n/Telegram) on metric thresholds.
- **Negative:** Adds complexity to the infrastructure. Requires maintaining custom exporter scripts.

## Implementation
- `infrastructure/prometheus/prometheus.yml` (Scrape configuration)
- `infrastructure/scripts/g01-exporter.py` (Strength training metrics)
- `infrastructure/scripts/goals-exporter.py` (Goal progress and task metrics)
- Grafana Dashboards (Visual Layer)
