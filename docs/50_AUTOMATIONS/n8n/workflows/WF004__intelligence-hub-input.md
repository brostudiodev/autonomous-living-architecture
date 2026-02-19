---
title: "WF004: Intelligence Hub Input Processing"
type: "automation_spec"
status: "active"
automation_id: "WF004__intelligence-hub-input"
goal_id: "goal-g04"
systems: ["S03", "S04"]
owner: "Michał"
created: "2026-02-03"
updated: "2026-02-07"
---

# WF004: Intelligence Hub Input Processing

## Purpose
Accept multi-source, multi-format input and normalize it to a standard text structure for downstream AI processing and intelligence extraction.

## Triggers
| Trigger | Type | Configuration |
|---------|------|---------------|
| Telegram Input | TelegramTrigger | Listens for `message` and `callback_query` events |
| Webhook | HTTP POST | Path: `/intelligence-hub`, Response mode: responseNode |
| Chat | LangChain ChatTrigger | n8n built-in chat interface |

## Inputs

### Telegram Message Structure
```json
{
  "message": {
    "message_id": 123,
    "from": { "id": 7689674321, "username": "user" },
    "chat": { "id": 7689674321, "type": "private" },
    "date": 1738591234,
    "text": "message content",
    "document": { "file_id": "...", "file_name": "file.pdf", "mime_type": "application/pdf" }
  }
}

Webhook Body Structure

{
  "body": {
    "text": "content to process",
    "type": "optional_format_override",
    "extraction_method": "optional_method_override",
    "callback_url": "https://example.com/callback",
    "telegram_chat_id": "optional_telegram_id_for_response"
  }
}

Chat Input Structure

{
  "chatInput": "user message",
  "sessionId": "session-123"
}

Processing Logic
Stage 1: Format Detection

    Source Identification
        Check for message.chat → Telegram
        Check for chatInput → Chat
        Check for body → Webhook

    Format Detection (Telegram Documents)

# Priority-based detection
if (fileName.endsWith('.pdf') || mimeType === 'application/pdf') → 'pdf'
if (fileName.endsWith('.csv') || mimeType === 'text/csv') → 'csv'
if (fileName.endsWith('.json') || mimeType === 'application/json') → 'json'
if (fileName.endsWith('.xml') || mimeType includes 'xml') → 'xml'
if (audio extensions or mimeType.startsWith('audio/')) → 'audio'
if (video extensions or mimeType.startsWith('video/')) → 'video'
if (text extensions) → 'text_file'
if (excel extensions) → 'excel'
if (word extensions) → 'word'
else → 'document'

URL Detection (Text Input)

    # YouTube pattern
    /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/shorts\/)([a-zA-Z0-9_-]+)/

    # General URL pattern
    /https?:\[^\s]+/

    Metadata Generation
        Generate trace ID: ${Date.now()}-${random_string}
        Build response endpoint based on source
        Include user authorization data

Stage 2: Content Extraction
Route 	Extraction Process
direct 	Pass-through raw_content
whisper 	Telegram Download → Groq Whisper API
video_whisper 	Telegram Download → Groq Whisper API
youtube 	Call YouTube Transcript sub-workflow
web 	HTTP GET → Strip HTML → Clean text
vision 	Telegram Download → (placeholder)
pdf 	Telegram Download → n8n Extract From File (pdf)
csv 	Telegram Download → n8n Extract (text) → Custom parser
json 	Telegram Download → n8n Extract (text) → JSON.parse
xml 	Telegram Download → n8n Extract (text) → Element analysis
text_file 	Telegram Download → n8n Extract (text)
excel 	Return placeholder message
word 	Return placeholder message
document 	Return placeholder message
CSV Parser Logic

# Parse CSV to structured markdown
1. Split by newlines, filter empty
2. Extract headers from first line
3. Parse remaining rows
4. Generate markdown table (first 10 rows)
5. Include full raw data in code block
6. Return metadata: columns, row_count, sample_rows

JSON Parser Logic

# Parse JSON to structured analysis
1. Attempt JSON.parse()
2. If success:
   - Detect Array vs Object
   - Count items/keys
   - Extract structure (keys, types)
   - Show sample items (first 5)
   - Include full formatted JSON
3. If failure:
   - Return parse error
   - Include raw content for debugging

Outputs
Normalized Output Structure

{
  "stage": "text_normalized",
  "metadata": {
    "trace_id": "string",
    "source": "telegram|webhook|chat",
    "chat_id": "number|null",
    "response_endpoint": { /* routing info */ }
  },
  "normalized": {
    "text": "extracted content",
    "text_length": 1234,
    "word_count": 200,
    "extraction_source": "pdf_parser|csv_parser|..."
  },
  "enrichment": {
    "pdf_metadata": { /* if PDF */ },
    "csv_metadata": { /* if CSV */ },
    "json_metadata": { /* if JSON */ }
  },
  "parsed_data": {
    "csv_parsed": { /* structured CSV data */ },
    "json_parsed": { /* parsed JSON object */ }
  }
}

Dependencies
Systems

    S03 Data Layer - Data normalization
    S04 AI Processing - Downstream consumption

External Services
Service 	Purpose 	Authentication
Telegram Bot API 	Message receiving, file download 	Bot token: "{{API_SECRET}}" n8n credential
Groq API 	Whisper transcription 	API key via n8n credential
YouTube Transcript Service 	Video transcripts 	Sub-workflow call
Credentials
Credential ID 	Name 	Used For
XDROmr9jSLbz36Zf 	Telegram (AndrzejSmartBot) 	All Telegram operations
jVObO4RMF7AJe9DN 	Groq account 	Whisper transcription
Sub-workflows
Workflow ID 	Name 	Purpose
wH4hbIMadI4Gh2lq 	YouTube Transcript Service 	Extract transcripts from YouTube URLs
Error Handling
Failure Scenario 	Detection 	Response 	Alert
Unknown format 	No extraction method matched 	Fallback Response node → Telegram error message 	Log trace ID
Telegram file download fails 	HTTP error from Telegram API 	Workflow fails, error logged 	Check Telegram bot status
Groq API timeout 	120s timeout exceeded 	Transcription fails 	Check Groq API status
JSON parse error 	JSON.parse() throws 	Return error message with parse details 	None (expected for invalid JSON)
CSV parse error 	Empty file or malformed 	Return raw text, empty metadata 	None
Unauthorized user 	User ID ≠ authorized_user_id 	"Access Denied" message 	Log attempt
Monitoring
Success Metrics

    Stage 2 completion rate (normalized output generated)
    Format detection accuracy (correct extraction method selected)
    Extraction success rate per format type

Logging

console.log(`[${traceId}] SOURCE: ${source}, FORMAT: ${inputFormat}, METHOD: ${extractionMethod}`);
console.log(`[${traceId}] NORMALIZED: ${textLength} chars from ${extractionSource}`);

Alert Conditions

    Consecutive failures > 3 within 1 hour
    Unknown format rate > 10%
    Groq API errors

Manual Fallback
If Telegram trigger fails:

    Check Telegram bot webhook status
    Verify bot token: "{{API_SECRET}}" valid
    Test with BotFather /getWebhookInfo

If file extraction fails:

    Download file manually via Telegram API
    Extract locally using appropriate tool
    Submit extracted text via Webhook trigger

Testing Commands

# Test webhook with text
curl -X POST https://your-n8n-instance/webhook/intelligence-hub \
  -H "Content-Type: application/json" \
  -d '{"body": {"text": "Test message"}}'

# Test webhook with format override
curl -X POST https://your-n8n-instance/webhook/intelligence-hub \
  -H "Content-Type: application/json" \
  -d '{"body": {"text": "{\"key\": \"value\"}", "type": "json"}}'

Configuration
Authorized Users

Located in "Configuration" node:

{
  "github_owner": "brostudiodev",
  "github_repo": "autonomous-living",
  "authorized_user_id": "7689674321"
}

Notification Messages

Located in "Prepare Notification" node:

const notifications = {
  'youtube_url': '🎬 Processing YouTube video...', 
  'voice': '🗣️ Transcribing voice message...', 
  'audio': '🎵 Processing audio file...', 
  'video': '🎥 Processing video...', 
  'pdf': '📄 Processing PDF document...', 
  'csv': '📊 Processing CSV file...', 
  'json': '🔣 Processing JSON file...', 
  'xml': '📑 Processing XML file...', 
  // ... etc
};

Related Documentation

    Project: P01 Intelligence Hub
    Goal: G04 Digital Twin Ecosystem
    SOP: Daily-Intelligence-Review (if exists)
    Runbook: Telegram-Bot-Recovery (if exists)
    - [WF002: SVC_Command-Handler](../WF002__svc-command-handler.md)
    - [WF003: SVC_Response-Dispatcher](../WF003__svc-response-dispatcher.md)
    - [WF005: SVC_Input-Normalizer](./WF005__svc-input-normalizer.md)

Changelog
2026-02-03

    Initial implementation with 15 format support
    Added PDF, CSV, JSON, XML extraction
    Placeholder nodes for Excel, Word, OCR
