---
title: "Pantry Management System"
type: "sub_project"
parent_goal: "G03"
status: "active"
owner: "Michał"
systems: ["S03", "S07"]
automation: "WF105"
updated: "2026-04-03"
goal_id: "goal-g03"
---

# Pantry Management System

> [!important]
> This is the **standard AI Agent for pantry** and it controls everything. It manages the bidirectional sync between Google Sheets and PostgreSQL, ensuring data integrity without the use of intermediate CSV files.

## Strategic Context
AI-powered pantry inventory tracking via natural language interaction through Telegram, 
n8n chat, and webhooks. Directly supports G03 Autonomous Household Operations by:
- Eliminating manual inventory management overhead
- Enabling predictive restocking based on consumption patterns
- Supporting budget optimization through usage tracking
- Reducing waste and ensuring food freshness through expiration date tracking and alerts (SVC_Pantry-Expiration-Alerts)
- Providing real-time supply chain visibility

## Architecture Overview

### Data Architecture
The Pantry Management System follows a **Hybrid UI / Centralized Data** model:
- **User Interface (UI):** Google Sheets (`Magazynek_domowy`) serves as the primary entry point. It contains multiple location-specific worksheets (e.g., `Spizarka`, `Zamrazarka`, `Garaz`).
- **Single Source of Truth (SSOT):** PostgreSQL (`autonomous_pantry` database) acts as the canonical data store for all system logic, Digital Twin integration, and cross-goal automation.
- **Synchronization:** Automated ETL processes (`pantry_sync.py`) ensure consistency. **The system uses a composite primary key `(category, location)` to support multi-storage tracking.**

### Data Layer (Google Sheets: Magazynek_domowy)
**Critical Design Decision:** Column headers remain in **Polish** for compatibility with existing workflows and AI system prompt, but are fully documented in English for Meta-System analysis.

#### Sheet 1: Inventory Interface (e.g., Spizarka, Zamrazarka)
The following structure is shared across all location-specific worksheets:
| Polish Column | English Definition | Purpose | Data Type |
|---|---|---|---|
| `Kategoria` | Category/Product Name | Primary key identifier | Text |
| `Aktualna_Ilość` | Current Quantity | Stock level (never negative) | Number |
| `Jednostka` | Unit of Measurement | "szt", "l", "kg", "paczka" | Text |
| `Najblizsa_Waznosc` | Nearest Expiration Date | YYYY-MM-DD format | Date |
| `Ostatnia_Aktualizacja` | Last Update Timestamp | Auto-updated by AI agent | Date |
| `Status` | Stock Status | "OK", "Niski", "Krytyczny", "Pusty" | Text |
| `Próg_Krytyczny` | Critical Threshold | Minimum quantity trigger | Number |
| `Budget_Category` | Budget Category | Maps to a category in the finance system (e.g., 'Groceries'). | Text |
| `Uwagi` | Notes | Free-form annotations | Text |

#### Sheet 2: Slownik (AI Dictionary)
| Polish Column | English Definition | Purpose |
|---|---|---|
| `Kategoria` | Canonical Category Name | Links to Spizarka primary key |
| `Synonimy_AI` | AI-Recognized Synonyms | Comma-separated alternatives |
| `Domyślna_Jednostka` | Default Unit | Used when unit not specified |
| `Próg_Krytyczny` | Default Critical Threshold | Template for new products |

### AI Agent Architecture
**Workflow:** WF105 Pantry Management  
**Model:** Google Gemini with ReAct (Reasoning + Acting) pattern  
**Tools:** 6 Google Sheets tools + calculator for quantity operations

**Agent Capabilities:**
- Natural language intent recognition (Polish)
- Synonym mapping via Slownik sheet
- Automatic category creation for unknown products
- Quantity validation (prevents negative inventory)
- Multi-channel response (Telegram, chat, webhook)

## Integration with Parent Goal (G03)

### Data Flows

Pantry System → S03 Data Layer → WF105 Grocery Automation

    Consumption patterns from the AI Agent feed predictive ordering.
    When stock levels fall below the `Próg_Krytyczny` (Critical Threshold), an item is automatically added to a "Shopping List".
    **Budgetary Enforcement:** Before adding an item to the shopping list, the system queries the **G05 Autonomous Finance** database. It uses the `get_current_budget_alerts()` PostgreSQL function to check for `CRITICAL` or `HIGH` alerts on the item's assigned `Budget_Category`. If an alert exists, the item is added with a status of 'Awaiting_Approval' instead of being automatically approved for purchase.

Pantry System → S03 Data Layer (PostgreSQL) for G12 Consumption

    Normalized pantry data (inventory levels, consumption patterns from `Spizarka` and `Transaction_Log`) is pushed to the S03 Data Layer. This provides G12 (Meta-System) with a structured, queryable source of household operational data for cross-system correlation and optimization.

Pantry System → S11 Meta-System → Optimization Suggestions

    Cross-system correlation detection
    Efficiency improvement recommendations
    Automated pattern analysis


### Success Metrics
- Manual inventory interventions: <2 per month
- AI interpretation accuracy: >95%
- System uptime: >99.5%
- Response time: <3 seconds end-to-end

## User Interaction Examples

**Adding Items:**

User: "kupiliśmy 3 paczki makaronu" Bot: ✅ Makaron: 2 → 5 paczka


**Removing Items:**

User: "zjedliśmy ostatnie jajka" Bot: ✅ Jajka: 6 → 0 szt [🔴 Krytyczny stan!]


**Status Queries:**

User: /inventory Bot: 📊 AKTUALNY STAN SPIŻARNI ✅ Mleko: 3 l 🟡 Jajka: 2 szt 🔴 Cukier: 0 kg


## Related Documentation
- [Automation Spec: WF105](../../50_Automations/n8n/workflows/WF105__pantry-management.md)
- [Data Schema: S03 Pantry](../../20_Systems/S03_Data-Layer/Pantry-Schema.md)
- [Daily Operations SOP](../../30_Sops/Home/Pantry-Management.md)
- [Troubleshooting Runbook](../../40_Runbooks/Household/Pantry-System-Failure.md)
