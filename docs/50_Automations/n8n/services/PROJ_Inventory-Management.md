---
title: "PROJ: Inventory Management (G03)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Inventory-Management"
goal_id: "goal-g03"
systems: ["S03", "S08"]
owner: "Michał"
updated: "2026-04-13"
---

# PROJ: Inventory Management (Multi-Location AI Agent)

## Purpose
The **Inventory Management System** is an AI-driven agent designed to maintain a unified view of Michał's household inventory across multiple physical locations (currently **Spizarka** and **Gabinet**). It provides natural language control over product quantities, handles low-stock alerts, and manages a synonym dictionary to resolve naming variations.

## Triggers
- **Sub-workflow:** Triggered by `ROUTER_Intelligent_Hub` when a `/pantry` command or related intent is detected.
- **Manual Trigger:** Used for audit and data integrity checks.

## Inputs
- **Query:** Natural language string (e.g., "Add 2 packs of coffee to Gabinet", "Ile mam ryżu w Spiżarni?").
- **Metadata:** Chat ID, User ID, and Source Type.

## Processing Logic
1. **Normalization:** Resolve session ID and extract the query. Sets a default query if input is empty.
2. **Multi-Location Data Loading:**
   - `Load Spizarka Data`: Fetches the current inventory from the "Spizarka" Google Sheet tab.
   - `Load Gabinet Data`: Fetches the current inventory from the "Gabinet" Google Sheet tab.
3. **Context Construction:** `Prepare AI Context` (JS Code) aggregates data from all locations into a structured text block. It identifies low-stock items across the entire ecosystem.
4. **Synonym Matching:** `Get Dictionary` loads the synonym map to ensure "mleko" and "mleczko" refer to the same item.
5. **Intelligence Layer:** Google Gemini (v1.5 Pro) reasons over the combined context and decides on the appropriate action (Add/Subtract/Query).
6. **Execution:** Updates the relevant Google Sheet location or appends new dictionary entries.
7. **Output:** Packages the final confirmation for the `Response Dispatcher`.

## AI Agent Configuration
- **Role:** Professional Household Inventory Assistant (Spiżarnia AI).
- **Language:** Polish (Primary), English (Secondary).
- **Model:** Google Gemini 1.5 Pro.
- **Memory:** Buffer window for maintaining inventory session context.

## Tools (Capabilities)
1. **get_inventory:** Loads data from all registered locations.
2. **update_inventory:** Surgically updates quantities in the correct sheet/location.
3. **add_product:** Appends new items to the inventory sheet.
4. **get_dictionary / add_dictionary:** Manages synonyms to reduce duplicate entries.

## Dependencies
### Systems
- [Autonomous Household (G03)](../../../10_Goals/G03_Autonomous-Household-Operations/README.md)
- [Data Layer (S03)](../../../20_Systems/S03_Data-Layer/README.md) - Google Sheets.

### External Services
- **Google Sheets API:** Read/Write access to `Magazynek_domowy`.
- **Google Gemini API:** Core intelligence and NLP.

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| Sheet Access Failure | HTTP 403/404 from Google node | Returns an error message suggesting a manual sheet check. |
| Ambiguous Location | Agent identifies multi-location match | Agent asks the user for clarification (e.g., "Which Gabinet or Spizarka?"). |
| Unit Mismatch | Adding 'liters' to 'kg' | Agent flags the unit mismatch and asks for confirmation. |

## Security Notes
- **Authority:** Full read/write access to inventory and dictionary sheets.
- **Credential:** `SLEIKPxbRj4qcc9d` (OAuth2).
- **ID Management:** Uses fixed Spreadsheet ID `{{LONG_IDENTIFIER}}`.

## Manual Fallback
[Open Magazynek_domowy Google Sheet](https://docs.google.com/spreadsheets/d/{{LONG_IDENTIFIER}}/edit)

---

*Documentation synchronized with PROJ_Inventory Management.json v2.0 (2026-04-13)*
