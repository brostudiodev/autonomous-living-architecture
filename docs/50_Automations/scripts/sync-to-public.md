---
title: "Automation Spec: sync-to-public.py"
type: "automation_spec"
status: "active"
automation_id: "sync_to_public"
goal_id: "goal-g12"
owner: "Michal"
updated: "2026-03-31"
---

# 🤖 Automation Spec: sync-to-public.py

## Purpose
Enforces a "Secure by Design" publishing workflow. It synchronizes the private `autonomous-living` repository with the public `autonomous-living-architecture` repository while ensuring that 100% of sensitive data (IPs, tokens, passwords, PII) is either redacted or replaced with placeholders.

## Strictest Security Protocol
This script employs a **Zero-Trust Sanitization** model:
1.  **Exclusion:** Entire directories (scripts, infrastructure, .env) are blocked from the public repo.
2.  **Sanitization:** Known patterns (IPs, Emails, Tokens) are replaced with `{{PLACEHOLDER}}` tags.
3.  **Fail-Safe (NEW):** After sanitization, the script performs a "Deep Scan" for raw sensitive patterns (e.g., `192-dot-168-dot-x-dot-x`, raw JWTs, `passwd=`). **If any raw secret is found, the entire sync operation aborts immediately.**

## Triggers
- **Manual:** `python3 sync-to-public.py` (after major architectural updates).
- **Recommended:** Always run with `--dry-run` first to audit changes.

## Inputs
- **Private Repo:** `{{ROOT_LOCATION}}/autonomous-living`
- **Public Repo Target:** `{{ROOT_LOCATION}}/autonomous-living-architecture`
- **Regex Library:** Comprehensive patterns for IPs, Tokens, and Database credentials.

## Sanitization Categories
| Category | Action | Result |
|---|---|---|
| **Internal IPs** | Matches `192-dot-168-dot-x-dot-x, `10.x.x.x` | `{{INTERNAL_IP}}` |
| **Telegram** | Matches specific Bot Tokens & Chat IDs | `{{TELEGRAM_BOT_TOKEN}}` |
| **Cloud APIs** | Matches Gemini, Withings keys | `{{API_KEY}}` |
| **Passwords** | Matches `password: "{{GENERIC_API_SECRET}}"`, `passwd = "{{GENERIC_API_SECRET}}"` | `{{DB_PASSWORD}}` |
| **System Paths** | Matches `/home/{{USER}}/...` | `/home/{{USER}}/...` |
| **Identity** | Matches Owner Name, Emails | `{{EMAIL}}`, `Michal` |

## Error Handling & Fail-Safes
- **Uncommitted Changes:** Script warns and asks for confirmation if the private repo has uncommitted work (prevents syncing "dirty" or experimental states).
- **Post-Sanitization Verification:** If `verify_no_secrets()` returns `False`, the script calls `sys.exit(1)`. No files are written to the public repository if a breach is detected in memory.
- **Binary Files:** Binary files (images, etc.) are copied directly but never analyzed/sanitized (risk of corruption).

## Manual Verification (Mandatory)
Even with the Fail-Safe, the owner should:
1.  Navigate to the public repo.
2.  Run `git diff` to ensure no unexpected data is being pushed.
3.  Verify that placeholders like `{{INTERNAL_IP}}` are correctly applied.
