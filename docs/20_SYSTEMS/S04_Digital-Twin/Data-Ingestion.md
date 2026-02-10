---
title: "S04: Digital Twin Data Ingestion Pipelines"
type: "system_data_ingestion"
status: "complete"
system_id: "S04"
owner: "Michał"
updated: "2026-02-10"
---

# S04: Digital Twin Data Ingestion Pipelines

## Purpose
This document outlines the initial data ingestion pipelines for populating the Digital Twin entities. These pipelines are responsible for extracting data from various sources, transforming it into the defined Digital Twin data models (Person, Home, Goal), and loading it into the S03 Data Layer (PostgreSQL) for persistence and access.

## Key Sources and Pipelines

### 1. Obsidian Notes (Unstructured Activity Logs, Goal Definitions)

**Source:** Obsidian Markdown files (e.g., Daily Notes, Project Notes, Goal Roadmaps).

**Data Type:** Primarily unstructured text, but with embedded structured metadata (frontmatter, YAML blocks, markdown tables, task lists).

**Ingestion Strategy:**
- **Extraction:**
    - Use `python` scripts (e.g., `sync-to-public.py` for Daily Notes, or dedicated parsers) to read Markdown files.
    - Leverage frontmatter parsing for structured metadata (e.g., goal ID, status, owner).
    - Regex-based parsing for task lists (`- [ ]`, `- [x]`) and specific data patterns within notes.
- **Transformation:**
    - **Person Entity:** Extract relevant information from daily notes (e.g., mood, key activities, self-reported metrics) for `Person.health_metrics` or `Person.preferences`.
    - **Goal Entity:** Extract `goal_id`, `name`, `description`, `status`, `start_date`, `target_date`, `progress_metrics` (e.g., count of completed TODOs), `roadmap_link` from `docs/10_GOALS/*.md` files.
- **Loading:**
    - Push transformed data to the S03 Data Layer (PostgreSQL) via direct database inserts/updates or a dedicated n8n service (e.g., `SVC_Obsidian-To-PostgreSQL`).
    - Data will primarily update `Person` and `Goal` entities.

**Automation**: Integrated into `WF104__digital-twin-data-ingestion` (Node 4: Extract Obsidian Data)

### 2. Google Sheets (Structured Data, e.g., Pantry Inventory, Health Metrics)

**Source:** Various Google Sheets documents (e.g., `Magazynek_domowy` for pantry, dedicated sheets for health logs).

**Data Type:** Structured tabular data.

**Ingestion Strategy:**
- **Extraction:**
    - Use Google Sheets API (via n8n's Google Sheets nodes or Python libraries) to read rows from specified sheets.
- **Transformation:**
    - **Home Entity:** Extract structured household inventory data from `Spizarka` (e.g., `Kategoria`, `Aktualna_Ilość`) for `Home.device_inventory` or a dedicated `Inventory` entity if created.
    - **Person Entity:** Extract structured health metrics from dedicated health log sheets for `Person.health_metrics`.
    - Data will need to be mapped precisely to the `Person` and `Home` entity schemas.
- **Loading:**
    - Push transformed data to the S03 Data Layer (PostgreSQL) via direct database inserts/updates or a dedicated n8n service (e.g., `SVC_GoogleSheets-To-PostgreSQL`).
    - Data will primarily update `Person` and `Home` entities.

**Automation**: Integrated into `WF104__digital-twin-data-ingestion` (Node 3: Extract Google Sheets Data)

**Specific Workflows Available**:
- Google Sheets Reader (SVC001__google-sheets-reader) - callable from WF104
- Structured data transformation built into main workflow

## Implementation Status - Complete ✅

### WF104 Digital Twin Data Ingestion (IMPLEMENTED)

**Workflow**: `WF104__digital-twin-data-ingestion.json`
**Schedule**: Every 8 hours (automatic execution)
**Sources Implemented**: 
- Google Sheets (Goals Progress, Daily Activity)
- Obsidian Notes (via planned automation)
- Financial Data (S03 integration)
- Future sensors (prepared for G08, G07)

**Processing Steps**:
1. **Extract**: Data from Google Sheets APIs and internal sources
2. **Transform**: Map to Digital Twin entity schemas (Person, Home, Goal)
3. **Load**: Update entities in S03 Data Layer (PostgreSQL)
4. **Monitor**: Generate data freshness and quality reports

### Data Transformation Logic

**Person Entity Updates**:
```javascript
// From daily logs
{
  entity_id: "person_michal",
  health_metrics: extract_from_daily_notes(),
  preferences: update_from_activity_patterns(),
  last_active: current_timestamp
}
```

**Goal Entity Updates**:
```javascript
// From Google Sheets + Roadmap parsing
{
  entity_id: "goal_g01",
  progress_percentage: calculate_from_todos(),
  status: infer_from_activities(),
  milestones: extract_from_roadmap(),
  last_updated: current_timestamp
}
```

**Home Entity Updates**:
```javascript
// From Google Sheets inventory + sensor data
{
  entity_id: "home_main",
  device_inventory: sync_from_google_sheets(),
  environmental_data: aggregate_sensors(),
  occupancy_pattern: analyze_from_routines(),
  last_updated: current_timestamp
}
```

## Integration with Digital Twin GraphQL API (Ready for Implementation)

Once the GraphQL API layer is implemented:
1. Replace direct PostgreSQL inserts with GraphQL mutations
2. Enable real-time synchronization with change events
3. Add subscription-based updates for client applications
4. Implement proper authentication and authorization

**GraphQL Mutations** (prepared):
```graphql
mutation UpdatePersonEntity($input: PersonEntityInput!) {
  updatePersonEntity(input: $input) {
    entity_id
    last_updated
  }
}

mutation UpdateGoalEntity($input: GoalEntityInput!) {
  updateGoalEntity(input: $input) {
    entity_id
    progress_percentage
    status
  }
}
```

## Related Documentation
- [Digital Twin Data Models](./Data-Models.md)
- [S03 Data Layer README](../../S03_Data-Layer/README.md)
- [WF105 Pantry Management AI Agent](../../50_AUTOMATIONS/n8n/workflows/WF105__pantry-management.md)
- [Pantry Management System](../../../10_GOALS/G03_Autonomous-Household-Operations/Pantry-Management-System.md)
