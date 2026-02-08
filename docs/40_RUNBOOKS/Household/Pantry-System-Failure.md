---
title: "Runbook: Pantry System Troubleshooting"
type: "runbook"
severity: "low"
status: "active"
updated: "2026-02-07"
owner: "Michał"
---

# Runbook: Pantry System Troubleshooting

## Common Failure Scenarios

### Scenario 1: Telegram Bot Not Responding
**Symptoms:** Message sent, no reply within 10 seconds

**Quick Diagnosis:**
```bash
# Check n8n workflow status
curl -X GET "http://n8n.homelab.local:5678/api/v1/workflows/WF105"
# Expected: {"active": true}
```

**Resolution Steps:**

*   Verify n8n workflow is active
*   Check Telegram webhook registration
*   Test alternative channels (n8n chat, webhook)
*   If persistent: Restart n8n container

### Scenario 2: AI Misinterpretation

**Symptoms:** Bot updates wrong category or quantity

**Immediate Correction:**

Send: "popraw [kategoria] na [prawidłowa ilość]"

**Root Cause Analysis:**

*   Check Slownik sheet for missing synonyms
*   Add problematic phrases to Synonimy_AI column
*   Review AI system prompt for clarity

### Scenario 3: Google Sheets API Quota Exceeded

**Symptoms:** "⚠️ Błąd połączenia z bazą" responses

**Mitigation:**

*   Reduce update frequency temporarily
*   Batch multiple updates in single message
*   Check API quota usage in Google Cloud Console

**Long-term Solution:**

*   Implement request caching in workflow
*   Consider Google Workspace upgrade for higher quotas

## Prevention & Monitoring

*   Daily: Automated health check via cron
*   Weekly: Review execution logs for anomalies
*   Monthly: Validate data integrity and optimize synonyms

## Related Documentation
