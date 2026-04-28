---
title: "Telegram Receiver (G04) - DEPRECATED"
type: "automation_spec"
status: "deprecated"
owner: "Michał"
updated: "2026-04-08"
---

# ⚠️ DEPRECATION NOTICE
This script (`G04_telegram_bot.py`) has been **permanently disabled** and renamed to `.deprecated`. 

## Reason for Deprecation
To comply with **Mandate 12 (Architectural Separation)**, all incoming Telegram data processing has been migrated to **n8n Telegram Triggers (Webhooks)**. 

Running a Python-based polling bot created a **409 Conflict** with the n8n webhook, causing data loss and system instability.

## New Architecture
- **Inbound:** All Telegram messages are received by n8n via Webhooks.
- **Outbound:** Python scripts (like `G04_digital_twin_notifier.py`) continue to handle outgoing notifications.
- **Brain:** n8n performs the intelligence/routing and calls local Python scripts as executors if needed.

---
*Archived: 2026-04-08 | Transitioned to n8n-first intelligence.*
