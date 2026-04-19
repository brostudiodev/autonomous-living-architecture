---
title: "Content Draft Agent (G13)"
type: "automation_spec"
status: "active"
automation_id: "G13_content_draft_agent.py"
goal_id: "goal-g02"
systems: ["S08"]
owner: "Michal"
updated: "2026-04-04"
---

# 🤖 Automation Spec: G13_content_draft_agent.py

## 📝 Overview
**Purpose:** Automatically generates LinkedIn and Substack content drafts based on the day's technical achievements ("Wins").
**Goal Alignment:** G02 Automationbro Recognition (Content Pipeline)

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Called by `autonomous_evening_manager.py` (during cognitive shutdown).
- **Databases:** None (Direct file system and Gemini API integration)
- **Dependencies:** `requests`, `G09_technical_win_harvester.py`, `G04_digital_twin_notifier.py`

## 🛠️ Logic Flow
1. **Harvesting:** Calls `harvest_wins()` to retrieve today's commits and technical updates.
2. **Consultation:** Sends the harvested context to Gemini (Flash 1.5) with a brand-aligned prompt.
3. **Creation:** Generates two distinct drafts: a professional LinkedIn post and a "Building in Public" Substack snippet.
4. **Storage:** Saves the drafts as a Markdown file in the Obsidian `00_Inbox/Content Ideas/` folder.
5. **Notification:** Sends a Telegram alert when new drafts are ready for review.

## 📤 Outputs
- **Markdown File:** `YYYY-MM-DD - Autonomous Drafts.md` with frontmatter and draft content.
- **Telegram Notification:** Prompt for user review.

## ⚠️ Known Issues / Maintenance
- **AI Context:** Draft quality depends on the clarity of the harvested commit messages/wins.
- **Gemini Key:** Requires a valid `GEMINI_API_KEY` in `.env`.

---
*Content Autonomy v1.0 - April 2026*
