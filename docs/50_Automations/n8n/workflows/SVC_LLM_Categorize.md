---
title: "SVC: LLM Categorize"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-02"
---

# SVC_LLM_Categorize

## Purpose
Provides an intelligent API for financial transaction categorization. It wraps Google Gemini to match raw bank descriptions against the system's category hierarchy with high precision, identifying potential budget breaches in real-time.

## Scope
- **In Scope:** Categorization of mBank/ING/Generic CSV imports, identifying budget over-utilization, providing human-readable reasoning.
- **Out Scope:** Direct database writes (results must be applied by the caller), automated rebalancing (handled by G05_rebalancer).

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "transaction": {
    "merchant": "Uber",
    "amount": 45.00,
    "currency": "PLN",
    "description": "Commute to office"
  },
  "categories": ["Transport > Ride", "Food > Groceries", "Lifestyle > Fun"]
}
```

### Output (JSON)
```json
{
  "category": "Transport > Ride",
  "is_breach": false,
  "reasoning": "Merchant 'Uber' matches transport intent; amount is within standard commute variance."
}
```

## Dependencies
- **Service:** Google Gemini SDK (via n8n)
- **Credential:** `googleGeminiSdkApi` (n8n internal)
- **Upstream:** `G05_llm_categorizer.py` (Local Python)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Gemini API Timeout | Webhook returns 5xx error | Script falls back to 'Other' and logs a system error. |
| Hallucination | Impossible category ID returned | Script validation fails; transaction remains unapproved. |
| Budget Overload | `is_breach` is true | System emits `finance.warning.budget_breach` to RabbitMQ. |

## Security Notes
- Uses `${GEMINI_API_KEY}` via n8n encrypted vault.
- Transaction amounts are processed but no full PII (Names/Account Nos) is sent to the LLM.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Audit category mapping accuracy)
