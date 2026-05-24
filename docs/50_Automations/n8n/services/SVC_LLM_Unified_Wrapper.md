---
title: "SVC: LLM Unified Wrapper"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-04"
---

# SVC_LLM_Unified_Wrapper

## Purpose
The primary intelligent gateway for the Autonomous Living ecosystem. It acts as a centralized "Service Router" that accepts various task types (categorization, idea generation, decision evaluation, summarization) and applies domain-specific reasoning and safeguards.

## Scope
- **In Scope:** Routing requests to the appropriate internal LLM logic, input validation, standardized parsing, and output safety checks.
- **Out Scope:** Large-scale data processing (handled by specialized ETL jobs).

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "service": "decision-proposal",
  "domain": "finance",
  "proposal": "Rebalance 500 PLN",
  "reason": "Inflation adjustment"
}
```

### Output (JSON)
```json
{
  "success": true,
  "service": "decision-proposal",
  "data": {
    "decision": "APPROVED_AUTO",
    "confidence": 0.9,
    "risk_level": "LOW",
    "logic": {
      "stability_impact": "Positive",
      "roi_assessment": "High",
      "growth_value": "Medium"
    }
  },
  "processed_at": "2026-05-04T09:40:00Z"
}
```

## Dependencies
- **Service:** Google Gemini API (Flash 1.5)
- **Registry:** internal `SERVICES` configuration in n8n Code node.
- **Trigger:** Webhook at `/webhook/llm/unified`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Unknown Service | 400 Bad Request | Returns list of `available_services`. |
| Validation Fail | `_valid` is false | Returns detailed `missing` fields and `expected_format`. |
| Parse Error | Try/Catch in Safeguard | Returns a service-specific `fallback` object (e.g. `UNCATEGORIZED`). |

## Security Notes
- Implements string length limiting (max 200-2000 chars depending on field) to prevent prompt injection or excessive token usage.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Evaluate service coverage and routing accuracy)
