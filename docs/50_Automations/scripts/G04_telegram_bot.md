---
title: "Automation Spec: G04_telegram_bot.py"
type: "automation_spec"
status: "active"
created: "2026-03-16"
updated: "2026-03-16"
---

# 🤖 Automation Spec: G04_telegram_bot.py

## 📝 Overview
**Purpose:** A persistent background listener that processes interactive Telegram button clicks (approvals/denials) and updates the decision engine.
**Goal Alignment:** G04 Digital Twin (Interactive Hub), G11 Meta-System Integration (Closing the loop).

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Long-polling Telegram Bot API (`getUpdates`).
- **Databases:** PostgreSQL (`digital_twin_michal`)
- **Dependencies:** `requests`, `psycopg2`, `subprocess` (to trigger G11 executor).

## 🛠️ Logic Flow
1. **Poll Updates:** Continuously checks for new Telegram updates (Callback Queries and Messages).
2. **Handle Slash Commands:**
    - `/approve [ID]`: Instantly approves and executes a decision via the API.
    - `/deny [ID]`: Instantly denies a decision.
    - `/approve rebalance`: Triggers the proactive budget rebalancer execution.
    - `/reflect ...`: Logs daily mood/energy metrics.
3. **Handle Callback:**
    - Extracts `action` (approve/deny) and `req_id` from button clicks.
...
5. **UI Feedback:** Updates the original Telegram message to show the final result and removes the buttons.

## 📤 Outputs
- **Database Update:** Status change in `decision_requests`.
- **System Trigger:** Execution of approved actions (e.g., adding to shopping list).
- **Interactive UI:** Real-time feedback in Telegram.

## ⚠️ Known Issues / Maintenance
- **Persistence:** This script MUST run as a background service (e.g., via Docker or systemd).
- **Conflict Resolution:** If both Obsidian and Telegram are used to approve, the first one wins.

---
*Interactive decision authority enabled Q1 2026.*
