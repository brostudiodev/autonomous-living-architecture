---
title: "G02: LinkedIn Content Drafter"
type: "automation_spec"
status: "active"
automation_id: "G02_linkedin_drafter.py"
goal_id: "goal-g02"
systems: ["S02", "S04"]
owner: "Michal"
updated: "2026-03-11"
---

# G02: LinkedIn Content Drafter

## Purpose
Automatically generates high-engagement LinkedIn post drafts from newly published Substack articles in the Obsidian Vault. This closes the gap between long-form writing and social distribution.

## Triggers
- **Automated:** Executed as part of the `G11_global_sync.py` registry (following Substack sync).
- **Manual:** `python3 scripts/G02_linkedin_drafter.py`

## Inputs
- **Substack Articles:** Markdown files in `04_Resources/Automationbro/Articles/`.
- **LLM Engine:** Gemini 1.5 Flash (via Google AI API).
- **Context:** Strategic intent and system state from the Digital Twin.

## Processing Logic
1.  **Content Discovery:** Identifies the most recently modified `.md` file in the Substack articles directory.
2.  **Synthesis:** Sends the first 4000 characters of the article to Gemini with a specialized "Content Strategist" prompt.
3.  **Formatting:** Structure the output with a "Hook," "Insights," "The Why," and a "Call to Action."
4.  **Storage:** Saves the result as a new Markdown draft in `00_Inbox/LinkedIn-Drafts/` with metadata tags.

## Outputs
- **Obsidian Note:** A ready-to-review LinkedIn draft.
- **Centralized Logging:** Reports `SUCCESS` or `FAILURE` to `system_activity_log`.

## Dependencies
### Systems
- [S02 Content Distribution](../../20_Systems/S02_Content-Distribution/README.md)
- [S04 Digital Twin](../../20_Systems/S04_Digital-Twin/README.md)

### External Services
- Google Gemini API (Flash 1.5)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| No Articles Found | Empty glob list | Log warning, exit gracefully | System Activity Log |
| API Timeout | `requests` timeout | Log failure, retry next sync | System Activity Log |
| Missing API Key | `os.getenv` is None | Log critical error | System Activity Log |

## Manual Fallback
If drafts are not generated:
1.  Verify that `G02_substack_sync.py` has successfully downloaded the latest article.
2.  Check the `system_activity_log` for Gemini API errors.
3.  Manually copy article text into the Digital Twin UI with the prompt: "Draft a LinkedIn post for this."
