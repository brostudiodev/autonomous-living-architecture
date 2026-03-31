---
title: "script: G02 Automationbro Content Harvester"
type: "automation_spec"
status: "active"
automation_id: "G02_content_harvester"
goal_id: "goal-g02"
systems: ["S08", "G02"]
owner: "Michal"
updated: "2026-02-25"
---

# script: G02_content_harvester.py

## Purpose
A specialized utility that scans project-wide activity logs to "harvest" technical achievements and autonomously generate high-signal content drafts for LinkedIn and Substack. This ensures that every technical win is leveraged for brand building with zero friction.

## Triggers
- **Manual:** `python3 scripts/G02_content_harvester.py`
- **Recommended:** Run after a significant build session or as part of the Sunday Weekly Review.

## Inputs
- **Activity Logs:** All `Activity-log.md` files in `docs/10_Goals/`.
- **Time Window:** Last 7 days.

## Processing Logic
1. **Extraction:** Recursively finds all `Activity-log.md` files.
2. **Filtering:** Filters for entries within the last 7 days.
3. **Drafting:** Uses achievement context to generate structured Markdown drafts in Obsidian.
4. **Categorization:** Includes ready-to-use hooks and tags for social platforms.

## Outputs
- **Obsidian Note:** A new file in `00_Inbox/Content Ideas/` named `YYYY-MM-DD - Automationbro Content Harvest.md`.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md)
- [G02 Automationbro Recognition](../../../10_Goals/G02_Automationbro-Recognition/README.md)

### External Services
- Obsidian (File system)

## Manual Fallback
If the harvester is unavailable, manually review the `G11 Strategic Summary` or recent `Activity-log.md` entries to find content inspiration.

---
*Usage:*
```bash
./.venv/bin/python3 scripts/G02_content_harvester.py
```
