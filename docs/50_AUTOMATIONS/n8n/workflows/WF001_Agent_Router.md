---
title: "WF001: Agent Router (Agent Zero / Intelligence Hub Entry Point)"
type: "automation_spec"
status: "active"
owner: "Michał"
goal_id: "goal-g04"
updated: "2026-02-07"
---

# WF001: Agent Router (Agent Zero / Intelligence Hub Entry Point)

## Overview
WF001 is the **single entry point** for “Agent Zero”: the router that receives *all incoming traffic* (messages, ideas, content) and sends it through the right extractor + sub-workflow.

**Today (v0):** it is mainly used for:
- Capturing text/ideas into the Obsidian inbox (via GitHub commit into the vault repo)
- Processing **YouTube links** → transcript → intelligence extraction → Obsidian inbox note

**Later (target):** it becomes the **decision hub** for everything (finance, household, health, career, meta-system), implemented as additional intent routes + dedicated sub-workflows.

Workflow export: `WF001_Agent_Router.json`

## Naming Conventions (n8n)
This repo uses a simple split:
- **WF*** = *main workflows* (user-facing, orchestrators, end-to-end pipelines)
- **SVC_*** = *services / sub-workflows* (single-responsibility “functions” called by WF workflows)

Recommended pattern:
- **WF**: `WF###_<ShortName>`
  - Example: `WF001_Agent_Router`, `WF020_Youtube-toDatabase`
- **SVC**: `SVC_<Domain>-<Capability>`
  - Example: `SVC_Youtube-Extractor` (or more specific: `SVC_Youtube-TranscriptExtractor`)

Rule of thumb:
- WF workflows can depend on multiple SVC workflows.
- SVC workflows should be reusable and stable (clear input/output contract).

## SVC Contract Template (recommended)
Goal: any `SVC_*` workflow should be callable from a `WF*` workflow **without custom glue code**.

### Invariants
- Accept **1 item** in, return **1 item** out.
- Preserve `metadata.trace_id` for observability.
- Prefer **idempotent** behavior (safe to retry).
- Avoid side-effects by default (don’t send Telegram messages / write to GitHub) unless the SVC is explicitly an “executor” service.

### Standard Input (minimum)
Every SVC should accept this shape (extra fields are allowed):
```json
{
  "metadata": {
    "trace_id": "string",
    "source": "telegram|webhook|chat|…",
    "timestamp": "ISO-8601"
  },
  "input": {
    "format": "text|youtube_url|web_url|voice|document|…",
    "raw_content": "string|null",
    "file_id": "string|null",
    "extraction_method": "direct|youtube_transcript|…",
    "additional_data": {}
  },
  "normalized": {
    "text": "string (optional)",
    "extraction_source": "string (optional)"
  },
  "intent": {
    "primary": "command|question|capture|task|… (optional)",
    "secondary": "string|null",
    "confidence": 0.0,
    "entities": {}
  }
}
```

### Standard Output (minimum)
Every SVC should return this shape (extra fields are allowed):
```json
{
  "ok": true,
  "service": "SVC_<Domain>-<Capability>",
  "stage": "service_done",
  "metadata": {
    "trace_id": "string",
    "timestamp": "ISO-8601"
  },
  "result": {
    "type": "text|json|mixed",
    "text": "string|null",
    "data": {},
    "warnings": []
  },
  "enrichment": {}
}
```

### Extractor Services (SVC_*_Extractor)
If the SVC is an extractor called before `Stage 2: Normalize to Text`, return in a WF001-compatible way:
```json
{
  "metadata": { "trace_id": "…" },
  "input": { "format": "youtube_url", "extraction_method": "youtube_transcript" },
  "stage": "text_extracted",
  "extracted_text": "…",
  "extraction_source": "SVC_Youtube-Extractor",
  "youtube_metadata": {
    "video_id": "…",
    "title": "…",
    "channel": "…"
  }
}
```

### Error Contract
- If recoverable: set `ok: true` + add a warning in `result.warnings`.
- If not recoverable: set `ok: false` + include `error.code`, `error.message`, and any safe debug context.

## High-Level Architecture

```
Inputs (Telegram / Webhook / n8n Chat)
  → Stage 1: Detect Format (text/voice/youtube_url/web_url/photo/…)
  → Route to Extractor
  → Stage 2: Normalize to Text
  → Stage 3: Classify Intent (command / question / capture / task / …)
  → Stage 4: Route by Intent
      → Capture: AI Intelligence Analysis → Extract Intelligence → Save to GitHub (Obsidian inbox)
      → Command: local handler (help/status/goals) OR “Intelligence Activator”
      → Question: placeholder route (LLM Chat webhook)
      → Task: placeholder route (Task Creator webhook)
      → Callback: placeholder route (Callback Handler webhook)
```

## Inputs
WF001 supports three input channels:

1. **Telegram Trigger**: `Telegram Input`
   - Updates: `message`, `callback_query`
2. **Webhook Trigger**: `Webhook Input`
   - POST endpoint: `/intelligence-hub`
   - Response mode: `responseNode`
3. **n8n Chat Trigger**: `When chat message received`

## Outputs
Depending on source + intent:

- **Obsidian inbox note** (via GitHub API):
  - Repository: `brostudiodev/michal-second-brain-obsidian`
  - Path: `00_Inbox/{{ filename }}.md`
- **Telegram status message** back to user:
  - “processing …” notifications for some extractors
  - “✅ INTELLIGENCE PROCESSED …” summary after saving
- **Webhook response** (JSON) when invoked via `/intelligence-hub`

## Stage 1 — Format Detection & Normalization
Node: `Stage 1: Detect Format`

