---
title: "SVC_Workflow-Health-Monitor"
type: "automation_spec"
status: "draft"
automation_id: "SVC__workflow-health-monitor"
goal_id: "goal-g11"
systems: ["S01"]
owner: "Michał"
updated: "2026-02-18"
---

> ⚠️ **DEPRECATED** - Use [SVC003__workflow-heartbeat-monitor.json](../services/SVC003__workflow-heartbeat-monitor.json) instead

# SVC_Workflow-Health-Monitor

## Metadata
- **Name:** SVC_Workflow-Health-Monitor
- **Type:** Service (Monitoring)
- **Trigger:** Cron - every 60 minutes
- **Purpose:** Monitor critical workflows and alert on failure/overdue

---

## Workflow Structure

### Node 1: Cron Trigger
```
Name: "Every 60 minutes"
Expression: 0 * * * *
```

### Node 2: Set Config (Static)
```
Name: "Workflows To Monitor"
JSON:
{
  "workflows": [
    {"id": "WF102", "name": "Budget Alerts", "expected_interval_hours": 12},
    {"id": "WF001", "name": "Morning Brief", "expected_interval_hours": 24},
    {"id": "WF013", "name": "Evening Planner", "expected_interval_hours": 24},
    {"id": "WF105", "name": "Pantry Management", "expected_interval_hours": 24}
  ]
}
```

### Node 3: HTTP Request - Get Workflows
```
Name: "List All Workflows"
Method: GET
URL: "http://n8n:5678/api/workflows"
Authentication: Basic Auth
User: {{$credentials.n8n_api_user}}
Password: {{$credentials.n8n_api_password}}
```

### Node 4: Function Item - Filter Monitored
```
Name: "Filter Monitored Workflows"
Code:
const workflows = $input.first().json.data;
const toMonitor = $("Workflows To Monitor").first().json.workflows;

const result = toMonitor.map(m => {
  const found = workflows.find(w => w.id === m.id || w.name.toLowerCase().includes(m.name.toLowerCase()));
  if (found) {
    return { ...m, n8n_id: found.id, active: found.active };
  }
  return { ...m, n8n_id: null, active: false, error: "Not found in n8n" };
});

return result.map(r => ({ json: r }));
```

### Node 5: HTTP Request - Get Last Execution
```
Name: "Get Last Execution"
Method: GET
URL: "http://n8n:5678/api/executions?workflowId={{$json.n8n_id}}&limit=1"
Authentication: Basic Auth (same as above)
```

### Node 6: Function Item - Check Health
```
Name: "Check Health Status"
Code:
const workflow = $input.first().json;
const executions = $("Get Last Execution").first().json.data;

const now = new Date();
const lastExecution = executions[0];
let status = "unknown";
let message = "";
let hoursSince = null;

if (!lastExecution) {
  status = "no_runs";
  message = `No executions found for ${workflow.name}`;
} else {
  const finishedAt = new Date(lastExecution.finishedAt);
  const startedAt = new Date(lastExecution.startedAt);
  hoursSince = (now - finishedAt) / (1000 * 60 * 60);
  
  if (!workflow.active) {
    status = "inactive";
    message = `${workflow.name} is deactivated`;
  } else if (lastExecution.status === "success") {
    if (hoursSince > workflow.expected_interval_hours) {
      status = "overdue";
      message = `${workflow.name} last ran ${hoursSince.toFixed(1)}h ago (expected: ${workflow.expected_interval_hours}h)`;
    } else {
      status = "healthy";
      message = `${workflow.name} OK - last run ${hoursSince.toFixed(1)}h ago`;
    }
  } else if (lastExecution.status === "error") {
    status = "failed";
    message = `${workflow.name} FAILED - ${lastExecution.errorMessage || "Unknown error"}`;
  } else if (lastExecution.status === "running") {
    status = "running";
    message = `${workflow.name} still running (started ${(now - startedAt)/(1000*60)}min ago)`;
  } else {
    status = "unknown_status";
    message = `${workflow.name} status: ${lastExecution.status}`;
  }
}

return { json: { ...workflow, status, message, hoursSince, last_execution_id: lastExecution?.id } };
```

### Node 7: Split In Batches - Process Each
```
Name: "Split to Items"
Batch Size: 1
```

### Node 8: IF - Check if Alert Needed
```
Name: "Alert Needed?"
Conditions:
{{$json.status}} != "healthy" AND {{$json.status}} != "unknown"
```

---

## ALERT PATH (True)

### Node 9: Telegram - Send Alert
```
Name: "Send Alert"
Operation: "Send Message"
Chat ID: {{$credentials.telegram_chat_id}}
Text:
🚨 *Workflow Health Alert*

*Status:* {{$json.status}}
*Workflow:* {{$json.name}}
*Message:* {{$json.message}}

_This is an automated alert from SVC_Workflow-Health-Monitor_
```

---

## CONTINUE PATH (False)

### Node 10: No Action
```
Name: "Healthy - Skip"
Just passes through
```

---

## Optional: Store History

### Node 11: HTTP Request - Store to Database
```
Name: "Store Health Record"
Method: POST
URL: "http://postgres:5432/health_logs"
(Or write to CSV/Spreadsheet)
Body:
{
  "timestamp": "{{$now}}",
  "workflow_id": "{{$json.id}}",
  "status": "{{$json.status}}",
  "hours_since": "{{$json.hoursSince}}"
}
```

---

## Credentials Needed
1. **n8n_api_user** / **n8n_api_password** - Basic auth for n8n API
2. **telegram_chat_id** - Your Telegram chat ID

## Environment Variables (optional)
- `N8N_URL` - Default: http://n8n:5678
- `ALERT_ON_INACTIVE` - Default: true

## How to Add New Workflows
Simply add to the config JSON in Node 2:
```json
{"id": "WF_XXX", "name": "New Workflow", "expected_interval_hours": 24}
```

## Next Steps
1. Rebuild this in n8n
2. Add your actual workflow IDs
3. Test with a failing workflow
4. Deploy and monitor
