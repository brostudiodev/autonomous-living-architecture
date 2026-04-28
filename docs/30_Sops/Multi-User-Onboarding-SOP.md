---
title: "SOP: Family Member Onboarding (Multi-User)"
type: "sop"
status: "active"
owner: "Michał"
updated: "2026-04-02"
---

# Purpose
This SOP defines the process for adding a family member to the Autonomous Living ecosystem with restricted access levels.

# Scope
- **User Personas:** Partners, children, guests.
- **Access Levels:** Tier 1 (Household/Pantry), Tier 2 (Shared Calendar), Tier 3 (Full Admin - Owner Only).

# Onboarding Procedure

## 1. Bot Creation
1.  Create a new Telegram Bot via @BotFather (e.g., `[Name]HouseholdBot`).
2.  Add the API Token to n8n Credentials as `Telegram Partner Auth`.

## 2. Router Deployment
1.  Deploy a new router based on the `ROUTER_Partner_Hub.json` template.
2.  Update the **Authorization Node** with the specific Telegram User ID.
3.  Ensure the **Intent Classifier** is tuned to the specific domain (e.g., only `pantry` keywords).

## 3. Tool Filtering
1.  Configure the AI Agent node within the new router to use a restricted **System Prompt**.
2.  The prompt MUST explicitly list allowed domains and instruct the agent to refuse other requests.

# Safety & Isolation
- **No Shared Finance:** Partner bots MUST NOT have access to the `G05` (Finance) domain scripts.
- **No Private Notes:** Access to the `06_Brain` or `01_Daily_Notes` folders is strictly forbidden for non-admin users.
- **Unique Trace IDs:** Partner interactions are logged with a separate `partner_` prefix in the activity logs.

# Maintenance
- Audit user IDs monthly.
- Revoke access immediately if a device is lost.
