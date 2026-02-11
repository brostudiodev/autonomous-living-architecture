---
title: "WF003: Training Data Sync"
type: "automation_spec"
status: "active"
automation_id: "WF003__training-data-sync"
goal_id: "goal-g01"
systems: ["S03", "S01"]
owner: "Michał"
updated: "2026-02-11"
---

# WF003: Training Data Sync

## Purpose
Automated synchronization of HIT (High-Intensity Training) data from Google Sheets Training_Journal to PostgreSQL autonomous_training database, providing real-time progression tracking, recovery monitoring, and intelligent workout recommendations based on Mike Mentzer's training principles.

## Triggers
- **Scheduled:** Every 6 hours (00:00, 06:00, 12:00, 18:00 UTC)
- **Manual:** Execute via n8n interface for immediate sync or debugging

## Inputs

### Google Sheets Source
**Document:** `Training_Journal` (ID: `1L56kLlHljvgkug4XWZ6N2VwTGHosqcqzsjF_2oPatBg`)

**Sheet 1: workouts (gid: 872382533)**

Columns: date, workout_id, location, duration_min, days_since_last_workout, recovered_1_5, mood_1_5, notes Example: 2026-01-20, hit_lower_a, home, 12, 3, 4, 4, "felt recovered; went hard"


**Sheet 2: sets (gid: 0)**

Columns: date, workout_id, exercise_id, weight_kg, tut_s, max_effort, form_ok, notes Example: 2026-01-20, hit_lower_a, ex_squat, 78, 67.00, TRUE, TRUE, "hard; clean reps"


**Sheet 3: measurements (gid: 15732560)**

Columns: date, bodyweight_kg, bodyfat_pct, notes Example: 2026-01-23, 82.6, 22, "Test morning fasted; slept poorly"


### Database Target
**PostgreSQL:** `autonomous_training` database
**Tables:** `workouts`, `workout_sets`, `measurements` (partitioned by year)
**Functions:** `upsert_workout_from_sheet()`, `upsert_set_from_sheet()`, `upsert_measurement_from_sheet()`

## Processing Logic

### Phase 1: Data Extraction (Parallel)
Three Google Sheets nodes execute simultaneously:
- `Read Workouts Sheet` → Extract workout session data
- `Read Sets Sheet` → Extract exercise performance data  
- `Read Measurements Sheet` → Extract body composition data

### Phase 2: Transformation & Validation (HIT-Specific)

**Workouts Transformation:**
- Date parsing with ISO 8601 normalization
- Duration validation: 5-300 minutes (HIT typical: 10-20 min)
- Recovery score validation: 1-5 scale per HIT readiness principles
- Mood score validation: 1-5 scale
- Days since last workout: 0-30 days (HIT optimal: 3-7 days)
- String sanitization for SQL safety

**Sets Transformation (Critical HIT Logic):**
- **TUT (Time Under Tension) validation:** 20-300 seconds range
- Weight validation: ≥0 kg (allows bodyweight exercises)
- Boolean parsing: `max_effort`, `form_ok` with multi-format support
- HIT-specific TUT range checking: 45-90s optimal per Mentzer principles

**Measurements Transformation:**
- Bodyweight validation: 40-200 kg reasonable range
- Body fat percentage: 3-50% (optional field)
- Estimated lean mass calculation for body composition tracking

**Validation Statistics Captured:**
```javascript
stats = {
  totalRows: count,
  validRecords: count,
  skippedEmpty: count,
  skippedInvalidDate: count,
  skippedInvalidWeight: count,
  skippedInvalidTUT: count,
  validationErrors: count
}
```

### Phase 3: Database Upsert (Parallel)

Critical Fix Applied: Uses direct node name references to avoid n8n API compatibility issues:

```javascript
const workoutItems = $('Upsert Workouts to PostgreSQL').all();
const setItems = $('Upsert Sets to PostgreSQL').all();
const measurementItems = $('Upsert Measurements to PostgreSQL').all();
```

Workouts Upsert:

