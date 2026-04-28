---
title: "G02: Substack Content & Metrics Sync"
type: "automation_spec"
status: "active"
automation_id: "G02_substack_sync"
goal_id: "goal-g02"
systems: ["S03", "S04", "S11"]
owner: "Michał"
updated: "2026-03-22"
---

# G02: Substack Content & Metrics Sync

## Purpose
Automates the synchronization of Substack articles to the Obsidian vault and tracks brand metrics (subscribers, views) in the central database.

## Triggers
- **Scheduled:** Part of the `G11_global_sync.py` cycle.
- **Manual:** `python3 scripts/G02_substack_sync.py`

## Inputs
- **RSS Feed:** `https://automationbro.substack.com/feed`
- **Web Scraping:** `https://automationbro.substack.com/about` (for subscriber count)
- **Environment:** `DB_PASSWORD` for PostgreSQL access.

## Processing Logic
1.  **Article Sync:**
    *   Fetches the Substack RSS feed.
    *   Compares post IDs with local files in `04_Resources/Automationbro/Articles`.
    *   Converts HTML content to Markdown and saves new articles with proper frontmatter.
2.  **Metrics Sync:**
    *   Scrapes the Substack "About" page for the latest subscriber count.
    *   Upserts metrics (date, subscribers, views) into the `brand_metrics` table in the `autonomous_finance` database.
3.  **Reporting:**
    *   Logs success/failure and item counts to the `system_activity_log`.

## Outputs
- **Obsidian Files:** New Markdown articles in the vault.
- **Database:** Updated rows in `brand_metrics`.
- **System Log:** SUCCESS/FAILURE entry.

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- **Substack:** RSS and HTTP access.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| RSS Feed Offline | `feedparser` empty result | Skip sync, log warning | System Report |
| Scraping Blocked | HTTP 403/429 | Fallback to manual/placeholder count | System Report |
| DB Error | `psycopg2` Exception | Log failure | System Report |

## Manual Fallback
Run the script manually from the terminal to check for specific HTTP errors or database connectivity issues.
