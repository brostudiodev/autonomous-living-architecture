---
title: "S04: Digital Twin Data Models"
type: "system_data_models"
status: "draft"
system_id: "S04"
owner: "Michał"
updated: "2026-02-09"
---

# S04: Digital Twin Data Models

## Purpose
This document defines the core data models for the Digital Twin entities. These models serve as the foundational structure for representing the various aspects of the "autonomous living" ecosystem, enabling a unified and consistent view across different goals and systems.

## Core Entities

### 1. Person Entity
Represents the individual operating the autonomous living ecosystem. This entity aggregates personal data, preferences, health metrics, and goal progress.

**Schema:**

| Field Name | Data Type | Description | Constraints / Notes |
|---|---|---|---|
| `person_id` | UUID | Unique identifier for the person. | Primary Key |
| `name` | String | Full name of the person. | |
| `date_of_birth` | Date | Person's date of birth. | |
| `gender` | String | Biological gender. | Enum: 'Male', 'Female', 'Other' |
| `contact_email` | String | Primary contact email. | Unique, Valid Email Format |
| `timezone` | String | IANA Time Zone Database format (e.g., 'Europe/Warsaw'). | |
| `current_location_id` | UUID | Foreign Key to `Location` entity (e.g., current home). | |
| `health_metrics` | JSONB | Aggregated health data (e.g., weight, body fat %, sleep score). | Structure defined in G07 |
| `preferences` | JSONB | User preferences (e.g., dietary restrictions, automation preferences). | |
| `activity_level` | String | Self-reported or tracked activity level. | Enum: 'Sedentary', 'Light', 'Moderate', 'Active', 'Very Active' |
| `goals_progress` | JSONB | Summary of progress across all defined goals. | Derived from `Goal` entities |
| `last_updated` | Timestamp | Timestamp of the last update to this entity. | Auto-managed |

### 2. Home Entity
Represents the physical living space and its associated smart devices, environmental data, and operational status.

**Schema:**

| Field Name | Data Type | Description | Constraints / Notes |
|---|---|---|---|
| `home_id` | UUID | Unique identifier for the home. | Primary Key |
| `name` | String | User-friendly name for the home (e.g., 'Main Residence', 'Summer House'). | |
| `address` | JSONB | Full postal address. | Contains fields like street, city, postal_code, country |
| `location_coordinates` | GEOGRAPHY(Point, 4326) | Geographical coordinates (latitude, longitude). | For geo-spatial queries |
| `environmental_data` | JSONB | Aggregated smart home sensor data (e.g., temperature, humidity, air quality). | Structure defined in G08 |
| `device_inventory` | JSONB | List of smart devices, their status, and integrations. | Structure defined in G08 |
| `occupancy_status` | String | Current occupancy status of the home. | Enum: 'Occupied', 'Vacant', 'Away' |
| `operational_status` | String | Overall operational health of home systems (e.g., 'Optimal', 'Degraded', 'Alert'). | Derived from device statuses |
| `last_updated` | Timestamp | Timestamp of the last update to this entity. | Auto-managed |

### 3. Goal Entity
Represents an individual goal, tracking its definition, associated metrics, progress, and dependencies.

**Schema:**

| Field Name | Data Type | Description | Constraints / Notes |
|---|---|---|---|
| `goal_id` | UUID | Unique identifier for the goal. | Primary Key |
| `goal_code` | String | Short code for the goal (e.g., 'G01', 'G03'). | Unique, Maps to existing goal documentation |
| `name` | String | Human-readable name of the goal. | |
| `description` | Text | Detailed description of the goal's purpose and scope. | |
| `owner_person_id` | UUID | Foreign Key to `Person` entity (owner of the goal). | |
| `status` | String | Current status of the goal. | Enum: 'Planning', 'Active', 'On Hold', 'Completed', 'Archived' |
| `start_date` | Date | Date when the goal was initiated. | |
| `target_date` | Date | Target completion date for the goal. | |
| `progress_metrics` | JSONB | Key metrics and current values tracking progress. | Structure varies per goal |
| `roadmap_link` | String | Link to the detailed roadmap document for the goal. | URL to Markdown file |
| `dependencies` | ARRAY of UUIDs | List of `goal_id`s that this goal depends on. | |
| `last_updated` | Timestamp | Timestamp of the last update to this entity. | Auto-managed |

## Relationships
-   **Person** can have multiple **Goals**.
-   **Home** is linked to a **Person** (current residence).
-   **Goals** can have **dependencies** on other **Goals**.

## Integration Points
-   Data for `health_metrics` in `Person` comes from G07 (Predictive Health Management).
-   Data for `environmental_data` and `device_inventory` in `Home` comes from G08 (Predictive Smart Home Orchestration).
-   `goals_progress` in `Person` is aggregated from individual `Goal` entities.
-   `Goal` entity data is sourced from `docs/10_GOALS/` markdown files and updated via automation.

## Next Steps
-   Refine schemas based on data availability and system requirements.
-   Implement data ingestion mechanisms for populating these entities.
-   Develop API endpoints for querying and updating Digital Twin entities.
