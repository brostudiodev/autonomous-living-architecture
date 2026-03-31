---
title: "G11_behavioral_monitor.py: Behavioral Anomaly Detection"
type: "automation_spec"
status: "active"
automation_id: "G11_behavioral_monitor"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michal"
updated: "2026-03-16"
---

# G11: Behavioral Monitor (Anomaly Detection)

## Purpose
Monitors behavioral patterns and detects anomalies that may indicate:
- Skipped routines (journaling, workouts, medication)
- Declining engagement (reduced task completion, fewer interactions)
- Health warning signs (sleep patterns, activity changes)
- Autonomy drift (increasing manual overrides)

## Scope
### In Scope
- Tracking behavioral events (journaling, workouts, learning sessions)
- Detecting missed patterns against baselines
- Alerting on behavioral anomalies
- Providing actionable recommendations

### Out of Scope
- Direct intervention (only monitors and alerts)
- Long-term trend analysis (beyond 30 days)
- Complex pattern recognition (ML-based)

## Triggers
- **Passive:** Called by G11_daily_orchestrator
- **Manual:** `python3 G11_behavioral_monitor.py --check`
- **Scheduled:** Daily via `G11_global_sync.py`

## Inputs
- **Baselines:** Hardcoded behavior expectations
- **Database:** `digital_twin_michal`
- **External:** Can integrate with any data source via `log_event()`

## Processing Logic
1. **Load Baselines:** Read expected frequencies for each behavior
2. **Query Events:** Count events in lookback period
3. **Compare:** Check against threshold
4. **Detect Anomaly:** If threshold exceeded, create alert
5. **Log:** Store in `behavioral_anomalies` table

## Outputs
- **DB Records:** `behavioral_events`, `behavioral_anomalies` tables
- **Alerts:** Actionable messages about detected issues
- **Stats:** Behavioral tracking statistics

## Failure Modes
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| DB connection fail | psycopg2 Error | Skip logging | Console |
| No baseline defined | KeyError | Skip behavior | Console |
| Table missing | CREATE TABLE IF NOT EXISTS | Auto-create | None |

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Database storage
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Event data

### External Services
- PostgreSQL (digital_twin_michal)

### Credentials
- DB credentials from `.env`

## Security Notes
- All data stored locally in PostgreSQL
- No external API calls
- Anomaly data is personal - handle with care

## Owner + Review Cadence
- **Owner:** Michal
- **Review Cadence:** Weekly (review anomalies)
- **Last Review:** 2026-03-16

---

## Monitored Behaviors

| Behavior ID | Expected | Threshold | Alert Message Template |
|-------------|----------|-----------|------------------------|
| journaling | daily | 3 days | "You've skipped journaling {count} days. Historically this precedes poor decisions." |
| workout | weekly | 2 misses | "You've missed {count} scheduled workouts. Check readiness and adjust schedule." |
| grocery_planning | weekly | 1 miss | "No grocery planning this week. Pantry may need attention." |
| financial_review | weekly | 1 miss | "No financial review this week. Budget may be drifting." |
| learning_session | daily | 3 misses | "You've missed {count} learning sessions. Exam prep may be at risk." |
| social_contact | weekly | 14 days | "No social contact in {count} days. Relationship maintenance needed." |
| manual_override | daily | 5/week | "You've overridden {count} autonomous decisions this week. System may need tuning." |

---

## Usage Examples

### Check All Behaviors
```bash
python3 scripts/G11_behavioral_monitor.py --check
```

### Log an Event
```bash
python3 scripts/G11_behavioral_monitor.py --log journaling 1 '{"source": "daily_note"}'
```

### List Unacknowledged Anomalies
```bash
python3 scripts/G11_behavioral_monitor.py --anomalies
```

### Acknowledge an Anomaly
```bash
python3 scripts/G11_behavioral_monitor.py --ack 42
```

### Get Behavior Stats
```bash
python3 scripts/G11_behavioral_monitor.py --stats journaling
```

---

## Integration

### Auto-Logging from Daily Notes
The monitor can be integrated into `autonomous_daily_manager.py` to automatically log:
- Journaling completion
- Workout completion
- Learning session completion

### Example Integration
```python
from G11_behavioral_monitor import BehavioralMonitor

monitor = BehavioralMonitor()

# After parsing daily note
if completed_journaling:
    monitor.log_event("journaling", 1, {"source": "daily_note"})
    
if completed_workout:
    monitor.log_event("workout", 1, {"type": "HIT", "duration": 45})

# In morning briefing
anomalies = monitor.get_unacknowledged_anomalies()
for a in anomalies:
    print(f"⚠️ {a['message']}")
```

---

## Related Documentation
- [Autonomy Upgrade Plan](../../10_Goals/Autonomy-Upgrade-Plan.md)
- [G11 Rules Engine](G11_rules_engine.md)
- [G11 Experiment Engine](G11_experiment_engine.md)
- [G11 Self-Healing Supervisor](G11_self_healing_supervisor.md)

---
*Updated: 2026-03-16 by Digital Twin Assistant*
