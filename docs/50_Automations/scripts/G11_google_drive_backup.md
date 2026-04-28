---
title: "Google Drive Backup Sync (G11)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Google Drive Backup Sync** (`G11_google_drive_backup.py`) handles the off-site storage of encrypted system backups. It ensures that critical data is available for recovery even in the case of local hardware failure.

# Scope
- **In Scope:** Uploading `.sql.gpg` files to a dedicated "Autonomous Backups" folder on Google Drive.
- **Out Scope:** Managing Drive storage quotas or deleting old cloud backups (retention is currently manual/unlimited on Drive).

# Inputs/Outputs
- **Inputs:** Encrypted backup files from `_meta/backups/db/`.
- **Outputs:** Google Drive file IDs and sync status.

# Dependencies
- **Systems:** S03 (Data Layer), G11 (Meta-System)
- **API:** Google Drive API v3 (Scope: `drive.file`)
- **Files:** `client_secret.json`, `google_drive_token.pickle`

# Procedure
- Triggered automatically by `G11_db_recovery_shield.py` after successful encryption.
- **Deduplication:** Checks for existing file names in the target folder to prevent redundant uploads.

# Failure Modes
| Scenario | Response |
|----------|----------|
| Auth Token Expired | Attempt auto-refresh; log failure if manual re-auth needed. |
| Network Timeout | Log PARTIAL status; retry during next morning sync. |
| Folder Missing | Script autonomously creates "Autonomous Backups" folder. |

# Security Notes
- **DRIVE SCOPE:** Uses the narrow `drive.file` scope, meaning the script can only see and access files it created itself.
- **ENCRYPTION:** Files are uploaded in their GPG-encrypted state. Cleartext data NEVER leaves the local environment.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Check Drive folder for sync consistency)
