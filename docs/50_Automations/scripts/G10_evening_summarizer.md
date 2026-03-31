---
title: "Automation Spec: G10_evening_summarizer.py"
type: "automation_spec"
status: "active"
automation_id: "G10_evening_summarizer"
goal_id: "goal-g10"
systems: ["S04", "S10"]
owner: "Michal"
updated: "2026-03-26"
---

# 🤖 Automation Spec: G10_evening_summarizer.py

## 📝 Overview
**Purpose:** Surgically injects qualitative reflection data and raw journaling logs into the Obsidian Daily Note.
**Goal Alignment:** G10 Intelligent Productivity (Subjective Context) and G04 Digital Twin (Memory).

## ⚡ Technical Details
- **Language:** Python
- **Triggers:** Called by `G04_digital_twin_api.py` upon receiving a reflection submission.
- **Databases:** PostgreSQL (`digital_twin_michal.reflection_answers`)
- **Dependencies:** `os, re, json, psycopg2, argparse`

## 🛠️ Logic Flow
1.  **Data Retrieval:** Fetches a specific reflection answer (by ID) or the latest one from the database.
2.  **File Identification:** Locates the Obsidian Daily Note matching the `answer_date`.
3.  **Marker Parsing:** Identifies `%%REFLECTION%%` and `%%JOURNAL%%` blocks in the Markdown file.
4.  **Multi-Session Injection:**
    *   **REFLECTION:** Replaces existing content with the latest AI-generated summary + structured fields (Emotions, Decisions, Interactions).
    *   **JOURNAL:** Appends the raw response and timestamp to the existing log, preserving previous sessions for that day.
5.  **Persistence:** Overwrites the Daily Note with the updated content.

## 📤 Outputs
- **Obsidian Mutation:** Updated `.md` file in `01_Daily_Notes/`.
- **CLI Log:** Success/failure confirmation.

## ⚠️ Known Issues / Maintenance
- **Marker Integrity:** If the `%%TAG_START%%` or `%%TAG_END%%` markers are deleted from the Daily Note, the injection will fail silently (no change).
- **File Locks:** If Obsidian is actively saving the file, there is a theoretical (but rare) race condition.

---
*Updated: 2026-03-26 | Integrated with Reflection Bridge v1.2*
