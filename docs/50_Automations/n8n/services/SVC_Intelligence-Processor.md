---
title: "SVC: Intelligence Processor"
type: "service_spec"
status: "active"
service_id: "SVC_Intelligence-Processor"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC: Intelligence Processor

## Purpose
AI-powered content analysis service that processes user-captured content (notes, ideas, URLs, transcripts) and extracts actionable intelligence. It analyzes content against Michał's 12 Power Goals, identifies automation opportunities, and automatically creates structured notes in Obsidian via GitHub.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub for `capture` intent |

**Workflow ID:** `2Tw0zw8nti_kcLB1CSynU`

## Processing Flow

```
┌─────────────────────────┐
│     Workflow Trigger    │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Notify: Service Started │  Progress: "🟡 Analyzing content..."
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│   Validate & Prepare    │  Code: Validate _router, extract content
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Preserve Metadata       │  Set: original_context, transcript
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  AI: Intelligence       │  LangChain + Gemini: Analyze against 12 Goals
│       Analysis          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Extract Intelligence    │  Code: Parse JSON + Markdown, generate filename
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│    Check File Exists    │  GitHub API: Check if note already exists
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│      File Exists?       │  IF: Branch to Update OR Create
└────────┬────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌────────┐ ┌──────────┐
│ Update │ │  Create  │
│  File  │ │   File   │
└───┬────┘ └───┬──────┘
    │         │
    └────┬────┘
         ▼
┌─────────────────────────┐
│ Notify: Service        │  Progress: "✅ Analysis saved to Obsidian"
│      Completed          │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Prepare Service       │  Code: Format response for Dispatcher
│      Response          │
└─────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Progress Notification
- **Node:** `Notify: Service Started` (Execute Workflow)
- Sends progress update via `SVC_Response-Dispatcher`
- Message: "🟡 **Intelligence Processor** - Started\n🧠 Analyzing content against 12 Power Goals..."

### Stage 2: Validation
- **Node:** `Validate & Prepare` (Code)
- Validates required metadata:
  - `_router` - must exist
  - `metadata.response_endpoint` - must exist
- Extracts content from:
  - `input.normalized.text`
  - `input.extracted_text`
  - `input.input.raw_content`
- Throws error if content is empty

### Stage 3: Metadata Preservation
- **Node:** `Preserve Metadata for AI` (Set)
- Preserves `original_context` and `transcript` for downstream nodes

### Stage 4: AI Analysis
- **Node:** `AI: Intelligence Analysis` (LangChain Chain LLM)
- **Model:** Google Gemini (temperature: 0.3)
- **System Prompt:** Analyzes content against 12 Power Goals:

**Michał's 12 Power Goals:**
1. Reach Target Body Fat (15%)
2. Be recognizable Automationbro
3. Autonomous Household Operations
4. Digital Twin Ecosystem
5. Autonomous Financial Command Center
6. Pass Certification Exams
7. Predictive Health Management
8. Predictive Smart Home
9. Automated Career Intelligence
10. Intelligent Productivity System
11. Meta-System Integration
12. Complete Process Documentation

**AI Output Format:**
```markdown
## MARKDOWN NOTE:
---
source: [source URL]
title: [captured note title]
content_type: [format type]
date_captured: [timestamp]
status: inbox
power_goals: [list of relevant goals]
tags: [relevant tags]
---

## Summary
[2-3 sentence overview]

## Key Insights
[3-5 main takeaways]

## Actionable Items
[Specific tasks]

## Automation Opportunities
[Processes to automate]

## Connections to Goals
[How this relates to Power Goals]

