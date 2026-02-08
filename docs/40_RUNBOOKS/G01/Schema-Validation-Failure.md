---
title: "Runbook: G01 Schema Validation Failure"
type: "runbook"
status: "active"
goal_id: "goal-g01"
automation_id: "WF_G01_001__sheets-to-github-sync"
owner: "Michał"
updated: "2026-02-07"
---

# Runbook: G01 Schema Validation Failure

## Symptoms
- GitHub Actions workflow fails at "Validate CSV schemas" step
- Error message shows header mismatch (expected vs actual)
- Training data not syncing despite being logged in Sheets

## Root Cause
CSV header in Google Sheets doesn't match expected schema defined in workflow.

Common causes:
- Accidentally renamed a column (e.g., `weight_kg` → `weight`)
- Added/removed a column
- Reordered columns
- Extra spaces or special characters in header

## Resolution
### Step 1: Identify which CSV failed
Check Actions log error message:

❌ ERROR: sets.csv header mismatch Expected: date,workout_id,exercise_id,weight_kg,tut_s,max_effort,form_ok,notes Got: date,workout_id,exercise_id,weight,tut_s,max_effort,form_ok,notes

### Step 2: Fix Google Sheets header
1. Open Google Sheet: `G01_Training_Journal`
2. Go to failed tab (sets/workouts/measurements)
3. Edit row 1 (header row) to match expected schema **exactly**
4. Check:
   - Spelling
   - Column order
   - No extra spaces
   - No special characters

### Step 3: Re-run sync
1. GitHub → Actions → "G01 Training Sync" → "Run workflow"
2. Check log for ✓ checkmarks

## Expected Headers (Reference)
### sets.csv
```
date,workout_id,exercise_id,weight_kg,tut_s,max_effort,form_ok,notes
```

### workouts.csv
```
date,workout_id,location,duration_min,days_since_last_workout,recovered_1_5,mood_1_5,notes
```

### measurements.csv
```
date,bodyweight_kg,bodyfat_pct,notes
```

## If You Intentionally Changed Schema
1. Update Google Sheets header
2. Update workflow validation step:
   - Edit `.github/workflows/g01_training_sync.yml`
   - Find `EXPECTED_SETS=` (or WORKOUTS/MEASUREMENTS)
   - Update to match new schema
3. Commit + push workflow change
4. Re-run sync

## Prevention
- Add data validation dropdowns in Google Sheets (prevents typos)
- Don't edit header row casually
- If schema must change, plan it (update workflow + docs together)

## Related Documentation
- [WF_G01_001 Automation Spec](../../50_AUTOMATIONS/github-actions/WF_G01_001__sheets-to-github-sync.md)
- [G01 Training README](../../10_GOALS/G01_Target-Body-Fat/Training/README.md)