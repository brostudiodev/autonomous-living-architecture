---
title: "WF002: SVC_Command-Handler"
type: "automation_spec"
status: "active"
automation_id: "WF002__svc-command-handler"
goal_id: "goal-g11"
systems: ["S04", "S10"]
owner: "Micha\u0142"
updated: "2026-02-13"
version: "1.0.0"
---

# WF002: SVC_Command-Handler

## Purpose
Centralized command orchestration service that processes all `/command` requests from the Intelligence Hub router. Implements a two-tier architecture: handles simple system commands (`/start`, `/help`, `/status`) with inline responses for optimal performance, and delegates complex domain commands (`/inventory`, `/training`, `/finance`) to specialized sub-services. Ensures consistent command parsing, validation, and response formatting across all interaction channels while maintaining clean separation between orchestration and domain logic.

## Architectural Role
**Service Type:** Domain Orchestrator / Command Processor  
**Position:** Business logic layer in Intelligence Hub architecture  
**Pattern:** Two-Level Service Hierarchy (Simple Inline + Complex Delegation)  
**Dependencies:** Called by `ROUTER_Intelligence-Hub`, delegates to 5 domain-specific services

## Triggers
- **Primary**: Execute Workflow call from `ROUTER_Intelligence-Hub`
- **Condition**: Router's Stage 4 intent classification returns `intent.primary === "command"`
- **Type**: `executeWorkflowTrigger` (no external endpoints)
- **Frequency**: On-demand per user command
- **Mode**: Always `waitForSubWorkflow: true` (synchronous execution)

## Inputs

### Service Contract Schema
```json
{
  "_router": {
    "trigger_source": "telegram|webhook|chat",
    "user_id": "string",
    "username": "string", 
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
  "intent": {
    "primary": "command",
    "secondary": "system_command|intelligence_activator",
    "confidence": 1.0,
    "entities": {
      "command": "string",
      "args": "string"
    }
  },
  "input": {
    "format": "text",
    "raw_content": "string"
  }
}
```

Required Fields

    `_router.trigger_source` (for response routing)
    `_router.timestamp` (for execution time calculation)
    `intent.entities.command` (command name without leading slash)
    `metadata.response_endpoint` (for response delivery)

Optional Fields

    `intent.entities.args` (command arguments, defaults to empty string)
    `_router.chat_id` (required for Telegram responses)

Processing Logic
Stage 1: Command Extraction & Validation

Node: Extract & Validate Command

Validation Logic:

```javascript
const input = $input.first().json;

// Critical validation checks
if (!input._router) {
  throw new Error('Missing _router metadata - cannot route response');
}

if (!input.intent?.entities?.command) {
  throw new Error('Missing command in intent.entities - malformed request');
}

// Extract and normalize command
const command = input.intent.entities.command.toLowerCase();
const args = (input.intent.entities.args || '').trim();
```

Command Classification:

```javascript
// Performance-optimized command categorization
const simpleCommands = ['start', 'help', 'status'];
const complexCommands = {
  inventory: ['inventory', 'pantry', 'spizarnia', 'magazyn', 'zapasy'],
  training: ['training', 'trening', 'hit', 'workout', 'cwiczenia'],
  finance: ['finance', 'finanse', 'budget', 'bud\u017cet', 'budzet'],
  planning: ['plan', 'evening'],
  goals: ['goals', 'todo', 'list', 'goal'],
  intelligence: ['intel']
};

let commandType = 'unknown';
let complexCategory = null;

if (simpleCommands.includes(command)) {
  commandType = 'simple';
} else {
  for (const [category, commands] of Object.entries(complexCommands)) {
    if (commands.includes(command)) {
      commandType = 'complex';
      complexCategory = category;
      break;
    }
  }
}

return {
  json: {
    ...input,
    _command: {
      name: command,
      args: args,
      type: commandType,
      category: complexCategory,
      original_text: input.input?.raw_content || `/${command} ${args}`.trim()
    }
  }
};
```

