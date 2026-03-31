---
title: "ADR-0013: Security Hardening & Secrets Management"
type: "adr"
status: "accepted"
date: "2026-03-03"
owner: "Michal"
---

# ADR-0013: Security Hardening & Secrets Management

## Context
Multiple scripts in the `scripts/` directory previously contained hardcoded credentials (API keys, passwords, client secrets). This posed a security risk and made the repository difficult to share or move to public version control (Git).

## Decision
We will transition to a **Environment-First Secrets Management** strategy.

1.  **Centralized Storage:** All sensitive credentials must reside in a single `.env` file at the root of the project (`{{ROOT_LOCATION}}/autonomous-living/.env`).
2.  **Standardized Loading:** All Python scripts must use `python-dotenv` to load these variables.
3.  **Variable Naming:** 
    - Database: `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`.
    - API: `PROVIDER_CLIENT_ID`, `PROVIDER_CLIENT_SECRET`, `PROVIDER_API_KEY`.
    - User: `PROVIDER_EMAIL`, `PROVIDER_PASSWORD`.
4.  **No Hardcoding:** Hardcoded string literals for passwords or secrets are strictly forbidden in `.py` files.

## Consequences
- **Security:** Reduced risk of credential leakage. The `.env` file is explicitly ignored by Git.
- **Portability:** Easier deployment across different environments (Dev/Prod/Docker).
- **Maintenance:** Changing a password now requires an update in only one file (`.env`).
- **Complexity:** Requires adding `load_dotenv()` and `os.getenv()` calls to every script that interacts with external services or databases.

## Implementation (March 03, 2026)
- **Withings:** Migrated Client ID and Secret to `.env`.
- **Zepp:** Migrated Email and Password to `.env`.
- **Database:** Unified script connections to use global `DB_USER` and `DB_PASSWORD`.
- **Scripts Updated:** `withings_to_sheets.py`, `G07_zepp_sync.py`, `G07_weight_sync.py`, `G09_career_sync.py`, and multiple debug/verification scripts.
