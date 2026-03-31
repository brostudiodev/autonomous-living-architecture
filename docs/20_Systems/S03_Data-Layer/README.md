---
title: "S03: Data Layer (Multi-Database Architecture)"
type: "system"
status: "active"
system_id: "system-s03"
owner: "Michal"
updated: "2026-03-23"
review_cadence: "monthly"
---

# S03: Data Layer

## Purpose
A distributed multi-database architecture providing the persistent foundation for all autonomous living systems. It ensures data isolation, scalability, and high-speed retrieval for the Digital Twin's strategic reasoning.

> [!insight] 📝 **Automationbro Insight:** [Clean Code, Dirty Data: When Master Data Inconsistencies Killed Automations](https://automationbro.substack.com/p/clean-code-dirty-data-when-master)

## Scope
### In Scope
- Distributed PostgreSQL databases (Docker-hosted).
- Domain-specific schemas (Finance, Health, Logistics, etc.).
- Strategic Memory persistence for Agent Zero.
- Automated synchronization from Google Sheets and external APIs.

### Out of Scope
- Unstructured knowledge (handled by Obsidian Vault).
- Real-time sensor streams (handled by Home Assistant/MariaDB).

## Distributed Database Registry
| Database | Purpose | Key Tables |
|----------|---------|------------|
| `autonomous_finance` | Financial Command Center | `transactions`, `merchants`, `budgets`, `finance_entries` |
| `autonomous_health` | Predictive Health | `biometrics`, `water_log`, `caffeine_log`, `sleep_log` |
| `autonomous_training` | HIT Training & Performance | `workouts`, `workout_sets`, `exercises` |
| `autonomous_pantry` | Household & Logistics | `pantry_inventory`, `selected_meal` |
| `autonomous_life_logistics` | Document & Deadline Tracking | `autonomous_life_logistics`, `relationships` |
| `autonomous_learning` | Certification & Skill Progress | `learning_progress`, `subject_metrics` |
| `autonomous_career` | Career Intelligence | `skill_metrics`, `project_impact` |
| `digital_twin_michal` | Twin Brain & Memory | `strategic_memory`, `autonomy_roi`, `system_activity_log`, `decision_requests`, `autonomous_decisions` |

## Core Components

### System Activity Log (`digital_twin_michal`)
Centralized heartbeat of the ecosystem, tracking the execution status of all automations.
```sql
CREATE TABLE system_activity_log (
    id SERIAL PRIMARY KEY,
    script_name VARCHAR(100) NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'SUCCESS', 'FAILURE', 'PARTIAL'
    items_processed INTEGER DEFAULT 0,
    details TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Autonomy ROI (`digital_twin_michal`)
Quantifies the actual time saved by autonomous systems.
```sql
CREATE TABLE autonomy_roi (
    id SERIAL PRIMARY KEY,
    source VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    minutes_saved INT NOT NULL,
    details TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Life Logistics (`autonomous_life_logistics`)
Tracks the "Administrative Health" of the user.
```sql
CREATE TABLE autonomous_life_logistics (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100),
    item_name VARCHAR(255),
    due_date DATE,
    amount NUMERIC(10,2),
    status VARCHAR(50), -- empty, DONE, REJECTED
    alert_threshold_days INT,
    notes TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Decision Requests (`digital_twin_michal`)
Manages the "Human-in-the-Loop" validation for autonomous actions.
```sql
CREATE TABLE decision_requests (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    domain VARCHAR(50),
    policy_key VARCHAR(100),
    payload JSONB,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, RESOLVED, EXPIRED
    resolution TIMESTAMP,
    resolution_result VARCHAR(20), -- APPROVED, DENIED, SUCCESS
    is_notified BOOLEAN DEFAULT FALSE
);
```

## Data Freshness & Sync
- **Orchestrator:** [G11_global_sync.py](../../50_Automations/scripts/G11_global_sync.md)
- **Mechanism:** Python scripts using `psycopg2` and `gspread`.
- **Validation:** Daily freshness checks integrated into the Digital Twin API `/status` endpoint.

## Dependencies
- **Infrastructure:** S00 Homelab Platform (Docker Compose).
- **Environment:** Dedicated `.venv` with `psycopg2-binary` and `python-dotenv`.
- **Credentials:** Securely loaded via `.env` (using `DB_PASSWORD`, `DB_HOST`, `HA_TOKEN`).

## Related Documentation
- [Goal: G11 Meta-System Integration](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
- [System: S04 Digital Twin](../S04_Digital-Twin/README.md)

---
*Updated: 2026-03-23 by Digital Twin Assistant*