Stage 2: Complexity-Based Routing

Node: Route by Complexity (Switch)

| Condition | Output | Target | Performance Rationale |
|---|---|---|---|
| `_command.type === "simple"` | 0 | Route Simple Commands | <50ms inline processing |
| `_command.type === "complex"` | 1 | Route Complex Commands | Delegate to specialists |
| default | 2 | Cmd: Unknown Simple | Error handling |

Stage 3A: Simple Command Processing

Node: Route Simple Commands (Switch)
Command Implementations
`/start` Command

```javascript
const data = $input.first().json;

return {
  json: {
    ...data,
    response_text: '\U0001f44b Welcome to your Second Brain Bot!

' +
                   'Send me:
' +
                   '\u2022 YouTube links
' +
                   '\u2022 Article URLs
' +
                   '\u2022 Voice notes
' +
                   '\u2022 Text (prefix with note:, task:, idea:)
' +
                   '\u2022 Documents/PDFs
' +
                   '\u2022 Photos

' +
                   'Type /help for more info.',
    execution_time_ms: Date.now() - new Date(data._router?.timestamp || Date.now()).getTime()
  }
};
```

`/help` Command

```javascript
const data = $input.first().json;

return {
  json: {
    ...data,
    response_text: `\U0001f4da *Commands:*

*System:*
/start - Welcome message
/status - System status
/goals - Show Power Goals
/help - This help

*Planning:*
/plan - Evening planning
/evening - Evening planning

*Intelligence:*
/intel - Intelligence activator

*Inventory:*
/inventory [query] - Check pantry stock
/pantry [query] - Check pantry stock
/spizarnia [query] - Check pantry stock
/magazyn [query] - Check pantry stock
/zapasy [query] - Check pantry stock

*Training:*
/training [query] - Training intelligence
/trening [query] - Training intelligence
/hit - HIT workout info
/workout - Workout info

*Finance:*
/finance - Budget intelligence
/finanse - Budget intelligence
/budget - Budget intelligence

*Examples:*
`\/inventory` - show all items
`\/inventory Ile mam mleka?`
`\/spizarnia Co kupi\u0107?`
`\/pantry low stock items`

*Prefixes:*
\u2022 note: - Save a note
\u2022 task: - Create a task
\u2022 idea: - Capture an idea

Or just send content to capture!`,
    execution_time_ms: Date.now() - new Date(data._router?.timestamp || Date.now()).getTime()
  }
};
```

`/status` Command

```javascript
const data = $input.first().json;
const now = new Date();

return {
  json: {
    ...data,
    response_text: `\u2705 All systems operational.

\U0001f916 Router: Active
\U0001f4dd Capture: Ready
\U0001f3af Goals: Loaded
\u23f0 Time: ${now.toISOString().slice(0, 16).replace('T', ' ')} UTC`,
    execution_time_ms: Date.now() - new Date(data._router?.timestamp || Date.now()).getTime()
  }
};
```

Stage 3B: Complex Command Processing

Node: Route Complex Commands (Switch)
Domain Service Delegation
Inventory Commands

Aliases: `/inventory`, `/pantry`, `/spizarnia`, `/magazyn`, `/zapasy`
Processing: Prep: Inventory Query → Call: Inventory Service
Target: PROJ_Inventory Management (oi_WvlDIOgFHExCJgFNuJ)

Query Preparation Logic:

```javascript
const data = $input.first().json;
const args = data._command?.args || '';
const query = args.trim() || 'Poka\u017c aktualny stan magazynu';

return {
  json: {
    query: query,
    command: data._command?.name,
    chat_id: data.metadata?.response_endpoint?.chat_id || data._router?.chat_id,
    user_id: data._router?.user_id,
    username: data._router?.username,
    source_type: data.metadata?.response_endpoint?.type || data._router?.trigger_source,
    _router: data._router,
    metadata: data.metadata
  }
};
```

