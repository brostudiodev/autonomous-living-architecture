---
title: "SOP: Pantry Inventory Update"
type: "sop"
status: "active"
owner: "Michał"
goal_id: "goal-g03"
updated: "2026-03-26"
---

# SOP: Pantry Inventory Update

## Purpose
Keep pantry inventory accurate through natural language commands via Telegram.

## Procedure

### Adding Items
1. Send Telegram message: "Dodaj mleko 2l" (Add milk 2l)
2. AI Agent parses intent and updates Google Sheets
3. System syncs to PostgreSQL database

### Removing Items (Consumption)
1. Send Telegram message: "Zużyłem mleko" (Used milk)
2. AI Agent decreases quantity in inventory

### Checking Stock
1. Send Telegram message: "Stan spiżarni" (Pantry status)
2. System returns current inventory levels

## Automated Sync
- Google Sheets ↔ PostgreSQL sync runs every 15 minutes
- Low stock alerts sent when quantity drops below reorder point
- Expiration warnings sent 3 days before expiry

## Related Documentation
- [G03 Autonomous Household Operations](../10_Goals/G03_Autonomous-Household-Operations/README.md)
- [PROJ Inventory Management Workflow](../50_Automations/n8n/services/PROJ_Inventory-Management.md)

---
*Owner: Michał*
*Review Cadence: Monthly*
