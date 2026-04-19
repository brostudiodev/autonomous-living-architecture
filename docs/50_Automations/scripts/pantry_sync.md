---
title: "Automation Spec: pantry_sync.py"
type: "automation_spec"
status: "active"
automation_id: "pantry_sync"
goal_id: "goal-g03"
systems: ["S03", "S08"]
owner: "Michal"
updated: "2026-04-03"
---

# 🤖 Automation Spec: pantry_sync.py

## 📝 Overview
**Purpose:** Synchronizes pantry inventory and dictionary data from Google Sheets to the PostgreSQL `autonomous_pantry` database.
**Goal Alignment:** G03 Autonomous Household Operations.

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Part of `G11_global_sync.py` cycle.
- **Databases:** PostgreSQL (`autonomous_pantry`)
- **Dependencies:** `sys, datetime, os, google.oauth2.service_account, psycopg2, re, gspread`

## 🛠️ Logic Flow
1.  **Dictionary Sync:** Updates the `pantry_dictionary` table with synonyms and critical thresholds from the `Slownik` worksheet.
2.  **Multi-Location Inventory Sync:**
    -   Iterates through specified location worksheets: `Spizarka`, `Gabinet`, `Lazienka_dol`, `Lazienka_gora`, `Pralnia`, `Zamrazarka`, `Garaz`, `Garderoba`, `Strych`.
    -   Extracts records and identifies the `location` based on the worksheet name.
    -   Uses the `upsert_pantry_item` SQL function to update the `pantry_inventory` table.
    -   **Data Integrity:** Items with the same name in different locations are tracked independently using a composite primary key `(category, location)`.
3.  **Completion:** Logs the total count of synced items to the system activity log.

## 📤 Outputs
- **Database:** Updated `pantry_inventory` and `pantry_dictionary` tables.
- **Logs:** Activity entry in `system_activity_log`.

## ⚠️ Known Issues / Maintenance
- Worksheet names in the script must match the Google Sheet exactly.
- Renaming a sheet requires an update to the `inventory_sheets` list in the script.
- **Composite Key Constraint:** Ensure any external tool querying `pantry_inventory` accounts for the `location` column to avoid duplicate result sets.

---
*Updated: 2026-04-03*
