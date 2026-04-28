---
title: "Automation Spec: G11_friction_discovery.py"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-28"
---

# 🤖 Automation Spec: G11_friction_discovery.py

## 📝 Overview
**Purpose:** Discovers "hidden friction" by analyzing cross-domain correlations in the system's unified intelligence data. It identifies how variables in one domain (e.g., sleep) impact outcomes in another (e.g., spending).
**Goal Alignment:** G11 Meta-System Integration & Continuous Optimization.

## ⚡ Technical Details
- **Language:** Python 3.x
- **Triggers:** Weekly Mission Sync (Sundays) / Manual Execution
- **Databases:** PostgreSQL (digital_twin_michal)
- **Dependencies:** `pandas`, `psycopg2`, `db_config`, `G04_digital_twin_notifier`

## 🛠️ Logic Flow
1. **Data Load:** Fetches up to 10 years of `daily_intelligence` data into a Pandas DataFrame.
2. **Correlation Analysis:**
   - **Financial Friction:** Compares average daily spending on days with good sleep vs. poor sleep.
   - **Productivity Pivot:** Correlates readiness scores with time saved (ROI).
   - **Activity Stress:** Calculates correlation between step counts and budget alerts.
3. **Insight Generation:** Flags significant deviations (e.g., spending >20% higher after poor sleep).

## 📤 Outputs
- **Telegram Message:** Detailed report of discovered correlations and system suggestions.
- **Log Entry:** Success/Failure log in `system_activity_log`.

## ⚠️ Known Issues / Maintenance
- Requires at least 7 days of unified data to provide meaningful insights.
- Heuristics are currently hardcoded; could be expanded to include more variables (mood, weather, etc.).

---
*Updated: 2026-04-19 by Digital Twin Assistant*
