---
title: "Runbook: G01 Sheets Sync Failure"
type: "runbook"
status: "active"
goal_id: "goal-g01"
automation_id: "WF_G01_001__sheets-to-github-sync"
owner: "Michał"
updated: "2026-01-23"
---

# Runbook: G01 Sheets Sync Failure

## Symptoms
- GitHub Actions workflow "G01 Training Sync" shows red X (failed)
- Email notification: "G01 Training Sync (Sheets -> CSV) failed"
- Training data not appearing in repo after logging workout

## Diagnosis Steps
1. **Check Actions log:**
   - Go to GitHub → Actions → "G01 Training Sync" → latest run
   - Look for which step failed (Download, Validate, Commit)

2. **If "Download CSV" step failed:**
   - Check error message (likely `curl: (3)` = malformed URL, or `curl: (22)` = 404/403)
   - Verify Google Sheets "Publish to web" is still active:
     - Open Google Sheet → File → Share → Publish to web
     - Ensure "Published content & settings" shows CSV links

3. **If "Validate CSV schemas" step failed:**
   - Check error message for which CSV (sets/workouts/measurements)
   - Look for "header mismatch" → shows expected vs actual headers
   - Likely cause: accidentally renamed column in Google Sheets

4. **If "Commit changes" step failed:**
   - Check for Git conflict (rare, only if manual edit happened)
   - Check GitHub API rate limits (very rare)

## Resolution Procedures

### Case A: Google Sheets unpublished (404/403 error)
```bash
# Re-publish sheet as CSV
1. Open Google Sheet
2. File → Share → Publish to web
3. Select sheet tab (sets/workouts/measurements)
4. Format: CSV
5. Publish
6. Copy new URL
7. Update GitHub Secret (Settings → Secrets → Edit G01_*_CSV_URL)
8. Re-run workflow manually
```

### Case B: Header mismatch (column renamed in Sheets)
```bash
# Fix Google Sheets header
1. Check Actions log for expected header (e.g., "date,workout_id,exercise_id,weight_kg,tut_s,max_effort,form_ok,notes")
2. Open Google Sheets
3. Fix header row to match exactly (check spelling, order, no extra spaces)
4. Re-run workflow manually
```

### Case C: Git push conflict
```bash
# Resolve conflict locally
cd autonomous-living
git pull origin main
# If conflict in CSV files, accept remote version (Sheets is source of truth):
git checkout --theirs docs/10_GOALS/G01_Target-Body-Fat/Training/data/*.csv
git add .
git commit -m "G01: resolve sync conflict (accept Sheets data)"
git push origin main
# Re-run workflow manually
```

## Prevention
- Don't manually edit CSV files in repo (Sheets is source of truth)
- Don't rename columns in Sheets without updating workflow validation step
- Check "Publish to web" settings quarterly (Google sometimes expires these)

## Escalation
If manual fallback doesn't work:
- Check GitHub Actions status page (service outage?)
- Post in #automation Slack channel (if team exists)
- Temporarily log workouts in Sheets only; sync later when fixed

## Related Documentation
- [WF_G01_001 Automation Spec](../../50_AUTOMATIONS/github-actions/WF_G01_001__sheets-to-github-sync.md)
- [G01 Training README](../../10_GOALS/G01_Target-Body-Fat/Training/README.md)