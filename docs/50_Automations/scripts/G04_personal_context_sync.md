---
title: "G04: Personal Context Sync"
type: "automation_spec"
status: "active"
automation_id: "G04_personal_context_sync"
goal_id: "goal-g04"
systems: ["S04", "S03"]
owner: "Michał"
updated: "2026-04-28"
---

# G04: G04_personal_context_sync.py

## Purpose
Synchronizes deep personal context (identity, CV, work history, hobbies, health baselines) from Obsidian Markdown files to the Digital Twin database. This allows the AI Engine to have a persistent, document-driven awareness of Michał's background and preferences.

## Triggers
- **Scheduled:** Part of the Tier 0 global sync cycle via `G11_global_sync.py`.
- **Manual:** `python3 scripts/G04_personal_context_sync.py`

## Inputs
- **Obsidian Folder:** `/Obsidian Vault/99_System/Personal/`
- **Files:** `Identity.md`, `CV.md`, `Work-History.md`, `Hobbies-Deep-Dive.md`, `Health-Baselines.md`.
- **Metadata:** YAML frontmatter in each file.

## Processing Logic
1.  Scans the designated Obsidian "Personal" folder for Markdown files.
2.  For each file, parses the YAML frontmatter and the raw Markdown content.
3.  **Upsert Logic:** Inserts or updates the content into the `personal_intelligence` table in the `digital_twin_michal` database.
4.  **JSON Hardening:** Utilizes a `json_serial` helper to ensure date objects in metadata are correctly serialized to JSONB.
5.  Logs synchronization status to the `system_activity_log`.

## Outputs
- **Database Table:** `digital_twin_michal.public.personal_intelligence`
- **Fields:** `source_file`, `content`, `metadata`, `last_updated`.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- None (Local file system)

### Credentials
- PostgreSQL `DB_TWIN` credentials (via `db_config.py`).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Folder Missing | `os.path.exists` check fails | Log ERROR, exit | System Sync Status: ❌ |
| JSON Serialization Error | `TypeError` in `json.dumps` | Handled via `json_serial` helper | Logged to activity system |
| DB Connection Fail | `psycopg2.OperationalError` | Log error, exit | System Sync Status: ❌ |

## Monitoring
- **Success Metric:** Number of files processed (expected: 5).
- **Log:** `system_activity_log` records SUCCESS for `G04_personal_context_sync`.

## Manual Fallback
The AI Engine will continue to use the last successfully synchronized data from the database. Manual data injection can be done via SQL if the file system is unavailable.
