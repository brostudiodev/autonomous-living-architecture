# Adr-0018: Standardized Timeouts and Syntax Hardening

## Status
Accepted

## Context
As the Autonomous Living ecosystem grew to 150+ scripts, several issues emerged:
1. **Hanging Processes:** Scripts without timeouts would hang indefinitely on flaky DB connections or slow API responses, blocking the global sync loop.
2. **Inconsistent Timeouts:** Different scripts used different timeouts (2s, 5s, 15s), leading to unpredictable failure patterns.
3. **Syntax Fragility:** A previous automated update introduced a widespread syntax error `subprocess.run((...` (extra opening parenthesis), causing silent failures in several core scripts (G04, G05, G09, G12).

## Decision
We will implement a system-wide "Standardized Timeout" policy and perform a surgical syntax hardening sweep.

### 1. Timeout Standards
| Component | Standard Timeout | Implementation |
|-----------|-----------------|----------------|
| **Database (PostgreSQL)** | **3 seconds** | `connect_timeout=3` in `db_config.py` and direct `psycopg2.connect` calls. |
| **HTTP Requests** | **10 seconds** | `timeout=10` for all `requests.get/post` calls (unless specialized like LLMs). |
| **Subprocesses (Standard)** | **30 seconds** | Default for individual scripts (G11_self_healing audit). |
| **Subprocesses (Consumers)** | **300 seconds** | For complex orchestration consumers (G11_global_sync). |
| **Orchestration Wrapper** | **1800 seconds** | For top-level wrappers (G11_obsidian_safe_sync). |

### 2. Implementation Rules
- **Centralized Config:** `scripts/db_config.py` is the source of truth for DB connection defaults.
- **Explicit Wrappers:** Use `scripts/utils/timeout_helpers.py` for new scripts, but keep existing G-series scripts explicit and readable.
- **Hierarchical Timeouts:** Orchestrators MUST have timeouts larger than the sum of their children (or significantly larger for parallel execution).
- **Syntax Integrity:** Ensure all `subprocess.run` calls use balanced parentheses and proper argument passing.

## Consequences
- **Positive:** Improved system reliability; the global sync loop is now resilient against single-component hangs.
- **Positive:** All scripts pass `py_compile` checks.
- **Neutral:** Faster failure detection (3s vs 5s+) means logs will fill faster during outages, but provides quicker feedback for self-healing.
- **Negative:** Highly specialized tasks (e.g., large DB dumps or LLM calls) require manual overrides of these defaults.

## Date
2026-04-18
