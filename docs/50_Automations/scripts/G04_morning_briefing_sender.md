---
title: "G04_morning_briefing_sender: Daily Strategic Broadcast"
type: "automation_spec"
status: "active"
automation_id: "G04_morning_briefing_sender"
goal_id: "goal-g04"
systems: ["S04", "S10"]
owner: "Michał"
updated: "2026-04-28"
---

# G04_morning_briefing_sender: Daily Strategic Broadcast

## Purpose
Synthesizes the "Primary Directive" and current status from the Digital Twin Engine into a high-impact Telegram briefing. This ensures the user starts the day with total alignment on the North Star and immediate tactical wins.

## 🚀 Enhancements (Apr 14)
1. **HTML-Primary Delivery:** Updated to use `parse_mode="HTML"` to support the rich formatting (bolding, code blocks) used by the `DigitalTwinEngine`.
2. **Reliability Fallback:** Implemented a silent retry mechanism that falls back to `Plain Text` if HTML parsing fails at the Telegram API level.
3. **System Activity Integration:** Now records success/failure to the `system_activity_log` for systematic monitoring of broadcast reliability.

## Triggers
- **System Sync:** Part of the `G11_global_sync.py` morning pipeline (06:15).
- **Manual:** `python3 G04_morning_briefing_sender.py`

## Inputs
- **Digital Twin Engine:** Generates the `suggested_report` using latest metrics.
- **System Activity Log:** Checked to prevent duplicate briefings on the same day.

## Processing Logic
1. **Deduplication:** Checks `system_activity_log` for a `SUCCESS` entry for `MORNING_BRIEFING` or `G04_morning_briefing_sender` today.
2. **Synthesis:** Calls `DigitalTwinEngine.generate_suggested_report()` to build the briefing content.
3. **Broadcasting:** 
   - Attempts to send via Telegram with HTML formatting.
   - If `requests` raises an error (likely due to unescaped characters), it retries with `parse_mode=None` (Plain Text).
4. **Finalization:** Logs the success/failure status to the database.

## Outputs
- **Telegram Message:** Detailed morning briefing.
- **System Activity Log:** Success/Failure signal.

## Dependencies
### Systems
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)
- [G04_digital_twin_notifier.py](./G04_digital_twin_notifier.md)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Telegram API Error | HTTP 400 (Bad Request) | Automatic Plain Text fallback |
| API Token Missing | .env check | Log FAILURE to DB; Exit |
| Engine Crash | Exception caught | Log FAILURE with traceback; Exit |
