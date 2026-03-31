---
title: "Automation Spec: G09_career_data_provider.py"
type: "automation_spec"
status: "active"
created: "2026-03-06"
updated: "2026-03-06"
---

# 🤖 Automation Spec: G09_career_data_provider.py

## 📝 Overview
**Purpose:** Fetches raw career goals, progress metrics, and recent study history from the `autonomous_learning` database to serve as context for external AI agents (n8n).
**Goal Alignment:** G09 (Automated Career Intelligence)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** On-Demand via API (`GET /career_data`) or Health Audit.
- **Databases:** PostgreSQL (`autonomous_learning`)
- **Dependencies:** `psycopg2`, `json`, `datetime`
- **Environment:** Standard `.env` DB credentials.

## 🛠️ Logic Flow
1. **Goal Retrieval:** Fetches all active `career_goals` (e.g., AWS, Six Sigma).
2. **History Retrieval:** Fetches the last 30 `study_sessions` with notes and impact scores.
3. **Progress Calculation:** Computes total hours vs. required hours for each active goal.
4. **Data Formatting:** Returns a structured JSON object optimized for LLM context injection.

## 📤 Outputs
- **JSON Object:**
  - `goals`: List of active targets.
  - `progress`: Calculated completion percentages and gaps.
  - `history`: Chronological log of recent learning activities.

## ⚠️ Known Issues / Maintenance
- **Data Quality:** Relies on accurate logging in `study_sessions` to calculate progress correctly.

---
*Generated for n8n Integration.*
