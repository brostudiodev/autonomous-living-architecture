---
title: "SVC: YouTube Transcript"
type: "automation_spec"
status: "active"
automation_id: "SVC_Youtube_Transcript"
goal_id: "goal-g10"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-10"
---

# SVC_Youtube_Transcript

## Purpose
Fetches YouTube video transcripts and provides AI-powered summarization. Used in conjunction with AI agents for video content analysis.

## Triggers
- **Workflow Trigger:** Executed by another workflow (e.g., `ROUTER_Intelligent_Hub`).
- **Input:** Video URL or video_id.

## Inputs
- **Video URL:** YouTube link (youtube.com/watch?v= or youtu.be/)
- **Video ID:** Extracted from URL.

## Processing Logic
1. **Initialize & Extract Video ID** (Code node, lines 21-31): Extracts video_id from URL or direct input.
2. **IF: Has Video ID?** (IF node): Validates video_id exists.
3. **Get YouTube Subtitle** (YouTube node): Fetches transcript using YouTube API.
4. **Format Transcript** (Code node): Processes transcript text.
5. **AI Summarization** (LLM Chain node): Generates summary via Gemini.
6. **Send to User** (Telegram node): Delivers summary.

## Outputs
- **Transcript:** Full video transcript.
- **Summary:** AI-generated summary.
- **Telegram:** Formatted message with summary.

## Dependencies
### Systems
- [S08 Automation Orchestrator](../../../20_Systems/S08_Automation-Orchestrator/README.md)

### External Services
- YouTube Data API v3.
- Google Gemini API.
- Telegram Bot.

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No video_id | IF node (video_id empty) | "Please provide YouTube URL" | Telegram |
| API error | YouTube node error | Error message | n8n Execution log |

## Security Notes
- YouTube API key stored in n8n credential store.
- Telegram credentials stored in n8n credential store.

## Manual Fallback
```bash
# Get transcript manually via yt-dlp
yt-dlp --write-subs --skip-download "VIDEO_URL"
```