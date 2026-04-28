---
title: "Automation Spec: G09 Career Evidence Collector"
type: "automation_spec"
status: "active"
system_id: "S09"
goal_id: "goal-g09"
owner: "Michał"
updated: "2026-04-25"
review_cadence: "monthly"
---

# 🤖 Automation Spec: G09 Career Evidence Collector

## 🎯 Purpose
Automate the collection of technical achievements by scanning Git history for high-impact commits (features, fixes, refactors). This builds a "Technical Brag Document" in real-time, supporting career positioning and performance reviews with zero manual effort.

## 📝 Scope
- **In Scope:** Scanning local Git repositories for commits in the last 24h; Filtering by keyword (feat, fix, refactor, etc.); Formatting for Daily Note injection.
- **Out of Scope:** Pushing commits to remote; Synthesizing business impact (handled by `G09_career_growth_reporter.py`).

## 🔄 Inputs/Outputs
- **Inputs:** Local Git logs (via `git log`).
- **Outputs:** `CAREER_WINS` report injected into the Obsidian Daily Note.

## 🛠️ Dependencies
- **Systems:** S09 Career Intelligence & Positioning.
- **Services:** Git (Local CLI).
- **Credentials:** Local file system permissions.

## ⚙️ Logic & Procedure
1. **Command:** Executes `git log --since='24 hours ago'`.
2. **Filtering:** Filters commit messages against a regex pattern: `feat|perf|fix|refactor|arch|surgical|auto`.
3. **Injection:** The `autonomous_daily_manager.py` calls the collector and injects any found wins into the "🚀 Career Growth & Impact" collapsible section.
4. **Trigger:** Automated via `G11_global_sync.py`.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Git not installed | CommandNotFound error in logs | Ensure Git is available in the environment |
| Not a Git Repo | "Not a git repository" error | Verify `BASE_DIR` points to the correct root |
| No commits | Returns empty string (Normal) | No action needed |

## 🔒 Security Notes
- **Secrets:** Only commit messages are read; no source code or sensitive data is exported.

---
*System Hardening v5.4 - April 2026*
