---
title: "Logistics Module: Life & Intelligence Management"
type: "system_specification"
status: "active"
owner: "Michał"
updated: "2026-05-14"
goal_id: "goal-g04"
---

# Logistics Module (G04-MSM)

## Purpose
Consolidate life logistics management (legal docs, asset maintenance, subscriptions), interpersonal relationships, and system-wide intelligence metrics (ROI) into a unified modular framework.

## Scope
-   **Life Logistics:** Sync from Google Sheets (G04 Logistics Sheet).
-   **Personal Context:** Sync from Obsidian Vault (`99_System/Personal`).
-   **Relationships:** Track contact frequency and reminders via the Relationships Sheet.
-   **Autonomous ROI:** Automated calculation of time saved by all system components.
-   **API Endpoints:** Real-time access to expiry alerts, subscription costs, and ROI metrics.

## Inputs/Outputs
-   **Inputs:**
    -   Google Sheets (Logistics & Relationships): Primary sources for life and social data.
    -   Obsidian Markdown Files: Source for personal intelligence and human-level context.
    -   System Activity Logs: Source for ROI calculations.
-   **Outputs:**
    -   `autonomous_life_logistics` & `relationships` tables: Production storage.
    -   `personal_intelligence` table: Knowledge base for the Digital Twin.
    -   `autonomy_roi` table: Tracks system-wide efficiency gains.
    -   RabbitMQ Events: `logistics.sync_complete`, `relationships_synced`.

## Dependencies
-   **Data:** Google Sheets API, PostgreSQL (`logistics`, `twin` domains).
-   **Infrastructure:** Kernel SDK, RabbitMQ.

## Procedure

### Synchronization
The module performs a multi-stage sync:
1.  **Logistics Sync:** Fetches 6 tabs from the Logistics Google Sheet, performing upserts based on `item_name` and `category`.
2.  **Relationship Sync:** Fetches contact data from the Relationships Google Sheet and triages reminders.
3.  **Intelligence Sync:** Parses YAML frontmatter and content from specific Obsidian folders, updating the `twin` database.
4.  **ROI Calculation:** Aggregates today's successful script runs and applies weights to determine time saved.

### API Access
-   Access logistics alerts via `/api/v1/logistics/expiries`.
-   Monitor system ROI via `/api/v1/intelligence/roi`.

## Failure Modes
-   **Worksheet Missing:** Logs a warning and continues with the next tab.
-   **YAML Parse Error:** Skips the specific Obsidian file and logs the error.
-   **Auth Failure:** Circuit breaker opens for the `logistics` domain.

## Security Notes
-   Uses centralized `google_credentials_digital-twin-michal.json`.
-   Personal intelligence content is kept strictly in the private `digital_twin_michal` database.

## Owner + Review Cadence
-   **Owner:** Michał
-   **Review Cadence:** Monthly
