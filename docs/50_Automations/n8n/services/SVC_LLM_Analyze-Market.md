---
title: "SVC: LLM Analyze Market"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-04"
---

# SVC_LLM_Analyze-Market

## Purpose
The Market Intelligence Engine. It performs rigorous market analysis for automation opportunities. It is designed to be analytical, skeptical, and data-grounded, helping a solo operator assess business potential and unique positioning gaps.

## Scope
- **In Scope:** Opportunity assessment, competitive landscape, positioning Messaging, trend trajectory.
- **Out Scope:** primary market data scraping (provided as context).

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "market": "n8n integration services for SMEs",
  "analysis_type": "opportunity",
  "context": {
    "my_skills": ["n8n", "Python", "RPA"],
    "target_audience": "Small manufacturing firms"
  }
}
```

### Output (JSON)
```json
{
  "success": true,
  "data": {
    "executive_summary": "High potential in legacy system bridging...",
    "market_score": 0.75,
    "confidence": 0.7,
    "sections": {
      "demand_signals": { "overall_demand": "HIGH" }
    },
    "kill_criteria": ["Lack of API access in 80% of targets"]
  }
}
```

## Dependencies
- **Service:** Google Gemini API
- **Source:** `G09_market_scout_handler.py`
- **Trigger:** Webhook at `/webhook/llm/analyze-market`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Hype Bias | System Message | Orchestrator is forced to be 'skeptical' and 'analytical'. |
| Inflated Revenue | Safeguard node | Flags targets >1,000,000 PLN as potentially inflated for solo op. |

## Security Notes
- Strategic intent is private; market signals may be derived from public data.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Quarterly (Review market pivots and positioning)
