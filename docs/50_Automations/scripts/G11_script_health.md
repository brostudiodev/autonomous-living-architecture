---
title: "Automation Spec: G11_script_health.py"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-19"
---

# 🤖 Automation Spec: G11_script_health.py

## 📝 Overview
**Purpose:** Provides a per-script health status monitoring and reporting interface. It analyzes the success rates and failure patterns for individual scripts to isolate problematic components.
**Goal Alignment:** G11 Meta-System Integration & Continuous Optimization.

## ⚡ Technical Details
- **Language:** Python 3.x
- **Triggers:** Manual Execution / API Call (via G11_tools_health.py)
- **Databases:** PostgreSQL (digital_twin_michal)
- **Dependencies:** `psycopg2`, `db_config`, `datetime`

## 🛠️ Logic Flow
1. **Fetch Metrics:** Retrieves total runs, successes, and failures for a specific script name from the last 7 days of `system_activity_log`.
2. **Error Capture:** Fetches the last 3 error details and timestamps for the script.
3. **Status Heuristic:**
   - **HEALTHY:** Success rate >= 90% and run within last 24h.
   - **FLAKY:** Success rate < 90%.
   - **CRITICAL:** Success rate < 50%.
   - **STALE:** Last run was more than 24 hours ago.
   - **UNKNOWN:** No data in the last 7 days.

## 📤 Outputs
- **JSON Object:** Contains `status`, `success_rate`, `total_runs`, `failures`, `last_run`, and `recent_errors`.

## ⚠️ Known Issues / Maintenance
- Depends on the accuracy of the `system_activity_log` table.
- Does not account for scripts that are intended to run less frequently than once per 24h (will mark as STALE).

---
*Updated: 2026-04-19 by Digital Twin Assistant*
