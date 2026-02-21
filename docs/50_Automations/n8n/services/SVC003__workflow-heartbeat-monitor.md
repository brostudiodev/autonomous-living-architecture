---
title: "SVC003: Workflow Heartbeat Monitor"
type: "automation_spec"
status: "active"
automation_id: "SVC003__workflow-heartbeat-monitor"
goal_id: "goal-g11"
systems: ["S01"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-18"
---

# SVC003: Workflow Heartbeat Monitor

## Purpose
Generic monitoring service that tracks n8n workflow health, detects failures/overdue executions, and sends alerts via Telegram, Email, or Webhook. Runs on a schedule to provide continuous observability of all critical workflows.

## Triggers
- **Schedule:** Every 60 minutes
- **Cron Expression:** `0 * * * *`

## Inputs

### Configuration (Set Node)
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `n8n_baseURL` | string | `http://{{INTERNAL_IP}}:5678` | n8n instance URL |
| `Telegram_ChatID` | string | `7689674321` | Your Telegram chat ID |
| `Alert_Email` | string | `{{EMAIL}}` | Email for alerts |
| `check_window_hours` | string | `1` | Window to check for failures |
| `send_healthy_summary` | string | `true` | Send notification even when healthy |

### Workflows to Monitor (Code Node)
```javascript
// DEFINE YOUR MONITORED WORKFLOWS HERE
const workflows = [
  { id: "hYym7cI6xSHidRqL", name: "Export Workflows to GitHub", expected_interval_hours: 168 },
  { id: "ir0VnzSKPpKkSzIM", name: "YouTube Summarizer 1", expected_interval_hours: 1 },
  // Add more workflows here
];
```

## Processing Logic

### 1. Fetch Workflows
- Call `GET /api/v1/workflows?limit=250`
- Get all active workflows from n8n

### 2. Fetch Executions
- Call `GET /api/v1/executions?limit=200`
- Get recent executions for all workflows

### 3. Match & Analyze
For each monitored workflow:
- Match by ID or name (fuzzy match)
- Check if active
- Get last execution status
- Calculate hours since last run

### 4. Status Logic
| Status | Condition |
|--------|-----------|
| `healthy` | Success within expected interval |
| `failed` | Error within check window |
| `overdue` | Success but exceeded expected interval |
| `stuck` | Running > 30 minutes |
| `inactive` | Workflow deactivated |
| `not_found` | Workflow ID not in n8n |
| `no_runs` | No executions found |

### 5. Build Report
- Group alerts by status
- Format Telegram message (Markdown)
- Format Email body (HTML table)
- Create webhook payload (JSON)

## Outputs

### Telegram Alert
```
🚨 *n8n Health Check Report*

📊 *Summary:* 2 issue(s) / 5 monitored
✅ Healthy: 3 | ⚠️ Alerts: 2

🔴 *FAILED* (1):
  • YouTube Summarizer [ir0VnzSKPpKkSzIM]
    _1 failure(s) in last 1h_

🟡 *OVERDUE* (1):
  • Export Workflows [hYym7cI6xSHidRqL]
    _170.5h since last run (expected every 168h)_
```

### Email Alert
HTML table with columns: Status, Workflow, ID, Details, Last Run

### Webhook Payload
```json
{
  "timestamp": "2026-02-18 12:00:00",
  "total_monitored": 5,
  "total_healthy": 3,
  "total_alerts": 2,
  "alerts": [...],
  "healthy_workflows": [...]
}
```

## Dependencies

### Systems
- [S01: Observability & Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)

### External Services
- n8n API (via n8n account credential)
- Telegram Bot API
- Gmail API

### Credentials
| Credential | ID | Purpose |
|------------|---|---------|
| n8n account | `6I7lyZLfxLb39xUu` | API access to n8n |
| Telegram (AndrzejAIBot) | `iUTfhBhZ5vUwjE9F` | Send Telegram alerts |
| Gmail account | `ZKOV4vsgAhk74S3u` | Send email alerts |

## Configuration

### Adding New Workflows to Monitor
Edit the `Workflows To Monitor` code node:

```javascript
const workflows = [
  { id: "WORKFLOW_ID", name: "Display Name", expected_interval_hours: 24 },
  // Add more...
];
```

**How to find workflow ID:**
- Open workflow in n8n
- Check URL: `.../workflow/WF123__name` or check API response

### Expected Interval Guidelines
| Workflow Type | Recommended Hours |
|--------------|-------------------|
| Hourly sync | 1-2 |
| Daily reports | 24 |
| Weekly exports | 168 |
| Monthly tasks | 720 |

## Error Handling

| Failure Scenario | Detection | Response | Alert |
|-----------------|-----------|----------|-------|
| n8n API unreachable | HTTP error | Skip check, log error | Next run |
| No executions data | Empty response | Mark as `no_runs` | Alert if unexpected |
| Invalid workflow ID | Not found in n8n | Mark as `not_found` | Alert |
| Telegram send fail | HTTP error | Log error | Retry next run |
| Email send fail | HTTP error | Log error | Retry next run |

## Monitoring

- **Success metric:** All monitored workflows return `healthy` status
- **Alert on:** Any non-healthy status
- **Check frequency:** Every 60 minutes

## Manual Fallback

If the monitor fails:

1. **Check n8n is running:**
   ```bash
   curl http://{{INTERNAL_IP}}:5678
   ```

2. **Check credentials:**
   - Verify n8n API credential has correct permissions
   - Test Telegram bot: send message via BotFather

3. **Manual workflow check:**
   - Open n8n UI
   - Check workflow execution history manually

4. **Test API directly:**
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     http://{{INTERNAL_IP}}:5678/api/v1/workflows
   ```

## Related Documentation

: Observability &- [S01 Monitoring](../../20_Systems/S01_Observability-Monitoring/README.md)
- [G11: Meta-System Integration & Optimization](../G11_Meta-System-Integration-Optimization/README.md)
- [Adr-0010: Hub and Spoke Integration](../../60_Decisions_adrs/Adr-0010-Hub-and-Spoke-Integration.md)

## Changelog

| Date | Version | Change |
|------|---------|--------|
| 2026-02-18 | 1.0.0 | Initial release |
