---
title: "Database Recovery Shield (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-28"
---

# Purpose
The **Database Recovery Shield** (`G11_db_recovery_shield.py`) provides enterprise-grade data protection. It ensures that all 7 critical system databases are backed up, verified for integrity, and encrypted before being stored.

# Scope
- **In Scope:** SQL dumps of all PostgreSQL databases, GPG encryption, restore verification tests.
- **Out Scope:** Large binary file backups (images/PDFs), real-time streaming replication.

# Inputs/Outputs
- **Inputs:** PostgreSQL databases via Docker `pg_dump`.
- **Outputs:** Verified `.sql.gpg` files in `_meta/backups/db/`.

# Dependencies
- **Systems:** S03 (Data Layer), G11 (Meta-System)
- **Tools:** `docker`, `gpg`
- **Environment:** `DB_BACKUP_PASSPHRASE` must be set in `.env`.

# Procedure
- Triggered daily by `autonomous_daily_manager.py`.
- **Verification Logic:** Creates a temporary `{db}_verify_test` database, restores the dump (600s timeout), and checks for public tables.
- **Encryption Logic:** Uses AES256 symmetric encryption via `gpg`.
- **Backups:** `pg_dump` uses a 600s timeout to handle large DB volumes (S03 hardening).

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Verification Failed | Script logs PARTIAL/FAILURE | Alert via Telegram; check SQL file size. Timeouts increased to 600s for stability. |
| Encryption Failed | `.gpg` file missing | Alert via Telegram; check gpg passphrase |
| Disk Full | `pg_dump` error | Cleanup `_meta/backups/` manually |
| SQL Dump Timeout | stderr log: "timeout" | Increase timeout in script or check DB load during backup. |

# Security Notes
- **PASSWORDS:** Never store the backup passphrase in cleartext in documentation. Use `${DB_BACKUP_PASSPHRASE}`.
- **OFF-SITE:** Encrypted files are safe for Google Drive upload.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify restoration manually once a month)
