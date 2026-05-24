---
title: "Cross-Domain Sync & Auth Restoration"
type: "system_documentation"
status: "active"
owner: "Michał"
updated: "2026-05-20"
system_id: "s01-sync-restoration"
---

# Cross-Domain Sync & Auth Restoration (S01/G11)

## Purpose
This document records the emergency restoration of Google OAuth flows and critical domain synchronization (Pantry, Health, Training) that were failing due to modularization side-effects and hardcoded legacy configurations.

## Scope
- **Auth:** Google Tasks / Google Sheets OAuth 2.0 flow repairs.
- **Pantry (G03):** Restoration of inventory sync and suggestion engine.
- **Health (G07):** Restoration of Withings API to PostgreSQL direct sync.
- **Observability (S01):** Resolution of "Unknown/No Log" statuses on the `/map` endpoint.

## Inputs/Outputs
- **Inputs:** `.env` variables (`GOOGLE_SHEET_ID_PANTRY`, `WITHINGS_CLIENT_ID`), `client_secret.json`.
- **Outputs:** Verified "SUCCESS" logs in `system_activity_log`, updated Obsidian reports (`Pantry-Suggestions.md`, `Strength-Gains-*.md`).

## Dependencies
- **Infrastructure:** RabbitMQ (Event Bridge), PostgreSQL (S03), Google Cloud Console (OAuth Client).
- **SDK:** `autonomous_sdk` (Modular Path Resolution, Structured Logging).

## Procedure

### 1. Google Auth Redirect Fix
The `google_auth_helper.py` was updated to explicitly discover a free port and set the `redirect_uri` *before* generating the authorization URL. This resolves the `400: invalid_request` error in headless environments.

### 2. Pantry Sync Recovery
- **Environment Alignment:** Switched `pantry_sync.py` from a hardcoded Sheet ID to the `GOOGLE_SHEET_ID_PANTRY` environment variable.
- **Code Repair:** Surgically removed corrupted duplicate imports that were injected during previous batch updates, resolving `NameError: BASE_DIR` and `SyntaxError`.

### 3. Health Sync Standardization
- **Naming Alignment:** Synchronized `G07_weight_sync` and `G07_withings_direct_sync` to ensure both use the modular SDK standard.
- **Logging Restoration:** Added `log_activity` calls to the Withings sync flow, enabling "Success" visibility on the connectivity map.

### 4. Visibility Enforcement
- Implemented `sys.path` injection across all `modules/*/scripts/` to ensure `ModuleNotFoundError` is eliminated when scripts are run in isolation or by the Orchestrator.

### 5. System Backup & State Persistence
- **Repository Backup:** Pushed all architectural repairs and standardized scripts to GitHub (`origin/autonomy_phase`).
- **Data Persistence:** Synchronized generated reports (Strength Gains, Content Harvest) and the May Progress Summary to the remote Obsidian Vault.
- **Git Hygiene:** Cleaned up `__pycache__` artifacts from the remote history to maintain repository integrity.

## Failure Modes

| Failure | Detection | Fix |
|---------|-----------|-----|
| `400: invalid_request` | Browser error on auth link. | Ensure `redirect_uri` is generated with an active port. |
| `404: Sheet Not Found` | Pantry sync log error. | Verify `GOOGLE_SHEET_ID_PANTRY` in `.env`. |
| Status "Unknown" | Grey dot on `/map`. | Check if `log_activity` is called inside the script. |

## Security Notes
- OAuth tokens are stored in `config/auth/*.json` and are excluded from git.
- Direct API syncs (Withings) are preferred over intermediate Google Sheets to reduce the credential attack surface.

## Owner + Review Cadence
- **Owner:** Digital Twin Assistant
- **Review Cadence:** Part of the G12 Weekly System Stability Audit.

## References
- [S01: Modular Script Logging Standard](./Modular-Script-Logging-Standard.md)
- [Adr-0001: Repo Structure](../../60_Decisions_adrs/Adr-0001-Repo-Structure.md)
