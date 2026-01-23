---
title: "WF_G01_001: Google Sheets to GitHub CSV Sync"
type: "automation_spec"
status: "active"
automation_id: "WF_G01_001__sheets-to-github-sync"
goal_id: "goal-g01"
systems: ["S03"]
owner: "Michał"
updated: "2026-01-23"
---

# WF_G01_001: Google Sheets to GitHub CSV Sync

## Purpose
Automatically export training data from Google Sheets to Git-versioned CSVs every 6 hours, with schema validation to prevent data corruption.

## Triggers
- **Scheduled:** Every 6 hours (`0 */6 * * *` cron)
- **Manual:** GitHub Actions "Run workflow" button (for immediate sync after logging workout)

## Inputs
- **Google Sheets published CSV URLs** (stored as GitHub Secrets):
  - `G01_SETS_CSV_URL`
  - `G01_WORKOUTS_CSV_URL`
  - `G01_MEASUREMENTS_CSV_URL`

## Processing Logic
1. **Download CSVs** from Google Sheets published URLs using `curl`
2. **Validate schemas:**
   - Check header row matches expected column names exactly
   - Strip carriage returns (Google Sheets sometimes exports CRLF)
   - Verify files are non-empty (at least header row)
3. **Commit if changed:**
   - Stage CSV files
   - Check `git diff --cached` (skip commit if no changes)
   - Commit with message: `"G01: sync training CSVs from Google Sheets"`
   - Push to `origin/main`

## Outputs
- **Updated CSVs** in repo:
  - `docs/10_GOALS/G01_Target-Body-Fat/Training/data/sets.csv`
  - `docs/10_GOALS/G01_Target-Body-Fat/Training/data/workouts.csv`
  - `docs/10_GOALS/G01_Target-Body-Fat/Training/data/measurements.csv`
- **Git commit** (only if files changed)
- **Actions log** with validation checkmarks

## Dependencies
### Systems
- [S03 Data Layer](../../../20_SYSTEMS/S03_Data-Layer/README.md)

### External Services
- Google Sheets (published CSV export)
- GitHub Actions (runner environment)

### Credentials
- GitHub Secrets (CSV URLs)
- GitHub Actions default `GITHUB_TOKEN` (auto-provided for push)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| CSV URL returns 404/403 | `curl -f` exit code | Workflow fails, no commit | GitHub Actions email notification |
| Header mismatch | Bash string comparison | Workflow fails, prints diff | GitHub Actions log + email |
| Empty CSV downloaded | `wc -l < file` check | Workflow fails | GitHub Actions log |
| Git push conflict | `git push` exit code | Workflow fails (no auto-merge) | Manual resolution required |

## Monitoring
- **Success metric:** CSV files updated in repo, commit exists in Git history
- **Alert on:** Workflow failure (GitHub sends email to repo owner)
- **Dashboard:** GitHub Actions "G01 Training Sync" workflow page

## Manual Fallback
If automation fails:
```bash
# Download CSVs manually
curl -L "<SETS_CSV_URL>" -o docs/10_GOALS/G01_Target-Body-Fat/Training/data/sets.csv
curl -L "<WORKOUTS_CSV_URL>" -o docs/10_GOALS/G01_Target-Body-Fat/Training/data/workouts.csv
curl -L "<MEASUREMENTS_CSV_URL>" -o docs/10_GOALS/G01_Target-Body-Fat/Training/data/measurements.csv

# Validate headers manually (visual check or run validation script)
head -1 docs/10_GOALS/G01_Target-Body-Fat/Training/data/sets.csv

# Commit
cd autonomous-living
git add docs/10_GOALS/G01_Target-Body-Fat/Training/data/*.csv
git commit -m "G01: manual sync training CSVs"
git push origin main

Related Documentation

    Goal: G01 Target Body Fat
    System: S03 Data Layer
    SOP: docs/10_GOALS/G01_Target-Body-Fat/Training/README.md
    Runbook: docs/40_RUNBOOKS/G01/Sheets-Sync-Failure.md
    Workflow code: .github/workflows/g01_training_sync.yml (in repo root)

---

## Related Runbooks
- [Sheets Sync Failure](../../40_RUNBOOKS/G01/Sheets-Sync-Failure.md) - When workflow fails to download or sync data
- [Schema Validation Failure](../../40_RUNBOOKS/G01/Schema-Validation-Failure.md) - When CSV headers don't match expected schemas

