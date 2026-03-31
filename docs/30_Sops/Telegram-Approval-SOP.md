---
title: "SOP: Telegram Approval System"
type: "sop"
status: "active"
goal_id: "goal-g11"
owner: "Michal"
updated: "2026-03-25"
---

# SOP: Telegram Approval System

## Purpose
This SOP defines the process for reviewing and acting upon autonomous decision requests sent via the Digital Twin Telegram bot.

## Scope
- Financial categorization and rebalancing.
- Household procurement (pantry).
- Productivity schedule adjustments.
- Health workout modifications.

## Procedure

### 1. Receiving a Request
When the system identifies a situation requiring human intervention, it sends a Telegram message with:
- **Decision ID:** Unique identifier (e.g., #45).
- **Domain:** The area of life (FINANCE, HOUSEHOLD, etc.).
- **Summary:** The proposed action.
- **Payload:** Technical details (amount, items, reasons).

### 2. Decision Matrix
| Action | Response | Result |
|---|---|---|
| **Approve** | Click "✅ Approve" OR type `/approve [ID]` | System executes the action immediately. |
| **Deny** | Click "❌ Deny" OR type `/deny [ID]` | System logs the rejection and cancels the action. |
| **Discuss** | Reply to the message | Gemini AI assistant will explain the reasoning or take alternative input. |

### 3. Execution
Upon approval, the `G11_decision_handler.py` is triggered to:
- Update Google Sheets (Finance).
- Add items to Google Tasks (Shopping).
- Modify the Obsidian Daily Note (Schedule).

## Error Handling
- **Button not working:** Check if the `digital-twin-api` container is running.
- **Message not sent:** Verify `G11_approval_prompter.py` is running in the global sync.

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (verify autonomy rate)
