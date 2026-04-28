---
title: "Automation Spec: G04_life_simulator.py"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-19"
---

# 🤖 Automation Spec: G04_life_simulator.py

## 📝 Overview
**Purpose:** The "6-Month Outcome Simulator" aggregates cross-domain trends (Health, Finance, Brand, Productivity) to project your life status 180 days from today. It uses linear regression on historical data to provide a "future glance" at your trajectory.
**Goal Alignment:** G04 Digital Twin Ecosystem (Predictive Partner).

## ⚡ Technical Details
- **Language:** Python 3.x
- **Triggers:** Manual Execution / Strategic Review
- **Databases:** `autonomous_health`, `autonomous_finance`, `autonomous_career`, `digital_twin_michal`
- **Dependencies:** `pandas`, `numpy`, `psycopg2`, `db_config`

## 🛠️ Logic Flow
1. **Data Harvest:** Fetches 90 days of history for key KPIs:
    - **Health:** Body Fat %, Weight.
    - **Finance:** Daily Net Cashflow.
    - **Brand:** Substack & LinkedIn metrics.
    - **Productivity:** Time Saved (ROI).
2. **Smoothing:** Applies a 7-day rolling average to reduce daily noise.
3. **Regression:** Performs linear regression (`numpy.polyfit`) using date ordinals.
4. **Projection:** Calculates the expected value at `today + 180 days`.
5. **Categorization:** Determines status (🟢, 🟡, 🔴) based on whether the trend aligns with goal directions.

## 📤 Outputs
- **Markdown Report:** Grouped by domain with current vs. projected values and status icons.
- **JSON Data:** Full simulation results available via `--json` flag for API integration.

## ⚠️ Known Issues / Maintenance
- **Linearity Bias:** Assumes current trends will continue linearly; does not account for plateaus or exponential growth.
- **Data Density:** Requires at least 5 data points per KPI to generate a trend.
- **Brand Metrics:** Currently depends on manual or automated entry into `brand_impact` table.

---
*Created: 2026-04-19 by Digital Twin Assistant*
