---
title: "SVC: Format Detector Extractor"
type: "service_spec"
status: "active"
service_id: "SVC_Format-Detector-Extractor"
goal_id: "goal-g11"
systems: ["S04", "S08", "S11"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC: Format Detector Extractor

## Purpose
Multi-format input detection and content extraction service that identifies input type (text, voice, YouTube, web URL, PDF, CSV, JSON, XML) and extracts text content using appropriate methods. This is the critical preprocessing step that enables the system to understand any format of user input.

## Triggers

| Trigger | Type | Configuration |
|---------|------|---------------|
| **Workflow Trigger** | Execute Workflow | Called by ROUTER_Intelligent_Hub |

**Workflow ID:** `e8ra0WcR4TalzD7NpA7UD`

## Supported Formats

| Format | Extraction Method | Status |
|--------|-------------------|--------|
| Plain Text | `direct` | ✅ Fully implemented |
| Voice/Audio | `whisper_stt` | ✅ Fully implemented |
| YouTube URL | `youtube_transcript` | ✅ Fully implemented |
| Web URL | `web_scraper` | ✅ Fully implemented |
| PDF | `pdf_parser` | ✅ Fully implemented |
| CSV | `csv_parser` | ✅ Fully implemented |
| JSON | `json_parser` | ✅ Fully implemented |
| XML | `xml_parser` | ✅ Fully implemented |
| Text File (.txt, .md) | `direct_text` | ✅ Fully implemented |
| Image | `vision_ocr` | ⚠️ Caption only (OCR not implemented) |
| Excel | `excel_parser` | ⚠️ Placeholder |
| Word | `word_parser` | ⚠️ Placeholder |

## Processing Flow

```
┌─────────────────────────┐
│     Workflow Input      │  Passthrough input
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Stage 1: Detect Format  │  Code: Auto-detect input format & extraction method
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│   Route to Extractor    │  Switch: 14 format branches
└────────┬────────────────┘
         │
    ┌────┼────┬────┬────┬────┬────┬────┬────┐
    ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼
 direct whisper youtube  web  pdf  csv  json xml text
    │    │    │    │    │    │    │    │    │
    ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼
┌─────────────────────────────────────────────┐
│           Format & Return                    │  Code: Normalize output structure
└─────────────────────────────────────────────┘
```

## Detailed Processing Logic

### Stage 1: Format Detection
- **Node:** `Stage 1: Detect Format` (Code)
- **Input Analysis:** Examines `input.raw_content`, `input.format`, `input.file_id`, `input.additional_data`
- **Format Detection Rules:**

| Input Pattern | Detected Format | Extraction Method |
|---------------|-----------------|-------------------|
| Plain text message | text | `direct` |
| Telegram voice file | audio_voice | `whisper_stt` |
| YouTube URL (youtube.com, youtu.be) | youtube_url | `youtube_transcript` |
| Web URL (https://...) | web_url | `web_scraper` |
| Telegram photo with caption | image | `vision_ocr` |
| File attachment .pdf | pdf | `pdf_parser` |
| File attachment .csv | csv | `csv_parser` |
| File attachment .json | json | `json_parser` |
| File attachment .xml | xml | `xml_parser` |
| File attachment .txt/.md | text_file | `direct_text` |
| File attachment .xlsx | excel | `excel_parser` (placeholder) |
| File attachment .docx | word | `word_parser` (placeholder) |

- **Dynamic Credential Support:** Reads `_telegram_credential` from caller for backward compatibility
- **Response Endpoint:** Creates unified structure for all source types

### Stage 2: Route to Extractor
- **Node:** `Route to Extractor` (Switch)
- Routes to appropriate extraction branch based on `input.extraction_method`

### Stage 3: Extraction Methods

#### 1. Direct Text (`direct`)
- **Node:** `Direct Text` (Code)
- Returns `input.raw_content` as `extracted_text`
- Extraction source: `direct_input`

#### 2. Whisper STT (`whisper_stt`)
- **Node:** `STT: Download` (Telegram) → `STT: Prepare Audio` (Code) → `Gemini: STT` (HTTP) → `STT: Format` (Code)
- Downloads voice file from Telegram
- Converts to base64 for Gemini
- Uses Gemini 2.0 Flash for transcription
- Returns: `extracted_text`, `transcript_language`

#### 3. YouTube Transcript (`youtube_transcript`)
- **Node:** `YouTube: Prepare` → `YouTube: Call SVC` (Execute Workflow) → `YouTube: Format`
- Calls `SVC_Youtube_Transcript` sub-workflow (ID: `wH4hbIMadI4Gh2lq`)
- Returns: `extracted_text`, `youtube_metadata`, `word_count`

#### 4. Web Scraper (`web_scraper`)
- **Node:** `Web: Fetch` (HTTP) → `Web: Extract` (Code)
- Fetches HTML from URL
- Strips `<script>`, `<style>` tags
- Converts HTML to plain text
- Extracts `<title>` for metadata
- Returns: `extracted_text`, `web_metadata` (url, title)

#### 5. PDF Parser (`pdf_parser`)
- **Node:** `PDF: Download` (Telegram) → `PDF: Extract` (Extract from File) → `PDF: Format`
- Downloads PDF from Telegram
- Extracts text using n8n's extractFromFile node
- Returns: `extracted_text`, `pdf_metadata` (file_name, text_length, word_count)

#### 6. CSV Parser (`csv_parser`)
- **Node:** `CSV: Download` → `CSV: Extract` → `CSV: Format`
- Downloads CSV file
- Parses headers and rows
- Generates Markdown table preview
- Returns: `extracted_text` (Markdown), `csv_metadata` (columns, row_count)

#### 7. JSON Parser (`json_parser`)
- **Node:** `JSON: Download` → `JSON: Extract` → `JSON: Format`
- Downloads JSON file
- Analyzes structure (Array vs Object)
- Generates formatted analysis
- Returns: `extracted_text` (Markdown), `json_metadata` (type, item_count)

#### 8. XML Parser (`xml_parser`)
- **Node:** `XML: Download` → `XML: Extract` → `XML: Format`
- Downloads XML file
- Counts elements
- Generates structure summary
- Returns: `extracted_text`, `xml_metadata` (element_count)

#### 9. Direct Text File (`direct_text`)
- **Node:** `Text File: Read` → `Text File: Format`
- Reads .txt or .md file
- Returns raw text content

#### 10. Vision/OCR (`vision_ocr`)
- **Node:** `Vision: Download` → `Vision: Process`
- Downloads image from Telegram
- Returns caption (OCR not yet implemented)
- Returns: `extracted_text` (caption or placeholder)

### Stage 4: Output Formatting
- **Nodes:** `*Format` (Code) - Each extraction branch has a formatter
- Normalizes output structure:
  ```json
  {
    "stage": "text_extracted",
    "extracted_text": "...",
    "extraction_source": "method_name",
    "[format_metadata]": {...}
  }
  ```

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
  "input": {
    "raw_content": "https://youtube.com/watch?v=abc123",
    "format": "youtube_url",
    "extraction_method": "youtube_transcript"
  }
}
```

## Outputs

```json
{
  "stage": "text_extracted",
  "extracted_text": "Transcribed content from the input...",
  "extraction_source": "youtube_transcript",
  "input": {
    "format": "youtube_url",
    "extraction_method": "youtube_transcript"
  },
  "youtube_metadata": {
    "title": "Video Title",
    "channel": "Channel Name",
    "duration": "10:30"
  },
  "_router": {
    "trigger_source": "telegram",
    "chat_id": "{{TELEGRAM_CHAT_ID}}"
  }
}
```

## Dependencies

### Systems
- [S04 Digital Twin](../../../20_Systems/S04_Digital-Twin/README.md) - State queries
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md) - Workflow execution
- [S11 Meta-System Integration](../../../20_Systems/S11_Meta-System-Integration/README.md) - Cross-system coordination

### Called By
- [ROUTER_Intelligent-Hub.md](./ROUTER_Intelligent-Hub.md) - Primary caller

### Sub-Workflows
- **SVC_Youtube_Transcript** (ID: `wH4hbIMadI4Gh2lq`) - YouTube transcript extraction

### External Services
- **Telegram Bot API** - File downloads (voice, photo, documents)
- **Google Gemini API** - STT transcription (gemini-2.0-flash)
- **Web URLs** - HTML scraping

## Error Handling

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| YouTube transcript fails | Sub-workflow returns success: false | Return error text with `youtube_error` | Log to console |
| Web fetch timeout | HTTP timeout (30s) | Return "[Web fetch timeout]" | n8n error workflow |
| PDF extraction fails | extractFromFile error | Return "[PDF parse error]" | n8n error workflow |
| JSON parse fails | JSON.parse exception | Return raw text with warning | Log to console |
| Unsupported format | Switch fallback | Return "[Unknown format]" | None |

## Manual Fallback

### Test via Workflow Execute:
```bash
curl -s -X POST http://localhost:5678/rest/workflow/e8ra0WcR4TalzD7NpA7UD/execute \
  -H "Content-Type: application/json" \
  -d '{
    "input": {
      "raw_content": "Hello world",
      "format": "text",
      "extraction_method": "direct"
    },
    "_router": {
      "trigger_source": "telegram",
      "chat_id": "{{TELEGRAM_CHAT_ID}}"
    }
  }'
```

### Test specific format (YouTube):
```bash
curl -s -X POST http://localhost:5678/webhook/intelligence-hub \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "chat": {"id": "{{TELEGRAM_CHAT_ID}}"},
      "text": "https://youtube.com/watch?v=dQw4w9WgXcQ"
    }
  }'
```

## Security Notes

- **File Downloads:** All file downloads go through Telegram Bot API
- **External URLs:** Web scraping only works for user-provided URLs (no arbitrary crawling)
- **API Keys:** Gemini API key stored in workflow credentials

---

*Documentation synchronized with svc_format-detector-extractor.json v1.0 (2026-04-10)*