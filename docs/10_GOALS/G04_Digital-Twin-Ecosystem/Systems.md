---
title: "G04: Systems"
type: "goal_systems"
status: "active"
goal_id: "goal-g04"
updated: "2026-02-03"
---

# Systems

## Enabling systems
- [S03 Data Layer](../../20_SYSTEMS/S03_Data-Layer/README.md) - Data normalization and storage
- [S04 AI Processing](../../20_SYSTEMS/S04_AI-Processing/README.md) - Intelligence extraction
- [S05 Telegram Integration](../../20_SYSTEMS/S05_Telegram-Integration/README.md) - Primary user interface

## Traceability (Outcome → System → Automation → SOP/Runbook)

| Outcome | System | Automation | SOP/Runbook |
|---------|--------|------------|-------------|
| Multi-format input processing | S03 Data Layer | [WF004__intelligence-hub-input](../../50_AUTOMATIONS/n8n/workflows/WF004__intelligence-hub-input.md) | - |
| PDF text extraction | S03 Data Layer | WF004 (pdf_parser route) | - |
| CSV data parsing | S03 Data Layer | WF004 (csv_parser route) | - |
| JSON data parsing | S03 Data Layer | WF004 (json_parser route) | - |
| Voice transcription | S04 AI Processing | WF004 (whisper route) → Groq API | - |
| YouTube transcript | S04 AI Processing | WF004 → Sub-workflow wH4hbIMadI4Gh2lq | - |
| User notification | S05 Telegram | WF004 (Send Telegram Notification) | - |
| Access control | S05 Telegram | WF004 (Verify User node) | - |