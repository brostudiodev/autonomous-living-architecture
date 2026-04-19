---
title: "SVC: Digital Twin API"
type: "n8n_workflow"
status: "active"
owner: "Michal"
goal_id: "goal-g04"
updated: "2026-04-16"
---

# SVC: Digital Twin API

## Purpose

Provides a bidirectional interface between n8n AI agents and the Digital Twin REST API. Allows AI agents to execute Digital Twin commands (status, vision, report, etc.) via a standardized workflow trigger.

## Scope

### In Scope
- Execution of Digital Twin API commands triggered by AI agents
- Routing of commands to appropriate API endpoints
- JSON payload transformation for Telegram compatibility

### Out of Scope
- Direct API management or monitoring
- Error recovery or retry logic
- Manual command execution (use Digital Twin API directly)

## Inputs/Outputs

### Trigger
- **Type:** Workflow execution trigger (from AI Agent)
- **Payload:**
  ```json
  {
    "action": "status|today|tomorrow|vision|report|audit|map|harvest|hydration|career",
    "chat_id": 123456789,
    "user_id": 123456789
  }
  ```

### Flow
1. **Trigger:** Receives execution request from AI Agent
2. **Route Action:** Switch node routes to appropriate API endpoint
3. **Call API:** HTTP Request to Digital Twin API (`http://{{INTERNAL_IP}}:5677/{action}`)
4. **Output:** Returns API response to calling agent

## Dependencies

### Systems
- [S04 Digital Twin](../20_Systems/S04_Digital-Twin/README.md)

### Infrastructure
- Digital Twin API running on port 5677
- Internal network access to `{{INTERNAL_IP}}:5677`

### Credentials
- None required (internal network call)

## Procedure

### Manual Execution
This workflow is triggered automatically by AI agents. To test manually:

1. Open n8n workflow editor
2. Click "Test workflow" on the trigger node
3. Send a test payload with action and chat_id

### Monitoring
- Check n8n execution logs for workflow runs
- Monitor Digital Twin API health at `/status` endpoint

## Failure Modes

| Scenario | Detection | Response |
|----------|----------|----------|
| Digital Twin API unreachable | HTTP 500/timeout | Check API service status |
| Invalid action parameter | HTTP 404 | Verify action value is valid |
| Network connectivity loss | Connection timeout | Verify internal network connectivity |

## Security Notes

- Internal network only - not exposed externally
- No credentials required
- Chat IDs are logged for audit purposes

## Owner + Review Cadence
- **Owner:** Michal
- **Review:** Monthly (during G11 system audit)
- **Last Updated:** 2026-04-16

## Related Documentation

- [Digital Twin API Documentation](../20_Systems/S04_Digital-Twin/README.md)
- [G04 Digital Twin Roadmap](../10_Goals/G04_Digital-Twin-Ecosystem/Roadmap.md)
- [Agentic Framework](../20_Systems/S08_Automation-Orchestrator/README.md)
