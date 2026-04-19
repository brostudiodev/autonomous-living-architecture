---
title: "SVC: Email Summary Agent"
type: "automation_spec"
status: "active"
automation_id: "SVC_Email-Summary-Agent"
goal_id: "goal-g10"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Email-Summary-Agent

## Purpose
Automated morning email triage service that fetches unread emails from Gmail (last 18+ hours), uses Google Gemini AI to analyze and prioritize them, and delivers a concise triage report to Telegram. Runs daily at 6:55 AM.

## Triggers
- **Schedule Trigger:** Daily at 6:55 AM (Schedule Trigger at 6:55, lines 223-240).
- **Webhook Trigger:** POST `/emails` endpoint (lines 33-48).
- **Manual Trigger:** When clicking 'Execute workflow' (lines 138-147).
- **Workflow Trigger:** Executed by another workflow (lines 7-17).

## Inputs
- **Gmail API:** Fetches unread emails received after 6:00 PM yesterday (receivedAfter filter, line 55).
- **LLM Prompt:** Structured prompt defining triage logic (line 151).

## Processing Logic
1. **Schedule Trigger / Webhook / Manual** (Multiple triggers, lines 6-240): Various entry points.
2. **Gmail: Get Recent Emails** (Gmail node, lines 50-73): Fetches unread emails from last 18+ hours.
3. **IF: Has Emails?** (IF node, lines 98-106): Branches based on email count.
4. **No Emails Found** (Code node, lines 20-31): Returns if 0 emails.
5. **Aggregate Emails** (Aggregate node, lines 108-120): Aggregates all email data.
6. **Combine e-mails into list** (Code node, lines 184-194): Formats emails for LLM - extracts From, Subject, Snippet, Labels, Received time.
7. **Google Gemini Chat Model** (LM Chat node, lines 164-181): Google Gemini LLM integration.
8. **Basic LLM Chain** (LLM Chain node, lines 149-162): Processes emails with LLM using prompt:
   - Priority levels: 🔴 URGENT, 🟡 HIGH, 🟢 MEDIUM, ⚪ LOW
   - Focus on work, automation projects, technical expertise
   - Mark personal/promotional as LOW
9. **Info telegram** (Telegram node, lines 196-220): Sends HTML-formatted message to chat ID `{{TELEGRAM_CHAT_ID}}`.
10. **Progress messages** (Execute Workflow nodes, lines 242-302): Notifies via SVC_Response-Dispatcher.

## Outputs
- **Telegram Message:** HTML-formatted triage report.
- **Example Output:** `📧 3 unread emails - 1 URGENT priority, 1 HIGH priority, 1 LOW priority

🔴 URGENT:
• [Subject] - from [Sender] - [Summary]

🟡 HIGH:
• [Subject] - from [Sender] - [Summary]`

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - n8n Execution engine.

### External Services
- Gmail API (via OAuth2 - "Autonomous Living Gmail").
- Google Gemini AI (PaLM API).
- Telegram Bot (AndrzejSmartBot credentials).

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No unread emails | IF node (count = 0) | Returns "📧 0 unread emails - Your inbox is clean!" | None |
| LLM failure | LLM node error | Workflow error logged | n8n Execution log |
| Telegram send fail | Telegram node error | Workflow error logged | n8n Execution log |

## Security Notes
- Hardcoded Telegram chat_id (`{{TELEGRAM_CHAT_ID}}`) - should use environment variable.
- Gmail credentials stored in n8n credential store.
- Google Gemini credentials stored in n8n credential store.
- Telegram credentials stored in n8n credential store.

## Manual Fallback
```bash
# Check Gmail via CLI (requires Gmail API setup)
curl -s "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=is:unread after:$(date -v-1d +%Y/%m/%d)" \
  -H "Authorization: Bearer $OAUTH_TOKEN"
```