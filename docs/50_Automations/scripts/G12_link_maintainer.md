---
title: "Automation Spec: G12_link_maintainer.py"
type: "automation_spec"
status: "active"
created: "2026-03-06"
updated: "2026-03-06"
---

# 🤖 Automation Spec: G12_link_maintainer.py

## 📝 Overview
**Purpose:** Autonomously identifies broken Markdown and WikiLinks across the documentation library and Obsidian Vault to maintain system traceability.
**Goal Alignment:** G12 (Complete Process Documentation)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Scheduled via `G11_global_sync.py` or On-Demand via `G11_self_healing_supervisor.py`.
- **Databases:** None (File system scan).
- **Dependencies:** `os`, `re`, `json`, `pathlib`

## 🛠️ Logic Flow
1. **Directory Crawl:** Deep-scans `docs/` and `Obsidian Vault/` for Markdown files.
2. **Link Extraction:** Uses regex to find both standard `[text](path)` and `[[WikiLinks]]`.
3. **Target Validation:** Verifies if the target file or anchor exists on disk.
4. **Issue Logging:** Aggregates all broken references into `_meta/broken_links.json`.

## 📤 Outputs
- **`_meta/broken_links.json`**: Machine-readable log of all broken references.
- **Audit Signal:** Non-zero exit code if paths are invalid, alerting the Self-Healing Supervisor.

## ⚠️ Known Issues / Maintenance
- **Performance:** Scanning the full Obsidian Vault can be time-consuming; uses a flat list check for WikiLinks to optimize.

---
*Generated for Documentation Integrity.*
