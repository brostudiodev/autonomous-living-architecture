---
title: "Coding Patterns & Standards"
type: "coding_standard"
status: "active"
owner: "Michał"
updated: "2026-04-09"
---

# Coding Patterns & Standards

> Documented: 2026-04-09 | Part of G12 Infrastructure Optimization

This document establishes the coding patterns and standards for the autonomous-living codebase. All scripts should follow these patterns for consistency and maintainability.

---

## 1. Database Configuration (Mandatory)

### Use `db_config.py` for ALL database connections

**Pattern:**
```python
# ❌ NEVER define DB configs in individual scripts
# BAD - duplicated across 50+ files
DB_CONFIG = {"user": "root", "password": os.getenv("DB_PASSWORD"), ...}
DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}

# ✅ ALWAYS use centralized db_config
# GOOD - single source of truth
from db_config import DB_FINANCE, DB_TWIN, setup_logger
```

**Available Databases:**
| Variable | Database Name | Purpose |
|----------|---------------|---------|
| `DB_FINANCE` | autonomous_finance | Financial tracking |
| `DB_TRAINING` | autonomous_training | Workout/fitness data |
| `DB_PANTRY` | autonomous_pantry | Household inventory |
| `DB_HEALTH` | autonomous_health | Biometrics/health |
| `DB_TWIN` | digital_twin_michal | Core system state |
| `DB_LEARNING` | autonomous_learning | Study/certifications |
| `DB_LOGISTICS` | autonomous_life_logistics | Life admin |
| `DB_CAREER` | autonomous_career | Career tracking |

**Connection Example:**
```python
import psycopg2
from db_config import DB_FINANCE

conn = psycopg2.connect(**DB_FINANCE)
```

---

## 2. Logging (Mandatory)

### Use `setup_logger()` for consistent logging

**Pattern:**
```python
# ✅ ALWAYS set up logging at the top of the script
from db_config import setup_logger

logger = setup_logger(__file__)

# Then use throughout
logger.info("Starting my automation...")
logger.warning("Something unexpected happened")
logger.error("Critical failure")
```

**Output Format:**
```
2026-04-09 14:30:45 | G01_strength_auditor | INFO | Starting my automation...
2026-04-09 14:30:46 | G01_strength_auditor | WARNING | No training data found
```

---

## 3. Environment Variables

### Read from `.env` via db_config helper

**Pattern:**
```python
# ✅ Use db_config's get_env helper
from db_config import get_env

api_key = get_env("GEMINI_API_KEY")
token = get_env("TELEGRAM_BOT_TOKEN", "default_fallback")

# ❌ DON'T load dotenv in each script
# BAD - duplicated loading logic
from dotenv import load_dotenv
SCRIPT_DIR = os.path.dirname(...)
load_dotenv(os.path.join(SCRIPT_DIR, '..', '.env'))
```

---

## 4. Import Order

### Follow this import order in all scripts

```python
#!/usr/bin/env python3
"""
Script description and purpose.
"""

# 1. Standard library
import os
import sys
import json
from datetime import datetime

# 2. Third-party libraries
import psycopg2
import requests

# 3. Local imports (centralized config first)
from db_config import DB_TWIN, DB_FINANCE, setup_logger
from G10_google_tasks_sync import get_upcoming_tasks

# 4. Setup
logger = setup_logger(__file__)

# 5. Main logic follows...
```

---

## 5. Exception Handling

### Avoid bare `except: pass`

**Pattern:**
```python
# ❌ BAD - hides errors
try:
    result = risky_operation()
except:
    pass

# ✅ GOOD - log the error
try:
    result = risky_operation()
except Exception as e:
    logger.warning(f"Expected failure, skipping: {e}")
    return None

# ✅ BEST - specific exception handling
try:
    result = risky_operation()
except FileNotFoundError as e:
    logger.error(f"Config file missing: {e}")
    raise
except psycopg2.OperationalError as e:
    logger.error(f"Database connection failed: {e}")
    raise
```

---

## 6. Function Design

### Keep functions small and focused

**Pattern:**
```python
# ✅ GOOD - single responsibility
def get_todays_readiness():
    """Fetch today's readiness score from database."""
    conn = psycopg2.connect(**DB_TWIN)
    try:
        cur = conn.cursor()
        cur.execute("SELECT readiness_score FROM biometrics WHERE measurement_date = CURRENT_DATE")
        result = cur.fetchone()
        return result[0] if result else 75
    finally:
        cur.close()
        conn.close()

# ❌ BAD - multiple responsibilities
def do_everything():
    # fetch data
    # process data
    # send notifications
    # update database
    # ... too much!
```

---

## 7. Script Metadata

### Include docstring at top of every script

**Pattern:**
```python
#!/usr/bin/env python3
"""
Script Name: G01_strength_auditor.py
============================
Purpose: Autonomously audits HIT training progress based on Time Under Tension.

Logic:
1. Fetch sets performed today.
2. Compare with previous session.
3. Detect PRs and recommend weight increases.

Output: Markdown progress report for Obsidian Daily Note.
"""

# Implementation...
```

---

## 8. Error Messages

### Make errors actionable

**Pattern:**
```python
# ❌ BAD - vague
logger.error("Error occurred")

# ✅ GOOD - specific and actionable
logger.error(f"Failed to connect to database: {e}. Check DB_HOST in .env")
```

---

## 9. Testing

### Test critical paths manually before deployment

```bash
# Test script syntax
python3 -m py_compile your_script.py

# Test imports
python3 -c "from db_config import DB_TWIN; print('OK')"

# Run with verbose output
python3 your_script.py --verbose
```

---

## 10. Migration Guide

### Converting old scripts to new pattern

**Before:**
```python
import os
from dotenv import load_dotenv
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
load_dotenv(os.path.join(SCRIPT_DIR, '..', '.env'))

DB_BASE = {"user": "root", "password": os.getenv("DB_PASSWORD"), ...}
DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}

def my_function():
    conn = psycopg2.connect(**DB_FINANCE)
```

**After:**
```python
from db_config import DB_FINANCE, setup_logger

logger = setup_logger(__file__)

def my_function():
    conn = psycopg2.connect(**DB_FINANCE)
```

---

## Related Documentation

- [db_config.py](./db_config.md) - Centralized database configuration
- [Documentation Standard](../../10_Goals/Documentation-Standard.md) - How to document scripts
- [Principles](../../00_Start-here/Principles.md) - Architectural philosophy
- [North Star](../../00_Start-here/North-Star.md) - Goal of full autonomy

---

*Last Updated: 2026-04-09 | G12 Documentation Audit*
*Author: Michał | Part of db_config.py migration*