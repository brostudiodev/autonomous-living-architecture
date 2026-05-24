---
title: "SVC: LLM Draft Content"
type: "automation_spec"
status: "active"
owner: "Michał"
updated: "2026-05-02"
---

# SVC_LLM_Draft-Content

## Purpose
Acts as the expert Content Strategist for @Automationbro. It takes structured content ideas and transforms them into high-engagement drafts for LinkedIn and Substack, maintaining a consistent professional/technical voice.

## Scope
- **In Scope:** Drafting from Obsidian idea files, LinkedIn formatting, tone-of-voice alignment.
- **Out Scope:** Image generation, auto-posting (Manual copy-paste required for safety).

## Data Flow (Inputs/Outputs)

### Input (JSON via Webhook)
```json
{
  "target_platform": "linkedin",
  "title": "Autonomous Living ROI",
  "hook": "I reclaimed 2 hours of my life today.",
  "key_points": ["System automated pantry", "Focus-Guard activated"]
}
```

### Output (JSON)
```json
{
  "output": "## 📝 LinkedIn Draft\n\nI reclaimed 2 hours of my life today...\n\n[Full Draft Content]"
}
```

## Dependencies
- **Service:** Google Gemini SDK
- **Voice Profile:** Defined in n8n system message.
- **Trigger:** `G02_linkedin_drafter.py`

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Tone Mismatch | Post sounds too 'corporate' | Human review in Obsidian Inbox identifies need for prompt adjustment. |
| Hallucination | Post claims features not in key_points | human editor rejects draft. |

## Security Notes
- Drafts are stored in `00_Inbox/LinkedIn-Drafts` (Private Vault).

## Owner + Review Cadence
- **Owner:** Michał
- **Review:** Monthly (Check engagement metrics vs draft style)