Responsibilities:
- Detect input **source** (`telegram`, `webhook`, `chat`)
- Create a `trace_id` for correlation across logs
- Detect input **format** + **extraction method**:
  - `text` → `direct`
  - `youtube_url` → `youtube_transcript`
  - `web_url` → `web_scraper`
  - `voice`/`audio` → `whisper_stt`
  - `video`/`video_note` → `extract_audio_then_whisper` (pipeline placeholder)
  - `photo` → `vision_ocr` (placeholder)
  - `pdf` → `pdf_parser` (placeholder)
  - `document` → `document_parser` / `direct_text` (placeholder)

Output shape (simplified):
```json
{
  "metadata": {
    "trace_id": "…",
    "source": "telegram|webhook|chat",
    "chat_id": 123,
    "user_id": 456,
    "timestamp": "…"
  },
  "input": {
    "format": "text|youtube_url|web_url|voice|photo|pdf|document|…",
    "raw_content": "…",
    "file_id": "…",
    "extraction_method": "direct|youtube_transcript|whisper_stt|…",
    "additional_data": { }
  }
}
```

## Extractors (Route to Extractor)
Node: `Route to Extractor`

Routes by `input.extraction_method` into one of:
- `Direct Text (No Extraction)`
- Whisper STT path:
  - `Whisper: Notify` → `Whisper: Download File` → `Whisper: Transcribe` → `Whisper: Format Output`
- YouTube transcript path:
  - `Call YouTube Transcript Service` (sub-workflow)
  - `YouTube: Has Transcript?` → (fallback to description if missing)
- Web page path:
  - `Web: Notify` → `Web: Fetch Page` → `Web: Extract Text`
- Vision/PDF/Document placeholder processors

Implemented vs placeholders:
- Implemented: `direct`, `youtube_transcript` (via service), `web_scraper` (simple HTML→text), `whisper_stt` (OpenAI node)
- Placeholders: `vision_ocr`, `pdf_parser`, `document_parser`, `extract_audio_then_whisper`

## Stage 2 — Normalize to Text
Node: `Stage 2: Normalize to Text`

Purpose:
- Convert all extractor outputs into one stable text payload:
  - `normalized.text`
  - `normalized.text_length`, `normalized.word_count`
  - `enrichment` (YouTube/web metadata)

This is the contract boundary that makes adding new extractors low-risk.

## Stage 3 — Intent Classification
Node: `Stage 3: Classify Intent`

Rule-based intent classifier using:
- Text prefix patterns (`/command`, `note:`, `idea:`, `task:`)
- Heuristics for questions
- Input format hints (YouTube/web/doc tends toward “capture”)

Output:
```json
{
  "intent": {
    "primary": "command|question|capture|task|conversation|callback",
    "secondary": "…",
    "confidence": 0.0,
    "entities": { }
  }
}
```

## Stage 4 — Route by Intent
Node: `Stage 4: Route by Intent`

### Command
Node: `Handle Commands`

- Handles basic system commands locally: `/start`, `/help`, `/status`, `/goals`
- Special case: “intelligence activator” commands (`/approve_*`, `/review_*`, `/skip_*`)
  - routed to `Call Intelligence Activator` (currently a placeholder URL)

### Capture (current main path)
Nodes:
- `Preserve Metadata for AI`
- `AI: Intelligence Analysis` (LLM chain)
- `Extract Intelligence`
- `Save to GitHub`

The LLM prompt instructs the model to output **two blocks**:
- ```markdown …``` → becomes the Obsidian note
- ```json …``` → structured extraction (goals, action items, priority)

`Extract Intelligence` then:
- Parses the markdown/json blocks
- Generates a filename `YYYY-MM-DD-<title-slug>`
- Passes to GitHub node to write `00_Inbox/<filename>.md`

After saving:
- If source = Telegram → sends a summary with filename + goals + action count
- If source = Webhook → returns JSON response via `Webhook Response`

### Question / Task / Callback
Currently routed to placeholder webhooks:
- `Route: LLM Chat` → `YOUR_LLM_CHAT_WEBHOOK_URL`
- `Route: Task Creator` → `YOUR_TASK_CREATOR_WEBHOOK_URL`
- `Route: Callback Handler` → `YOUR_CALLBACK_HANDLER_WEBHOOK_URL`

## Sub-Workflows / Services
- `Call YouTube Transcript Service` executes an n8n sub-workflow (SVC).
  - Current n8n name: `SVC_Youtube-Youtube_transcript`
  - Recommended convention name: `SVC_Youtube-Extractor` (or `SVC_Youtube-TranscriptExtractor`)

This keeps transcript extraction isolated from router logic.

## Failure Modes
Most common expected failures:
- Telegram download/transcription failures (file too large, API error)
- YouTube transcript missing / disabled (falls back to description)
- Web scraping returns huge/noisy content (HTML extraction is simplistic)
- LLM output not parseable (missing ```json``` or invalid JSON)
- GitHub write fails (rate limits, auth, repo unavailable)

## Monitoring / Observability
Minimal v0 monitoring:
- Use `metadata.trace_id` for correlation in n8n execution logs
- Alerting strategy (recommended next):
  - On workflow error → send Telegram message to yourself
  - Track daily “capture heartbeat” (did a note get created today?)

## Roadmap (next sub-workflows)
Suggested next additions to WF001 routing:
- `capture → obsidian_inbox_append` (Agent Zero v0, single file append in the local vault)
- `task → todoist` (or your task system)
- `finance → ingestion health check` (goal-g05)
- `meta → autonomy scoreboard update` (goal-g11)

## Related Files
- Workflow export: `WF001_Agent_Router.json`
- Sub-workflow: `SVC_Youtube-Youtube_transcript` (n8n internal id)
