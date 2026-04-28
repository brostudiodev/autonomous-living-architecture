---
title: "G13: Autonomous Content Engine"
type: "goal"
status: "active"
goal_id: "goal-g13"
owner: "Michał"
updated: "2026-04-21"
review_cadence: "monthly"
---

# G13: Autonomous Content Engine

## 🌟 What you achieve
*   **Zero-Effort Content Harvesting:** Automatically extract "wins" and insights from daily work logs.
*   **Multi-Platform Draft Generation:** AI-powered creation of LinkedIn posts and Substack newsletters.
*   **Automated Scheduling:** Programmatic queueing of content for optimal engagement.

## Purpose
To bridge the gap between "doing the work" and "sharing the work." G13 automates the high-friction task of content drafting, ensuring that technical achievements in the Autonomous Living system are consistently translated into public-facing thought leadership (linked to G02).

## Scope
### In Scope
- Content idea harvesting from `system_activity_log` and `digital_twin_michal`.
- LinkedIn draft generation (via `G13_linkedin_draft_generator.py`).
- Substack draft generation (via `G13_substack_draft_generator.py`).
- Automated content scheduling and pipeline management.

### Out of Scope
- Manual video editing.
- Management of paid sponsorships.

## Definition of Done (2026)
- [ ] Pipeline running daily with < 5% failure rate.
- [ ] Automatic delivery of 3 LinkedIn drafts and 1 Substack draft per week to Obsidian Inbox.
- [ ] Integration with G11 for failure reporting.

## Inputs
- `system_activity_log` (PostgreSQL)
- Goal Roadmaps and Activity Logs (Markdown)
- Google Gemini API

## Outputs
- `Obsidian Vault/00_Inbox/Content Ideas/`
- `Obsidian Vault/00_Inbox/LinkedIn Drafts/`
- `Obsidian Vault/00_Inbox/Substack Drafts/`

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md)

### External
- Google Gemini API
- LinkedIn/Substack APIs

## Key Links
- Roadmap: [Roadmap.md](Roadmap.md)
- Activity Log: [Activity-log.md](Activity-log.md)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| LLM Hallucination | Gibberish in draft | Human-in-the-loop review before publishing |
| Script Failure | G11 FAILURE log | Trigger G11 resolver; check `G13_run_content_pipeline.log` |
| Zero Wins found | Empty draft | Adjust harvesting thresholds in `G13_content_idea_generator.py` |

## Owner & Review
- **Owner:** Michał
- **Review Cadence:** Monthly
