---
title: "SVC_Digital-Twin-Report: Strategic Summary Fetcher"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Report"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC_Digital-Twin-Report: Strategic Summary Fetcher

## Purpose
An n8n service workflow that fetches the latest auto-generated Strategic Progress Summary from the Digital Twin API for delivery to the user via Telegram or other dispatchers.

## Triggers
- **Execute Workflow Trigger:** Called by the Master Router or Intelligent Hub when the user requests a "strategic report" or "progress summary".

## Inputs
- **API Endpoint:** `http://{{INTERNAL_IP}}:5677/report?format=text`
- **Context:** User metadata (chat_id, language, source) passed from the caller.

## Processing Logic
1. **Normalize Router Input** (Code node, lines 21-31): Extracts `query`, `language` (auto-detected from Polish/English keywords), `chat_id`, `source_type`, and `username` from input.
2. **Fetch Twin Strategic Report** (HTTP Request node, line 47): GET request to `http://{{INTERNAL_IP}}:5677/report?format=text` - fetches strategic report from Digital Twin API.
3. **Format for Dispatcher** (Code node, lines 34-44): Extracts `response_text` from API body, adds metadata, language, timestamp, and formats JSON for dispatcher.

## Outputs
- **Structured JSON:** Contains `response_text` (the report) and `chat_id` for delivery.

## Dependencies
### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md)
- [G11 Strategic Summarizer](../../../scripts/G11_strategic_summarizer.py)

### External Services
- **Digital Twin API:** Must be online and accessible at the specified IP/Port.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| API Offline | HTTP Node Failure | Returns "⚠️ Service Offline" to user | n8n Error Workflow |
| Report Generation Error | 500 Internal Server Error | Returns detailed error if available | n8n Error Workflow |

## Monitoring
- **Success Metric:** Successful delivery of the monthly draft report.
