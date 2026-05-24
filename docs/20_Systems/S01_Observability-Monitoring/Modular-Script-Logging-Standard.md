---
title: "Modular Script Logging Standardization"
type: "system_documentation"
status: "active"
owner: "Michał"
updated: "2026-05-20"
system_id: "s01-logging-standard"
---

# Modular Script Logging Standardization (S01)

## Purpose
This documentation outlines the standardization of script logging and path resolution across the modularized Autonomous Living codebase. It ensures that all scripts executed from within the `modules/` directory are correctly tracked on the `/map` endpoint and system activity logs.

## Scope
- **In Scope:** All Python scripts located in `modules/*/scripts/`.
- **Out of Scope:** Legacy scripts in the root `scripts/` directory (deprecated) and non-Python automations.

## Inputs/Outputs
- **Inputs:** Script execution status, error messages, and metrics.
- **Outputs:** `system_activity_log` entries in the `autonomous_twin` database, events emitted to the RabbitMQ bus.

## Dependencies
- **Systems:** S03 Data Layer (PostgreSQL), S12 Event-Driven Architecture (RabbitMQ).
- **Services:** `autonomous_sdk` for path and logging utilities.
- **Credentials:** `DB_PASSWORD` for database connectivity.

## Procedure

### 1. Standard Path Resolution
Every modular script MUST include the following boilerplate at the top to ensure the project root is in `sys.path`. This allows scripts to find the `autonomous_sdk` and other top-level modules regardless of where they are executed from.

```python
import os
import sys
from pathlib import Path

# Ensure project root is in PYTHONPATH
AP = str(Path(__file__).resolve().parent.parent.parent.parent)
if AP not in sys.path:
    sys.path.append(AP)
    sys.path.append(os.path.join(AP, "scripts"))
```

### 2. Standardized Activity Logging
Scripts MUST use the `log_activity` function to record their status.

```python
from G11_log_system import log_activity

# On Success
log_activity("script_name", "SUCCESS", items=processed_count, details="Optional success message")

# On Failure
log_activity("script_name", "FAILURE", details="Error description")
```

### 3. Verification Checklist
- [ ] Script executed via project virtual environment (`.venv`).
- [ ] No `ModuleNotFoundError` for `autonomous_sdk`.
- [ ] Entry visible in `system_activity_log` table.
- [ ] `/map` endpoint shows correct status (Green for Success, Red for Failure).

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| `ModuleNotFoundError` | Script fails immediately with import error. | Check `sys.path` injection logic. |
| Status "Unknown" on `/map` | Script shows grey/dotted on connectivity map. | Ensure `log_activity` is called and `script_name` matches manifest. |
| DB Connection Timeout | "Connection refused" in logs. | Verify `DB_HOST` and `DB_PORT` in `.env`. |

## Security Notes
- Logging MUST NOT include PII, API keys, or plain-text credentials.
- Error details should be sanitized before being written to the database.

## Owner + Review Cadence
- **Owner:** Michał / Digital Twin Assistant
- **Review Cadence:** Monthly System Stability Audit (G12).
