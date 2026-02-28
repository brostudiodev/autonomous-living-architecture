---
title: "script: strategic-reporter"
type: "automation_spec"
status: "active"
automation_id: "strategic-reporter"
goal_id: "goal-g11"
systems: ["S01", "S11"]
owner: "Michal"
updated: "2026-02-23"
---

# script: strategic-reporter

## Purpose
Automates the generation of monthly strategic progress reports. It aggregates accomplishments, roadmap completion percentages, and technical milestones from across the entire ecosystem.

## Triggers
- **API Call:** Triggered via the `/report` endpoint.
- **Manual:** `python3 G11_strategic_summarizer.py`.

## Inputs
- **Activity Logs:** All `Activity-log.md` files.
- **Goal Roadmaps:** All `Roadmap.md` files (for completion percentages).
- **Metadata:** Current date and month.

## Processing Logic
1. **Log Aggregation:** Pulls the last 15 actions from the current month across all goals.
2. **Roadmap Audit:** Calculates the ratio of completed vs. total tasks in the Q1 sections of all goals.
3. **Drafting:** Constructs a Markdown summary with a completion status table and accomplishment list.

## Outputs
- **Markdown File:** Saved to `Monthly Summaries/YYYY-MM-Progress-Summary-DRAFT.md`.
- **API Response:** Content of the draft report.

## Dependencies
### Systems
- [Observability (S01)](../../../20_Systems/S01_Observability-Monitoring/README.md)
- [Intelligence Router (S11)](../../../20_Systems/S11_Intelligence_Router/README.md)

## Error Handling
| Failure Scenario | Detection | Response |
|---|---|---|
| No logs found | empty accomplishments list | Report "No accomplishments logged this month" |
| Roadmap Error | PCT calculation fail | Skip specific goal from status table |

## Manual Fallback
Use the G11 monthly reporter CLI manually.
