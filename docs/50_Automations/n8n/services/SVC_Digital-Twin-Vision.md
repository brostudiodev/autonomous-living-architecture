---
title: "SVC_Digital-Twin-Vision: North Star Monitor"
type: "automation_spec"
status: "inactive"
automation_id: "SVC_Digital-Twin-Vision"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michał"
updated: "2026-04-10"
---

# SVC_Digital-Twin-Vision: North Star Monitor

## Purpose
An n8n service workflow that retrieves the 2026 North Star vision and Power Goal intents to provide the user with high-level strategic context.

## Triggers
- **Execute Workflow Trigger:** Called when user asks "What are my goals?" or "Show vision".

## Inputs
- **API Endpoint:** `http://{{INTERNAL_IP}}:5677/vision?format=text`

## Processing Logic
1. **Normalize Router Input** (Code node, lines 19-29): Extracts `query`, `language` (auto-detected), `chat_id`, `source_type`, and `username` from input.
2. **Fetch Twin Vision Intent** (HTTP Request node, line 45): GET request to `http://{{INTERNAL_IP}}:5677/vision?format=text` - fetches North Star vision and Power Goals. Note: Uses placeholder `{{INTERNAL_IP}}` - should be updated.
3. **Format for Dispatcher** (Code node, lines 32-42): Extracts `response_text` from API body, adds metadata, language, timestamp, and formats JSON for dispatcher.

## Outputs
- **Vision Dashboard:** Markdown text showing the North Star and active Power Goals.
