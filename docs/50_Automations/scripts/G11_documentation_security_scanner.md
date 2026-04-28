---
title: "Automation Spec: G11_documentation_security_scanner.py"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-04-19"
---

# 🤖 Automation Spec: G11_documentation_security_scanner.py

## 📝 Overview
**Purpose:** Scans the entire documentation base (both `docs/` and the `Obsidian Vault/`) to identify potential security exposures, including internal IP addresses, hardcoded passwords, API keys, and sensitive database connection strings.
**Goal Alignment:** G11 Meta-System Integration & Security Hardening.

## ⚡ Technical Details
- **Language:** Python 3.x
- **Triggers:** Manual Execution / Part of documentation audit.
- **Databases:** None (File-based scan).
- **Dependencies:** `os`, `re`, `pathlib`.

## 🛠️ Logic Flow
1. **Directory Crawl:** Recursively walks through the `docs/` and `Obsidian Vault/` directories, skipping hidden folders (like `.git` and `.venv`).
2. **Pattern Matching:** Searches all `.md` files for predefined regex patterns:
    - **Internal IP:** Matches 192-dot-168-dot-x-dot-x, 10-dot-x-dot-x-dot-x, and 172-dot-16-31-dot-x-dot-x ranges.
    - **Hardcoded Password:** Detects common assignment patterns (`password: "{{GENERIC_API_SECRET}}"`, etc.).
    - **API Key / Token:** Identifies tokens and keys based on length and common naming.
    - **Database URL:** Detects PostgreSQL connection strings containing credentials.
3. **Filtering:** Automatically ignores placeholder patterns like `{{INTERNAL_IP}}` or `${DB_PASSWORD}` to avoid false positives.
4. **Reporting:** Outputs the file path and the offending string for every exposure found.

## 📤 Outputs
- **Console Report:** Categorized list of exposures with direct file references.
- **Exit Status:** Summarizes total issues found.

## ⚠️ Known Issues / Maintenance
- **Heuristic Limits:** May occasionally flag non-sensitive strings that match the patterns (e.g., long hex strings that aren't keys).
- **MD Exclusive:** Currently only scans Markdown files.

---
*Created: 2026-04-19 by Digital Twin Assistant*
