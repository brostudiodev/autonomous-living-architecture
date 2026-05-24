---
title: "SVC: LLM Summarize Context"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-04"
---

# SVC_LLM_Summarize-Context

## Purpose
The Context Compression Engine. It distills large volumes of raw data (logs, event streams, documents) into structured, consumption-ready summaries designed for downstream LLM services or rapid human resumption of work.

## Scope
- **In Scope:** Narrative summary, entity/event extraction, topic detection, compression assessment (information loss).
- **Out Scope:** Analysis of data (handled by dedicated analysts).

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "content": "System logs from last 24 hours...",
  "source_type": "system_logs",
  "purpose": "context_compression"
}
```

### Output (JSON)
```json
{
  "success": true,
  "service": "summarize-context",
  "data": {
    "summary": "Infrastructure stable. 3 minor sync failures detected...",
    "key_entities": [{ "name": "G03 Scraper", "type": "service", "relevance": "HIGH" }],
    "compression_ratio": "8000 chars -> 150 words",
    "information_loss": "MINIMAL"
  }
}
```

## Dependencies
- **Service:** Google Gemini API
- **Source:** `G04_digital_twin_engine.py`, `G12_context_resumer.py`
- **Trigger:** Webhook at `/webhook/llm/summarize-context`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Missing Summary | Safeguard node | Uses raw truncation as fallback if LLM fails to output valid field. |
| Invalid Sentiment | Safeguard node | Defaults to `NEUTRAL` if sentiment value is non-standard. |

## Security Notes
- Sanitizes input to max 8000 characters to prevent context window overflow.

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Audit summary accuracy against source logs)
