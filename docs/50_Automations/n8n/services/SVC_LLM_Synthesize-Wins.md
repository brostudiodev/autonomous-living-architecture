---
title: "SVC: LLM Synthesize Wins"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-04"
---

# SVC_LLM_Synthesize-Wins

## Purpose
The Reflection & Synthesis Engine. It analyzes collections of system events and personal wins to extract meaning, momentum, and actionable insights. It helps maintain strategic alignment by celebrating real progress and identifying blind spots.

## Scope
- **In Scope:** Win aggregation, pattern detection, momentum scoring (0-1), next-action suggestion, content hook generation.
- **Out Scope:** Direct social media posting.

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "wins": [
    { "domain": "system", "event": "Migrated LLM to n8n", "impact": "High architectural decoupling" }
  ],
  "period": "2026-W18",
  "context": { "mood": "focused", "focus_area": "infrastructure" }
}
```

### Output (JSON)
```json
{
  "success": true,
  "service": "synthesize-wins",
  "data": {
    "period": "2026-W18",
    "summary": "Completed critical infrastructure decoupling...",
    "top_wins": [
      { "domain": "system", "win": "n8n Migration", "north_star_alignment": "HIGH" }
    ],
    "momentum_score": 0.85,
    "suggested_next_actions": ["Audit G11 logs"],
    "content_hook": "Infrastructure as a service for life."
  }
}
```

## Dependencies
- **Service:** Google Gemini API
- **Source:** `G09_career_growth_reporter.py`
- **Trigger:** Webhook at `/webhook/llm/synthesize-wins`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Empty Wins | `_valid` is false | Returns `expected_format` requiring at least 1 win. |
| Hallucination | Low `momentum_score` but high `top_wins` | Safeguard node normalizes scores and truncates wins to max 5. |

## Security Notes
- Sanitizes input fields to 100-300 characters to ensure processing efficiency.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Weekly (During Sunday Review)
