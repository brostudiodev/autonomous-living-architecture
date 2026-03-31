---
title: "G09: Career Evidence Collector"
type: "automation_spec"
status: "active"
automation_id: "G09_career_evidence_collector"
goal_id: "goal-g09"
systems: ["S09", "S11"]
owner: "Michal"
updated: "2026-03-12"
---

# G09: Career Evidence Collector

## Purpose
Automatically builds a "Technical Brag Document" by scanning Git commit history for high-impact prefixes (`feat`, `fix`, `perf`, `arch`). This ensures professional wins are captured in real-time for performance reviews and branding.

## Triggers
- Scheduled: Part of the `autonomous_daily_manager.py` daily sync cycle.

## Inputs
- Local Git Repository history (last 7 days).

## Processing Logic
1. **Fetch:** Execute `git log` for the last 7 days.
2. **Filter:** Match commit messages against impact patterns (feat, fix, perf, etc.).
3. **Format:** Generate a bulleted list with dates and commit summaries.
4. **Persist:** Append the list to `Technical_Wins_Log.md` in the G09 goal folder.

## Outputs
- Updated `docs/10_Goals/G09_Automated-Career-Intelligence/Technical_Wins_Log.md`.
- Activity log entry.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Git Command Error | Exit code != 0 | Log failure, skip cycle | Log Critical |
| Permission Denied | File write error | Check OS permissions | Log Warning |
