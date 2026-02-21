---
title: "SOP: Log Workout in 60 Seconds"
type: "sop"
status: "active"
goal_id: "goal-g01"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# SOP: Log Workout in 60 Seconds

## Purpose
Fast, mobile-first procedure for capturing HIT training data immediately after workout with minimal cognitive load.

## Scope
This SOP covers logging a single workout session to Google Sheets. Sync to GitHub happens automatically (no manual Git operations required).

## Prerequisites
- Google Sheets app installed on mobile device
- Bookmark to `G01_Training_Journal` spreadsheet
- Basic knowledge of your exercise IDs (reference available in `Training/config/exercises.yml`)

## Success Criteria
- All exercises from current session logged in `sets` tab
- One session metadata row added to `workouts` tab
- Total time: <60 seconds post-workout
- No missing required fields

---

## Procedure

### Step 1: Open Google Sheet (5 seconds)
**On mobile:**
1. Open Google Sheets app
2. Tap `G01_Training_Journal`

**On desktop (if at gym computer):**
1. Open browser bookmark to sheet

---

### Step 2: Log Exercise Sets (30–40 seconds)

**Navigate to `sets` tab**

**For EACH exercise you performed**, add ONE row with these columns:

| Column | What to enter | Example |
|---|---|---|
| `date` | Today's date (YYYY-MM-DD) | `2026-01-23` |
| `workout_id` | Which workout? | `hit_upper_a` or `hit_lower_a` or `hit_fullbody_a` |
| `exercise_id` | From exercise list | `ex_lat_pulldown` |
| `weight_kg` | Load used (kg) | `70` |
| `tut_s` | Time under tension (seconds) | `92` |
| `max_effort` | Did you push to max? | `TRUE` or `FALSE` |
| `form_ok` | Was form clean? | `TRUE` or `FALSE` |
| `notes` | Optional context | `"signal: consider increase"` or leave blank |

**Quick entry tips:**
- Use Google Sheets mobile autocomplete (type first few letters)
- Default to `TRUE, TRUE` for max_effort and form_ok unless you know it's false
- Notes are optional—skip if session was normal

**Example rows (Upper A session):**
2026-01-23, hit_upper_a, ex_chest_press_machine, 80, 67, TRUE, TRUE, 2026-01-23, hit_upper_a, ex_lat_pulldown, 70, 92, TRUE, TRUE, signal: consider increase 2026-01-23, hit_upper_a, ex_seated_row_machine, 75, 58, TRUE, TRUE, 2026-01-23, hit_upper_a, ex_lateral_raise_db, 16, 44, TRUE, FALSE, form broke last 10s 2026-01-23, hit_upper_a, ex_biceps_curl_cable, 35, 61, TRUE, TRUE, 2026-01-23, hit_upper_a, ex_triceps_pushdown, 45, 55, TRUE, TRUE,


---

### Step 3: Log Session Metadata (10–15 seconds)

**Navigate to `workouts` tab**

**Add ONE row** with session-level data:

| Column | What to enter | Example |
|---|---|---|
| `date` | Same as sets | `2026-01-23` |
| `workout_id` | Same as sets | `hit_upper_a` |
| `location` | Where you trained | `gym` or `home` |
| `duration_min` | Session length (minutes) | `52` |
| `days_since_last_workout` | Days since last session (optional) | `3` or leave blank |
| `recovered_1_5` | How recovered did you feel? (1–5 scale) | `4` |
| `mood_1_5` | Mood/motivation (1–5 scale) | `4` |
| `notes` | Optional session context | `"felt good; pushed hard"` or leave blank |

**Recovery/mood scale reference:**
- `1` = terrible (exhausted/terrible mood)
- `2` = below average
- `3` = ok/neutral
- `4` = good/ready
- `5` = excellent (fully recovered/great mood)

**Example row:**

2026-01-23, hit_upper_a, gym, 52, 3, 4, 4, felt good; pushed hard


---

### Step 4: Done (5 seconds)
**Close Google Sheets.**

That's it. No Git operations. No files to save. Sync happens automatically within 6 hours.

---

## Next Morning: Log Body Measurement (Optional, 15 seconds)

**Navigate to `measurements` tab**

**Add ONE row** with smart scale data:

| Column | What to enter | Example |
|---|---|---|
| `date` | Today's date | `2026-01-24` |
| `bodyweight_kg` | Weight (kg) | `86.1` |
| `bodyfat_pct` | Body fat % (smart scale) | `18.6` |
| `notes` | Conditions | `"morning fasted"` |

**Measurement protocol (for consistency):**
- Time: morning, after bathroom, before food/water
- Conditions: same scale, same floor location, minimal clothing

---

## Common Scenarios

### Scenario A: You skipped some exercises (low energy day)
**Solution:** Only log the exercises you actually did. No need to log zeros or "skipped" rows.

**Example:** Planned Upper A, but only did 3 exercises.
- Log 3 rows in `sets` tab
- Log 1 row in `workouts` tab (still log the session metadata)
- Optional: add note like `max_effort=FALSE` or session notes: `"low energy; cut short"`

---

### Scenario B: You forgot exercise_id or workout_id names
**Quick reference (most common):**

**Workout IDs:**
- `hit_upper_a` (chest/back/shoulders/arms)
- `hit_lower_a` (legs/calves/abs)
- `hit_fullbody_a` (all compound movements)

