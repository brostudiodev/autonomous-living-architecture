---
title: "db_config.py - Centralized Database Configuration and Logging"
type: "automation_spec"
status: "active"
automation_id: "db_config"
goal_id: "goal-g12"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-04-09"
---

# db_config.py - Centralized Database Configuration and Logging

## Purpose
Provides a **single source of truth** for all database connections, logging infrastructure, and system-wide configurations (like Timezone) across the entire autonomous living ecosystem. Eliminates duplicated configurations in 50+ scripts.

## Scope

### In Scope
- Centralized database connection configurations for all 8 databases
- Shared logging infrastructure with consistent formatting
- Global constants (e.g., `TIMEZONE`)
- Environment variable management via `.env`
- Migration utilities for existing scripts

### Out of Scope
- Connection pooling (future enhancement)
- Database schema management
- Migration scripts for data

---

## Inputs/Outputs

### Configuration Inputs
| Input | Source | Description |
|-------|--------|-------------|
| `DB_USER` | `.env` | Database username |
| `DB_PASSWORD` | `.env` | Database password |
| `DB_HOST` | `.env` | Database host (default: localhost) |
| `DB_PORT` | `.env` | Database port (default: 5432) |
| `TIMEZONE` | `.env` | System-wide timezone (default: Europe/Warsaw) |

### Global Constants
| Constant | Type | Value / Source |
|----------|------|----------------|
| `TIMEZONE`| string | `os.getenv("TIMEZONE", "Europe/Warsaw")` |

### Database Outputs
| Variable | Database | Purpose |
|----------|----------|---------|
| `DB_FINANCE` | autonomous_finance | Financial tracking |
| `DB_TRAINING` | autonomous_training | Workout/fitness data |
| `DB_PANTRY` | autonomous_pantry | Household inventory |
| `DB_HEALTH` | autonomous_health | Biometrics/health |
| `DB_TWIN` | digital_twin_michal | Core system state |
| `DB_LEARNING` | autonomous_learning | Study/certifications |
| `DB_LOGISTICS` | autonomous_life_logistics | Life admin |
| `DB_CAREER` | autonomous_career | Career tracking |

---

## Dependencies

### Systems
- **S03 Data Layer:** PostgreSQL databases
- **S04 Digital Twin:** Uses for all DB connections

### Credentials Required
- PostgreSQL access (user/password from `.env`)
- All 8 databases must be accessible

### Files Using This
- [G04_digital_twin_engine.py](./G04_digital_twin_engine.md) - ✅ Migrated (DB & TZ)
- [G04_digital_twin_api.py](./G04_digital_twin_api.md) - ✅ Migrated (DB & TZ)
- [G10_calendar_enforcer.py](./G10_calendar_enforcer.md) - ✅ Migrated (TZ)
- [G07_zepp_sync.py](./G07_zepp_sync.md) - ✅ Migrated (TZ)
- [G10_calendar_client.py](./G10_calendar_client.md) - ✅ Migrated (TZ)
- [G10_location_intelligence.py](./G10_location_intelligence.md) - ✅ Migrated (TZ)
- [G05_llm_categorizer.py](./G05_llm_categorizer.md)
- [G11_decision_handler.py](./G11_decision_handler.md)
- 160+ additional scripts

---

## Usage

### Basic Import
```python
from db_config import DB_TWIN, DB_FINANCE, DB_PANTRY, DB_HEALTH, TIMEZONE
import psycopg2

# Connect to database
conn = psycopg2.connect(**DB_TWIN)

# Use system timezone
print(f"Current timezone: {TIMEZONE}")
```

### With Logging
```python
from db_config import setup_logger

logger = setup_logger(__file__)
logger.info("Starting my script...")

# Use consistent logging throughout
logger.warning("Something went wrong")
logger.error("Critical failure")
```

### Get Database by Name
```python
from db_config import get_db_config

# Dynamically get database config
db = get_db_config('finance')  # Returns DB_FINANCE dict
```

---

## Migration Guide

### Before (50+ files had this)
```python
# In each script - DUPLICATED!
import os
from dotenv import load_dotenv
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
load_dotenv(os.path.join(SCRIPT_DIR, '..', '.env'))

DB_BASE = {
    "user": "root",
    "password": os.getenv("DB_PASSWORD", "admin"),
    "host": os.getenv("DB_HOST", "localhost"),
    "port": "5432"
}
DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}
```

### After (use centralized config)
```python
from db_config import DB_FINANCE, DB_TWIN, setup_logger
logger = setup_logger(__file__)
```

---

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| `.env` file missing | `FileNotFoundError` | Script fails - restore `.env` from backup |
| DB credentials wrong | `psycopg2.OperationalError` | Check `.env` DB_PASSWORD |
| DB host unreachable | Connection timeout | Check DB_HOST network connectivity |
| Database doesn't exist | `psycopg2.OperationalError` | Create database or fix dbname |

---

## Security Notes

- **Credentials:** Stored in `.env` file, never committed to git
- **Access:** All scripts read from same `.env`
- **Audit:** Changing password = single file edit, not 50+

---

## Owner & Review

- **Owner:** Michał
- **Review Cadence:** Monthly (via G12 Documentation Audit)
- **Last Updated:** 2026-04-15
- **Migration Status:** Core scripts ✅ migrated (Timezone centralization complete)

---

## Related Documentation

- [Documentation Standard](../../10_Goals/Documentation-Standard.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [G12 Meta-System Integration Optimization](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)

---

*Created: 2026-04-09 | Part of G12 Infrastructure Optimization*