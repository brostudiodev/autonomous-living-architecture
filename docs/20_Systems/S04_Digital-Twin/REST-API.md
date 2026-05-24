---
title: "S04: Digital Twin REST API"
type: "system_api_spec"
status: "active"
system_id: "S04"
owner: "Michał"
updated: "2026-05-10"
---

# S04: Digital Twin REST API

## Purpose
This document specifies the FastAPI-based REST API layer for the S04 Digital Twin system. This API provides a high-performance, standardized interface for querying and updating the state of the Digital Twin entities (Person, Home, Goal, etc.). It serves as the central gateway for all intelligent agents and sub-systems to interact with the twin's data, replacing the legacy GraphQL implementation with a more robust and scalable FastAPI Gateway.

## Architecture
The REST API acts as a production-grade gateway over the S03 Data Layer (PostgreSQL) and the RabbitMQ event bus. It is implemented using **FastAPI** and serves as the primary orchestration point for the autonomous ecosystem.

### Key Components
- **FastAPI Gateway:** Main entry point (Port 5677) for all external and internal requests.
- **Pydantic Models:** Strict type validation for all incoming and outgoing data (Person, Home, Goal schemas).
- **Event Bus Integration:** Native bridge to RabbitMQ for real-time event emission and consumption.
- **Tool Registry:** Integrated management of **144 validated tools** accessible via the `/execute_tool` endpoint.
- **WebSocket Bridge:** Real-time system event stream available at `/ws`.

## Core REST Endpoints

### 1. System Aggregation
| Endpoint | Method | Description |
|---|---|---|
| `/all` | GET | Returns the complete system context (Person, Home, Goals). |
| `/status` | GET | Quick health check of all sub-systems and databases. |
| `/health/ready` | GET | Deep readiness check (PostgreSQL + RabbitMQ + Engine). |

### 2. Entity Management
| Endpoint | Method | Description |
|---|---|---|
| `/person/{id}` | GET | Fetch a single Person by ID. |
| `/person/update` | POST | Update Person metrics and preferences. |
| `/home/{id}` | GET | Fetch Home environmental and device status. |
| `/goals` | GET | List all goals (filterable by status/domain). |
| `/goals/{id}` | GET | Fetch detailed progress for a specific goal. |
| `/state/update` | POST | Unified endpoint for pushing telemetry to any entity. |

### 3. Autonomous Operations
| Endpoint | Method | Description |
|---|---|---|
| `/tools` | GET | List all **144 validated tools** in the registry. |
| `/execute_tool` | POST | Trigger a G-series script with specific parameters. |
| `/emit` | POST | Manually emit an event to the `life.events` bus. |
| `/suggested` | GET | Retrieve the current autonomous mission report. |

## Data Models
The API uses the schemas defined in [Data Models](Data-Models.md). All responses are standardized JSON.

### Example: Person Entity Response
```json
{
  "person_id": "michal",
  "name": "Michał",
  "health_metrics": {
    "focus_score": 85,
    "sleep_quality": "good"
  },
  "activity_level": "moderate",
  "last_updated": "2026-05-10T12:00:00Z"
}
```

## Authentication & Authorization
- **Security:** API Key based authentication for internal services.
- **Rate Limiting:** Enforced via FastAPI middleware to protect the S03 Data Layer.

## Deployment
The REST API is deployed as a Dockerized service within the `autonomous-living` stack, exposed on port **5677**.

## Related Documentation
- [Digital Twin Data Models](Data-Models.md)
- [Digital Twin Data Ingestion Pipelines](Data-Ingestion.md)
- [S03 Data Layer README](../README.md)
- [Agent-Registry](Agent-Registry.md)
