---
title: "ADR-0002: Pantry System Polish Column Headers"
type: "adr"
status: "accepted"
owner: "Michał"
updated: "2026-02-07"
systems: ["S03"]
goals: ["G03"]
---

# ADR-0002: Pantry System Polish Column Headers

## Context
Building Pantry Management System requires Google Sheets backend. Decision needed: 
English headers (international standard) vs Polish headers (user mental model).

## Decision
**Use Polish column headers** (`Kategoria`, `Aktualna_Ilość`, etc.) with comprehensive English documentation.

## Rationale
**Operational reality trumps abstract standards.** Daily users interact in Polish - 
forcing English creates cognitive friction reducing adoption and increasing errors.

### Supporting Factors
- User mental model alignment (household thinks in Polish)
- AI system prompt already trained on Polish terminology
- Natural language processing efficiency (Polish input → Polish data)
- Existing workflow compatibility

### Mitigation for Downsides
- Comprehensive English documentation with translation mappings
- Data schema explicitly defines Polish→English equivalents  
- Public demonstrations use English-translated data

## Consequences
**Positive:** Zero cognitive friction, faster AI response, easier debugging
**Negative:** Requires documentation translation layer, Meta-System needs mapping
**Precedent:** Establishes pattern for other household systems

## Review Trigger
Revisit if expanding to non-Polish users or migrating to enterprise database.
