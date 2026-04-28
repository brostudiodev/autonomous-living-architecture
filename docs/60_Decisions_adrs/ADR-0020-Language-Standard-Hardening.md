---
title: "ADR-0020: Language Standard Hardening (English-Only Core)"
type: "adr"
status: "accepted"
owner: "Michał"
updated: "2026-04-24"
---

# ADR-0020: Language Standard Hardening (English-Only Core)

## Context
The system has historically used a hybrid of Polish and English keywords for intent detection, flag analysis (health/productivity), and data parsing. With the deployment of `SVC_Language-Gate` in n8n, all incoming user requests are automatically translated to English before reaching the Python core and Digital Twin API.

Maintaining dual-language regexes and keyword maps in Python scripts creates redundant logic, increases maintenance overhead, and introduces potential conflicts in intent detection.

## Technical Implementation: SVC_Language-Gate
The **SVC_Language-Gate** is implemented as an **n8n workflow** that acts as the primary translation and intent-normalization layer.

- **Access Method:** Webhook
- **Endpoint:** `[N8N_URL]/webhook/language-gate`
- **Integrated Endpoints:** The `/chat` and `/query` endpoints in the Digital Twin API are natively protected/routed through this gate.

## Mandatory Guideline for New Scripts
Any future Python scripts or automations that require processing of Polish text (or other non-English input) **MUST NOT** implement local translation or regex logic. Instead:
1.  They must delegate translation to the `SVC_Language-Gate` via its webhook.
2.  All internal processing, database lookups, and logic branching must occur using the returned English text.

## Consequences
- **Reduced Complexity:** Scripts are leaner and easier to audit.
- **Improved Accuracy:** Eliminates false positives caused by multi-language regex overlaps.
- **Dependency:** The system now strictly depends on `SVC_Language-Gate` for non-English users. If the gate fails, core intent detection for Polish users will degrade.
- **Technical Debt:** Legacy Polish strings in data-layer scripts (e.g., `G05_bank_ingest.py`) are prioritized for future refactoring but left intact for immediate stability.

## Status
**Accepted** - Applied to G04, G10, and G03 core scripts on 2026-04-24.
