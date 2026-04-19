---
title: "SVC: Career Market Scout"
type: "automation_spec"
status: "active"
owner: "Michal"
goal_id: "goal-g09"
systems: ["S11", "S04"]
updated: "2026-04-09"
---

# SVC: Career Market Scout (n8n)

## Overview
This n8n service workflow proactively monitors the job market for target roles (AI Architect, Automation Engineer) and identifies emerging skill requirements. It bridges the gap between external market trends and internal personal development goals (G06/G09).

## Logic Flow
1. **Trigger:** Weekly Cron (Sunday 18:00).
2. **Search:** HTTP Request to Job Board RSS/APIs or LinkedIn Scraper.
3. **Extraction (LLM):** Uses Google Gemini to extract "Required Skills" from job descriptions.
4. **Comparison:** Checks extracted skills against the internal `autonomous_career.skill_metrics` (via Digital Twin API).
5. **Reporting:** If a high-demand skill is missing or at "None" level, it calls `POST /career/report_gap` on the Digital Twin API.

## API Integration
- **Endpoint:** `POST /career/report_gap`
- **Payload:**
```json
{
  "skill": "Six Sigma Black Belt",
  "demand": "High",
  "current_level": "None",
  "source": "LinkedIn (Senior Architect Roles)"
}
```

## Related Documentation
- [Goal: G09 Career Intelligence](../../../10_Goals/G09_Automated-Career-Intelligence/README.md)
- [Script: Market Scout Handler](../../scripts/G09_market_scout_handler.md)
