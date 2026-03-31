---
title: "G11: Task Triage Pro"
type: "automation_spec"
status: "active"
automation_id: "G11_task_triage_pro"
goal_id: "goal-g11"
systems: ["S04", "S10"]
owner: "Michal"
updated: "2026-03-25"
---

# G11: Task Triage Pro

## Purpose
Surgically triages Google Tasks into actionable categories, with a primary focus on **Biological Readiness**. It prevents decision fatigue by dynamically adjusting task priority according to Michal's energy levels.

## Triggers
- **Scheduled:** Runs as a dependency within `autonomous_daily_manager.py` every time the dashboard is updated.
- **Manual:** Can be run via `python3 scripts/G11_task_triage_pro.py`.

## Inputs
- **Google Tasks API:** List of upcoming tasks.
- **Digital Twin API/DB:** Current `readiness_score` (G07).
- **Gemini 1.5 Flash:** (Optional) For high-fidelity semantic classification.

## Processing Logic
1. **Context Retrieval:** Fetches today's Readiness Score from the `biometrics` table.
2. **Analysis:** 
   - **LLM Mode:** Sends task titles and notes to Gemini 1.5 Flash for categorization, providing the readiness score as context.
   - **Fallback Mode:** Uses keyword-based regex rules.
3. **Categorization & Energy Logic:**
   - **PEAK ENERGY (>85):** Promotes `#deep` and `#roadmap` tasks to `URGENT_TODAY`. Deprioritizes low-value admin.
   - **LOW ENERGY (<65):** Demotes `#deep` work to `BACKLOG`. Prioritizes `RECOVERY` and simple `#admin` or `#errands`.
   - `HABIT`: Recurring maintenance items.
   - `NOTE_TO_OBSIDIAN`: Informational items that are not tasks.
4. **Action:**
   - Items in `NOTE_TO_OBSIDIAN` are saved as `.md` files in `00_Inbox/Notes_from_Tasks/` and marked as completed in Google Tasks.
   - Other categories are saved to `scripts/_meta/triaged_tasks.json` for dashboard consumption.

## Outputs
- **JSON Metadata:** `scripts/_meta/triaged_tasks.json` containing the sorted task lists.
- **Obsidian Notes:** New markdown files in `00_Inbox/Notes_from_Tasks/`.
- **Google Tasks Update:** Marks triaged notes as "Completed" in the source API.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [S10 Daily Goals Automation](../../20_Systems/S10_Daily-Goals-Automation/README.md)

### External Services
- Google Tasks API
- Google Gemini API (Optional)

### Credentials
- `google_tasks_token.pickle`
- `GOOGLE_GEMINI_API_KEY` in `.env`

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Gemini API Error | Exception caught | Fallback to rule-based triage | Log warning |
| Auth Error | Pickle load failure | Skip triage, use raw task list | Log error |
| FS Error | Write permission denied | Log error, proceed with memory-only | Log error |

## Monitoring
- **Success Metric:** `triaged_tasks.json` is updated with non-zero items.
- **Activity Log:** Logs results to `system_activity_log` table in `digital_twin_michal`.

## Manual Fallback
If triage fails, `autonomous_daily_manager.py` will default to displaying the raw, untriaged list of the top 15 tasks.
