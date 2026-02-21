---
title: "SOP: Daily Pantry Management"
type: "sop"
status: "active"
frequency: "daily"
automation: "WF105"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# SOP: Daily Pantry Management

## Purpose
Maintain accurate household inventory through natural language interaction with AI agent, 
enabling predictive restocking and consumption pattern analysis.

## Daily Interaction Patterns

### Morning Review (2 minutes)

Send: /inventory Review: Critical stock levels (🔴 items) Action: Add to mental shopping list


### Evening Logging (3 minutes)
**After cooking/consumption:**

Examples: "zużyliśmy 2 jajka na śniadanie" "kupiliśmy 3 paczki makaronu w Biedronce" "otworzyliśmy nowy tuńczyk ważny do 2026-08-20"


### Weekly Validation (10 minutes)
**Every Sunday evening:**
1. Physical count of top 10 categories
2. Correct any discrepancies via Telegram
3. Review consumption patterns

## AI Interaction Best Practices

**Clear Intent Communication:**
- ✅ "kupiliśmy 2 mleka" (clear quantity + action)
- ❌ "mamy mleko" (ambiguous - how much?)

**Error Correction:**
- If AI misinterprets: "nie, odejmij 2 mleka" (immediate correction)
- AI has conversation memory and can self-correct

**Unit Specification:**
- AI uses defaults from Slownik sheet
- Override when needed: "3 litry mleka" vs "3 kartony mleka"

## Quality Assurance
- **Daily:** Verify bot responses match intent
- **Weekly:** Cross-check physical inventory vs. system
- **Monthly:** Review Slownik for duplicate categories

## Related Documentation
- [Pantry Management System](../../10_Goals/G03_Autonomous-Household-Operations/Pantry-Management-System.md)
- [Automation: WF105](../../50_Automations/n8n/workflows/WF105__pantry-management.md)
- [Troubleshooting Runbook](../../40_Runbooks/Household/Pantry-System-Failure.md)
