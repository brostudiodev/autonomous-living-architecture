---
title: "S04: Digital Twin Grafana Dashboard"
type: "system_dashboard_spec"
status: "planning"
system_id: "S04"
owner: "{{OWNER_NAME}}"
updated: "2026-02-09"
---

# S04: Digital Twin Grafana Dashboard

## Purpose
This document outlines the initial design for a Grafana dashboard dedicated to visualizing the current state and key metrics of the S04 Digital Twin. The dashboard will provide a holistic, real-time overview of the Person, Home, and Goal entities, enabling quick insights into the autonomous living ecosystem.

## Integration with S01 Observability
The Digital Twin Grafana Dashboard will be part of the overarching S01 Observability system. It will leverage data primarily from the S03 Data Layer (PostgreSQL), which serves as the persistent store for Digital Twin entities.

## Dashboard Design

### Dashboard UID
`digital-twin-overview` (Proposed)

### Key Panels

#### 1. Person Overview
**Purpose:** Provide a snapshot of the individual's current state and goal progress.
**Data Source:** S03 PostgreSQL (Person entity data).
**Panels:**
- **Current Health Metrics:** Display key health metrics (e.g., current weight, body fat %, sleep score) from `Person.health_metrics`.
- **Activity Level:** Gauge showing current activity level.
- **Goal Progress Summary:** A table or series of gauges showing `Goal.status` and `Goal.progress_metrics` for key goals.
- **Sentiment/Mood (Future):** Graph of daily sentiment/mood from ingested unstructured data.

#### 2. Home Overview
**Purpose:** Visualize the operational status and environmental data of the home.
**Data Source:** S03 PostgreSQL (Home entity data).
**Panels:**
- **Environmental Conditions:** Gauges/graphs for current indoor temperature, humidity, air quality from `Home.environmental_data`.
- **Device Status:** Table or icons showing status of critical smart home devices from `Home.device_inventory`.
- **Occupancy Status:** Text/icon indicating current home occupancy.
- **Energy Consumption (Future):** Graph of historical and real-time energy usage.

#### 3. Goal Tracking
**Purpose:** Monitor the status and progress of individual goals.
**Data Source:** S03 PostgreSQL (Goal entity data).
**Panels:**
- **Active Goals List:** Table showing `Goal.name`, `Goal.status`, `Goal.progress_metrics`, and `Goal.target_date`.
- **Goal Completion Rate:** Percentage of goals completed over time.
- **Dependency Map (Future):** Visual representation of goal dependencies.

#### 4. System Health (Meta-System Context)
**Purpose:** Provide an overview of the Meta-System's health and data integration status relevant to the Digital Twin.
**Data Source:** S01 Observability metrics, potentially S03 (system telemetry).
**Panels:**
- **Data Ingestion Latency:** Graph showing delays in data ingestion pipelines.
- **API Health:** Status of the GraphQL API.
- **Data Quality Alerts:** Number of data quality issues detected in Digital Twin entities.

## Implementation Notes
- **Data Model Mapping:** Ensure clear mapping between PostgreSQL tables/views and Grafana query variables.
- **Custom SQL Queries:** Utilize Grafana's PostgreSQL data source to write custom SQL queries to extract and transform data for panels.
- **Alerting:** Configure Grafana alerts for critical changes in Digital Twin state (e.g., significant health deviations, device failures).

## Next Steps
-   Refine specific queries for each panel.
-   Implement initial Grafana dashboard configuration.
-   Develop data quality checks for ingested data.

## Related Documentation
- [Digital Twin Data Models](./Data-Models.md)
- [Digital Twin Data Ingestion Pipelines](./Data-Ingestion.md)
- [Digital Twin GraphQL API](./GraphQL-API.md)
- [S01 Observability & Dashboards](../../S01_Observability-Dashboards/README.md)
- [S03 Data Layer README](../../S03_Data-Layer/README.md)
