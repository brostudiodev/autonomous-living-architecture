---
title: "Automation Spec: G11_self_healing_supervisor.py"
type: "automation_spec"
status: "active"
created: "2026-03-06"
updated: "2026-04-13"
---

# 🤖 Automation Spec: G11_self_healing_supervisor.py

## 📝 Overview
**Purpose:** Standardizes system health checks and provides an LLM-ready "Self-Healing" interface for fixing broken automations. Version 2.5 (Registry Hardening).
**Goal Alignment:** G11 (Meta-System Integration & Optimization)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** 
  1. **Every Sync:** Runs as the first step of `G11_global_sync.py`.
  2. **Morning Mission:** Triggered by `fill-daily.sh` before dashboard generation.
  3. **On-Demand:** Triggered via `GET /health_audit` or manual CLI execution.
- **Environment:** Respects `AUDIT_MODE=1` to perform non-destructive checks.

## 🛠️ Logic Flow
1. **Script Discovery:** Iterates through a registry of core automation scripts.
    - **Expanded Registry (Apr 13):** Now monitors `G11_db_recovery_shield.py` and other G-series scripts.
    - **Circular Guard:** `autonomous_daily_manager.py` removed from registry to prevent recursive loops.
2. **Health Probe:** Executes each script with `AUDIT_MODE=1`.
3. **Auto-Repair (NEW Mar 28):**
    - Identifies known failure patterns (DB connectivity, stale tokens, missing directories).
    - Executes corrective actions (restart Docker container, remove stale pickle, create dirs).
    - **Self-Healing Loop:** Re-audits scripts after repair to verify the fix.
4. **Data Integrity Check:** Triggers `G11_pre_flight_check.py` to ensure physical sensor data is current.
5. **Log Persistence:** Saves results to `_meta/automation_health.json` and logs to `system_activity_log`.

## 🩹 Targeted Repair Protocols
The supervisor implements specific repair logic for detected failure patterns:

### 1. Auth Token Recovery (Self-Healing)
- **Detection:** `token invalid`, `expired`, or `unauthorized`.
- **Target Files:** `google_tasks_token.pickle`, `zepp_token.json`, `withings_tokens.json`.
- **Action:** Deletes the stale token file, allowing the next execution to trigger a fresh login flow.

### 2. Database Lock Mitigation
- **Detection:** `lock` error in a Finance-related script (`G05`).
- **Action:** Restarts the `postgres` container to clear hanging sessions and deadlocks.

### 3. Rate Limit Cooldowns
- **Detection:** `429` (Too Many Requests) in `G07_zepp_sync.py`.
- **Action:** Logs a "Cooldown Required" status and skips the current retry to prevent account suspension.

### 4. Bytecode & Attribute Sanitization
- **Detection:** `magic number`, `AttributeError`, or `not found`.
- **Action:** Recursively deletes all `__pycache__` directories in the workspace to force clean compilation.

## 🩹 Auto-Repair Decision Matrix
| Issue | Signature | Action |
|-------|-----------|--------|
| DB Connectivity | `connection to server...` | `docker restart postgres` |
| Stale Auth Tokens | `token invalid` or `expired` | `rm [TOKEN_FILE]` |
| Rate Limiting | `429` / `rate limit` | `Skip/Cooldown` |
| Missing Logs/Meta | `no such file... _meta` | `mkdir -p _meta/daily-logs` |
| Bytecode Corrupt | `magic number`, `AttributeError` | `find . -name __pycache__ -delete` |
| Missing Module | `No module named '...'` | `pip install [module]` |

## 📤 Outputs
- **`_meta/automation_health.json`**: Historical record of system health.
- **LLM Fix Prompt**: Accessible via `--prompt` flag or API.
- **API Endpoint**: `GET /health_audit` for real-time reporting.

## ⚠️ Known Issues / Maintenance
- **Audit Implementation:** Child scripts must implement `AUDIT_MODE` logic to be fully compatible. Unsupported scripts will run normally but may time out or perform side effects.

---
*Generated for G11 System Resilience.*
