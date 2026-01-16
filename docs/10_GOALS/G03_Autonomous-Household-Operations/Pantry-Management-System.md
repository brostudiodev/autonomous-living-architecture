---
title: "Pantry Management System"
type: "sub_project"
parent_goal: "G03"
status: "active"
owner: "Michał"
systems: ["S03", "S07"]
automation: "WF105"
updated: "2026-01-15"
---

# Pantry Management System

## Strategic Context
AI-powered pantry inventory tracking via natural language interaction through Telegram, 
n8n chat, and webhooks. Directly supports G03 Autonomous Household Operations by:
- Eliminating manual inventory management overhead
- Enabling predictive restocking based on consumption patterns
- Supporting budget optimization through usage tracking
- Providing real-time supply chain visibility

## Architecture Overview

### Data Layer (Google Sheets: Magazynek_domowy)
**Critical Design Decision:** Column headers remain in **Polish** for compatibility with existing workflows and AI system prompt, but are fully documented in English for Meta-System analysis.

#### Sheet 1: Spizarka (Primary Inventory)
| Polish Column | English Definition | Purpose | Data Type |
|---|---|---|---|
| `Kategoria` | Category/Product Name | Primary key identifier | Text |
| `Aktualna_Ilość` | Current Quantity | Stock level (never negative) | Number |
| `Jednostka` | Unit of Measurement | "szt", "l", "kg", "paczka" | Text |
| `Najblizsa_Waznosc` | Nearest Expiration Date | YYYY-MM-DD format | Date |
| `Ostatnia_Aktualizacja` | Last Update Timestamp | Auto-updated by AI agent | Date |
| `Status` | Stock Status | "OK", "Niski", "Krytyczny", "Pusty" | Text |
| `Próg_Krytyczny` | Critical Threshold | Minimum quantity trigger | Number |
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

Pantry System → S03 Data Layer → WF101 Grocery Automation

    Consumption patterns feed predictive ordering
    Stock levels trigger automated shopping lists
    Budget constraints from S05 Finance enforced

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
- [Automation Spec: WF105](../../50_AUTOMATIONS/n8n/workflows/WF105__pantry-management.md)
- [Data Schema: S03 Pantry](../../20_SYSTEMS/S03_Data-Layer/Pantry-Schema.md)
- [Daily Operations SOP](../../30_SOPS/Home/Pantry-Management.md)
- [Troubleshooting Runbook](../../40_RUNBOOKS/Household/Pantry-System-Failure.md)
