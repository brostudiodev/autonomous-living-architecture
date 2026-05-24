---
title: "ROUTER Intelligence Hub: High-Level Architecture"
type: "architecture"
status: "active"
system_id: "S11"
owner: "Michał"
updated: "2026-05-19"
---

# ROUTER_Intelligence-Hub: High-Level Architectural Blocks

## 6-Stage Architecture Overview

### Stage 1: Multi-Channel Ingestion & Security
**The "Gatekeeper" - Unified entry point with access control**

**Core Function:** Accept and authenticate inputs from multiple channels
- **Telegram Trigger** - Message and callback handling
- **HTTP Webhook** - API endpoint for external integrations
- **Chat Interface** - LangChain conversational interface
- **Source Tagging** - Add routing metadata (_router object)
- **Security Layer** - Telegram user authorization, trusted channel bypass

### Stage 2: Content Normalization & Extraction
**The "Translator" - Convert any input into processable content**

**Core Function:** Detect formats and extract structured content
- **Format Detection Service** - Identify input types (PDF, voice, URLs, etc.)
- **Content Extraction** - Convert complex formats to normalized text
- **User Experience Management** - Progress notifications for long operations
- **Metadata Preservation** - Maintain routing context through processing

### Stage 3: Intent Classification & Analysis
**The "Brain" - Understand what the user wants**

**Core Function:** Analyze content and determine user intent with confidence scoring
- **Multi-Language Analysis** - English and Polish pattern recognition
- **Intent Hierarchy** - Command > Calendar > Capture > Question > Task > Conversation
- **Confidence Scoring** - Certainty levels for routing decisions
- **Entity Extraction** - Extract relevant parameters and context

### Stage 4: Domain-Specific Routing & Processing
**The "Specialists" - Execute domain-specific logic**

**Core Function:** Route to specialized processing based on classified intent
- **Command Processor:** System commands, status audits, tool discovery.
- **Intelligence Capture:** AI analysis and Obsidian Second Brain integration.
- **Domain Orchestrators:** 13 specialized modules (Health, Finance, Career, Content, etc.).
- **Calendar & Task Managers:** Google Ecosystem operations and autonomous triage.
- **Self-Healing Engine:** Automatic repair of system-wide failures and friction.

### Stage 5: Response Preparation & Formatting
**The "Formatter" - Structure results for delivery**

**Core Function:** Prepare responses in appropriate formats for each channel
- **Content Structuring** - Organize results and metadata
- **Channel Detection** - Identify response destination
- **Format Adaptation** - Telegram markdown, JSON for webhooks, chat responses
- **Status Enrichment** - Add confirmation messages and metadata

### Stage 6: Unified Response Dispatch
**The "Delivery Service" - Ensure responses reach their destination**

**Core Function:** Centralized response delivery across all channels
- **Response Dispatcher Service** - Single point for all outbound communication
- **Delivery Confirmation** - Ensure successful response delivery
- **Error Handling** - Manage delivery failures and retries

## Architectural Flow Pattern
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   STAGE 1   │    │   STAGE 2   │    │   STAGE 3   │
│ Gatekeeper  ├───▶│ Translator  ├───▶│    Brain    │
│             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
                                              │
┌─────────────┐    ┌─────────────┐    ┌─────────▼───┐
│   STAGE 6   │    │   STAGE 5   │    │   STAGE 4   │
│  Delivery   │◀───│  Formatter  │◀───│ Specialists │
│             │    │             │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Cross-Cutting Concerns
- **Tracing & Observability** - Unique trace IDs and metadata throughout
- **Error Handling** - Graceful degradation and user feedback
- **Configuration Management** - Centralized settings and credentials

This architecture implements a hub-and-spoke pattern with centralized orchestration and specialized processing, enabling scalable addition of new input channels and processing capabilities while maintaining unified response handling.