Other Complex Commands

    Training: `/training`, `/trening`, `/hit`, `/workout`, `/cwiczenia` → PROJ_Training-Intelligence-System
    Finance: `/finance`, `/finanse`, `/budget`, `/bud\u017cet`, `/budzet` → PROJ_Personal-Budget-Intelligence-System
    Planning: `/plan`, `/evening` → SVC_Github-Autonomous_Evening_Planner
    Goals: `/goals`, `/todo`, `/list`, `/goal` → SVC_GitHub-Todo-List-Extractor
    Intelligence: `/intel` → HTTP POST to intelligence activator webhook (legacy)

Stage 4: Response Standardization

Node: Standardize Service Response

Critical Function: Normalizes all command outputs for SVC_Response-Dispatcher compatibility

```javascript
const data = $input.first().json;

// CRITICAL: Preserve routing metadata (never lose this)
const router = data._router || {
  trigger_source: 'unknown',
  user_id: 'unknown',
  timestamp: new Date().toISOString()
};

const metadata = data.metadata || {
  response_endpoint: {
    type: router.trigger_source || 'unknown',
    chat_id: router.chat_id || null
  }
};

// Normalize response text with comprehensive fallbacks
const responseText = data.response_text || 
                    data.text || 
                    data.message || 
                    data.result || 
                    '\u2705 Command executed successfully.';

// Calculate execution time with error handling
let executionTime = data.execution_time_ms;
if (!executionTime && router.timestamp) {
  try {
    executionTime = Date.now() - new Date(router.timestamp).getTime();
  } catch (e) {
    executionTime = 0;
  }
} else if (!executionTime) {
  executionTime = 0;
}

const cmd = data._command || {};

// Build standardized response for dispatcher
return {
  json: {
    // ESSENTIAL: Router metadata for dispatcher routing decisions
    _router: router,
    metadata: metadata,
    
    // Service identification
    service: 'SVC_Command-Handler',
    success: data.success !== false,
    
    // PRIMARY: Human-readable response (used by Chat and Telegram)
    response_text: responseText,
    
    // STRUCTURED: Data for webhook/API responses
    response_data: {
      command: cmd.name || 'unknown',
      args: cmd.args || '',
      type: cmd.type || 'unknown',
      category: cmd.category || null,
      execution_time_ms: executionTime,
      success: data.success !== false
    },
    
    // MONITORING: Service-level metadata
    _service_result: {
      service: 'SVC_Command-Handler',
      success: data.success !== false,
      command_type: cmd.type || 'unknown',
      category: cmd.category || null,
      processed_at: new Date().toISOString()
    }
  }
};
```

Node Specifications
Node 1: Workflow Trigger

Type: `executeWorkflowTrigger`
Purpose: Receive command requests from router

Node 2: Extract & Validate Command

Type: Code (Run Once for Each Item)
Purpose: Parse, validate, and classify commands
Error Handling: Throws on missing required fields
Output: Enriches data with `_command` classification object

Node 3: Route by Complexity

Type: Switch
Conditions: 3 outputs (simple, complex, unknown)
Purpose: Performance optimization via routing strategy

Node 4: Route Simple Commands

Type: Switch
Conditions: 4 outputs (start, help, status, unknown)
Purpose: Fast inline response generation

Node 5-7: Simple Command Handlers

Type: Code (Run Once for Each Item)
Performance: <50ms execution time
Output: Static response text with execution timing

Node 8: Route Complex Commands

Type: Switch
Conditions: 7 outputs for domain categories
Purpose: Delegate to specialized services

Node 9: Prep: Inventory Query

Type: Code (Run Once for Each Item)
Purpose: Transform command args into inventory service format
Special Handling: Provides default query for empty args

Node 10-14: Domain Service Calls

