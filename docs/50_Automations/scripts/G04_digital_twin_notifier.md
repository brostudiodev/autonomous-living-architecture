---
title: "Automation Spec: G04_digital_twin_notifier.py"
type: "automation_spec"
status: "active"
created: "2026-03-05"
updated: "2026-03-16"
---

# 🤖 Automation Spec: G04_digital_twin_notifier.py

## 📝 Overview
**Purpose:** Centralized utility for sending notifications to the user via Telegram.
**Goal Alignment:** G04 Digital Twin (Proactive Interface).

## ⚡ Technical Details
- **Language:** Python
- **Databases:** None
- **Dependencies:** `requests`, `dotenv`, `html`, `os`
- **Configuration:** Requires `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` in `.env`.

## 🛠️ Logic Flow
1. **Initialize:** Loads credentials from `.env`.
2. **Chunking:** Automatically splits messages longer than 4096 characters to comply with Telegram API limits.
3. **Dispatch:** Sends POST requests to the Telegram Bot API `sendMessage` endpoint.
4. **Interactivity:** Supports optional `reply_markup` (JSON) to enable Inline Keyboards and buttons.

## 📤 Outputs
- **Telegram Message:** Delivered to the configured chat.

## ⚠️ Known Issues / Maintenance
- **HTML Escaping:** Ensure special characters in content are HTML-escaped if `parse_mode="HTML"` is used.

---
*Updated Q1 2026 to support interactive button payloads.*
