---
title: "SVC_Digital-Twin-Vision: North Star Monitor"
type: "automation_spec"
status: "active"
automation_id: "SVC_Digital-Twin-Vision"
goal_id: "goal-g04"
systems: ["S04", "S11"]
owner: "Michal"
updated: "2026-02-24"
---

# SVC_Digital-Twin-Vision: North Star Monitor

## Purpose
An n8n service workflow that retrieves the 2026 North Star vision and Power Goal intents to provide the user with high-level strategic context.

## Triggers
- **Execute Workflow Trigger:** Called when user asks "What are my goals?" or "Show vision".

## Inputs
- **API Endpoint:** `http://[INTERNAL_IP]:5677/vision?format=text`

## Processing Logic
1. **Fetch Twin Vision Intent:** Calls the Twin API `/vision` endpoint.
2. **Format for Dispatcher:** Prepares the formatted vision text for Telegram delivery.

## Outputs
- **Vision Dashboard:** Markdown text showing the North Star and active Power Goals.