Type: Execute Workflow
Configuration: `waitForSubWorkflow: true`
Purpose: Synchronous delegation to specialized services

Node 15: Standardize Service Response

Type: Code (Run Once for Each Item)
Purpose: Normalize all outputs for dispatcher compatibility
Critical: Preserves `_router` and `metadata` structures

Outputs
Service Response Contract

```json
{
  "_router": {
    "trigger_source": "telegram|webhook|chat",
    "user_id": "string",
    "chat_id": "number|null",
    "trace_id": "string",
    "timestamp": "ISO8601"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram|webhook|chat", 
      "chat_id": "number|null"
    }
  },
  "service": "SVC_Command-Handler",
  "success": true,
  "response_text": "Human-readable command result",
  "response_data": {
    "command": "help",
    "args": "",
    "type": "simple",
    "category": null,
    "execution_time_ms": 45,
    "success": true
  },
  "_service_result": {
    "service": "SVC_Command-Handler",
    "success": true,
    "command_type": "simple",
    "category": null,
    "processed_at": "2026-02-13T18:24:51.644Z"
  }
}
```

Performance Characteristics

    Simple Commands: 20-50ms execution time
    Complex Commands: 500ms-30s (depends on sub-service)
    Error Responses: <20ms execution time

Dependencies
Systems

    S04 Messaging & Interaction Layer
    S10 Daily Goals Automation

Called Services (Sub-Workflows)

    PROJ_Inventory Management (oi_WvlDIOgFHExCJgFNuJ)
    PROJ_Training-Intelligence-System (ObclRsvXi3JJglr_Kw_33)
    PROJ_Personal-Budget-Intelligence-System (IKOjl4PPD97oB2k1)
    SVC_Github-Autonomous_Evening_Planner (l2GqBHBpFz0VF5LN)
    SVC_GitHub-Todo-List-Extractor (XXPi08S8CHeszG2w)

External Services

    Intelligence Activator: HTTP webhook endpoint (legacy integration)

Credentials

    None: All credentials managed by sub-services
    Security: No secrets stored in this orchestrator

Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Missing `_router` metadata | Validation check fails | Throw error, halt execution | Execution error log |
| Missing command entity | Validation check fails | Throw error, halt execution | Execution error log |
| Unknown simple command | Not in command list | "Unknown command" message | Silent (expected case) |
| Unknown complex command | Not in category map | "Unknown command" message | Silent (expected case) |
| Sub-service timeout | Execute Workflow timeout | Sub-service error propagated | Sub-service logs |
| Sub-service error | Sub-service returns error | Error response to user | Sub-service logs |
| Missing `response_text` | Fallback chain exhausted | Use default success message | Silent fallback |
| Execution time calc error | Date parsing fails | Set to 0 | Console log |

Monitoring
Success Metrics

    Simple Commands: Response generated in <50ms
    Complex Commands: Sub-service called successfully
    All Commands: Standardized output structure maintained

Alert Conditions

    Critical: Validation errors (missing `_router` or command)
    Warning: Unknown command frequency spike (may indicate new feature requests)
    Info: Sub-service delegation events (normal operation)

Observability

Key Metrics:

    Command type distribution (simple vs complex)
    Command category popularity (inventory, training, etc.)
    Average execution time by command type
    Sub-service delegation success rate

Testing Procedures
Test 1: Simple Command - `/help`

Input:

```json
{
  "_router": {
    "trigger_source": "telegram",
    "chat_id": 123456789,
    "timestamp": "2026-02-13T18:00:00.000Z"
  },
  "intent": {
    "primary": "command",
    "entities": {
      "command": "help",
      "args": ""
    }
  }
}
```

Expected: Multi-section help text, execution time <50ms

Test 2: Complex Command - `/inventory` with args

Input:

```json
{
  "_router": {
    "trigger_source": "chat",
    "timestamp": "2026-02-13T18:00:00.000Z"
  },
  "intent": {
    "primary": "command", 
    "entities": {
      "command": "inventory",
      "args": "Ile mam mleka?"
    }
  }
}
```

