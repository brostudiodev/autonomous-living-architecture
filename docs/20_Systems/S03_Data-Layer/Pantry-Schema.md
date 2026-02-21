---
title: "S03: Pantry Data Schema (Magazynek_domowy)"
type: "data_model"
status: "active"
source_system: "Google Sheets"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Pantry Data Schema

## Design Constraint
**Language Policy:** Column headers must remain in **Polish** to maintain compatibility with:
- Existing AI system prompt (trained on Polish terms)
- Legacy scripts and automations
- User mental model (Polish household context)

**Documentation Policy:** All schema documentation in **English** to enable:
- Meta-System Integration Engine analysis
- Enterprise client demonstrations
- Future system migrations

## Schema Definition

### Primary Table: Spizarka (Inventory)
**Purpose:** Real-time household consumable tracking with predictive analytics support

**Column Specifications:**
- `Kategoria` (Category): Primary key, standardized product names
- `Aktualna_Ilość` (Current Quantity): Non-negative integer, updated by AI agent
- `Jednostka` (Unit): Controlled vocabulary ["szt", "l", "kg", "paczka", "opak"]
- `Najblizsa_Waznosc` (Expiration Date): ISO date format, supports meal planning
- `Ostatnia_Aktualizacja` (Last Updated): Automatic timestamp, audit trail
- `Status` (Status): Computed field ["OK", "Niski", "Krytyczny", "Pusty"]
- `Próg_Krytyczny` (Critical Threshold): Triggers automated shopping alerts
- `Uwagi` (Notes): Free text, human annotations

### Reference Table: Slownik (Dictionary)
**Purpose:** AI natural language understanding and synonym resolution

**Column Specifications:**
- `Kategoria` (Category): Foreign key to Spizarka
- `Synonimy_AI` (AI Synonyms): Comma-separated, supports multilingual input
- `Domyślna_Jednostka` (Default Unit): Template for new product creation
- `Próg_Krytyczny` (Default Threshold): Template for new product creation

## Integration Patterns
- **Read Operations:** AI agent queries both tables for context
- **Write Operations:** Updates Spizarka, extends Slownik as needed
- **Validation Rules:** Enforced by AI agent system prompt
- **Backup Strategy:** Daily export to S03 Data Layer for disaster recovery

## Meta-System Integration Points
This schema enables the Meta-System Integration Engine to:
- Analyze consumption patterns across categories
- Detect correlation with health/fitness data (S06)
- Optimize grocery spending patterns (S05)
- Predict restocking needs for WF101 automation
