---
title: "G11: Meta-System Architecture and Core Data Integration Patterns"
type: "architecture_spec"
status: "draft"
goal_id: "goal-g11"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# G12: Meta-System Architecture and Core Data Integration Patterns

## Purpose
This document outlines the high-level architecture and the fundamental data integration patterns for the G12 Meta-System. The Meta-System aims to be a unified, intelligent platform that integrates data and insights from all individual goals (G01-G11) to provide holistic understanding, predictive capabilities, and autonomous optimization of the "autonomous living" ecosystem. It acts as the central nervous system, connecting disparate data sources and intelligent agents.

## Core Data Integration Patterns

### 1. Centralized Relational Core (PostgreSQL-based - S03 Data Layer)

*   **Description:** This pattern is suitable for structured, high-integrity data where complex relationships and business logic can be efficiently managed within a relational database. It serves as the "single source of truth" for critical operational and analytical data. All data from other systems, once processed and normalized, should ideally converge here for persistence and unified access.
*   **Examples:** Financial transactions, structured health metrics (e.g., body fat, workout logs), system telemetry, structured household inventory.
*   **Integration Points:**
    *   Data from various sources (APIs, direct input, other systems) is transformed and loaded into PostgreSQL.
    *   Business logic, aggregations, and derived metrics are encapsulated in SQL views and functions (as seen in G05 Autonomous Finance).
    *   This layer exposes cleaned, enriched, and standardized data for consumption by other systems (e.g., S01 Observability) and directly by the Meta-System.
*   **Meta-System Role:** The Meta-System primarily queries this core for structured, historical, and real-time data, using its views and functions as a reliable and performant interface. It may also write back processed insights or commands (e.g., goal adjustments, automation triggers) into this layer for persistence and action.

### 2. User-Centric / Unstructured Data Layer (AI-enhanced & Event-Driven)

*   **Description:** This pattern accommodates user-facing data sources that might be less structured, use natural language, or rely on external, often non-relational, services. It prioritizes ease of user interaction, local language conventions, and leverages AI agents for data parsing, validation, and enrichment.
*   **Examples:** Pantry inventory (Google Sheets, using Polish schema), Obsidian notes (unstructured activity logs, goal definitions, project notes), natural language commands (e.g., from Telegram, n8n chat), voice input.
*   **Integration Points:**
    *   Data is captured through user-friendly interfaces (e.g., Google Sheets, Obsidian markdown files, chat bots).
    *   AI agents (like the Google Gemini agent in the Pantry system, or LLMs processing Obsidian notes) process this input, perform initial validation, apply business logic (e.g., interpreting natural language requests), and then normalize/structure the data.
    *   The structured output is then pushed into the Centralized Relational Core (PostgreSQL) for persistence, historical tracking, and broader integration.
    *   Explicit 'Meta-System Integration Points' are defined (as per Adr-0002 and Pantry-Schema.md) to ensure downstream systems can reliably consume this data, often with an event-driven mechanism.
*   **Meta-System Role:** The Meta-System consumes the structured, normalized output of these AI-enhanced layers, primarily after it has been persisted and made available in the Centralized Relational Core. It also provides context and intelligence back to these user-facing systems (e.g., predictive suggestions for the Pantry, automated summarization of Obsidian notes).

## Additional Architectural Components (to be further defined)

### S04 Digital Twin

*   **Role:** This system will act as a real-time, dynamic, and holistic representation of the ecosystem's current and predicted state. It will aggregate data from both integration patterns (Centralized Relational Core and User-Centric Data Layer), providing a unified, context-rich view of the individual (user), their home, goals, and interactions for the Meta-System.
*   **Integration:** Will subscribe to changes in the Centralized Relational Core and process events from User-Centric layers to maintain its state. Exposes its own API for querying the current state of the "twin".

### S08 Automation Orchestrator (n8n)

*   **Role:** This system is crucial for managing data flows, executing transformation logic, and orchestrating interactions between various systems and intelligent agents. It acts as the middleware and workflow engine for most integration tasks.
*   **Integration:** Connects to data sources, invokes AI agents, performs data transformations, and triggers actions based on Meta-System insights or events from other goals.

### S01 Observability & Monitoring

*   **Role:** A central logging, alerting, and monitoring system for tracking data quality, integration health, system performance, and security across the entire Meta-System.
*   **Integration:** Receives telemetry and logs from all integrated systems and components, providing a consolidated view of the ecosystem's operational status.

## Next Steps (Initial Q1 Roadmap for G12)

Based on this foundational architecture:

*   [ ] Conduct a detailed review of `docs/20_Systems/S04_Digital-Twin/` and `docs/20_Systems/S08_Automation-Orchestrator/` to understand their current design and intended integration points.
*   [ ] Systematically map inputs and outputs for all goals (G01-G11), identifying which integration pattern each data flow follows.
*   [ ] Begin defining a high-level unified data schema for S03 Data Layer that can accommodate data from diverse goals.
*   [ ] Prototype a basic Meta-System dashboard in S01 (Observability) to display aggregated KPIs from at least two integrated goals.
*   [ ] Document identified correlations and dependencies between the goals to inform future optimization strategies.
