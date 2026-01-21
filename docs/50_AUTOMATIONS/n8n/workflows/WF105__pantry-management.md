---
title: "WF105: Pantry Management AI Agent"
type: "automation_spec"
status: "active"
owner: "Michał"
goal: "G03"
sub_project: "Pantry Management"
systems: ["S03"]
updated: "2026-01-15"
---

# WF105: Pantry Management AI Agent

## Overview

This n8n workflow implements an intelligent home pantry management system that allows users to track inventory through natural language commands. The system supports multiple input channels (Telegram, Webhook, n8n Chat) and uses an AI Agent powered by Google Gemini to process natural language requests for adding, removing, and checking pantry items.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              INPUT SOURCES                                       │
├─────────────────┬─────────────────┬─────────────────────────────────────────────┤
│  Telegram Bot   │  Webhook POST   │  n8n Chat Interface                         │
│  (AndrzejAIBot) │  /spizarnia-    │  (When chat message received)               │
│                 │   webhook       │                                              │
└────────┬────────┴────────┬────────┴─────────────────┬───────────────────────────┘
         │                 │                          │
         └─────────────────┼──────────────────────────┘
                           ▼
                 ┌─────────────────┐
                 │ Normalize Input │
                 │   (Code Node)   │
                 └────────┬────────┘
                          ▼
                 ┌─────────────────┐
                 │  Is Command?    │
                 │   (IF Node)     │
                 └───────┬─────────┘
                    ┌────┴────┐
                    ▼         ▼
            ┌───────────┐ ┌───────────────┐
            │  Handle   │ │   AI Agent    │
            │ Commands  │ │ (Gemini LLM)  │
            └─────┬─────┘ └───────┬───────┘
                  │               │
                  ▼               ▼
         ┌─────────────┐  ┌──────────────┐
         │   Needs     │  │  Is Chat?    │
         │ Inventory?  │  │    (AI)      │
         └──────┬──────┘  └──────┬───────┘
                │                │
                ▼                ▼
         ┌─────────────────────────────────┐
         │        Merge Responses          │
         └────────────────┬────────────────┘
                          ▼
                 ┌─────────────────┐
                 │  Response       │
                 │  Routing        │
                 └────────┬────────┘
                    ┌─────┼─────┐
                    ▼     ▼     ▼
              ┌────────┐ ┌────────┐ ┌────────┐
              │Telegram│ │Webhook │ │  Chat  │
              │Response│ │Response│ │Response│
              └────────┘ └────────┘ └────────┘
```

## Workflow Components

### 1. Input Triggers
The workflow accepts input from three different sources:

- **Telegram Trigger**: Listens for messages from the Telegram bot "AndrzejAIBot" and captures message text, chat ID, and user information.
- **Webhook Trigger**: Provides an HTTP POST endpoint at `/spizarnia-webhook` that accepts a JSON body with `message`, `sessionId`, and `userName` fields.
- **When chat message received**: The built-in n8n chat interface trigger, providing `chatInput` and `sessionId`.

### 2. Normalize Input (Code Node)
This node standardizes data from all three input sources into a unified output structure:
```json
{
  "source": "'telegram' | 'webhook' | 'chat'",
  "userMessage": "string",
  "chatId": "number | null",
  "sessionId": "string",
  "userName": "string",
  "isCommand": "boolean",
  "timestamp": "ISO string"
}
```
**Detection Logic:**
- **Telegram**: Identified by the presence of `message.chat.id`.
- **Chat**: Identified by `chatInput` or `sessionId` properties.
- **Webhook**: Identified by `body` or `query` properties.

### 3. Command Router (Is Command? IF Node)
Routes messages based on whether they start with `/`:
- **True branch**: Direct commands (`/start`, `/help`, `/inventory`).
- **False branch**: Natural language processing via AI Agent.

### 4. Handle Commands (Code Node)
Processes direct commands:
- **/start**: Returns a welcome message with usage instructions.
- **/help**: Returns detailed help documentation.
- **/inventory**: Sets a flag to fetch the current inventory.
- **Other**: Returns an "unknown command" message.

### 5. Inventory Flow
When `/inventory` is requested:
1.  **Get Inventory**: Fetches all rows from the `Spizarka` sheet.
2.  **Format Inventory**: Transforms data into a readable format with status emojis (✅ OK, 🟡 Niski, 🔴 Krytyczny), quantity, unit, and a timestamp.

### 6. AI Agent (Gemini LLM)
**Model Configuration:**
- **Model**: Google Gemini
- **Temperature**: 0.2 (for consistent, deterministic operations)
- **Memory**: Buffer Window (maintains conversation context per session)

**System Prompt Capabilities:**
- Understands Polish natural language.
- Recognizes ADD intents ("in", "dodaj", "kupiliśmy", "kupiłem", "mamy").
- Recognizes REMOVE intents ("out", "usuń", "zjedliśmy", "zużyliśmy").
- Handles expiration dates when provided.
- Creates new categories when a product doesn't exist.

**Available Tools:**
| Tool | Operation | Description |
|---|---|---|
| `get_inventory` | Read | Fetches current inventory from `Spizarka`. |
| `update_inventory` | Update | Modifies existing product quantities. |
| `add_product` | Append | Adds a new product to `Spizarka`. |
| `get_dictionary` | Read | Fetches the synonym dictionary from `Slownik`. |
| `add_dictionary` | Append | Adds a new category to `Slownik`. |
| `calculator` | Calculate | Performs arithmetic for quantity updates. |

### 7. Response Routing
After processing, responses are routed back to the original source (`Telegram`, `Webhook`, or `Chat`) based on the `source` field set in the `Normalize Input` node.

## Message Flow Examples

### Example 1: Adding Products via Telegram
```
User: "2 mleka in"
     │
     ▼
