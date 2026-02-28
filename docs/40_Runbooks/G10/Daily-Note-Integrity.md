---
title: "Runbook: Daily Note Integrity & Sync Failures"
type: "runbook"
status: "active"
goal_id: "goal-g10"
owner: "Michal"
updated: "2026-02-24"
---

# Runbook: Daily Note Integrity & Sync Failures

## Scenario
The `sync_daily_goals.py` script runs but reports "0 goals found" or fails to update the YAML `goals_touched` field, even though goals are checked in Obsidian.

## 1. Detection
- Check the console output of `sync_daily_goals.py`.
- Look for: `🔍 Found 0 checked goals` or `ℹ️ No goals with activity content found`.
- Check if the frontmatter in the Daily Note has `goals_touched: []`.

## 2. Common Causes & Fixes

### A. Formatting Mismatch (Regex Failure)
- **Issue:** The script expects a specific header for the Power Goals section.
- **Fix:** Ensure the header is exactly `### Choose Today’s Power Goals`. 
- **Note:** The script has been updated (Feb 24) to be robust against leading spaces and extra text like `(max 3)`.

### B. "Did" Field Requirement
- **Issue:** The sync script only counts a goal as "touched" if the `- **Did:**` line has text after it.
- **Fix:** Ensure you have written at least one word in the "Did" section for each checked goal.

### C. Script Clobbering (Race Condition)
- **Issue:** The `autonomous_daily_manager.py` (which runs at 05:00 AM or on-demand) might overwrite the file if called while the user has unsaved changes in Obsidian.
- **Response:** If data is lost, use Git to restore the previous version of the daily note:
  ```bash
  cd "~/Documents/Obsidian Vault"
  git checkout HEAD@{1} -- "01_Daily_Notes/YYYY-MM-DD.md"
  ```

## 3. Technical Implementation Notes
- The regex in `sync_daily_goals.py` uses `re.MULTILINE` and `re.DOTALL` to capture everything between the header and the next `---` divider.
- Standardized checkboxes `[x]` and `[X]` are supported.
