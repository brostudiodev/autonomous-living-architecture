# AGENTS.md - Autonomous Living Development Guide

## Core Architecture

- **n8n = Brain** - LLM orchestration, decision-making, agent coordination
- **Python scripts = Body** - Data access, execution, API endpoints
- **PostgreSQL = Memory** - 8 databases for different domains
- **FastAPI (port 5677) = API Gateway** - Digital Twin REST API
- **Obsidian = Visualization** - Daily notes, dashboards, planning

## Key Commands

```bash
# Verify script syntax
python3 -m py_compile <script.py>

# Test imports
python3 -c "from db_config import DB_TWIN; print('OK')"

# Run Daily Manager
python3 autonomous_daily_manager.py

# Run Evening Manager
python3 autonomous_evening_manager.py

# Run Digital Twin API
python3 G04_digital_twin_api.py
```

## Mandatory Patterns (2026-04-09)

### Database Config
```python
# ✅ ALWAYS use this
from db_config import DB_FINANCE, DB_TWIN, setup_logger

# ❌ NEVER define DB configs inline
```

### Logging
```python
logger = setup_logger(__file__)
logger.info("Starting...")
```

### Exception Handling
```python
# ✅ GOOD
except Exception as e:
    logger.warning(f"Expected failure: {e}")

# ❌ BAD - hides errors
except: pass
```

## Critical Files

| File | Purpose |
|------|----------|
| `scripts/db_config.py` | Centralized DB config + logging (MUST use) |
| `scripts/G04_digital_twin_api.py` | Main API (1900+ lines, hard to maintain) |
| `scripts/G04_digital_twin_engine.py` | Core engine with all getters |
| `scripts/autonomous_daily_manager.py` | Daily orchestration |
| `docs/50_Automations/scripts/Coding-Patterns.md` | Full standards doc |

## 12 Goals (G01-G12)

1. **G01** - Target Body Fat (15%)
2. **G02** - Automationbro Recognition
3. **G03** - Autonomous Household Operations
4. **G04** - Digital Twin Ecosystem
5. **G05** - Autonomous Financial Command Center
6. **G06** - Certification Exams
7. **G07** - Predictive Health Management
8. **G08** - Predictive Smart Home Orchestration
9. **G09** - Automated Career Intelligence
10. **G10** - Intelligent Productivity Time Architecture
11. **G11** - Meta-System Integration Optimization
12. **G12** - Complete Process Documentation

## Database Schema

| Database | Domain |
|----------|--------|
| `autonomous_finance` | Financial tracking |
| `autonomous_training` | Workout/fitness |
| `autonomous_pantry` | Household inventory |
| `autonomous_health` | Biometrics/health |
| `digital_twin_michal` | Core system state |
| `autonomous_learning` | Study/certifications |
| `autonomous_life_logistics` | Life admin |
| `autonomous_career` | Career tracking |

## Common Pitfalls

1. **Don't use bare `except: pass`** - Use `logger.warning()` instead
2. **Don't define DB configs inline** - Import from `db_config.py`
3. **Don't hardcode paths** - Use relative imports where possible
4. **Don't skip syntax check** - Run `python3 -m py_compile` before testing

## n8n Workflows

- Located in `infrastructure/n8n/workflows/`
- 5+ agents implemented with LangChain
- Main workflow: `WF001__Agent_Zero_Strategic_Brain.json`

## North Star

> By end of 2026, everything in daily life runs autonomously - no manual focus on ordinary tasks.

Last updated: 2026-04-09