---
title: "G13: Metrics"
type: "goal_metrics"
status: "active"
owner: "Michal"
updated: "2026-05-23"
goal_id: "goal-g13"
---

# Metrics

## Leading Indicators
| Metric | Target | Source |
|---|---:|---|
| Content harvest files generated | 7 per week | `Obsidian Vault/00_Inbox/Content Ideas/` |
| Drafts generated | 4+ per week | `Obsidian Vault/00_Inbox/Content-Drafts/`, LinkedIn Drafts, Substack Drafts |
| Draft scheduling tasks created | 1+ per week | Google Tasks via `G13_substack_scheduler.py` |
| Content sync success rate | >= 95% | `system_activity_log` / G11 reliability reports |
| Manual review backlog age | <= 14 days | Obsidian Inbox review |

## Lagging Indicators
| Metric | Target | Source |
|---|---:|---|
| Published LinkedIn posts from G13 drafts | 3 per week | G02/G13 publishing review |
| Published Substack articles from G13 drafts | 1 per week or cadence agreed in G02 | G02/G13 publishing review |
| Draft-to-publish conversion rate | >= 50% | Manual review log |
| Content tied to real system wins | 100% | Goal activity logs and `system_activity_log` |

## Measurement Procedure
1. Review generated files in `00_Inbox/Content Ideas` and draft folders weekly.
2. Check G11 activity logs for `G13_*` script `SUCCESS` and `FAILURE` entries.
3. Compare generated drafts against G02 publishing outcomes.
4. Archive or delete stale drafts older than 14 days after review.

## Failure Signals
| Signal | Meaning | Response |
|---|---|---|
| No harvest file for 2+ days | Idea pipeline stalled | Run `G13_content_idea_generator.py` or module sync and inspect logs |
| Drafts contain ungrounded claims | LLM context quality issue | Tighten prompt/context and require manual rejection |
| Draft backlog older than 14 days | Review loop is overloaded | Reduce draft volume or add automatic archival |
| Scheduler task missing | Publishing handoff failed | Check Google Tasks integration through G10 |

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Weekly quick check, monthly metric review
