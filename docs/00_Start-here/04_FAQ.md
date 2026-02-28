---
title: "04: FAQ"
type: "guide"
status: "active"
owner: "Michal"
updated: "2026-02-28"
---

# ❓ Frequently Asked Questions (FAQ)

## 💡 Concepts & Philosophy

### What is the difference between "Automation" and "Autonomy"?
**Automation** is about performing a task (e.g., "Script X runs every hour"). **Autonomy** is about managing the entire lifecycle of a goal (e.g., "Goal G05 ensures my net worth increases by 5% without me touching a spreadsheet"). An autonomous system detects errors, adapts, and only alerts you when it's truly stuck.

### Do I need to be a developer to use this?
While the *engine* is built with Python and SQL, the *user interface* is designed for everyone. If you can use Google Sheets and Telegram, you can "drive" this system.

### Why use a "Digital Twin"?
Instead of checking 10 different apps (Withings, Bank, Calendar, etc.), the Digital Twin aggregates all that data into a single AI model. You talk to *one* thing that knows *everything* about your life status.

---

## 🛠 Technical Setup

### Why PostgreSQL? Isn't a spreadsheet enough?
Spreadsheets are great for entry, but they fail at "intelligence." A database allows for complex queries, cross-referencing (e.g., "How does my sleep affect my spending?"), and is the industry standard for reliable data storage.

### Why n8n instead of Zapier?
n8n is self-hosted and highly flexible. It allows for "low-code" visual workflows while giving me the power to inject custom JavaScript or Python where needed. Plus, your data stays in your homelab.

---

## 🔐 Privacy & Security

### Is my biometric and financial data safe?
Yes. Your "Single Source of Truth" is stored in a local PostgreSQL database in your homelab. I use Google Gemini for processing, but I only send it the minimal data required for a specific task—never your entire database history.

---

## 🎯 Productivity

### What is a "MINS"?
**MINS** stands for "Most Important Next Step." It is the one single task that moves the needle for a specific goal. Your Digital Twin identifies this every morning to keep you focused.

### What if I miss a daily sync?
Don't worry. The system is designed with "Self-Healing" in mind. The next time you run the sync, it will detect missing data points and attempt to backfill them from the source APIs (like Withings or Google Sheets).
