---
title: "service: PROJ_Inventory-Management"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Inventory-Management"
goal_id: "goal-g03"
systems: ["S03", "S08"]
owner: "Michal"
updated: "2026-02-22"
---

# service: PROJ_Inventory-Management (AI Pantry Agent)

> [!important]
> This is the **standard AI Agent for pantry** and it controls everything. It is the primary interface for all inventory-related operations.

## Purpose
An AI-driven inventory management system that allows for natural language control of the home pantry. It uses a Google Gemini-powered agent to interpret Polish commands, manage product quantities, and maintain a synonym dictionary, all while operating directly on Google Sheets as the data source.

## Triggers
- **Sub-workflow:** Called by `ROUTER_Intelligent_Hub` when a `/pantry` command or related intent is detected.
- **Manual/Direct:** Can be called via Execute Workflow node for testing.

## Inputs
- **Query:** Natural language string (e.g., "Add 2 milk", "Ile mam jajek?").
- **Metadata:** Chat ID, source type, and username for response routing.

## AI Agent Configuration (Gemini)
- **Role:** Home Pantry Assistant (Spiżarnia AI).
- **Language:** Polish ONLY.
- **Model:** Google Gemini 1.5 Pro.
- **Memory:** Windowed memory buffer for session context.

## Tools (Capabilities)
1.  **get_inventory:** Loads current product list, quantities, and thresholds from the "Spizarka" sheet.
2.  **update_inventory:** Updates quantity, status, and timestamp for existing items.
3.  **add_product:** Appends new categories/products to the inventory sheet.
4.  **get_dictionary:** Retrieves synonyms to handle variations in naming (e.g., "mleko" vs "mleczko").
5.  **add_dictionary:** Adds new entries to the synonym dictionary.
6.  **calculator:** Handles mathematical adjustments to quantities.

## Data Source
- **Google Sheet ID:** `10knY7Tnh5iNLooAxQ8OjI0sRJ-2l0t3rH5ABdVuvFAM`
- **Tab: Spizarka:** Main inventory (Kategoria, Ilość, Jednostka, Ważność).
- **Tab: Slownik:** AI Synonyms and default units.

## Processing Logic
1.  **Normalization:** Extracts the core query and detects source metadata.
2.  **Context Preparation:** Fetches entire sheet data and formats it into a human-readable "Context" block for the LLM.
3.  **Agent Reasoning:** Gemini decides which tools to call based on the user's intent (In/Out/Query).
4.  **Execution:** Updates the Google Sheet via the specialized Tools.
5.  **Formatting:** Returns a confirmation string (e.g., "✅ Mleko: 1 → 3 l") to the caller.

## Outputs
- **Response Text:** Human-readable confirmation or answer.
- **Summary:** Metadata about low stock items and total product count.

## Dependencies
### Systems
- [Data Layer (S03)](../../../20_Systems/S03_Data-Layer/README.md) - Google Sheets storage.
- [Automation Orchestrator (S08)](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n engine.

### External Services
- **Google Sheets API:** Read/Write access to inventory.
- **Google Gemini API:** AI reasoning and NLP.

## Manual Fallback
Directly edit the [Google Sheet](https://docs.google.com/spreadsheets/d/10knY7Tnh5iNLooAxQ8OjI0sRJ-2l0t3rH5ABdVuvFAM/edit) to correct errors or manually adjust stock.