Telegram Trigger → Normalize Input
     │
     ▼
Is Command? = false → AI Agent
     │
     ▼
AI Agent:
  1. get_inventory → checks current milk quantity (e.g., 3)
  2. calculator → 3 + 2 = 5
  3. update_inventory → sets Mleko to 5
     │
     ▼
Response: "✅ Mleko: 3 → 5 l"
     │
     ▼
Is Telegram? = true → Send to Telegram
```

### Example 2: New Product via Chat
```
User: "kupiliśmy 5 bananów"
     │
     ▼
Chat Trigger → Normalize Input
     │
     ▼
Is Command? = false → AI Agent
     │
     ▼
AI Agent:
  1. get_inventory → Banan not found
  2. add_dictionary → adds Banan to Slownik
  3. add_product → adds Banan with quantity 5
     │
     ▼
Response: "✅ Banan: 0 → 5 szt (nowa kategoria)"
     │
     ▼
Is Chat? = true → Send to Chat
```

## Supported User Interactions

### Natural Language Commands (Polish)
**Adding Items:**
- "2 mleka in"
- "kupiliśmy 3 paczki makaronu"
- "dodaj 1 tuńczyk ważny do 2026-06-15"
- "mamy 5 jajek"

**Removing Items:**
- "1 mleko out"
- "zjedliśmy ostatnie jajka"
- "zużyliśmy 2 puszki"
- "usuń 3 jabłka"

### Direct Commands
| Command | Description |
|---|---|
| `/start` | Initialize bot, show welcome message. |
| `/help` | Display detailed usage instructions. |
| `/inventory` | Show current pantry status. |

## Technical Notes

- **Session Management**: Each input source generates a unique `sessionId` (e.g., `telegram_123456789`) to maintain conversational context.
- **Error Handling**: Unknown commands return a helpful error message. The AI Agent handles missing products by creating new categories. Quantities are not allowed to go below zero.
- **Response Formats**: Responses are formatted for the source channel (Markdown for Telegram, JSON for Webhook, Plain Text for Chat).

## Dependencies & Credentials
- **External APIs:** Google Sheets, Telegram Bot API, Google Gemini
- **Infrastructure:** n8n execution environment, network connectivity
- **Credentials:**
    - **Telegram**: `Telegram (AndrzejAIBot)`
    - **Google Sheets**: `Google Sheets account`
    - **Google Gemini**: `Google Gemini(PaLM) Api account`

## Monitoring & Observability
- **Success Rate:** >95% command interpretation accuracy
- **Response Time:** <3 seconds end-to-end latency
- **API Integration:** Google Sheets quota monitoring
- **Error Alerting:** Slack notifications for workflow failures

## Workflow ID Reference
| Node | ID |
|---|---|
| Telegram Trigger | c0ad93ac-ce89-4af1-8d23-d691798301b5 |
| Webhook Trigger | 5dd7a6f3-7c31-406d-af6c-edd522a1a960 |
| AI Agent | c5425506-a5ef-47ac-bc74-f8e23c66ccab |
| Memory Buffer | d63b9372-e55f-4ea1-a413-c24e4f46c7f2 |

## Related Documentation
- [Sub-Project Master](../../../10_GOALS/G03_Autonomous-Household-Operations/Pantry-Management-System.md)
- [Data Schema](../../../20_SYSTEMS/S03_Data-Layer/Pantry-Schema.md)
- [Daily Operations SOP](../../../30_SOPS/Home/Pantry-Management.md)
- [Workflow Export](WF105__pantry-management.json)