---
title: "G10_focus_intelligence: Focus Mode Status Check"
type: "automation_spec"
status: "active"
automation_id: "G10_focus_intelligence"
goal_id: "goal-g10"
systems: ["S04", "S07", "S08"]
owner: "Michal"
updated: "2026-04-18"
---

# G10_focus_intelligence: Focus Mode Status Check

## Purpose

Queries readiness score (from G07 biometrics) and office environment (from G08 Home Assistant) to generate actionable focus recommendations. Provides intelligence layer for deep work readiness without direct device control.

## Triggers

- **Scheduled:** Daily at 6:00 AM via `autonomous_daily_manager.py`
- **Manual:** `python scripts/G10_focus_intelligence.py`

## Inputs

| Source | Data | Used For |
|--------|------|----------|
| Digital Twin Engine | Readiness score, sleep score, HRV | Focus state evaluation |
| G08 Home Monitor | Office occupancy, PC power, temperature | Environment scoring |
| PostgreSQL | `digital_twin_michal` database | System activity logging |

## Processing Logic

1. **Fetch Readiness Data** - Get biometrics from Digital Twin Engine
   - Readiness score (0-100)
   - Sleep score
   - HRV value

2. **Fetch Environment Data** - Query Home Assistant via `G08_home_monitor`
   - Office occupancy (Combined motion + time-fenced occupancy)
   - **Dual Power State:** Monitoring both Desktop PC and Laptop
   - Temperature

3. **Evaluate Focus State** - Calculate composite score
   ```
   readiness >= 85 → "peak"
   readiness >= 70 → "good"
   readiness >= 50 → "moderate"
   readiness < 50  → "low"
   
   environment_score = base(50) + occupancy(+30/-20) + temp(+10/-10) + computing(+10)
   ```

4. **Generate Recommendations** - Based on state + environment
   - Peak + empty office → "Deep work time"
   - Low readiness → "Recovery mode"
   - High temp → "Open window"
   - Computing off + peak → "Turn on PC/Laptop"

5. **Build Report** - Markdown output for injection into `%%FOCUS%%` marker.

## Outputs

| Output | Location | Format |
|--------|----------|--------|
| Focus Intel Report | Daily note `%%FOCUS%%` marker | Markdown |
| Log File | `_meta/daily-logs/focus_intel_YYYYMMDD.txt` | Text |
| Activity Log | `system_activity_log` table | PostgreSQL |

### Example Output

```markdown
### 🧠 Focus Mode Intelligence (G10)
**Status Check:** 🚀 PEAK

| Metric | Value |
|--------|-------|
| Readiness | 87/100 |
| Sleep Score | 92 |
| HRV | 6ms |

**Office Environment:**
- Occupancy: ⚠️ Occupied
- Computing: ✅ Active
  - PC: OFF | Laptop: 61.9W
- Temperature: 23.0°C

**💡 Recommendations:**
- 🚀 Peak readiness detected - ideal for deep work or complex tasks
- ⚠️ Office is occupied - consider alternative workspace
```

## Dependencies

### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Readiness data source
- [S07 Smart Home](../../20_Systems/S07_Smart-Home/README.md) - Environment sensors
- [S08 Automation Orchestrator](../../20_Systems/S08_Automation-Orchestrator/README.md) - Integration

### External Services
- Home Assistant REST API (`http://{{INTERNAL_IP}}:8123`)
- PostgreSQL (`digital_twin_michal`)

### Scripts
- `G04_digital_twin_engine.py` - Digital Twin state provider
- `G08_home_monitor.py` - Home Assistant data fetcher
- `G11_log_system.py` - Activity logging

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Digital Twin offline | Exception in `DigitalTwinEngine()` | Return error report, log failure |
| HA sensors unavailable | Exception in `get_home_status()` | Show "Unknown" values, continue |
| Database write fails | `psycopg2` exception | Print warning, don't crash |
| No readiness data | Empty biometrics dict | Show "N/A" values |

## Security Notes

- No direct device control (read-only)
- HA webhook integration **NOT implemented** (future phase)
- No sensitive data in logs
- Database credentials via `.env`

## Monitoring

- **Success metric:** Report generated and saved to file
- **Alert on:** 3 consecutive failures
- **Dashboard:** Check `system_activity_log` for failures

## Manual Fallback

If script fails:
```bash
cd {{ROOT_LOCATION}}/autonomous-living
source .venv/bin/activate
python scripts/G10_focus_intelligence.py
```

Manual check in Home Assistant:
```bash
curl http://{{INTERNAL_IP}}:8123/api/states/binary_sensor.lumi_lumi_sensor_motion_aq2_occupancy
```

## Related Documentation

- [G10 Roadmap](../../10_Goals/G{{LONG_IDENTIFIER}}/Roadmap.md)
- [G08 Smart Home Monitor](./G08_home_monitor.md)
- [G10 Schedule Optimizer](./G10_schedule_optimizer.md)
- [SOP: Daily Briefing Management](../../30_Sops/Daily-Briefing-Management.md)

## Changelog

| Date | Change |
|------|--------|
| 2026-03-20 | Initial implementation |
| 2026-03-20 | Integrated into `autonomous_daily_manager.py` |