**Exercise IDs (common):**
- Upper: `ex_chest_press_machine`, `ex_lat_pulldown`, `ex_seated_row_machine`, `ex_lateral_raise_db`, `ex_biceps_curl_cable`, `ex_triceps_pushdown`
- Lower: `ex_leg_press`, `ex_leg_curl_machine`, `ex_back_extension`, `ex_calf_raise_machine`, `ex_ab_crunch_machine`

**Full list:** See `docs/10_Goals/G01_Target-Body-Fat/Training/config/exercises.yml`

---

### Scenario C: You're not sure if you pushed max effort
**Decision rule:**
- `max_effort=TRUE` if you went close to failure (couldn't do another clean rep)
- `max_effort=FALSE` if you intentionally held back (testing weight, bad mood, joint discomfort, time pressure)

**When in doubt:** log `TRUE`. Only use `FALSE` when you *know* you didn't push.

---

### Scenario D: Form broke during the set
**Decision rule:**
- `form_ok=TRUE` if 90%+ of reps were clean
- `form_ok=FALSE` if you cheated significantly (momentum, partial ROM, pain compensation)

**Action:** If `form_ok=FALSE`, do NOT increase weight next time (even if TUT was high).

---

## Troubleshooting

### Problem: "I don't have my phone at the gym"
**Solutions:**
- Option A: Take quick voice memo (read out: exercise, weight, TUT, effort). Transcribe to Sheets later.
- Option B: Write on paper gym log, transfer to Sheets within 24 hours.
- Option C: Use gym computer browser (if available).

**Key rule:** Log within 24 hours while memory is fresh. TUT estimation degrades fast.

---

### Problem: "Google Sheets autocomplete suggests wrong IDs"
**Solution:**
- Sheets learns from history. If you logged typos early, autocomplete will suggest them.
- Fix: manually type correct ID once; delete bad history rows.
- Prevention: add dropdown data validation (see [Enhancement: Add Dropdowns](#enhancement-add-dropdowns-planned))

---

### Problem: "I forgot to log TUT during the set"
**Estimation guide:**
- If you did 8–10 reps with controlled tempo: estimate 50–70s
- If you did 6–8 reps slow: estimate 60–80s
- If you did 10–12 reps fast: estimate 40–60s

**Better solution:** Use gym clock or count "1-Mississippi, 2-Mississippi..." during set. Accuracy matters for progression signals.

---

### Problem: "Data didn't sync to GitHub"
**Check:**
1. Wait 6 hours (sync runs every 6 hours, not instant)
2. Check GitHub Actions: go to repo → Actions → "G01 Training Sync" → latest run
3. If failed, see [Runbook: Sheets Sync Failure](../../40_Runbooks/G01/Sheets-Sync-Failure.md)

**Manual trigger:** GitHub → Actions → "G01 Training Sync" → "Run workflow" (forces immediate sync)

---

## Quality Checks

### Self-audit (once per week, 2 minutes)
**Open Google Sheets, check for:**
- [ ] Missing dates (skipped logging?)
- [ ] Typos in `workout_id` or `exercise_id` (will break queries later)
- [ ] All `max_effort` and `form_ok` columns filled (no blanks)
- [ ] Notes are concise (not essays)

**Fix issues immediately** (before they propagate via sync).

---

### Monthly review (automated, planned Q1)
Script will check:
- Session frequency (2–4 per week target)
- TUT compliance (80%+ sets in 60–90s range)
- Max effort adherence (90%+ sessions with `max_effort=TRUE`)

---

## Enhancements (Planned)

### Enhancement: Add Dropdowns (Planned Q1)
**Goal:** Prevent typos at source via Google Sheets data validation.

**Planned dropdowns:**
- `workout_id` → (`hit_upper_a`, `hit_lower_a`, `hit_fullbody_a`)
- `exercise_id` → (from `exercises.yml`)
- `max_effort` / `form_ok` → (`TRUE`, `FALSE`)
- `recovered_1_5` / `mood_1_5` → (`1`, `2`, `3`, `4`, `5`)

**Status:** Tracked in [G01 Roadmap Q1](../../10_Goals/G01_Target-Body-Fat/Roadmap.md)

---

### Enhancement: Conditional Formatting (Planned Q1)
**Goal:** Visual feedback during logging.

**Planned rules:**
- Highlight row green if `tut_s > 90` (progression signal)
- Highlight row red if `form_ok = FALSE` (hold weight)
- Highlight row yellow if `max_effort = FALSE` (maintenance session)

---

## Related Documentation
- **Goal:** [G01 Target Body Fat](../../10_Goals/G01_Target-Body-Fat/README.md)
- **Training System:** [Training/README.md](../../10_Goals/G01_Target-Body-Fat/Training/README.md)
- **Automation:** [WF_G01_001 Sheets Sync](../../50_Automations/github-actions/WF_G01_001__sheets-to-github-sync.md)
- **Runbook (failures):** [Sheets Sync Failure](../../40_Runbooks/G01/Sheets-Sync-Failure.md)
- **Exercise reference:** [exercises.yml](../../10_Goals/G01_Target-Body-Fat/Training/config/exercises.yml)

---

## Revision History
| Date | Version | Changes | Author |
|---|---|---|---|
| 2026-01-23 | 1.0 | Initial SOP | {{OWNER_NAME}} |

