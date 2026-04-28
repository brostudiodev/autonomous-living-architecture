---
title: "SOP: Disaster Recovery & Database Restoration"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
This SOP provides the step-by-step procedure for restoring the Autonomous Living ecosystem from encrypted backups in the event of database corruption, container failure, or hardware loss.

# Scope
- **In Scope:** Restoring the 7 core PostgreSQL databases from `.sql.gpg` files.
- **Out Scope:** Restoring the Docker environment itself (refer to [Infrastructure Runbook](../40_Runbooks/Infrastructure/Docker-Setup.md)).

# Prerequisites
1.  **GPG Passphrase:** You must have the `${DB_BACKUP_PASSPHRASE}` from your `.env` file.
2.  **Backup Files:** Located in `_meta/backups/db/` or downloaded from Google Drive.
3.  **Docker:** The Postgres container must be running.

# Procedure

## 1. Decrypt the Backup
Navigate to your backup directory and decrypt the desired database file:
```bash
# Example for autonomous_finance
gpg --batch --yes --passphrase ${DB_BACKUP_PASSPHRASE} -d -o autonomous_finance.sql autonomous_finance_2026-04-02.sql.gpg
```

## 2. Prepare the Container
Ensure the database exists in the container. If you are restoring to a fresh environment, you may need to create the DB first:
```bash
docker exec -it local-ai-packaged-postgres-1 createdb -U root autonomous_finance
```

## 3. Restore the Data
Pipe the decrypted SQL file into the Postgres container:
```bash
cat autonomous_finance.sql | docker exec -i local-ai-packaged-postgres-1 psql -U root -d autonomous_finance
```

## 4. Verify Restoration
Run a quick check to ensure tables and data are present:
```bash
docker exec -it local-ai-packaged-postgres-1 psql -U root -d autonomous_finance -c "\dt"
```

## 5. Cleanup
Immediately delete the unencrypted `.sql` file to maintain security:
```bash
rm autonomous_finance.sql
```

# Failure Modes
| Scenario | Response |
|----------|----------|
| Decryption Error | Verify passphrase in `.env`. Ensure GPG is installed. |
| DB Already Exists | Use `dropdb` first if you want a clean restore. |
| Permission Denied | Ensure you are running as the user who owns the `_meta` folder. |

# Security Notes
- **NEVER** leave unencrypted `.sql` files on the disk or in the cloud.
- Store the GPG passphrase in a secure password manager (e.g., Bitwarden).

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Quarterly (Run a test restore of a non-critical DB)
