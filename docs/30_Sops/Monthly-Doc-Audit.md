---
title: "SOP: Monthly Documentation Audit"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-04-04"
---

# SOP: Monthly Documentation Audit

## Purpose
Ensure all system documentation remains current, accurate, and compliant with the `Documentation-Standard.md`. This process prevents "Knowledge Decay" and ensures that AI agents have reliable data for decision-making.

## Procedure

### 1. Automated Scan
Run the documentation audit script to identify immediate structural issues and broken links.
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 {{ROOT_LOCATION}}/autonomous-living/scripts/G12_documentation_audit.py
```

### 2. Review Audit Report
Open `docs/G12_Documentation_Audit_Report.md` and review the results.
- **Goal Tier Audit:** Ensure all goals have ✅ health.
- **System Tier Audit:** Check for missing READMEs or sub-docs.
- **Broken Links:** Address any entries in the "Broken Links Detail" section.

### 3. Stale Document Review
Check for documents that haven't been updated in 30+ days.
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 {{ROOT_LOCATION}}/autonomous-living/scripts/G12_stale_docs_monitor.py
```
For each stale document:
- Verify if the system/goal logic has changed.
- Update the `updated:` field in frontmatter.
- Commit changes.

### 4. Link Integrity Check
Run the deep link scanner to find orphan files or broken relative paths.
```bash
{{ROOT_LOCATION}}/autonomous-living/.venv/bin/python3 {{ROOT_LOCATION}}/autonomous-living/scripts/check_all_links.py
```

## Success Criteria
- [ ] Overall Documentation Health > 95%.
- [ ] Zero broken links in G-series goal folders.
- [ ] All `SSystems.md` files accurately reflect current automation states.

## Failure Modes
| Scenario | Response |
| :--- | :--- |
| Script fails to run | Check virtual environment and dependencies (`psycopg2`, `yaml`). |
| Report shows 0% health | Verify `DOCS_DIR` path in `G12_documentation_audit.py`. |