Expected: Inventory service called with Polish query, response includes item data

Test 3: Polish Command Alias

Input:

```json
{
  "intent": {
    "entities": {
      "command": "spizarnia",
      "args": "Co kupi\u0107?"
    }
  }
}
```

Expected: Routed to inventory category, query processed correctly

Test 4: Unknown Command

Input:

```json
{
  "intent": {
    "entities": {
      "command": "nonexistent",
      "args": ""
    }
  }
}
```

Expected: Error message: `\u2753 Unknown command: /nonexistent

Type /help for available commands.`

Manual Fallback
If Command Handler Fails Completely

Option 1: Router-Level Bypass

```javascript
// Temporary direct implementation in router
switch(command) {
  case 'help':
    return { json: { response_text: "\U0001f4da Commands:
/start - Welcome
..." } };
  case 'inventory':
    // Direct sub-service call
    break;
}
```

Option 2: Direct Sub-Service Execution

```bash
# Manual workflow execution
curl -X POST "https://n8n.domain/webhook/inventory" 
  -d '{"query": "status check"}'
```

Troubleshooting Guide
Problem: "Missing `_router` metadata" Error

Symptoms: Execution fails at Extract & Validate Command node
Root Cause: Router not passing metadata correctly

Diagnosis Steps:

    Check router's Stage 4 output includes `_router` object
    Verify `SVC_Input-Normalizer` preserves metadata structure
    Check `SVC_Format-Detector` doesn't overwrite metadata
    Test router with manual execution

Solution: Fix metadata preservation in upstream services

Problem: Unknown Command Not Recognized

Symptoms: Valid command shows "unknown command" error
Root Cause: Command not in classification maps

Diagnosis Steps:

    Check command spelling in user input
    Verify command exists in `simpleCommands` or `complexCommands`
    Check for typos in command aliases
    Review case sensitivity handling

Solution:

    Add command to appropriate classification list
    Update help text to include new command
    Test with all supported aliases
    Deploy updated workflow

Problem: Sub-Service Not Responding

Symptoms: Complex command times out or returns error

Diagnosis Steps:

    Check sub-service workflow is active and enabled
    Verify workflow ID is correct in Execute Workflow node
    Test sub-service with manual execution
    Check sub-service execution logs for errors
    Verify sub-service credentials are valid

Solution:

    Activate sub-service workflow if disabled
    Update workflow ID if changed
    Fix sub-service implementation issues
    Implement retry logic if needed

Problem: Chat Shows JSON Instead of Text

Symptoms: Chat interface displays JSON object instead of formatted text
Root Cause: Issue in `SVC_Response-Dispatcher`, not Command Handler

Solution: This service correctly returns JSON to the dispatcher. Check WF003: SVC_Response-Dispatcher troubleshooting guide.

Command Management
Adding New Simple Command

Steps:

    Add command to `simpleCommands` array in Extract & Validate Command
    Add case to Route Simple Commands switch
    Create new Code node with response logic
    Connect to Standardize Service Response
    Update help text in `/help` command
    Test across all channels

Adding New Complex Command

Steps:

    Add command to appropriate category in `complexCommands` map
    If new category, add to Route Complex Commands switch
    Create Execute Workflow node for sub-service
    Update help text with new command documentation
    Add integration example to this documentation
    Test end-to-end flow

Adding Command Alias

Example: Add `/pomoc` as Polish alias for `/help`

```javascript
// In Route Simple Commands switch condition
{
  "leftValue": "={{ $json._command.name }}",
  "rightValue": "help|pomoc",  // Add alias with regex pipe
  "operator": {
    "type": "string", 
    "operation": "regex"
  }
}
```

Integration Examples
From Router to Command Handler

