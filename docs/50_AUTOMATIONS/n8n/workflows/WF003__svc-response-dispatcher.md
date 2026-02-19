---
title: "WF003: SVC_Response-Dispatcher"
type: "automation_spec"
status: "active"
automation_id: "WF003__svc-response-dispatcher"
goal_id: "goal-g11"
systems: ["S04", "S10"]
owner: "Micha\u0142"
updated: "2026-02-13"
version: "2.0.0"
---

# WF003: SVC_Response-Dispatcher

## Purpose
Centralized response delivery service that routes formatted responses from Intelligence Hub services to the correct outbound channel (Telegram, Webhook, or Chat) with channel-specific formatting and error handling. Ensures consistent user experience across all interaction methods while isolating business logic services from delivery concerns.

## Architectural Role
**Service Type:** Infrastructure / Response Handler  
**Position:** Final delivery layer in Intelligence Hub architecture  
**Pattern:** Single responsibility service handling all outbound response routing  
**Dependencies:** Called by all domain services (Command Handler, Intelligence Processor, etc.)

## Triggers
- **Primary**: Execute Workflow calls from:
  - `ROUTER_Intelligence-Hub`
  - [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
  - `SVC_Intelligence-Processor`
  - Any service requiring response delivery
- **Type**: `executeWorkflowTrigger` (no external endpoints)
- **Frequency**: On-demand per service response

## Inputs

### Service Contract Schema
```json
{
  "_router": {
    "trigger_source": "telegram|webhook|chat",
    "user_id": "string",
    "chat_id": "number|null",
    "message_id": "number|null",
    "trace_id": "string",
    "timestamp": "ISO8601"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram|webhook|chat",
      "chat_id": "number|null"
    }
  },
  "response_text": "string",
  "response_data": {
    "success": "boolean",
    "service": "string",
    "execution_time_ms": "number"
  },
  "service": "string",
  "success": "boolean"
}
```

Required Fields

    `_router.trigger_source` OR `metadata.response_endpoint.type`
    `response_text` (human-readable message)

Optional Fields

    `response_data` (structured data for webhooks)
    `_router.chat_id` (for Telegram responses)
    All other router metadata (preserved for logging)

Processing Logic
Stage 1: Source Detection & Normalization

Node: Detect Source

```javascript
// Priority-based source detection
const source = input.metadata?.response_endpoint?.type ||
               input._router?.trigger_source ||
               'unknown';

// Comprehensive response text extraction
const responseText = input.response_text ||
                    input.text ||
                    input.output ||
                    input.chatResponse ||
                    'No response generated';

// Build normalized dispatch object
return {
  json: {
    ...input,
    _dispatch: {
      source: source,
      chat_id: chatId,
      response_text: responseText,
      response_data: input.response_data || input.structured_data || input
    }
  }
};
```

Stage 2: Channel Routing

Node: Route by Source (Switch)

| Condition | Output | Target Node |
|---|---|---|
| `_dispatch.source === "telegram"` | 0 | Send Telegram |
| `_dispatch.source === "webhook"` | 1 | Respond Webhook |
| `_dispatch.source === "chat"` | 2 | Chat Response |
| default | 3 | Unknown Source |

Stage 3: Channel-Specific Delivery
Telegram Path

Nodes: Send Telegram → Confirm Telegram

```json
// Telegram configuration
{
  "chatId": "={{ $json._dispatch.chat_id }}",
  "text": "={{ $json._dispatch.response_text }}",
  "additionalFields": {
    "parse_mode": "Markdown",
    "appendAttribution": false
  }
}
```

Webhook Path

Nodes: Respond Webhook → Confirm Webhook

```json
// Webhook response structure
{
  "success": true,
  "message": "response_text_here",
  "data": {response_data_object}
}
```

Chat Path (CRITICAL)

Node: Chat Response → END

```javascript
// CRITICAL: Must use 'text' field for n8n Chat UI
const input = $json;
const responseText = input._dispatch?.response_text || 
                    input.response_text || 
                    'Response completed successfully';

return {
  json: {
    text: responseText  // Exact format n8n Chat UI expects
  }
};
```

Critical Design Decisions
ADR-001: Chat Branch Isolation

Decision: Chat Response node has ZERO outgoing connections
Context: n8n Chat UI displays the final executed node's JSON output directly
Consequence: Any node after Chat Response overwrites the display format
Status: Active - Verified working solution

ADR-002: Multi-Level Source Detection

Decision: Three-tier fallback for source detection
Rationale: Different services may structure metadata differently
Implementation: `metadata.response_endpoint.type` → `_router.trigger_source` → 'unknown'
Status: Active

ADR-003: Response Text Fallback Chain

Decision: Multiple field names supported for response text
Context: Services return text in various field names (response_text, text, output)
Implementation: Comprehensive fallback chain prevents missing responses
Status: Active

Node Specifications
Node 1: Input from Main Workflow

Type: `executeWorkflowTrigger`
Purpose: Receive service responses for delivery

Node 2: Detect Source

Type: Code (Run Once for Each Item)
Purpose: Normalize routing metadata and extract response content
Key Logic: Source detection, text extraction, dispatch object creation

Node 3: Route by Source

Type: Switch
Conditions: 4 output paths based on `_dispatch.source`
Fallback: Unknown sources route to error logging

Node 4: Send Telegram

Type: Telegram
Credentials: Telegram (AndrzejSmartBot)
Configuration: Markdown parsing enabled, attribution disabled

Node 5: Respond Webhook

Type: Respond to Webhook
Format: JSON with success flag, message, and data fields

Node 6: Chat Response

Type: Code (Run Once for Each Item)
CRITICAL: No outgoing connections
Output: `{"text": "response_text"}` only

Node 7: Unknown Source (Fallback)

Type: Code
Purpose: Debug logging for unrecognized source types
Output: Error structure with full input data

Node 8-9: Confirm Telegram/Webhook

Type: Code
Purpose: Return dispatch confirmation metadata
Note: Chat intentionally has no confirmation node

Outputs
Telegram

    User Experience: Markdown-formatted message in Telegram chat
    Workflow Output: `{"dispatched": true, "source": "telegram", "timestamp": "..."}`

Webhook

    HTTP Response:

```json
{
  "success": true,
  "message": "Human readable response",
  "data": {structured_service_data}
}
```

    Workflow Output: `{"dispatched": true, "source": "webhook", "timestamp": "..."}`

Chat

    User Experience: Clean text display in n8n Chat UI
    Workflow Output: `{"text": "response_text"}` (final output)

Dependencies
Systems

    S04 Messaging & Interaction Layer
    S10 Daily Goals Automation

External Services

    Telegram Bot API: Message delivery via bot token: "{{API_SECRET}}" Webhook System: HTTP response handling
    n8n Chat System: UI display rendering

Credentials

    Telegram API: `XDROmr9jSLbz36Zf` (n8n credential store)
    Security: No secrets in workflow code

Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Unknown source type | `source === 'unknown'` | Log full input, return error | Console log |
| Missing `chat_id` (Telegram) | `chat_id === null` | Telegram API error | n8n execution error |
| Missing `response_text` | Fallback chain exhausted | Use default message | Silent fallback |
| Webhook timeout | HTTP response timeout | Built-in n8n retry | Execution error |
| Chat JSON display | User sees `{"text": "..."}` | Check node connections | Manual verification |

Monitoring
Success Metrics

    Telegram: Message sent without API error
    Webhook: HTTP 200 response returned
    Chat: User sees formatted text (not JSON object)

Alert Conditions

    Critical: Unknown source type detected (indicates metadata corruption)
    Warning: Default response text used (service missing `response_text`)
    Info: Dispatch confirmation logged (normal operation)

Observability

Execution Data Points:

    Source type detected
    Response text length
    Dispatch timestamp
    Channel-specific delivery confirmation

Testing Procedures
Test 1: Telegram Delivery

Input:

```json
{
  "_router": {"trigger_source": "telegram", "chat_id": 123456789},
  "response_text": "✅ Test message with *markdown*"
}
```

Expected: Telegram message with bold formatting

Test 2: Webhook Response

Input:

```json
{
  "_router": {"trigger_source": "webhook"},
  "response_text": "Success message",
  "response_data": {"command": "test", "success": true}
}
```

Expected: HTTP JSON response with structured data

Test 3: Chat Interface

Input:

```json
{
  "_router": {"trigger_source": "chat"},
  "response_text": "📚 Help text

Commands:
/start"
}
```

Expected: Clean formatted text in Chat UI (NOT JSON object)

Test 4: Fallback Chain

Input:

```json
{
  "_router": {"trigger_source": "telegram", "chat_id": 123456789},
  "text": "Alternative field name"
}
```

Expected: Message sent using fallback text extraction

Manual Fallback
If Dispatcher Fails Completely

Telegram:

```bash
# Manual Telegram API call
curl -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" 
  -d "chat_id=123456789" 
  -d "text=Manual response message"
```

Webhook:

```javascript
// Return response directly in calling service
return {
  json: {
    success: true,
    message: "Manual response",
    data: response_data
  }
};
```

Chat:

```javascript
// Return text format directly in calling service
return {
  json: {
    text: "Manual chat response"
  }
};
```

Troubleshooting Guide
Problem: Chat Shows JSON Instead of Text

Symptoms: `{"text": "message"}` displayed in Chat UI
Root Cause: Chat Response node has outgoing connections
Solution:

    Open SVC_Response-Dispatcher workflow
    Select Chat Response node
    Delete any outgoing connection lines
    Save and test with `/help` command

Problem: Telegram Message Not Delivered

Diagnosis Steps:

    Check execution log for Telegram node errors
    Verify `_dispatch.chat_id` is populated
    Confirm Telegram credentials are valid
    Test with manual API call

Problem: Webhook Returns Empty Response

Diagnosis Steps:

    Check `response_data` field in service output
    Verify webhook response node configuration
    Test with manual HTTP request
    Check n8n webhook response logs

Problem: Unknown Source Type Logged

Diagnosis Steps:

    Check service output includes `_router` metadata
    Verify `metadata.response_endpoint.type` is set
    Review source detection fallback chain
    Check execution data at "Detect Source" node

Integration Examples
From Command Handler

```json
// SVC_Command-Handler → SVC_Response-Dispatcher
{
  "_router": {
    "trigger_source": "telegram",
    "chat_id": 123456789,
    "trace_id": "trace_001"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": 123456789
    }
  },
  "service": "SVC_Command-Handler",
  "response_text": "✅ Command executed successfully",
  "response_data": {
    "command": "help",
    "execution_time_ms": 45,
    "success": true
  }
}
```

From Intelligence Processor

```json
// SVC_Intelligence-Processor → SVC_Response-Dispatcher
{
  "_router": {"trigger_source": "telegram", "chat_id": 123456789},
  "service": "SVC_Intelligence-Processor",
  "response_text": "✅ INTELLIGENCE PROCESSED
📊 File: note.md
🎯 Goals: [2, 4, 9]",
  "response_data": {
    "filename": "2026-02-13-captured-note",
    "github_url": "https://github.com/user/repo/blob/main/00_Inbox/note.md",
    "structured_data": {
      "power_goals": [2, 4, 9],
      "action_items": ["Review automation", "Update documentation"]
    }
  }
}
```

Version History
v2.0.0 (2026-02-13)

Breaking Changes:

    Chat response format changed from `chatResponse` to `text` field
    Removed Confirm Chat node (Chat branch now ends at formatter)

Improvements:

    Enhanced source detection with 3-level priority fallback
    Comprehensive response text extraction chain
    Better error logging for unknown sources

Bug Fixes:

    Fixed Chat UI JSON display issue
    Resolved execution mode error in Chat Response node

Related Documentation
Core Services

    [WF001: ROUTER_Intelligence-Hub](./WF001_Agent_Router.md)
    [WF002: SVC_Command-Handler](./WF002__svc-command-handler.md)
    [WF004: SVC_Intelligence-Processor](./WF004__intelligence-hub-input.md)
    [WF005: SVC_Input-Normalizer](./WF005__svc-input-normalizer.md)

Systems

    S04 Messaging & Interaction Layer
    S10 Daily Goals Automation

SOPs & Runbooks

    SOP: Service Deployment
    SOP: Intelligence Hub Debugging
    Runbook: Telegram API Failures
    Runbook: n8n Workflow Failures

Maintenance Notes
When Adding New Channel

    Add condition to Route by Source switch
    Create channel-specific formatting node
    Add confirmation node (if tracking needed)
    Update documentation and test procedures
    Add integration examples

Monthly Review Checklist

    All three channels tested end-to-end
    Chat UI displays clean text (not JSON)
    Telegram messages delivered with formatting
    Webhook responses return proper JSON structure
    Error logging captures unknown sources
    Credentials valid and not expired
    Documentation matches current implementation

Last Reviewed: 2026-02-13
Next Review: 2026-03-13
Service Status: Production Active
Critical Dependencies: Telegram Bot API, n8n Webhook System, n8n Chat UI