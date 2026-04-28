---
title: "G11_experiment_engine.py: Personal Behavior Experimentation Framework"
type: "automation_spec"
status: "active"
automation_id: "G11_experiment_engine"
goal_id: "goal-g11"
systems: ["S11", "S04"]
owner: "Michał"
updated: "2026-03-16"
---

# G11: Experiment Engine (A/B Testing for Behaviors)

## Purpose
Enables A/B testing of personal behaviors to optimize decisions. The system chooses variants, applies them to schedules, evaluates outcomes, and auto-updates policies based on results.

## Scope
### In Scope
- Defining and running behavioral experiments (sleep timing, workout schedules, caffeine cutoff)
- Random variant assignment with tracking
- Metric collection and statistical evaluation
- Auto-updating policies based on winning variants
- Integration with Rules Engine for policy recommendations

### Out of Scope
- Direct execution of experiment variants (delegated to domain scripts)
- Long-term longitudinal studies
- Complex statistical analysis (beyond basic averages)

## Triggers
- **Passive:** Called by G11_daily_orchestrator or manual trigger
- **Manual:** `python3 G11_experiment_engine.py --start sleep_timing_01`
- **Scheduled:** Daily via `G11_global_sync.py`

## Inputs
- **Config File:** `experiments.yaml`
- **Database:** `digital_twin_michal`
- **External:** Health data (readiness, HRV), Productivity data (tasks completed)

## Processing Logic
1. **Load Experiments:** Read `experiments.yaml` for active experiments
2. **Variant Assignment:** Randomly assign variant (A or B) for new runs
3. **Metric Recording:** Collect target metrics during experiment period
4. **Evaluation:** Compare variant performance, determine winner
5. **Policy Update:** If winner meets threshold, recommend policy update

## Outputs
- **DB Records:** `experiment_runs`, `experiment_results` tables
- **Recommendations:** Policy updates for Rules Engine
- **Daily Briefings:** Current variant assignments

## Failure Modes
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Config file missing | FileNotFoundError | Use defaults, log warning | Console |
| DB connection fail | psycopg2 Error | Skip logging, continue | Log warning |
| Insufficient data | < 5 samples | Wait for more data | Console |
| Metric API fail | Request Error | Skip metric, log | Log warning |

## Dependencies
### Systems
- [S03 Data Layer](../../20_Systems/S03_Data-Layer/README.md) - Database storage
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md) - Health/Productivity data
- [G11 Rules Engine](G11_rules_engine.md) - Policy integration

### External Services
- PostgreSQL (digital_twin_michal)

### Credentials
- DB credentials from `.env`

## Security Notes
- Experiment data stored in local DB only
- No external API calls with personal data
- Policy recommendations require human approval before apply

## Owner + Review Cadence
- **Owner:** Michał
- **Review Cadence:** Monthly (review active experiments)
- **Last Review:** 2026-03-16

---

## Usage Examples

### List Active Experiments
```bash
python3 scripts/G11_experiment_engine.py --list
```

### Start an Experiment
```bash
python3 scripts/G11_experiment_engine.py --start sleep_timing_01
```

### Record a Metric
```bash
python3 scripts/G11_experiment_engine.py --record sleep_timing_01 readiness_score 85
```

### Evaluate Results
```bash
python3 scripts/G11_experiment_engine.py --evaluate sleep_timing_01
```

### Run Daily Check
```bash
python3 scripts/G11_experiment_engine.py --daily
```

---

## Related Documentation
- [Autonomy Upgrade Plan](../../10_Goals/Autonomy-Upgrade-Plan.md)
- [G11 Rules Engine](G11_rules_engine.md)
- [G11 Self-Healing Supervisor](G11_self_healing_supervisor.md)
- [experiments.yaml](../experiments.yaml)

---
*Updated: 2026-03-16 by Digital Twin Assistant*