```sql
SELECT upsert_workout_from_sheet(
    '{{ $json.workout_date }}'::DATE,
    '{{ $json.template_id }}',
    '{{ $json.location }}',
    {{ $json.duration_min }},
    {{ $json.days_since_last_workout || 'NULL' }},
    {{ $json.recovery_score || 'NULL' }},
    {{ $json.mood_score || 'NULL' }},
    '{{ ($json.notes || "").replace("'", "''") }}'
) AS result;
```

Features:

    Idempotent upserts (ON CONFLICT DO UPDATE)
    Auto-creates missing workout templates
    Returns JSON with success/error status
    Continues processing on individual failures

Sets Upsert:

    Verifies parent workout exists
    Auto-registers new exercises with default categorization
    Enforces one working set per exercise per workout (HIT principle)
    Tracks auto-creation for system learning

Measurements Upsert:

    Date-based deduplication
    Supports body composition trend analysis
    Handles optional body fat percentage

### Phase 4: Comprehensive Reporting

Generate Comprehensive Sync Report produces detailed analytics:

```javascript
report = {
  sync_timestamp: ISO8601,
  processing_stats: {
    workouts: { totalRows, validWorkouts, skippedEmpty, validationErrors },
    sets: { totalRows, validSets, skippedEmpty, validationErrors },
    measurements: { totalRows, validMeasurements, skippedEmpty, validationErrors }
  },
  database_stats: {
    workouts: { total_processed, successful_upserts, database_errors, auto_created_templates },
    sets: { total_processed, successful_upserts, database_errors, auto_created_exercises },
    measurements: { total_processed, successful_upserts, database_errors }
  },
  auto_created: {
    templates: [{ id, type, date }],
    exercises: [{ id, type, date }]
  },
  total_errors: count,
  overall_status: "SUCCESS" | "PARTIAL_SUCCESS"
}
```

### Phase 5: Error Alerting (Conditional)

Alert Conditions:

    overall_status != "SUCCESS" → Triggers error notification
    Formatted email with detailed error breakdown
    Sent to {{EMAIL}}

Alert Format:

```
🏋️ Training Sync Alert

⌚ Time: 2026-02-11 18:30:45
📊 Status: PARTIAL_SUCCESS
❌ Total Errors: 3

💪 WORKOUTS: • Processed: 50 • Valid: 48 • DB Success: 47
🎯 SETS: • Processed: 200 • Valid: 198 • DB Success: 196
📈 MEASUREMENTS: • Processed: 10 • Valid: 10 • DB Success: 10

❌ PROCESSING ERRORS:
  • Invalid TUT for ex_squat: 350 (expected 20-300s)
  • Invalid weight for ex_deadlift: -5 (expected ≥0)
```

## Outputs
### Database Records

Tables Updated:

    workouts (partitioned by year 2020-2030)
    workout_sets (partitioned by year 2020-2030)
    measurements (single table)
    workout_templates (auto-populated reference)
    exercises (auto-populated reference)

Analytics Views Refreshed:

    v_hit_progression - Progressive overload tracking with recommendations
    v_recovery_analysis - Recovery patterns and training readiness
    v_body_composition - Body weight and lean mass trends

### Execution Artifacts

    Console logs with detailed transformation summaries
    $execution.customData with stats and errors for debugging
    Email notifications on errors only

## Dependencies
### Systems

    S03 Data Layer - PostgreSQL autonomous_training database
    S01 Observability & Monitoring - Execution monitoring

### External Services

    Google Sheets API: OAuth2 authentication, 100 requests/100 seconds quota
    PostgreSQL: Docker container, connection pooling enabled
    Gmail API: OAuth2 authentication, error notifications only

### Credentials

    Google Sheets account (ID: LXYoAr7I3Ccidlg5)
    Postgres account autonomous_training docker (ID: haLW6cBWakuIUaNj)
    Gmail account (ID: ZKOV4vsgAhk74S3u)

