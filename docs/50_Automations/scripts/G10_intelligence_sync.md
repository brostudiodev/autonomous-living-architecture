---
title: "Intelligence DB Sync (G10)"
type: "automation_spec"
status: "active"
automation_id: "G10_intelligence_sync.py"
goal_id: "goal-g10"
owner: "Michal"
updated: "2026-04-04"
---

# 🤖 Intelligence DB Sync

## 📝 Overview
**Purpose:** Synchronizes Obsidian daily note metrics into the `daily_intelligence` PostgreSQL table. This enables long-term historical analysis, correlation detection, and multi-day trend reporting that would be token-inefficient to perform via raw file parsing.
**Goal Alignment:** G10 Intelligent Productivity (Data Integrity)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Called by `autonomous_evening_manager.py` (Daily sync) and manual (Backfill).
- **Databases:** `digital_twin_michal`
- **Dependencies:** `psycopg2`, `pyyaml`

## 🛠️ Logic Flow
1. **Extraction:** Surgically parses the YAML frontmatter of `YYYY-MM-DD.md` files.
2. **Cleaning:** 
   - **Selection Logic:** If `mood` or `energy` contain multiple options (template defaults), they are ignored (stored as `NULL`).
   - **Type Casting:** Converts energy strings (e.g., "5 - peak") to integers.
3. **Upsert:** Uses `ON CONFLICT (intelligence_date) DO UPDATE` to ensure the database stays in sync with the latest note edits.

## 📤 Outputs
- **Postgres:** Populated `daily_intelligence` table.
- **Log:** Success/Failure counts per run.

## ⚠️ Known Issues / Maintenance
- **Schema Sync:** If new fields are added to the Daily Note frontmatter, they must be manually added to this script and the DB schema.

---
*Unified Data Intelligence - April 2026*
