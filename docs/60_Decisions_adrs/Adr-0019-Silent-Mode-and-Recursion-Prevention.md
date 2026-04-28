# Adr-0019: Silent Mode and Sync Recursion Prevention

## Status
Accepted

## Context
During the expansion of the G11 Meta-System, two major issues were identified:
1. **Telegram Notification Spam:** The global synchronization loop (G11_global_sync.py) executes many scripts in a loop. When scripts fail or trigger logic-based alerts (like MVD or Decision Requests), they send multiple Telegram notifications. This leads to 40+ redundant messages during a single sync cycle.
2. **Infinite Sync Recursion:** The `G11_self_healing_supervisor.py` was auditing all G11 scripts. Since `G11_obsidian_safe_sync.py` and `G11_global_sync.py` are part of the G11 series, the supervisor was inadvertently triggering the entire sync process during its audit, leading to an infinite loop of processes and system resource exhaustion.

## Decision
We will implement a system-wide `SILENT_MODE` and enforce `AUDIT_MODE` guardrails for all orchestration scripts.

### 1. Silent Mode Implementation
- **Environment Variable:** `SILENT_MODE="1"` will be injected by top-level orchestrators into the environment of all sub-processes.
- **Notifier Integration:** `G04_digital_twin_notifier.py` now checks this variable and skips sending messages to the Telegram API if it is active.
- **Log System Integration:** `G11_log_system.py` suppresses failure-triggered notifications when silent mode is active.

### 2. Recursion Prevention (Audit Guardrails)
- **Mandatory Check:** Every orchestration script (G11 series) MUST check for the `AUDIT_MODE="1"` environment variable at the start of its execution.
- **Early Exit:** If `AUDIT_MODE` is detected, the script must exit with status `0` immediately, bypassing its synchronization or heavy-lifting logic.

### 3. YAML Integrity Hardening
- **Idempotent Quoting:** `G11_fix_yaml_integrity.py` and `autonomous_daily_manager.py` were updated to ensure YAML values (specifically `sleep_start` and `sleep_end`) are only quoted once.
- **Stripping Logic:** Scripts now strip existing quotes before applying a new pair to prevent nested `""""""""` proliferation.

## Consequences
- **Positive:** Telegram notifications are now limited to meaningful, non-retried events.
- **Positive:** System stability improved; infinite process loops are blocked by audit guardrails.
- **Positive:** Daily Note YAML frontmatter is resilient against multiple update attempts.
- **Neutral:** Logs will still show "🤫 SILENT_MODE active" to allow debugging of suppressed messages.

## Date
2026-04-20
