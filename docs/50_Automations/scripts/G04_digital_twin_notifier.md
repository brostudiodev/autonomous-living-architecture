---
title: "G04_digital_twin_notifier: Unified Communication Layer"
type: "automation_spec"
status: "active"
automation_id: "G04_digital_twin_notifier"
goal_id: "goal-g04"
systems: ["S04"]
owner: "Michał"
updated: "2026-04-14"
---

# G04_digital_twin_notifier: Unified Communication Layer

## Purpose
Provides a centralized, reliable interface for all system scripts to communicate with Michał via Telegram. It abstracts away message splitting, error handling, and formatting modes.

## 🚀 Enhancements (Apr 14)
1. **Rich Error Diagnosis:** Updated to always print the full Telegram API response text on failure (e.g., HTTP 400). This enables instant diagnosis of formatting or character escaping issues.
2. **Atomic Message Splitting:** Ensures that messages exceeding 4096 characters are split into manageable segments to prevent silent drop-offs.
3. **Flexible Parse Modes:** Supports `HTML`, `Markdown`, or `None` (Plain Text) with clean payload construction and robust error handling for each mode.

## Triggers
- **Library Call:** Imported and called by almost all G-series scripts for status alerts, briefings, and decision prompts.

## Inputs
- **Text:** The message content to send.
- **Parse Mode:** `HTML` (default), `Markdown`, or `None`.
- **Reply Markup:** Optional JSON for inline buttons/keyboards.

## Processing Logic
1. **Credential Check:** Verifies `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` exist in the environment.
2. **Chunking:** If the message exceeds 4000 characters, it is split into a list of smaller messages to comply with Telegram's 4096-character limit.
3. **Transmission:** 
   - Iterates through message chunks.
   - Sends POST requests to `https://api.telegram.org/bot[TOKEN]/sendMessage`.
   - Checks HTTP status code. If not 200, prints the raw response text for debugging.
4. **Resilience:** Catches connection exceptions and logs them without crashing the calling script.

## Outputs
- **Telegram Broadcast:** One or more messages delivered to the user.
- **Console Log:** Success confirmation or detailed error reports.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### Credentials
- `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` via `.env`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Invalid Formatting | HTTP 400 + "Can't parse entities" | Prints exact error; returns False |
| Message Too Long | HTTP 400 + "Message too long" | Automatic splitting should prevent this |
| Network Timeout | requests.exceptions.Timeout | Catches, prints, and returns False |
