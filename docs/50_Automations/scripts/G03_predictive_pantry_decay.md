---
title: "Predictive Pantry Decay (G03)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-25"
---

# Purpose
The **Predictive Pantry Decay** (`G03_predictive_pantry_decay.py`) moves household operations from reactive tracking to autonomous anticipation. It automatically depletes inventory for non-sensor items based on established daily consumption models.

# Scope
- **In Scope:** Common household staples (Eggs, Coffee, Milk, Bread, Butter) with predictable usage.
- **Out Scope:** Items with highly variable usage or items tracked by physical sensors.

# Consumption Models
| Item | Rate | Unit |
|---|---|---|
| Jajka | 2.0 | szt |
| Kawa | 0.05 | kg |
| Chleb | 0.3 | bochenek |
| Mleko | 0.2 | litr |
| Masło | 0.05 | kg |

# Inputs/Outputs
- **Inputs:** `pantry_inventory` table in PostgreSQL.
- **Outputs:** Database updates and a Markdown depletion report for the Daily Note.

# Dependencies
- **Systems:** S03 (Data Layer), G03 (Household Operations)
- **Database:** `autonomous_pantry`

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the daily sync.
- Deduplication: Only runs if the item hasn't been updated yet today.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Item Missing | category not found | Script skips the item; logs warning. |
| Negative Stock | new_qty < 0 | Script clamps quantity to 0.0. |

# Security Notes
- Read/Write access to the pantry database required.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Verify model accuracy against physical stock)
