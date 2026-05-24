---
title: "Adr-0028: Centralized Auth & Credential Relocation"
type: "adr"
status: "accepted"
date: "2026-05-09"
owner: "Michał"
---

# Adr-0028: Centralized Auth & Credential Relocation

## Context
Multiple scripts in the `scripts/` directory previously stored or referenced credential JSON files (OAuth tokens, client secrets, service account keys) locally within the script folder. This fragmented security posture made it difficult to audit, protect, and manage credentials, especially in Dockerized or multi-environment setups.

## Decision
We will centralize all file-based credentials into a dedicated, secure configuration directory.

1.  **Centralized Storage:** All credential JSON files must reside in `config/auth/` (relative to the project root).
2.  **Standardized Access:** Scripts must use the `AUTH_PATH` variable defined in `db_config.py` to resolve paths to these files.
3.  **Relocation:** All existing credential files (Zepp, Google, Withings) are moved from `scripts/` to `config/auth/`.
4.  **Security Auditor Update:** The `G11_security_auditor.py` is updated to monitor `config/auth/` instead of `scripts/` for sensitive files.

## Consequences
- **Security:** Improved auditability. Sensitive files are now isolated from script logic.
- **Consistency:** All G-series scripts now follow the same pattern for credential resolution.
- **Docker Portability:** Mounting `config/auth/` as a volume provides all necessary credentials to containers without cluttering the `scripts/` mount.
- **Maintenance:** Adding new integrations requires placing JSON files in one well-known location.

## Implementation (May 09, 2026)
- **Files Relocated:**
  - `zepp_token.json`
  - `client_secret.json`
  - `google_calendar_token.json`
  - `google_credentials_digital-twin-michal.json`
  - `google_tasks_token.json`
  - `withings_tokens.json`
- **Scripts Updated:**
  - `G04_logistics_sync.py`
  - `G04_relationships_sync.py`
  - `G05_finance_sync.py`
  - `G05_net_worth_snapshot.py`
  - `G07_zepp_sync.py`
  - `G07_weight_sync.py`
  - `G07_withings_direct_sync.py`
  - `G10_activate_calendar.py`
  - `G10_calendar_client.py`
  - `G10_google_tasks_sync.py`
  - `G11_google_drive_backup.py`
  - `pantry_sync.py`
  - `training_sync.py`
  - `G11_security_auditor.py`
- **Infrastructure:** `db_config.py` reinforced as the single source of truth for `AUTH_PATH`.
