---
title: "Automation Spec: G02 Content Pipeline Manager"
type: "automation_spec"
status: "active"
system_id: "S02"
goal_id: "goal-g02"
owner: "Michał"
updated: "2026-04-01"
review_cadence: "monthly"
---

# 🤖 Automation Spec: G02 Content Pipeline Manager

## 🎯 Purpose
Provide a centralized view of the "Automationbro" content pipeline by scanning LinkedIn and Substack idea baskets for drafts and ready-to-post content. Reduces the friction of finding what to execute next in the brand-building process.

## 📝 Scope
- **In Scope:** Scanning `LinkedIn Ideas Basket` and `Substack Notes Ideas Basket` folders; Identifying status based on tags (#draft, #ready) or file metadata; Formatting a summary table for the Daily Note.
- **Out of Scope:** Automatic posting to social platforms (handled by specialized sync scripts); LLM-based content generation.

## 🔄 Inputs/Outputs
- **Inputs:** Obsidian Markdown files in content folders.
- **Outputs:** `CONTENT_PIPELINE` report injected into the Obsidian Daily Note.

## 🛠️ Dependencies
- **Systems:** S02 Identity & Access (Brand), S10 Daily Goals Automation.
- **Services:** Local file system.
- **Credentials:** None (Obsidian Vault access).

## ⚙️ Logic & Procedure
1. **Directory Scan:** Iterates through files with `IDEA-` or `SN-` prefixes.
2. **Status Parsing:** 
   - **✅ READY:** If content contains `#ready`.
   - **📝 Draft:** If content contains `#draft` or `status: draft`.
   - **💡 Idea:** Default status.
3. **Injection:** `autonomous_daily_manager.py` calls the manager and injects the summary into the "📅 Content Pipeline" collapsible section.
4. **Trigger:** Automated via `G11_global_sync.py`.

## ⚠️ Failure Modes
| Scenario | Detection | Response |
|---|---|---|
| Directory Missing | FileNotFoundError in logs | Verify `Obsidian Vault/02_Projects/` path |
| No content found | Returns empty string (Normal) | No action needed |
| Permission Denied | PermissionError in logs | Check file system permissions for the script |

## 🔒 Security Notes
- **Secrets:** No sensitive data or API tokens are used in this script.

---
*System Hardening v5.4 - April 2026*
