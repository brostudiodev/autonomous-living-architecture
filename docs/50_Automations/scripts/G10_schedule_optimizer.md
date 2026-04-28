---
title: "G10: Schedule Optimizer"
type: "automation_spec"
status: "active"
automation_id: "G10__schedule_optimizer"
goal_id: "goal-g10"
systems: ["S09", "S04"]
owner: "Michał"
updated: "2026-04-28"
---

# G10: Schedule Optimizer

## Purpose
Generates a dynamic, readiness-aware daily schedule by mapping biological state (HRV, Sleep) and high-priority tasks (Google Tasks, Logistics, Finance) into optimized time blocks.

## Triggers
- **Scheduled:** Daily at 06:00 AM via `autonomous_daily_manager.py`.
- **Manual:** Triggered via the Obsidian button `🎯 Plan Next Hour`.

## Inputs
- **Biometrics:** `readiness_score`, `sleep_score`, `hrv_ms` from `DB_HEALTH`.
- **Tasks:** Google Tasks filtered by tags (`#deep`, `#admin`, `#work`, `#finance`, `#personal`, `#learning`).
- **Logistics:** Upcoming document expiries from `DB_LOGISTICS`.
- **Finance:** Active budget breaches from `DB_FINANCE`.
- **Calendar:** Today's events from Google Calendar.

## Processing Logic
1. **State Analysis:** Categorizes the day as `Peak` (Readiness > 85, Sleep > 80), `Balanced`, `Recovery`, or `Critical (MVD)` based on biometric thresholds.
2. **Task Selection (NEW Mar 28):** 
    - **Goal-Aware Mode:** When in `Peak` state, the picker scans for tasks containing goal tags (e.g., `G01` to `G12`) or `#deep`.
    - **Standard Mode:** Picks the top incomplete task for each category-specific block.
    - **Energy Filter:** Automatically skips `#deep` tasks if in `Recovery` or `Critical` states.
    - **Biometric State Hardening (NEW Apr 20):** Explicitly calls `engine.get_health_status()`, `engine.get_finance_status()`, and `engine.get_logistics_status()` before state access to ensure the lazy-loaded Digital Twin state is fully populated. Prevents "0% Readiness" reports during early morning execution.
3. **Agentic Trigger:** If the state is `Critical (MVD)`, it calls the `G11_rules_engine` with `readiness_score` and `recommended_action = 'Switch to Recovery Schedule'`.
4. **Approval Workflow:** If the engine returns `ASK_HUMAN`, it creates a `PENDING` request for proactive Telegram approval.
5. **Execution:** Approved adjustments are executed via `G11_decision_handler.py`, which force-updates the Daily Note with the MVD schedule.
6. **Block Assignment:** Assigns tasks to morning, admin, work, and evening blocks based on the determined state.

## Outputs
- **Markdown Schedule:** Injected into the Obsidian Daily Note under `%%SCHEDULE%%`.
- **Telegram Alert:** Dispatched if MVD Mode is triggered.
- **Activity Log:** Success/Failure logged to `system_activity_log`.

## Dependencies
### Systems
- [S04 Digital Twin Hub](../../20_Systems/S04_Digital-Twin/README.md)
- [S09 Productivity Time](../../20_Systems/S09_Productivity-Time/README.md)

### External Services
- Google Calendar API
- Google Tasks API
- Telegram Bot API

### Credentials
- `google_tasks_token.pickle`
- `TELEGRAM_BOT_TOKEN` in `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Timeout | Script hang | 30s timeout, fallback to "Standard" blocks | Log Warning |
| DB Connection Fail | Exception | Fallback to "Standard" blocks without tasks | Log Failure |
| Empty Task List | List length 0 | Use generic block titles | None |

## Changelog

| Date | Change |
|------|--------|
| 2026-03-21 | Initial schedule optimizer logic with biometric thresholds |
| 2026-03-28 | Added Peak state goal-aware task prioritization and energy-based #deep task filtering |
| 2026-04-20 | Fixed state initialization bug by explicitly calling status fetchers before logic execution. |
