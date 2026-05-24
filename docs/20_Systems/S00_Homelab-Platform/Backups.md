---
title: "S00: Backups"
type: "runbook"
status: "active"
owner: "Michał"
updated: "2026-05-10"
---

# Backups

## Backup policy
- **Frequency:** 
    - **Databases:** Daily at 06:15 (orchestrated by `G11_global_sync.py` via `G11_db_recovery_shield.py`).
    - **Vault/Scripts:** Daily filesystem snapshots + real-time Git/Obsidian sync.
- **Retention:**
    - **Local:** 7 days (strict cleanup enforced by `G11_db_recovery_shield.py`).
    - **Offsite (Cloud):** Indefinite (Google Drive versioning/storage limit).
- **Offsite:** 
    - Automated upload of AES256-encrypted GPG dumps to Google Drive (`Autonomous Backups` folder) via `G11_google_drive_backup.py`.
- **Restore testing schedule:**
    - **Automated:** Every run (Recovery Shield performs a full restore-to-test-db verification for all 7 domain databases).
    - **Manual Drill:** Quarterly (Next: July 2026).

## Restore drill
- [ ] **Step 1: Identify target backup** in `_meta/backups/db/` or Google Drive.
- [ ] **Step 2: Decrypt**
  ```bash
  gpg --batch --yes --passphrase [DB_BACKUP_PASSPHRASE] --decrypt file.sql.gpg > file.sql
  ```
- [ ] **Step 3: Restore**
  ```bash
  docker exec -i postgres psql -U root -d db_name < file.sql
  ```
- [ ] **Step 4: Validate**
  ```bash
  # Check system activity log for fresh entries
  docker exec postgres psql -U root -d digital_twin_michal -c "SELECT * FROM system_activity_log ORDER BY timestamp DESC LIMIT 5;"
  ```
- [ ] **Step 5: Document** time-to-restore and any anomalies in the Friction Log.

## Dependencies
- **Systems:** S00 Homelab Platform (Docker Host).
- **Credentials:** `DB_BACKUP_PASSPHRASE` (Symmetric key in `.env`).
- **Hardware:** Sufficient local disk space for 7 days of snapshots.
- **External:** Google Drive API (via `config/auth/google_drive_token.json`).

---
*Created: 2026-05-10 | Part of G11 Meta-System Hardening*
