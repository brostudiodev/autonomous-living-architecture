---
title: "ROUTER: Partner Hub"
type: "n8n_workflow"
status: "active"
owner: "Michał"
goal_id: "goal-g03"
updated: "2026-04-16"
---

# ROUTER: Partner Hub

## Purpose

Restricted access Telegram bot for household partners (e.g., spouse) that limits interactions to pantry and household inventory queries only. Provides a safe way for non-technical household members to interact with the autonomous living system.

## Scope

### In Scope
- Partner Telegram bot webhook reception
- Authorization verification (Telegram ID check)
- Pantry/household command routing
- Access restriction enforcement

### Out of Scope
- Full system access (see ROUTER_Intelligent_Hub)
- Financial queries
- Health/medical information
- Career/productivity features

## Inputs/Outputs

### Trigger
- **Type:** Telegram Bot Webhook
- **Bot:** PartnerBot (separate from main AndrzejSmartBot)
- **Webhooks:** `partner-telegram-router`

### Authorized Users
- Configured via Telegram ID in workflow
- Currently restricted to single partner (configurable)

### Command Examples
```
/pantry - Show pantry inventory
/pantry low stock - Show items needing restock
/spizarnia Ile mam mleka? - Query specific item
/zakupy - Get shopping list
```

## Dependencies

### Sub-Workflows
| Workflow ID | Name | Purpose |
|-------------|------|---------|
| stwRKQes9U0ui7e6 | SVC_Input-Normalizer | Input standardization |
| bLHLw65krtyBRdUZ | SVC_AI-Agent-Interactive | AI processing with restrictions |

### Infrastructure
- Telegram Bot API (PartnerBot)
- SVC_Input-Normalizer workflow
- SVC_AI-Agent-Interactive workflow

### Credentials
- PartnerBot Telegram API credentials

## Procedure

### Execution Flow
1. **Receive Message:** Partner Telegram input
2. **Verify Authorization:** Check if Telegram ID matches configured partner
3. **Normalize Input:** SVC_Input-Normalizer standardizes
4. **Classify Intent:** Partner-specific classification (household vs restricted)
5. **Route:**
   - **Household Request:** AI Agent with system override (household only)
   - **Restricted Request:** Polite denial message
6. **Respond:** Telegram reply to partner

### Configuration

To add authorized partners:
1. Edit the "Is Authorized Partner?" condition
2. Update `WIFE_TELEGRAM_ID_HERE` with actual Telegram ID
3. Save and activate workflow

### System Override
The AI Agent receives this system message:
```
You are the Household Partner Assistant. You only have access to PANTRY and GROCERY tools. If the user asks for anything else (finance, career, health), politely explain that you are only managing the household inventory.
```

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Unauthorized user | Telegram ID mismatch | No response (secure by default) |
| Partner AI Agent timeout | 30s timeout | Send fallback message |
| Telegram API error | n8n error | Check bot credentials |

## Security Notes

- **Critical:** Telegram ID check prevents unauthorized access
- PartnerBot should use separate bot token from main system
- No financial or personal data exposed
- All restricted requests receive polite denial

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Quarterly (or when adding new partners)
- **Last Updated:** 2026-04-16

## Related Documentation

- [ROUTER: Intelligent Hub](./ROUTER_Intelligent_Hub.md)
- [SVC: AI Agent Interactive](./WF001_Agent_Router.md)
- [G03 Household Operations](../10_Goals/G03_Autonomous-Household-Operations/Roadmap.md)
- [Pantry Management](./WF105__pantry-management.md)
