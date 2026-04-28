---
title: "Stale Documentation Monitor (G12)"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-04"
---

# Purpose
The **Stale Documentation Monitor** (`G12_stale_docs_monitor.py`) scans the goal and system documentation to identify files that haven't been updated in over 30 days. This ensures that the "Source of Truth" remains current and accurate.

# Scope
- **In Scope:** `docs/10_Goals/` and `docs/20_Systems/` Markdown files.
- **Out Scope:** `docs/90_Attachments/`, `_meta/` logs, and scripts.

# Inputs/Outputs
- **Inputs:** 
  - File frontmatter (specifically the `updated:` field).
  - File system metadata (mtime) as fallback.
- **Outputs:** Markdown report of stale files for the `G11_mission_aggregator`.

# Dependencies
- **Systems:** S04 (Digital Twin), G12 (Complete Process Documentation)
- **Libraries:** `pyyaml`

# Procedure
- Executed as part of the morning sync by `autonomous_daily_manager.py`.
- Can be run manually to audit documentation freshness.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| YAML Parse Error | Script logs warning | Fallback to file mtime |
| Date/Datetime Mismatch | ValueError (Fix Apr 04) | Script now handles `datetime`, `date`, and `str` (ISO/standard) formats gracefully. |
| Path not found | FileNotFoundError | Verify REPO_ROOT in .env |

# Security Notes
- Read-only access to documentation files.
- No sensitive data processed.

# Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Goal G12 audit)
