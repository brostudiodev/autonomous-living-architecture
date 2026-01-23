---
title: "G01: Outcomes"
type: "goal_outcomes"
status: "active"
goal_id: "goal-g01"
updated: "2026-01-23"
---

# Outcomes

## Primary outcome
**Body composition improvement** measured by:
- Smart scale body fat % trend (7-day moving average) showing 2–4% reduction over 2026
- OR waist circumference reduction of 5–8 cm (if BF% proves too noisy)
- AND strength maintained or improved (load × TUT trend per exercise stable or increasing)

Target is **direction and sustainability**, not a specific BF% number (due to smart scale accuracy limits).

## Secondary outcomes
- **Zero-friction logging:** post-workout data entry <60 seconds (mobile-first)
- **Audit trail:** every workout logged in Git with timestamps
- **Self-validating system:** schema enforcement prevents data corruption
- **Decision automation:** progression signals auto-generated (reduce "should I increase?" cognitive load)

## Constraints
- **Privacy:** Training data stored in public GitHub repo (acceptable; no sensitive health data)
- **Budget:** $0 (using free Google Sheets + GitHub Actions)
- **Time:** Max 60 seconds logging per workout; max 10 minutes/week for review
- **Equipment:** Machine-based exercises only (gym access required)

## Non-goals
- **Not** competitive bodybuilding prep (no DEXA scans, macro tracking to the gram, or peak-week protocols)
- **Not** fixed training schedule (train when recovered, 2–6 days between sessions)
- **Not** "optimal" programming (HIT low-volume is deliberate simplicity trade-off)
- **Not** nutrition tracking integration (separate system; may connect later if BF% progress stalls)

