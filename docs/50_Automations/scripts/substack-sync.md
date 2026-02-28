---
title: "G02_substack_sync.py: Substack Content & Metrics Sync"
type: "automation_spec"
status: "active"
automation_id: "substack-sync"
goal_id: "goal-g02"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-02-24"
---

# G02_substack_sync.py: Substack Content & Metrics Sync

## Purpose
Automates the synchronization of Substack articles to the Obsidian "Second Brain" and extracts key performance metrics (subscribers, views) into the Digital Twin database.

## Triggers
- **Scheduled:** Daily at 05:00 AM (invoked by `autonomous_daily_manager.py`).
- **Manual:** `python3 scripts/G02_substack_sync.py`

## Inputs
- **RSS Feed:** `https://automationbro.substack.com/feed`
- **Obsidian:** `04_Resources/Automationbro/Articles` (for local copies).
- **Database:** `autonomous_finance` (for metrics persistence).

## Processing Logic
1. **Fetch Feed:** Parses the Substack RSS feed for new entries.
2. **Local Sync:** For each new post, converts HTML to Markdown and saves it to the Obsidian Vault with relevant frontmatter.
3. **Metrics Extraction:** Pulls engagement data (currently simulated placeholders for subscribers/views until API/Scraping is finalized).
4. **DB Persistence:** UPSERTS daily metrics into the `brand_metrics` table.

## Outputs
- **Markdown Files:** Local copies of articles in Obsidian.
- **Database:** Daily record in `brand_metrics` table.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- **Substack RSS:** Public feed access.

## Monitoring
- **Digital Twin:** metrics displayed in the unified status summary.
- **SQL:** `SELECT * FROM brand_metrics ORDER BY metric_date DESC;`
