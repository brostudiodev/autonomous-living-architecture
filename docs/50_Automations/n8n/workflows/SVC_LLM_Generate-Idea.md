---
title: "SVC: LLM Generate Idea"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-02"
---

# SVC_LLM_Generate-Idea

## Purpose
The "Creative Spark" of the system. It monitors system events (Health wins, Finance ROI, System failures) and generates authority-building content ideas for the @Automationbro brand.

## Scope
- **In Scope:** ROI analysis from time-saved data, milestone recognition for certifications, "Building in Public" prompts.
- **Out Scope:** Full post drafting (handled by SVC_LLM_Draft-Content), scheduling.

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "domain": "productivity",
  "action": "time_saved",
  "payload": {
    "minutes": 120,
    "win_type": "pantry_automation"
  }
}
```

### Output (JSON)
```json
{
  "title": "The 120-Minute Reclaim",
  "hook": "I stopped manually checking my fridge. Here is what I did with the 2 hours I got back.",
  "key_points": ["Automated price scouting", "Zero-friction pantry sync"],
  "why": "Demonstrates ROI of life engineering."
}
```

## Dependencies
- **Service:** Google Gemini SDK (n8n)
- **Upstream:** `G02_idea_generator.py` (triggers on ROI events)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Generic Output | Idea title is "New Idea" | Filtered by script; no Markdown file created. |
| Context Missing | Payload is empty | Returns error; script skips generation. |

## Security Notes
- No private health biometrics (HRV/Weight) are sent as raw values; only "Readiness Level" (Peak/Low) is used.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Quarterly (Refine @Automationbro persona prompt)
