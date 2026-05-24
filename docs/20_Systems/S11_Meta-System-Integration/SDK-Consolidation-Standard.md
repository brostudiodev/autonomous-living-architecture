---
title: "Standard: SDK Consolidation & Config Centralization"
type: "standard"
status: "active"
owner: "Michał"
updated: "2026-05-19"
---

# Standard: SDK Consolidation & Config Centralization

## Purpose
To ensure the Personal OS remains stable, modular, and maintainable by centralizing core logic in the `autonomous_sdk` and separating configuration from logic.

## Scope
- All Python-based automations (G-series).
- All domain modules in `/modules`.
- Global configuration files in `/config`.

## Architecture

### 1. The Autonomous SDK
The SDK is the single source of truth for core services.
- **Location:** `/autonomous_sdk/`
- **Core Files:**
  - `db_config.py`: Path resolution and DB connections.
  - `log.py`: Unified activity logging and failure notifications.
  - `events.py`: Standardized RabbitMQ event emission.
  - `module.py`: Base class for all modules.

### 2. Configuration Centralization
All files that drive system behavior (YAML/JSON) MUST reside in `/config/`.
- **Autonomy Policies:** `/config/autonomy_policies.yaml`
- **Experiments:** `/config/experiments.yaml`

## Procedure: Using the SDK in a Module

### Step 1: Import DB Config
Always use the SDK version of `db_config` to ensure correct path resolution (especially for the Obsidian Vault).

```python
from autonomous_sdk.db_config import DB_TWIN, setup_logger, POLICY_PATH

logger = setup_logger(__file__)
```

### Step 2: Logging Activity
Use the SDK log service. This handles DB persistence and real-time event emission automatically.

```python
from autonomous_sdk import log

log.activity("script_name", "SUCCESS", items=5, details="Process completed")
```

### Step 3: Emitting Events
Use the SDK event service for cross-system coordination.

```python
from autonomous_sdk import events

events.emit("domain", "action", ```payload: "data"```)
```

## Failure Modes

| Scenario | Detection | Response |
|----------|-----------|----------|
| Missing SDK | `ModuleNotFoundError` | Ensure `PYTHONPATH` includes project root. |
| DB Connection Failure | SDK logs `CRITICAL` error | Check `.env` and PostgreSQL status. |
| Invalid Policy Path | Rules Engine logs `WARNING` | Verify `POLICY_PATH` in `db_config.py`. |

## Security Notes
- **No Secrets in Config:** Use placeholders or environment variables in YAML files.
- **SDK Access:** The SDK respects `SHADOW_MODE` to prevent accidental writes during testing.

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly
- **Next Review:** June 19, 2026
