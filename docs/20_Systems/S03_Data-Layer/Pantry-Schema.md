---
title: "S03: Pantry Data Schema (Magazynek_domowy)"
type: "data_model"
status: "active"
source_system: "Google Sheets"
owner: "Michał"
updated: "2026-04-03"
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

### Primary Table: pantry_inventory
**Purpose:** Real-time household consumable tracking with predictive analytics and multi-location support.

**Column Specifications:**
- `category` (Kategoria): Part of composite Primary Key, standardized product names.
- `location` (Lokalizacja): Part of composite Primary Key, storage area (e.g., Spizarka, Zamrazarka).
- `current_quantity` (Aktualna_Ilość): Numeric, updated by sync or AI agents.
- `unit` (Jednostka): Controlled vocabulary ["szt", "l", "kg", "paczka", "opak", etc.].
- `next_expiry` (Najblizsa_Waznosc): ISO date format, supports meal planning.
- `last_updated` (Ostatnia_Aktualizacja): Date of last change in the source sheet.
- `status` (Status): Computed field ["OK", "Low Stock", etc.].
- `critical_threshold` (Próg_Krytyczny): Triggers automated shopping alerts.
- `notes` (Uwagi): Free text, human annotations.
- `updated_at`: Internal database timestamp (automatic).

**Key Constraints:**
- **Composite Primary Key:** `(category, location)` allows tracking the same item in multiple places (e.g., Bread in 'Spizarka' and 'Zamrazarka').
- **Aggregation:** AI agents MUST use `SUM(current_quantity) GROUP BY category` to determine total household stock levels.

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
