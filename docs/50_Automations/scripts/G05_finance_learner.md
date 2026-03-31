---
title: "Automation Spec: G05_finance_learner.py"
type: "automation_spec"
status: "active"
created: "2026-03-06"
updated: "2026-03-06"
---

# 🤖 Automation Spec: G05_finance_learner.py

## 📝 Overview
**Purpose:** Implements a feedback loop for the financial categorization engine by learning from manual user corrections in Obsidian.
**Goal Alignment:** G05 (Autonomous Financial Command Center)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Scheduled daily via `G11_global_sync.py`
- **Databases:** PostgreSQL (`autonomous_finance`)
- **Dependencies:** `psycopg2`, `python-dotenv`, `re`, `datetime`

## 🛠️ Logic Flow
1. **Fetch Knowledge:** Retrieves the current category map (Name -> ID) from PostgreSQL.
2. **Scan Obsidian:** Reads the last 3 Obsidian daily notes to find the `### 💸 Financial Corrections` section.
3. **Parse Correction:** Identifies `[Merchant Name]: [Category Name]` patterns.
4. **Learn & Update:** Upserts the correction into the `merchants` table, setting the `default_category_id` for that merchant.

## 📤 Outputs
- Database updates to `merchants` table.
- Console logs of successful learning events.

## ⚠️ Known Issues / Maintenance
- **Parsing Strictness:** Requires the format `Merchant: Category` to work correctly.
- **Accuracy:** Relies on the user providing correct category names from the defined system list.

---
*Updated for 2026 Autonomy Milestone.*