## Error Handling
| Failure Scenario 	| Detection 	| Response 	| Alert |
|---|---|---|---|
| Invalid TUT value (HIT-critical) 	| Range check 20-300s 	| Skip set, log error, continue 	| Include in processing errors |
| Missing workout template 	| Database lookup returns NULL 	| Auto-create with default values 	| Log auto-creation in report |
| Orphaned set (no workout) 	| Foreign key validation 	| Return error, skip set 	| Include in database errors |
| Google Sheets API failure 	| 429/500 HTTP errors 	| Workflow fails, retry next schedule 	| Manual intervention required |
| PostgreSQL connection failure 	| Connection timeout 	| Workflow fails completely 	| Email alert + manual fix |
| Invalid recovery scores 	| HIT readiness scale 1-5 	| Skip workout, log validation error 	| Include in processing errors |

Error Severity:

    CRITICAL: Complete workflow failure (auth, connection)
    WARNING: Partial success (validation failures, some upserts fail)
    INFO: Normal operations (empty rows, duplicates handled)

## Monitoring
### Success Metrics

    Primary: overall_status = "SUCCESS" in sync report
    Secondary: Recent data verification in database views

### Health Checks (Automated)

```sql
-- Last sync verification
SELECT MAX(created_at) as last_sync FROM workouts 
WHERE workout_date >= CURRENT_DATE - INTERVAL '7 days';

-- Orphaned sets detection  
SELECT COUNT(*) FROM workout_sets ws
LEFT JOIN workouts w ON ws.workout_date = w.workout_date 
WHERE w.workout_date IS NULL;

-- HIT progression health
SELECT COUNT(*) as recent_workouts, AVG(recovery_score), AVG(mood_score)
FROM workouts WHERE workout_date >= CURRENT_DATE - INTERVAL '14 days';
```

### Performance Characteristics

Typical execution (50 workouts, 200 sets, 10 measurements): 15-22 seconds Resource usage: ~150 MB memory, minimal CPU (I/O bound) Network: <200 KB per execution

## Manual Fallback
### Emergency Sync Procedure

```sql
-- Manual workout entry
SELECT upsert_workout_from_sheet(
    '2026-02-11'::DATE, 'hit_lower_a', 'home', 12, 3, 4, 4, 'Manual entry'
);

-- Manual set entry
SELECT upsert_set_from_sheet(
    '2026-02-11'::DATE, 'hit_lower_a', 'ex_squat', 78.0, 67.0, TRUE, TRUE, 'Manual'
);
```

### Recovery Steps

    Immediate: Execute workflow manually via n8n interface
    Database issues: Check Docker container status, restart if needed
    Google Sheets issues: Verify OAuth credentials, check API quotas
    Complete failure: Export sheets to CSV, manual PostgreSQL import

## HIT-Specific Intelligence
### Progressive Overload Detection

Automated recommendations based on Mentzer's principles:

```sql
CASE 
    WHEN tut_seconds > 90 AND form_ok AND max_effort THEN 
        'INCREASE WEIGHT: TUT > 90s - add ' || ROUND(weight_kg * 0.025, 1) || 'kg'
    WHEN tut_seconds < 45 THEN 'REDUCE WEIGHT: TUT too low'
    WHEN NOT form_ok THEN 'MAINTAIN WEIGHT: Focus on form'
    WHEN tut_seconds BETWEEN 60 AND 90 THEN 'OPTIMAL RANGE'
END as recommendation
```

### Recovery Monitoring

Training readiness assessment:

```sql
CASE 
    WHEN days_since_last_workout < 2 THEN 'TOO FREQUENT: CNS needs recovery'
    WHEN (recovery_score + mood_score) <= 4 THEN 'SKIP SESSION: Poor readiness'
    WHEN days_since_last_workout >= 3 AND (recovery_score + mood_score) >= 7 
        THEN 'OPTIMAL: Maximum intensity'
END as training_recommendation
```

## Related Documentation

    Goal: G01: Autonomous Living Foundation
    System: S03 Data Layer
    Database Schema: autonomous_training PostgreSQL dump
    Workflow Export: WF003__training-data-sync.json
    SOP: Weekly Training Review (to be created)
    Runbook: Training Sync Troubleshooting (to be created)
