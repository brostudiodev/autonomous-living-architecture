---
title: "Automation Spec: G08_home_monitor.py"
type: "automation_spec"
status: "active"
automation_id: "G08_home_monitor"
goal_id: "goal-g08"
systems: ["S08", "S10"]
owner: "Michal"
updated: "2026-03-23"
---

# 🤖 Automation Spec: G08_home_monitor.py

## 📝 Overview
**Purpose:** Provides a centralized data provider for all Home Assistant sensor states. It abstracts the complexity of HA entity IDs into a structured status object used by the Digital Twin and Focus Intelligence layers.
**Goal Alignment:** G08 Predictive Smart Home Orchestration (Sensor Layer).

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Library calls from G10/G04 scripts, or Manual Execution for health check.
- **Databases:** None (Direct API fetch).
- **Dependencies:** `dotenv, requests, json, os, datetime`

## 🛠️ Logic Flow
1. **HA State Fetch:** Queries `/api/states` using a Bearer Token.
2. **Entity Filtering:** Filters for temperature, battery, motion, occupancy, and power sensors.
3. **Office Occupancy Heuristic:**
    - High Confidence: Active Motion (`binary_sensor...motion`).
    - Medium Confidence: Occupancy sensor (`binary_sensor...occupancy`) but only during office hours (**08:00-16:00**).
    - Prevents false positives from empty chairs outside of work hours.
4. **Computing State Detection:** Tracks both PC (`sensor.gabinet_komputer_moc`) and Laptop (`sensor.gabinet_laptop_moc`) power draw.

## 📤 Outputs
- **Status Dictionary:** Returns a JSON-compatible object with `temperature`, `battery`, `alerts`, and a nested `office` status.

## ⚠️ Known Issues / Maintenance
- HA Token expiry (typically long-lived but requires monitoring).
- Network latency between script host and HA instance ({{INTERNAL_IP}}).

---
*Updated: 2026-03-23 - Hardened occupancy logic and added laptop monitoring.*
