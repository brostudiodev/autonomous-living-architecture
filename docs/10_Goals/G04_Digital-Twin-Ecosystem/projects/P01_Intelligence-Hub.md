---
title: "P01: Intelligence Hub - Multi-Format Input Processing"
type: "project"
status: "active"
project_id: "P01"
goal_id: "goal-g04"
owner: "{{OWNER_NAME}}"
created: "2026-02-03"
updated: "2026-02-07"
---

# P01: Intelligence Hub - Multi-Format Input Processing

## Intent
Build a unified input processing system that accepts content from multiple sources (Telegram, Webhook, Chat) and multiple formats (text, voice, video, documents, data files), normalizes them into a standard text format, and prepares them for AI-powered intelligence extraction.

## Definition of Done
- [x] Three input triggers operational (Telegram, Webhook, Chat)
- [x] Format detection for 15+ file types
- [x] Text extraction pipelines for all supported formats
- [x] Normalized output structure for downstream processing
- [ ] Full OCR implementation for images
- [ ] Excel native parsing (currently requires CSV conversion)
- [ ] Word document native parsing

## Supported Formats

### Fully Implemented
| Format | Detection Method | Extraction Method | Output |
|--------|------------------|-------------------|--------|
| Text | Direct input | Pass-through | Raw text |
| Voice | Telegram message type | Groq Whisper STT | Transcription |
| Audio files | Extension/MIME | Groq Whisper STT | Transcription |
| Video | Extension/MIME | Audio extraction → Whisper | Transcription |
| YouTube URL | Regex pattern | External transcript service | Transcript + metadata |
| Web URL | Regex pattern | HTML scraping | Cleaned text |
| PDF | Extension/MIME | n8n Extract From File | Full text |
| CSV | Extension/MIME | Custom parser | Structured markdown + raw |
| JSON | Extension/MIME | Custom parser | Structure analysis + raw |
| XML | Extension/MIME | Custom parser | Element analysis + raw |
| TXT/MD | Extension/MIME | Direct extraction | Full text |

### Placeholder (Requires Conversion)
| Format | Current Behavior | Workaround |
|--------|------------------|------------|
| Excel (.xlsx/.xls) | Error message | Convert to CSV |
| Word (.docx/.doc) | Error message | Convert to PDF |
| Images (OCR) | Caption only | Manual transcription |

## Architecture

### Stage 1: Format Detection

Input Sources Detection Output ───────────────── ────────── ─────── Telegram ─────┐
│ ┌───────────────┐ ┌───────────────────┐ Webhook ──────┼───────▶│ Stage 1: Detect │──────▶│ format_detected │ │ │ │ Format │ │ metadata │ Chat ──────────┘ └───────────────┘ │ extraction_method│ └───────────────────┘


### Stage 2: Content Extraction

                  Route to Service (15 outputs)
                  ─────────────────────────────

format_detected ─────▶│ direct │──▶ Direct Text │ whisper │──▶ Audio → Groq Whisper │ video_whisper │──▶ Video → Audio → Whisper │ youtube │──▶ YouTube Transcript Service │ web │──▶ HTTP Request → HTML Parser │ vision │──▶ Image → OCR (placeholder) │ pdf │──▶ Telegram Download → Extract │ csv │──▶ Telegram Download → Parse │ json │──▶ Telegram Download → Parse │ xml │──▶ Telegram Download → Parse │ text_file │──▶ Telegram Download → Extract │ excel │──▶ Placeholder │ word │──▶ Placeholder │ document │──▶ Placeholder │ fallback │──▶ Error Response └───────────────┘ │ ▼ ┌───────────────┐ │ Stage 2: │ │ Normalize to │ │ Text │ └───────────────┘ │ ▼ ┌───────────────────┐ │ text_normalized │ │ enrichment │ │ parsed_data │ └───────────────────┘


## Data Structures

### Stage 1 Output (format_detected)
```json
{
  "stage": "format_detected",
  "metadata": {
    "trace_id": "1738591234567-abc123xyz",
    "source": "telegram|webhook|chat",
    "chat_id": 7689674321,
    "message_id": 123,
    "user_id": 7689674321,
    "username": "user",
    "session_id": null,
    "timestamp": "2026-02-03T12:00:00.000Z",
    "response_endpoint": {
      "type": "telegram",
      "chat_id": 7689674321,
      "credential_id": "XDROmr9jSLbz36Zf",
      "credential_name": "Telegram (AndrzejSmartBot)"
    }
  },
  "input": {
    "format": "pdf|csv|json|text|voice|...",
    "raw_content": "text content or null for files",
    "file_id": "telegram_file_id or null",
    "extraction_method": "pdf_parser|csv_parser|...",
    "additional_data": {
      "file_name": "document.pdf",
      "mime_type": "application/pdf",
      "file_size": 12345
    }
  },
  "original_message": { /* raw input */ }
}

Stage 2 Output (text_normalized)

{
  "stage": "text_normalized",
  "metadata": { /* same as Stage 1 */ },
  "input": { /* same as Stage 1 */ },
  "normalized": {
    "text": "extracted text content...",
    "text_length": 5000,
    "word_count": 850,
    "extraction_source": "pdf_parser"
  },
  "enrichment": {
    "youtube_metadata": null,
    "web_metadata": null,
    "pdf_metadata": {
      "file_name": "document.pdf",
      "file_size": 12345,
      "text_length": 5000,
      "word_count": 850
    },
    "csv_metadata": null,
    "json_metadata": null,
    "xml_metadata": null,
    "text_file_metadata": null,
    "excel_metadata": null,
    "word_metadata": null
  },
  "parsed_data": {
    "csv_parsed": null,
    "json_parsed": null
  },
  "original_message": { /* raw input */ }
}

CSV-Specific Enrichment

{
  "csv_metadata": {
    "file_name": "data.csv",
    "columns": ["Name", "Email", "Phone"],
    "column_count": 3,
    "row_count": 150,
    "file_size": 4567
  },
  "csv_parsed": {
    "headers": ["Name", "Email", "Phone"],
    "sample_rows": [
      ["John Doe", "{{EMAIL}}", "555-1234"],
      ["Jane Smith", "{{EMAIL}}", "555-5678"]
    ]
  }
}

JSON-Specific Enrichment

{
  "json_metadata": {
    "file_name": "config.json",
    "parse_success": true,
    "parse_error": null,
    "is_array": false,
    "item_count": 5,
    "file_size": 2345
  },
  "json_parsed": { /* actual parsed JSON object */ }
}

Key Links

    Automation: WF004__intelligence-hub-input
    Parent Goal: G04 README
    Systems: Systems.md

Notes

This is the input processing layer of the Intelligence Hub. Downstream processing (Stage 3: Intent Classification, Stage 4: Routing, AI Analysis) is handled by additional workflow nodes not included in this project scope.