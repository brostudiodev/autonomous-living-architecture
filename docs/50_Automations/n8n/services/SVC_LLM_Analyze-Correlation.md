---
title: "SVC: LLM Analyze Correlation"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-04"
---

# SVC_LLM_Analyze-Correlation

## Purpose
The Correlation Analysis Engine. It performs rigorous statistical analysis across disparate life-system datasets (e.g., Health vs. Productivity). It distinguishes between correlation and causation to provide data-grounded lifestyle adjustments.

## Scope
- **In Scope:** Pairwise correlation, lag analysis (up to 3 periods), confounder assessment, causal hypothesis testing.
- **Out Scope:** primary data collection.

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "datasets": [
    { "domain": "health", "metric": "sleep_hours", "data_points": [...] },
    { "domain": "productivity", "metric": "focus_score", "data_points": [...] }
  ],
  "hypothesis": "Better sleep improves focus",
  "analysis_depth": "deep"
}
```

### Output (JSON)
```json
{
  "success": true,
  "data": {
    "executive_summary": "Strong positive correlation detected with a 1-day lag...",
    "confidence_in_analysis": 0.8,
    "correlations": [
      {
        "pair": { "dataset_a": "health:sleep_hours", "dataset_b": "productivity:focus_score" },
        "direction": "POSITIVE",
        "estimated_strength": 0.75,
        "lag_days": 1,
        "spurious_risk": "LOW"
      }
    ],
    "recommendations": ["Enforce 11 PM sleep to protect focus"]
  }
}
```

## Dependencies
- **Service:** Google Gemini API
- **Source:** `G11_lifestyle_auditor.py`
- **Trigger:** Webhook at `/webhook/llm/analyze-correlation`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Insufficient Data | Code node check | Returns error if <3 data points per dataset. |
| Contradictory Signs | Safeguard logic | Fixes `direction` if it contradicts the `estimated_strength` sign. |

## Security Notes
- Handles internal life-telemetry; strictly private access.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Audit long-term findings against reality)
