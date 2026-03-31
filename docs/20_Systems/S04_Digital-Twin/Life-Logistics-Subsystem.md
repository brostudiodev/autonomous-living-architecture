---
title: "S04 Subsystem: Life Logistics & Asset Tracking"
type: "system_specification"
status: "active"
parent_system: "S04 Digital Twin"
database: "autonomous_life_logistics"
table: "autonomous_life_logistics"
updated: "2026-03-04"
---

# Life Logistics & Asset Tracking Subsystem

## Purpose
Provides a centralized "State & Threshold" monitoring layer for non-flow data points such as document expiries (Passport, ID), recurring payments (Rent, Insurances), and scheduled maintenance (Car, HVAC). This subsystem eliminates the need for manual checking of dates and enables proactive AI alerts.

## Data Model

### Database: `autonomous_life_logistics`
### Table: `autonomous_life_logistics`

| Column | Type | Description |
|---|---|---|
| `id` | SERIAL | Primary Key |
| `category` | VARCHAR(50) | Source Tab (e.g., 'Identity & Legal', 'Asset & Home Maintenance') |
| `item_name` | VARCHAR(100) | Human-readable name of the item |
| `due_date` | DATE | The hard deadline or expiry date |
| `amount` | NUMERIC(12,2) | Cost associated (if payment) |
| `status` | VARCHAR(20) | 'Pending' or 'Done' |
| `alert_threshold_days` | INTEGER | Days before due_date to start alerting (Default: 30) |
| `notes` | TEXT | Additional context (Location, Provider, etc.) |
| `updated_at` | TIMESTAMP | Last sync timestamp |

## Automation Architecture

### 1. Ingestion (`G04_logistics_sync.py`)
- **Source:** Master Google Sheet `Life_Logistics` (ID: `[SPREADSHEET_ID]`)
- **Logic:** Full truncate and reload sync pattern. Each row in the sheet represents a discrete deadline.
- **Trigger:** Daily Global Sync (`G11`) or Manual API Trigger (`/logistics_sync`).

### 2. Intelligence Engine (`G04_digital_twin_engine.py`)
- **Alert Logic:** Identifies items where `(due_date - current_date) <= alert_threshold_days`.
- **Urgency levels:** 
    - `URGENT` if days left <= 7.
    - `Reminder` if days left <= threshold.

## Outputs
- **Obsidian Daily Note:** Alerts injected into "Director's Insights".
- **Telegram Morning Briefing:** Alerts included in the daily mission brief.
- **API Endpoint:** `GET /logistics_sync` for on-demand synchronization.

## Dependencies
- **Systems:** S03 Data Layer (Postgres), S04 Digital Twin (Logic).
- **External:** Google Sheets API.

## Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Google Auth Fail | Sync script exit code | Log to console, Digital Twin marks domain as 'Stale' |
| Invalid Date Format | Regex parser error | Skip row, log warning in sync output |
