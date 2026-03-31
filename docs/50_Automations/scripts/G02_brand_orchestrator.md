---
title: "Automation Spec: G02 Brand Orchestrator"
type: "automation_spec"
status: "active"
automation_id: "G02_brand_orchestrator"
goal_id: "goal-g02"
systems: ["S02", "S05"]
owner: "Michal"
updated: "2026-03-26"
---

# G02: Brand Orchestrator

## Purpose
Manages the end-to-end content creation pipeline for Automationbro. It ensures a consistent flow of thought leadership by automating idea capture, drafting, and scheduling.

## Triggers
- **Telegram Command:** `/idea [content]` logs to the idea pool.
- **Daily Manager:** Executes the drafting and scheduling logic.

## Inputs
- **Idea Pool:** `brand_ideas` table.
- **Performance Data:** `brand_metrics` for high-impact topic selection.

## Processing Logic
1.  **Idea Capture:** Logs raw concepts from Telegram.
2.  **Drafting:** Identifies new ideas and triggers drafting (integration with `G02_linkedin_drafter.py`).
3.  **Scheduling:** Automatically assigns post dates (Next Tuesday/Thursday) to maintain a consistent cadence.
4.  **Performance Feedback:** Compares upcoming topics with past high-impression metrics to suggest refinements.

## Outputs
- **Content Queue:** Managed in the `content_calendar` table.
- **Drafts:** Markdown or text files ready for review.
- **Daily Report:** Status of the content pipeline in Obsidian.

## Dependencies
- **PostgreSQL:** `autonomous_finance` (brand schema).
- **Gemini API:** For intelligent drafting.

## Monitoring
- **Obsidian:** "Content Pipeline" section in the Daily Note.
