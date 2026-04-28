---
title: "Vault Janitor (G12)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
The **Vault Janitor** (`G12_vault_janitor.py`) maintains high performance and focus in the Obsidian Vault. It prevents the `00_Inbox` from becoming a clutter bottleneck by identifying stale notes and flagging low-value (empty) files.

# Scope
- **In Scope:** `00_Inbox` directory in the Second Brain vault.
- **Out Scope:** All other vault folders (Archive, Resources, Systems, etc.).

# Logic & Thresholds
- **Stale Note:** Any file in `00_Inbox` with a modification time (mtime) older than **72 hours**.
- **Empty Note:** Any file with less than **50 characters** of content (excluding YAML frontmatter).
- **Auto-Tagging:** Empty notes are automatically appended with the `#system/empty` tag for easy bulk deletion.

# Inputs/Outputs
- **Inputs:** Local file system metadata and file content from the Obsidian Vault.
- **Outputs:** Stale note alerts for the `G11_mission_aggregator`.

# Dependencies
- **Systems:** S10 (Daily Goals Automation), G12 (Complete Process Documentation)
- **Files:** `Obsidian Vault/00_Inbox/`

# Procedure
- Automatically executed as part of the daily sync via `autonomous_daily_manager.py`.
- Reports the top 3 oldest stale notes to the Golden Mission list (Weight 7).

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Inbox path missing | Script logs warning | Skip scan; ensure correct path in script. |
| Permission Denied | File access error | Check OS-level permissions for the Vault directory. |

# Security Notes
- Read/Write access to the vault is required for tagging.
- No external data transmission.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (verify hygiene effectiveness)
