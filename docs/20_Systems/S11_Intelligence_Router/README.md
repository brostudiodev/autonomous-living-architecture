---
title: "S11: Intelligence Router"
type: "system"
status: "active"
system_id: "system-s11"
owner: "{{OWNER_NAME}}"
updated: "2026-02-16"
review_cadence: "monthly"
---

# ROUTER_Intelligence-Hub: Architectural Documentation
## Executive Overview

The ROUTER_Intelligence-Hub serves as the central nervous system of your personal intelligence infrastructure. This n8n workflow implements a sophisticated hub-and-spoke architecture that transforms chaotic multi-channel inputs into structured, actionable intelligence. It's designed around the philosophy of universal intake, intelligent routing, specialized processing, and unified response.

**Core Value Proposition:** Rather than building separate systems for each input type (Telegram messages, PDFs, voice notes, calendar queries), this router normalizes everything into a common processing pipeline while maintaining the flexibility to handle each format's unique requirements.

**Strategic Context:** This system bridges the gap between rigid RPA automation and fluid AI processing, positioning you perfectly for the hyperautomation era while maintaining deterministic control where needed.

> [!insight] 📝 **Automationbro Insight:** [The Router Pattern: Stop Building Bots, Start Building a Nervous System](https://automationbro.substack.com/p/the-router-pattern-stop-building)

## Scope
### In Scope
- Multi-channel input ingestion (Telegram, Webhook, Chat).
- Format detection and content extraction (PDF, CSV, Audio, YouTube).
- Intent classification with Polish and English language support.
- Specialized routing to sub-workflows (Finance, Training, Calendar).
- Metadata preservation and trace ID management.

### Out of Scope
- Direct execution of financial transactions.
- Long-term conversational memory (handled by S04).

## Inputs
- **Telegram:** Text, Voice, Documents, Photos, Callbacks.
- **Webhooks:** JSON payloads from external systems.
- **Chat:** User input from the LangChain interface.

## Outputs
- **Dispatched Responses:** Channel-aware messages (Telegram/Chat).
- **Sub-workflow Triggers:** Normalized data for specialized handlers.
- **Obsidian Commits:** Processed content saved to the vault.
- **Processing Notifications:** Real-time "Processing..." status updates.

## Dependencies
### Systems
- [S00 Homelab Platform](../S00_Homelab-Platform/README.md) - n8n hosting.
- [S04 Digital Twin](../S04_Digital-Twin/README.md) - Intelligence and state access.
- [S05 Observability Dashboards](../S05_Observability-Dashboards/README.md) - Target for status commands.

### External
- **Google Gemini API** - Intent analysis and content extraction.
- **OpenAI Whisper** - Voice transcription.
- **GitHub API** - Storage for processed intelligence.

## Architectural Philosophy & Design Patterns
### Key Design Patterns

**Metadata Preservation Pattern** Every processing stage adds routing metadata without destroying original data. The _router object travels through the entire pipeline, ensuring complete traceability and enabling sophisticated routing decisions downstream.

**Conditional Notification Pattern** Long-running operations (PDF processing, voice transcription, YouTube extraction) trigger user notifications, while direct operations skip notifications to avoid spam. This manages user expectations effectively for latency-heavy tasks.

**Unified Response Pattern** All outputs converge through SVC_Response-Dispatcher, which handles channel-specific formatting (Telegram markdown, JSON for webhooks, chat responses) in a centralized manner.

**Sub-Workflow Isolation Pattern** Complex domain logic is delegated to specialized workflows, keeping the router clean, maintainable, and focused on orchestration rather than implementation.

**Intent Confidence Pattern** Classification includes confidence scores, enabling future implementation of fallback chains and clarifying questions for ambiguous inputs.
## Stage-by-Stage Architectural Breakdown
### Stage 1: Multi-Channel Ingestion & Source Tagging

**Purpose:** Accept inputs from multiple channels and normalize them with consistent routing metadata.

**Entry Points:**

- **Telegram Input (telegramTrigger):** Handles messages, callback queries, and inline interactions
- **Webhook (POST /intelligence-hub):** HTTP endpoint for external integrations and programmatic access
- **Chat Interface (chatTrigger):** LangChain-based conversational interface

**Tagging Process:** Each trigger immediately flows through source-specific tagging nodes that inject standardized _router metadata:

```json
{
  "_router": {
    "trigger_source": "telegram|webhook|chat",
    "user_id": "extracted_user_identifier",
    "username": "display_name",
    "chat_id": "conversation_identifier",
    "message_id": "for_reply_threading",
    "trace_id": "unique_execution_identifier",
    "timestamp": "ISO_timestamp"
  }
}
```

**Critical Design Decision:** Original payloads are preserved completely. The _router object is metadata, not a replacement, ensuring sub-workflows receive authentic trigger data.
### Stage 2: Authentication & Authorization

**Purpose:** Implement selective security - strict validation for public-facing Telegram, trusted bypass for internal channels.

**Security Logic:**

- **Source Detection (Is Telegram):** Routes Telegram traffic through authorization, bypasses webhook/chat
- **Telegram Authorization (Authorized1):** Validates against allowlisted user ID (7689674321)
- **Convergence:** All authorized paths merge at Converge1 for unified processing

**Technical Debt Alert:** The hardcoded user ID represents immediate technical debt. This should migrate to environment variables or a lookup service to avoid workflow redeployment for user management.
### Stage 3: Format Detection & Content Extraction

**Purpose:** Identify input types and extract processable content while managing user expectations.

**Format Detection Service (SVC: Format Detector):** Delegates to specialized sub-workflow that handles:

**Fully Implemented Formats:**

- 📄 PDF: Text extraction via parsing
- 📊 CSV: Table structure analysis with preview
- ⚙️ JSON/XML: Structure validation and element counting
- ✍️ TXT/MD: Direct text passthrough
- 🎙️ Voice/Audio: Whisper STT transcription
- 🎬 YouTube: Transcript fetching with metadata enrichment
- 🔗 Web URLs: HTML content scraping

**Placeholder Formats (requiring conversion):**

- 📈 Excel: Needs CSV conversion
- 📝 Word: Needs PDF conversion

**User Experience Enhancement:** For complex extractions (non-direct methods), the system:

- Stores original payload in _original_payload
- Sends progress notification ("📄 Processing PDF...")
- Continues processing
- Restores original payload post-notification

### Stage 4: Intent Classification

**Purpose:** Determine user intent through sophisticated rule-based classification with Polish language support.

**Classification Engine (Stage3 Classify):** Implements hierarchical intent detection with confidence scoring:

**Priority Classification Order:**

- **Callback (confidence: 1.0)** - Button interactions
- **Command (confidence: 1.0)** - / prefixed commands with argument parsing
- **Calendar (confidence: 0.95)** - Enhanced Polish Support
    - Keywords: kalendarz, spotkanie, wizyta, termin
    - Temporal patterns: "dziś o 15:00", "jutro rano", "w poniedziałek"
    - Action verbs: "sprawdź", "dodaj", "usuń" + date/time context
    - Sub-actions: check_availability, create_event, modify_event
- **Explicit Capture (confidence: 0.9)** - "save", "note", "zapisz"
- **Document/URL/Media Capture (confidence: 0.8-0.85)** - Based on format detection
- **Question (confidence: 0.85)** - Question words + patterns
- **Task (confidence: 0.8)** - Action verbs like "create", "remind"
- **Greeting (confidence: 0.9)** - Short social interactions
- **Fallback - Conversation or implicit questions**

**Strategic Critique:** This rule-based approach is fast and deterministic but represents a maintenance burden. The extensive Polish regex patterns (spotkan|spotkani|wizyt) create technical debt. Future evolution should migrate to semantic routing using lightweight LLMs for better scalability.
### Stage 5: Intent-Based Routing

**Purpose:** Direct classified requests to appropriate specialized handlers.

**Router Switch (Stage 4: Route by Intent):** Seven distinct processing paths:

- **Command Path →** System commands, intelligence activators, specialized tools
- **Question Path →** LLM-based conversational AI
- **Capture Path →** Intelligence analysis and Second Brain integration
- **Task Path →** Task creation and management
- **Conversation Path →** Social interactions and greetings
- **Callback Path →** Interactive button handling
- **Calendar Path →** Google Calendar integration

### Stage 6: Specialized Processing Flows
#### Command Processing Flow

**Command Router (Route Command)** handles:

**System Commands:**

- **/start:** Welcome and capabilities overview
- **/help:** Comprehensive command reference with examples
- **/status:** System health check
- **/goals:** Power Goals display via SVC_GitHub-Todo-List-Extractor

**Intelligence Commands:**

- **/intel:** Intelligence processing activator
- **/plan|/evening:** Autonomous evening planner integration

**Domain-Specific Commands:**

- **Inventory:** /inventory|/pantry|/spizarnia [query] → SVC: Inventory Management
- **Finance:** /finance|/budget → PROJ_Personal-Budget-Intelligence-System
- **Training:** /training|/workout → PROJ_Training-Intelligence-System

#### Intelligence Capture Flow (The "Second Brain")

**Core Processing Pipeline:**

- **Metadata Preservation (Preserve Metadata for AI):** Stores context and extracts transcript
- **AI Analysis (AI: Intelligence Analysis):**
    - **Model:** Google Gemini (temperature: 0.3)
    - **Context:** Your 12 Power Goals, content type, source metadata
    - **Output:** Structured markdown note + JSON with actionable items
- **Intelligence Extraction:** Parses AI response, generates filename, structures data
- **GitHub Storage:** Commits to michal-second-brain-obsidian/00_Inbox/
- **Response Dispatch:** Via centralized SVC_Response-Dispatcher

**AI Prompt Structure:**

```
You are {{OWNER_NAME}}'s Intelligence Processing System.

**MICHAŁ'S 12 POWER GOALS:**
1. Reach Target Body Fat
2. Be recognizable Automationbro
3. Autonomous Household Operations
... (complete list)

**OUTPUT FORMAT:**
## MARKDOWN NOTE + ## JSON OUTPUT
(Structured for Obsidian with YAML frontmatter)
```

#### Calendar Management Flow

Enhanced Polish language support for calendar operations:

- **Detection:** Sophisticated pattern matching for temporal queries
- **Processing:** SVC_Google-Calendar integration
- **Actions:** Check availability, create events, modify schedule
- **Response:** Via unified dispatcher

### Stage 7: Response Orchestration

**Centralized Dispatch Pattern:** Most flows converge on SVC_Response-Dispatcher which handles:

- Channel detection (Telegram/Webhook/Chat)
- Format adaptation (Markdown/JSON/Plain text)
- Delivery confirmation and error handling

**Direct Response Paths (Legacy):** Some specialized responses bypass the dispatcher for immediate delivery, representing opportunities for architectural consolidation.
## Data Flow Architecture

[View Architecture Diagram](./architecture_diagram.md)
## Critical Configuration & Technical Debt
### Immediate Configuration Requirements

Replace placeholder URLs:

- `YOUR_LLM_CHAT_WEBHOOK_URL`
- `YOUR_TASK_CREATOR_WEBHOOK_URL`
- `YOUR_CALLBACK_HANDLER_WEBHOOK_URL`
- `YOUR_INTELLIGENCE_ACTIVATOR_WEBHOOK_URL`

### Technical Debt Identification

**High Priority:**

- **Hardcoded Authorization:** User ID in Authorized1 node should be externalized
- **Regex Maintenance Burden:** Polish language patterns in Stage3 Classify create maintenance overhead
- **Missing Error Handling:** No global error recovery for sub-workflow failures

**Medium Priority:**

- **Response Path Consolidation:** Some flows bypass the unified dispatcher
- **State Management:** Currently stateless, limiting multi-turn conversations
- **Configuration Management:** Various hardcoded values throughout the workflow

### Monitoring & Observability

- **Trace IDs:** Every execution generates unique identifiers for end-to-end tracking
- **Confidence Scoring:** Intent classification provides confidence metrics
- **Processing Notifications:** User feedback for long-running operations

## Future Evolution Recommendations
### Near-Term Improvements

- **Semantic Intent Classification:** Replace regex-based classification with lightweight LLM for better accuracy and maintainability
- **Centralized Configuration:** Move hardcoded values to environment variables or configuration service
- **Error Recovery:** Implement global error handling and notification system

### Strategic Evolution

- **Context Memory:** Implement Redis or n8n memory for multi-turn conversations
- **Advanced Analytics:** Track intent distribution, processing times, and user patterns
- **Multi-Language Expansion:** Extend beyond Polish to support additional languages
- **Confidence-Based Routing:** Implement clarifying questions for low-confidence intents

## Architectural Maturity

This system represents a sophisticated bridge between deterministic automation and AI-driven processing. It's architecturally sound with clear separation of concerns, proper abstraction layers, and good delegation patterns. The main evolution path involves migrating from rule-based to semantic processing while maintaining the robust orchestration framework you've built.

**Strategic Assessment:** You're building a system that works for you, not just with you. The combination of structured automation with AI enhancement positions this perfectly for the hyperautomation future while maintaining control and predictability where needed.
### Supported Capabilities Summary

**Input Formats:** PDF, CSV, JSON, XML, TXT, MD, Voice, Audio, Video, YouTube URLs, Web URLs, Photos, Telegram messages, Webhooks, Chat

**Languages:** English and Polish with sophisticated morphological support

**Integrations:** GitHub (Obsidian), Google Calendar, Inventory Management, Budget Intelligence, Training Systems, Evening Planning

**Output Channels:** Telegram, HTTP webhooks, Chat interface with unified response formatting

This router represents a mature, production-ready intelligence processing system that effectively balances automation, AI enhancement, and user experience.

## Procedure
1. **Daily:** Check workflow execution status
2. **Weekly:** Review intent classification accuracy
3. **Monthly:** Analyze routing patterns, tune rules
4. **Quarterly:** Review technical debt, plan improvements

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Telegram bot down | /commands fail | Check n8n workflow status |
| AI API fails | Gemini returns error | Retry with backoff, log |
| Format detection fails | Wrong content extracted | Debug SVC, update patterns |
| GitHub write fails | Commit error | Manual retry, check token |

## Security Notes
- Authorization via Telegram user ID allowlist
- API keys stored in n8n credentials
- No PII in webhook payloads

## Owner & Review
- **Owner:** {{OWNER_NAME}}
- **Review Cadence:** Monthly
- **Last Updated:** 2026-02-16
