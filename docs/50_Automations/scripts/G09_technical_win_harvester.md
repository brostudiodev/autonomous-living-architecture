---
title: "Technical Win Harvester (G09)"
type: "automation_spec"
status: "active"
owner: "Michal"
updated: "2026-04-02"
---

# Purpose
The **Technical Win Harvester** (`G09_technical_win_harvester.py`) automates the collection of engineering achievements for career tracking. It eliminates the need for manual end-of-day reflection by pulling data directly from source control.

# Scope
- **In Scope:** Specified local git repositories, commits authored by the user today.
- **Out Scope:** Repositories not in the config list, merge commits, non-conventional commit messages.

# Harvesting Logic
- **Detection:** Runs `git log --since=00:00:00`.
- **Filtering:** Only includes commits starting with `feat:`, `fix:`, `refactor:`, `docs:`, `perf:`, or `sys:`.
- **Formatting:** Formats as `#🏆win` tags for Obsidian searchability.

# Inputs/Outputs
- **Inputs:** Local Git history.
- **Outputs:** Markdown list of technical wins for the `CAREER_WINS` collapsible section.

# Dependencies
- **Systems:** S11 (Meta-System), G09 (Automated Career Intelligence)
- **Tools:** `git` CLI

# Procedure
- Automatically executed by `autonomous_daily_manager.py` during the daily sync.

# Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Repo Missing | Path not found | Skips repo; logs warning. |
| Git Error | subprocess exit code != 0 | Skips repo; ensures sync continues. |

# Security Notes
- Read-only access to commit messages.
- No source code or secrets are extracted.

# Owner + Review Cadence
- **Owner:** Michal
- **Review:** Quarterly (Review career growth report based on harvested wins)