## Full Transcript/Content
[Original content]
```

### Stage 5: Intelligence Extraction
- **Node:** `Extract Intelligence` (Code)
- Parses AI response:
  - Extracts JSON block (structured data: power_goals, action_items)
  - Extracts Markdown block (full note content)
- Generates filename: `{date}-{clean-title}`
- Appends full transcript at the end of note
- Returns: `filename`, `markdown_content`, `structured_data`

### Stage 6: GitHub Upsert (Enterprise Pattern)
- **Node:** `Check File Exists` (GitHub API)
- Checks if file exists in Obsidian repository
- Returns: `sha` (file SHA if exists)

- **Node:** `File Exists?` (IF)
- Routes based on SHA presence:
  - **Has SHA** → `GitHub Update File`
  - **No SHA** → `GitHub Create File`

- **Node:** `GitHub Update File` (GitHub)
- Updates existing file with commit message: "🔄 Updated: ..."

- **Node:** `GitHub Create File` (GitHub)
- Creates new file with commit message: "✨ Created: ..."

### Stage 7: Completion Notification
- **Node:** `Notify: Service Completed` (Execute Workflow)
- Sends completion message: "✅ **Intelligence Processor** - Completed\n📄 Analysis saved to Obsidian: {filename}.md"

### Stage 8: Response Preparation
- **Node:** `Prepare Service Response` (Code)
- Formats response for `SVC_Response-Dispatcher`:
  - `_router` and `metadata` preserved
  - `response_text` with human-readable summary
  - `response_data` with structured info (filename, operation, github_url)

## Inputs

```json
{
  "_router": {
    "trigger_source": "telegram",
    "chat_id": "{{TELEGRAM_CHAT_ID}}",
    "trace_id": "trace_1234567890"
  },
  "metadata": {
    "source": "telegram",
    "response_endpoint": {
      "type": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  },
  "extracted_text": "Content from Format Detector...",
  "input": {
    "format": "youtube_url",
    "extraction_method": "youtube_transcript"
  }
}
```

## Outputs

```json
{
  "response_text": "✅ INTELLIGENCE CREATED\n📄 File: 2026-04-10-ai-automation.md\n🎯 Goals: [G04, G11]\n📋 Actions: 3 tasks created in Obsidian inbox.",
  "response_data": {
    "success": true,
    "filename": "2026-04-10-ai-automation",
    "operation": "created",
    "structured_data": {
      "power_goals": ["G04", "G11"],
      "action_items": ["...", "...", "..."]
    },
    "github_url": "https://github.com/brostudiodev/michal-second-brain-obsidian/blob/main/00_Inbox/..."
  },
  "_router": { ... },
  "metadata": { ... }
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - State queries
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md) - Cross-system coordination

### Called By
- [ROUTER_Intelligent-Hub.md](./ROUTER_Intelligent-Hub.md) - Primary caller

### Workflows Called
- **SVC_Response-Dispatcher** (ID: `pag6IhR3yLeBUpR4cb8L9`) - Progress and completion notifications

### External Services
- **Google Gemini API** - AI analysis (gemini-2.0-flash)
- **GitHub API** - Obsidian file management (michal-second-brain-obsidian repository)

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| Missing `_router` | Validation throws | Error propagated to Dispatcher | n8n error workflow |
| Empty content | Validation throws | Error propagated to Dispatcher | n8n error workflow |
| AI parse failure | JSON.parse exception | Returns `parse_error` in structured_data | Log to console |
| GitHub API error | HTTP error | Returns error in response_data | n8n error workflow |
| File write failure | GitHub node error | Returns error via Dispatcher | n8n error workflow |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/2Tw0zw8nti_kcLB1CSynU/execute \
  -H "Content-Type: application/json" \
  -d '{
    "extracted_text": "Learn about AI automation for productivity",
    "_router": {
      "trigger_source": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    },
    "metadata": {
      "response_endpoint": {
        "type": "telegram",
        "chat_id": "{{TELEGRAM_CHAT_ID}}"
      }
    }
  }'
```

### Check Obsidian Inbox:
```bash
# List files in Inbox
curl -s "https://api.github.com/repos/brostudiodev/michal-second-brain-obsidian/contents/00_Inbox" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" | jq '.[].name'
```

## Supported Content Types

| Input Format | Processing | Notes |
|--------------|------------|-------|
| YouTube transcript | Full AI analysis | Extracts video metadata |
| Web URL content | Full AI analysis | Scraped content analyzed |
| Plain text | Full AI analysis | Direct text analyzed |
| Voice transcription | Full AI analysis | STT output analyzed |
| PDF content | Full AI analysis | Extracted text analyzed |
| CSV data | Structure analysis | Tabular data summarized |
| JSON data | Structure analysis | JSON structure explained |

---

*Documentation synchronized with svc_intelligence-processor.json v1.0 (2026-04-10)*