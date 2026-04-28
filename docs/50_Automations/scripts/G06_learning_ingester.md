---
title: "Automation Spec: G06 Learning Ingester"
type: "automation_spec"
status: "active"
automation_id: "G06_learning_ingester"
goal_id: "goal-g06"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-03-26"
---

# G06: Learning Ingester

## Purpose
Automates the transition of raw study notes into structured, atomic knowledge assets. This script ensures that learning compounds over time by linking new concepts to existing 2026 goals and existing vault notes.

## Triggers
- **Telegram Command:** `/study [raw text]` (Saves to Inbox).
- **Daily Manager:** Processes files in `Obsidian Vault/00_Inbox/Learning`.

## Inputs
- **Raw Markdown:** Files in the dedicated Obsidian inbox.
- **AI Reasoning:** Gemini Pro for concept extraction and linking.

## Processing Logic
1.  **Scanning:** Looks for `.md` files in the `Learning` inbox.
2.  **AI Transformation:**
    *   Extracts a concise title.
    *   Rewrites content into structured Markdown with headers.
    *   Assigns tags and related Goal IDs (G01-G12).
    *   Generates a one-sentence executive summary.
3.  **Database Persistence:** Saves concepts to `learning_concepts` table in `autonomous_learning`.
4.  **Vault Persistence:** Saves the structured note to `06_Brain/Atomic/`.
5.  **Cleanup:** Deletes the raw inbox file after successful ingestion.

## Outputs
- **Atomic Note:** A new, formatted `.md` file in Obsidian.
- **Knowledge Entry:** Row in the PostgreSQL `learning_concepts` table.

## Dependencies
- **Digital Twin API:** For capture via Telegram.
- **Gemini API:** For intelligent structuring.

## Monitoring
- **Daily Note:** "Atomic Learning Ingested" section showing new concepts.
