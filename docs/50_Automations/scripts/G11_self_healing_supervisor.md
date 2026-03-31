---
title: "Automation Spec: G11_self_healing_supervisor.py"
type: "automation_spec"
status: "active"
created: "2026-03-06"
updated: "2026-03-13"
---

# 🤖 Automation Spec: G11_self_healing_supervisor.py

## 📝 Overview
**Purpose:** Standardizes system health checks and provides an LLM-ready "Self-Healing" interface for fixing broken automations.
**Goal Alignment:** G11 (Meta-System Integration & Optimization)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** 
  1. **Every Sync:** Runs as the first step of `G11_global_sync.py`.
  2. **Morning Mission:** Triggered by `fill-daily.sh` before dashboard generation.
  3. **On-Demand:** Triggered via `GET /health_audit` or manual CLI execution.
- **Databases:** None (Direct execution of child scripts).
- **Dependencies:** `subprocess`, `json`, `datetime`
- **Environment:** Respects `AUDIT_MODE=1` to perform non-destructive checks.

## 🛠️ Logic Flow
1. **Script Discovery:** Iterates through a registry of core automation scripts.
2. **Health Probe:** Executes each script with `AUDIT_MODE=1`.
3. **Auto-Repair (NEW Mar 28):**
    - Identifies known failure patterns (DB connectivity, stale tokens, missing directories).
    - Executes corrective actions (restart Docker container, remove stale pickle, create dirs).
    - **Self-Healing Loop:** Re-audits scripts after repair to verify the fix.
4. **Data Integrity Check:** Triggers `G11_pre_flight_check.py` to ensure physical sensor data is current.
5. **Log Persistence:** Saves results to `_meta/automation_health.json` and logs to `system_activity_log`.

## 🩹 Auto-Repair Directory
| Issue | Signature | Action |
|-------|-----------|--------|
| DB Connectivity | `connection to server...` | `docker restart postgres` |
| Stale Google Auth | `token invalid` or `expired` | `rm google_tasks_token.pickle` |
| Missing Logs/Meta | `no such file... _meta` | `mkdir -p _meta/daily-logs` |
| Bytecode Corrupt | `magic number` or `import error` | `find . -name __pycache__ -delete` |
5. **Prompt Engineering:** Generates a specific prompt for LLMs to diagnose and fix detected failures.
6. **Integration:** Block/Warn downstream syncs if critical failures are detected.

## 📤 Outputs
- **`_meta/automation_health.json`**: Historical record of system health.
- **LLM Fix Prompt**: Accessible via `--prompt` flag or API.
- **API Endpoint**: `GET /health_audit` for real-time reporting.

## ⚠️ Known Issues / Maintenance
- **Audit Implementation:** Child scripts must implement `AUDIT_MODE` logic to be fully compatible. Unsupported scripts will run normally but may time out or perform side effects.

---
*Generated for G11 System Resilience.*
