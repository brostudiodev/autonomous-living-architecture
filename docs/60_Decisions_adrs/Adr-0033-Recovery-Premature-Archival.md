---
title: "Adr-0033: Recovery from Premature Archival and Modular Path Alignment"
type: "adr"
status: "active"
owner: "Michał"
updated: "2026-05-14"
---

# Adr-0033: Recovery from Premature Archival and Modular Path Alignment

## Status
Active (Emergency Implementation)

## Context
During the G11 Modular Architecture migration, approximately 116 scripts were archived to `scripts/archive/`. However, the system's scheduled tasks (crontab), the Digital Twin API, and cross-domain dependencies were still pointing to the legacy root `/scripts/` directory. This resulted in:
1. **Automation Silence:** Failure of Daily Note generation and Telegram briefings (Morning/Evening).
2. **API Breakdown:** The `/all` (Uber-Context) endpoint failed due to missing G11 health dashboard imports.
3. **Execution Gap:** Modular scripts failed when run via cron due to missing `PYTHONPATH` context.

## Decision
1. **Immediate Restoration:** Restored essential orchestrators (`autonomous_daily_manager.py`, `autonomous_evening_manager.py`, `G11_obsidian_safe_sync.py`, `G11_unified_health_dashboard.py`) from `archive/` to `/scripts/`.
2. **Environment Hardening:** Updated the system crontab to explicitly define `AP` (root), `VENV`, and a comprehensive `PYTHONPATH` covering all modular script directories.
3. **Legacy Proxy Layer:** Created "Proxy Scripts" (e.g., `G04_digital_twin_engine.py`) in `/scripts/` that import from `core/` to maintain backward compatibility for scripts not yet fully refactored.
4. **API Import Correction:** Updated `core/api.py` to use relative package imports (e.g., `from scripts.G11_...`) ensuring stability regardless of working directory.

## Consequences
- **Positive:** Restoration of all primary autonomous loops (Briefings, Daily Notes, Syncs).
- **Positive:** Standardized environment for both Host and Docker execution.
- **Neutral:** Slower decommissioning of the `/scripts/` root to ensure stability during the transition.
- **Action Required:** Future refactoring must prioritize updating the crontab and API endpoints before archiving logic.
