---
title: "G10_focus_enforcer: Digital Focus Shielding"
type: "automation_spec"
status: "active"
automation_id: "G10_focus_enforcer"
goal_id: "goal-g10"
systems: ["S04", "S08"]
owner: "Michal"
updated: "2026-04-18"
---

# G10_focus_enforcer: Digital Focus Shielding

## Purpose

Enforces focus by triggering digital shielding alerts during high-cognitive work windows. Automates the "Deep Work" state by notifying the user to enable DND mode on Slack, Discord, and mobile devices when readiness is high and the schedule demands focus.

## Triggers

- **Scheduled:** Daily at 6:00 AM, 7:00 AM, 8:00 AM via `G11_global_sync.py`
- **Manual:** `python scripts/G10_focus_enforcer.py`

## Inputs

| Source | Data | Used For |
|--------|------|----------|
| Digital Twin Engine | Readiness score | Focus enforcement threshold |
| System Clock | Current hour, weekday | Focus window validation |
| PostgreSQL | `digital_twin_michal` database | System activity logging |

## Processing Logic

1. **Check Focus Window** - Validate if current time is between 06:00 and 09:00 on a weekday.
   - If outside window → Terminate (No shielding required).

2. **Check Readiness** - Fetch readiness score from Digital Twin Engine.
   - Readiness < 50 → Terminate (Low energy recovery mode).

3. **Enforce Shielding** - Send proactive Telegram alert for manual DND activation.
   - Alerts user to set phone to DND.
   - Alerts user to close Slack/Discord.
   - Confirms "Deep Work Shield Active".

4. **Future Expansion** - Roadmap includes direct Slack/Discord API status updates.

## Outputs

| Output | Location | Format |
|--------|----------|--------|
| Focus Shield Alert | Telegram Messenger | Push Notification |
| Activity Log | `system_activity_log` table | PostgreSQL |

### Example Alert

```text
🚀 **DEEP WORK SHIELD ACTIVE** 🚀

State: Peak Readiness (87%)
Window: 06:00 - 09:00

🛡️ **Actions Taken:**
- [ ] Set Phone to DND (Manual)
- [ ] Close Slack/Discord (Manual)
- [ ] Focus on your Roadmap Mission.

_Automation is shielding your cognitive load._
```

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Readiness data source
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - Integration

### Scripts
- `G04_digital_twin_engine.py` - Digital Twin state provider
- `G04_digital_twin_notifier.py` - Telegram notification engine
- `G11_log_system.py` - Activity logging

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Digital Twin offline | Exception in `DigitalTwinEngine()` | Log failure, no alert sent |
| Telegram API error | Return `False` from `send_telegram_message()` | Log failure |
| Database write fails | `psycopg2` exception | Print warning, don't crash |

## Security Notes

- No direct device control (notification-only)
- Slack/Discord tokens (Future) will be stored in `.env`
- No sensitive data in logs

## Monitoring

- **Success metric:** Alert sent during focus window
- **Alert on:** Failure to send during focus window
- **Dashboard:** Check `system_activity_log` for `G10_focus_enforcer` status

## Manual Fallback

If script fails:
```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate
python scripts/G10_focus_enforcer.py
```

## Related Documentation

- [G10 Roadmap](../../10_Goals/G{{LONG_IDENTIFIER}}/Roadmap.md)
- [G10 Focus Intelligence](./G10_focus_intelligence.md)
- [G10 Schedule Optimizer](./G10_schedule_optimizer.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-23 | Initial implementation (v1.0) |
| 2026-03-23 | Integrated into `G11_global_sync.py` |