```json
{
  "_router": {
    "trigger_source": "telegram",
    "user_id": "7689674321",
    "username": "michal",
    "chat_id": 123456789,
    "trace_id": "trace_001",
    "timestamp": "2026-02-13T18:24:51.644Z"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": 123456789
    }
  },
  "intent": {
    "primary": "command",
    "secondary": "system_command",
    "entities": {
      "command": "help",
      "args": ""
    }
  }
}
```

From Command Handler to Response Dispatcher

```json
{
  "_router": {
    "trigger_source": "telegram",
    "user_id": "7689674321",
    "chat_id": 123456789,
    "trace_id": "trace_001",
    "timestamp": "2026-02-13T18:24:51.644Z"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram",
      "chat_id": 123456789
    }
  },
  "service": "SVC_Command-Handler",
  "success": true,
  "response_text": "\U0001f4da *Commands:*

*System:*
/start - Welcome message...",
  "response_data": {
    "command": "help",
    "args": "",
    "type": "simple",
    "category": null,
    "execution_time_ms": 45,
    "success": true
  }
}
```

Version History
v1.0.0 (2026-02-13)

Initial Service Extraction:

    Extracted from monolithic router architecture
    Implemented two-tier command hierarchy (simple + complex)
    Added support for 9 command categories with Polish aliases
    Implemented comprehensive error handling and response standardization
    Added performance optimization via complexity-based routing

Supported Commands:

    Simple: start, help, status (inline processing)
    Complex: inventory, training, finance, planning, goals, intelligence (delegation)

Related Documentation
Core Services

    [WF001: ROUTER_Intelligence-Hub](./WF001_Agent_Router.md)
    [WF003: SVC_Response-Dispatcher](./WF003__svc-response-dispatcher.md)
    [WF004: SVC_Intelligence-Processor](./WF004__intelligence-hub-input.md)
    [WF005: SVC_Input-Normalizer](./WF005__svc-input-normalizer.md)

Sub-Services (Domain Specialists)

    [WF010: PROJ_Inventory-Management](./WF010__proj-inventory-management.md)
    [WF011: PROJ_Training-Intelligence-System](./WF011__proj-training-intelligence-system.md)
    [WF012: PROJ_Personal-Budget-Intelligence-System](./WF012__proj-personal-budget-intelligence-system.md)
    [WF013: SVC_Github-Autonomous-Evening-Planner](./WF013__svc-github-autonomous-evening-planner.md)
    [WF014: SVC_GitHub-Todo-List-Extractor](./WF014__svc-github-todo-list-extractor.md)

Systems

    S04 Messaging & Interaction Layer
    S10 Daily Goals Automation

SOPs & Runbooks

    SOP: Adding New Commands
    SOP: Service Integration
    Runbook: Command Handler Failures
    Runbook: Sub-Service Timeouts

Maintenance Notes
Monthly Review Checklist

    All commands tested across all channels (Telegram, Webhook, Chat)
    Sub-service workflow IDs are current and active
    Help text reflects all available commands and examples
    Error messages are helpful and actionable
    Execution times within expected ranges (<50ms simple, <30s complex)
    Polish aliases work correctly for all supported commands
    Response standardization preserves all required metadata
    Documentation matches current implementation

Performance Optimization Opportunities

    Implement command usage analytics for optimization priorities
    Add response time percentile tracking by command type
    Consider caching for frequently accessed static responses
    Evaluate async delegation for non-critical complex commands

When Adding New Sub-Service

    Add service to appropriate complexCommands category
    Add case to Route Complex Commands switch
    Create Execute Workflow node with correct workflow ID
    Connect to Standardize Service Response
    Update help text with new command documentation
    Add integration example to this documentation
    Test end-to-end flow across all channels
    Document sub-service response contract

Last Reviewed: 2026-02-13
Next Review: 2026-03-13
Service Status: Production Active
Critical Dependencies: 5 sub-services, SVC_Response-Dispatcher