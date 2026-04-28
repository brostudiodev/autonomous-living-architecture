---
title: "System Dependency Map"
type: "architecture_doc"
status: "active"
owner: "Michał"
updated: "2026-03-28"
---

# System Dependency Map (2026)

This document maps the inter-dependencies between the core automation scripts, databases, and external APIs.

## 📊 Core Databases (PostgreSQL)

| Database | Primary Owner | Critical Dependencies |
|----------|---------------|-----------------------|
| `autonomous_health` | G01, G07 | Zepp API, Withings API |
| `autonomous_finance` | G05 | Bank CSVs, LLM (Categorizer) |
| `autonomous_pantry` | G03 | Household Inventory |
| `autonomous_life_logistics` | G04, G08 | Task Scrubber, Calendar |
| `autonomous_learning` | G06 | Course Schedules |
| `autonomous_career` | G09 | Skill Metrics, Brand Impact |
| `digital_twin_michal` | G04, G12 | All other databases (via Engine) |

## 🔗 Script Inter-dependencies

### 🍱 Household & Procurement (G03)
- `G03_meal_planner.py` → `autonomous_pantry` (Input)
- `G03_meal_planner.py` → `selected_meal.json` (Output)
- `G03_cart_aggregator.py` → `selected_meal.json` (Input for missing ingredients)
- `G03_cart_aggregator.py` → `autonomous_cart.json` (Output)
- `G03_cart_aggregator.py` → Google Tasks (Output)

### 🚀 Productivity & Tasks (G10/G11)
- `G11_task_archiver.py` → Google Tasks (Input/Action)
- `G11_task_archiver.py` → `G11_rules_engine` (Decision Support)
- `G11_decision_handler.py` → Google Tasks (Execution for stale tasks)
- `G10_tomorrow_planner.py` → `autonomous_learning` (Course Readiness)
- `G10_tomorrow_planner.py` → `DigitalTwinEngine` (Strategic Intelligence)

### 📈 Career & Learning (G06/G09)
- `G09_career_sync.py` → `autonomous_career` (Initialization/Maintenance)
- `G11_quick_wins.py` → `autonomous_learning` (Course Prep Tasks)
- `G11_quick_wins.py` → `autonomous_finance` (Spending Anomalies)

## 🌐 External API Connectivity

| API | Key Scripts | Status (Mar 28 Audit) |
|-----|-------------|-----------------------|
| **Google Gemini** | `G03_meal_planner`, `G11_rules_engine` | ⚠️ Missing Key (Local .env) |
| **Google Tasks** | `G03_cart_aggregator`, `G10_tasks_sync` | ✅ Connected |
| **Google Calendar** | `G10_calendar_client`, `G11_global_sync` | ✅ Connected |
| **Home Assistant** | `G03_appliance_monitor`, `G08_orchestrator`| ⚠️ Missing URL/Token |
| **Zepp/Health** | `G07_zepp_sync` | ✅ Connected |

## 🛠️ Infrastructure Requirements
- **PostgreSQL 16+** (Running on localhost:5432)
- **Python 3.12+** (Venv: `.venv/`)
- **Docker Compose** (for Grafana/Prometheus/n8n stack)
