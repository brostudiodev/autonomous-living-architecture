---
title: "S03: Data Layer (The Source of Truth)"
type: "system"
status: "active"
system_id: "system-s03"
owner: "Michal"
updated: "2026-04-08"
---

# S03: Data Layer

## Purpose
The Data Layer serves as the unified source of truth for the entire Autonomous Living ecosystem. It manages the structured data across PostgreSQL, MariaDB (Home Assistant), and Flat Files (Obsidian/CSV).

## Architecture
- **Primary DB:** PostgreSQL (`digital_twin_michal`, `autonomous_finance`, `autonomous_pantry`, `autonomous_health`, `autonomous_training`).
- **IoT State:** MariaDB (via Home Assistant API).
- **Blob Storage:** Obsidian Vault (Markdown files).

## Core Databases
| Database | Domain | Key Tables |
|---|---|---|
| `digital_twin_michal` | Meta-System | `system_activity_log`, `decision_requests`, `strategic_memory` |
| `autonomous_finance` | G05 Finance | `transactions`, `budgets`, `categories` |
| `autonomous_pantry` | G03 Household | `pantry_inventory`, `pantry_dictionary`, `pantry_prices` |
| `autonomous_health` | G07 Health | `biometrics`, `daily_intelligence` |
| `autonomous_training` | G01 Performance | `workouts`, `workout_sets`, `exercises` |

## Data Ingestion Flow
1. **Sensors/APIs:** Zepp, Withings, Home Assistant, Google.
2. **ETL Scripts:** G-series Python scripts.
3. **Storage:** PostgreSQL.
4. **Consumption:** n8n, Grafana, Digital Twin API.

## Security
- All credentials stored in `.env`.
- Database accessible only via local network/Docker bridge.
- Regular AES256 encrypted backups via `G11_db_recovery_shield.py`.

---
*Created: 2026-04-08 | Part of G11 Meta-System Integration*
