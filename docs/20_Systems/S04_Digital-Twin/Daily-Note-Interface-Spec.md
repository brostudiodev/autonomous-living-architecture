---
title: "Interface Spec: Obsidian Daily Note"
type: "interface_spec"
status: "active"
owner: "Michal"
updated: "2026-04-01"
---

# 📝 Interface Spec: Obsidian Daily Note

## 🎯 Purpose
The **Obsidian Daily Note** is the primary human interface for the Autonomous Living Ecosystem. It serves as the Command Center where decisions are approved, biometrics are visualized, and daily reflections are stored.

## 🏗️ Structural Integrity (Markers)
The `autonomous_daily_manager.py` uses **Surgical Markers** (`%%TAG_START%%` and `%%TAG_END%%`) to inject data. 

### ⚠️ CRITICAL RULE for AI Engineers
**DO NOT remove or rename these markers.** Removing them causes data loss and breaks the automation flow. If a section is missing from the rendered note, check if the marker exists in the file first.

## 🔐 Data Integrity (YAML Safety)
To prevent sexagesimal (Base-60) parsing errors in YAML (where `23:05` might be interpreted as a number `1385`), the following rules apply:

1.  **Time Quoting:** All time-based strings (e.g., `sleep_start`, `sleep_end`, `workout_time`) **MUST** be wrapped in double quotes (e.g., `sleep_start: "22:00"`).
2.  **String Enforcement:** Any field that could be misinterpreted as a number or boolean by a standard YAML parser must be explicitly quoted.
3.  **Automation Compliance:** The `autonomous_daily_manager.py` script is the primary enforcer of this rule during frontmatter restoration.

## 📋 Required Sections & Content Map
This table defines exactly what must be in the Daily Note.

| Marker | Section Title | Source Script | Expected Content |
| :--- | :--- | :--- | :--- |
| `CONN` | System Connectivity | `G11_meta_mapper.py` | Status of Digital Twin API, Scripts, and Decisions. |
| `MEMORY` | One thing to remember | `autonomous_daily_manager.py` | Top-level automated insight for the day. |
| `TASKS` | Google Tasks Sync | `G10_task_sync.py` | Google Tasks integration. |
| `QUICK_WINS` | Quick Wins | `G11_quick_wins.py` | Low-hanging fruit tasks for immediate execution. |
| `SCHEDULE` | Suggested Schedule | `WF010_Schedule-Negotiator` (n8n) | Bio-optimized time blocks. |
| `FRICTION` | Friction Analysis | `WF011_Friction-Resolver` (n8n) | Automated frustration & system gap analysis. |
| `FOCUS` | Focus Mode Intelligence | `G10_focus_intelligence.py` | Office environment and cognitive readiness. |
| `AI_PRIORITIES` | AI Suggested Priorities | `autonomous_daily_manager.py` | Top 5 recommended tasks. |
| `G03` | After Work - Overview | `G03_meal_planner.py` | Chef's Choice and Price Intelligence. |
| `GOAL_PROGRESS` | Goal Progress Tracking | `G12_goal_progress_orchestrator.py` | Automated summary of goal activities. |
| `JOURNAL` | AI Journaling: Runtime Log | `G10_journal_data_collector.py` | Log of automated decisions and interactions. |
| `MISSION` | Today's Mission | `G11_mission_aggregator.py` | A clean 3-sentence AI directive (CEO focus). |
| `RICH_MISSION` | Strategic Steps | `G12_context_resumer.py` | Detailed roadmap tasks and quick starts. |

... (rest of the content map remains as reference)

## ✨ UX Logic: Smart Collapsing (Callouts)
As of **April 01, 2026**, the `autonomous_daily_manager.py` enforces a "Surgical Focus" UI using **Obsidian Collapsible Callouts**:
- **Syntax:** `> [!type]- Title` (collapsed) or `> [!type]+ Title` (expanded).
- **Collapsed by Default:** Any section marked as "Healthy" or "Within normal bounds" is rendered in a closed state to reduce scroll fatigue.
- **Auto-Expanded:** If a section contains critical keywords (e.g., `Alert`, `Anomaly`, `Breach`, `Urgent`, `Failure`, `Train Today`), it is automatically rendered in an open state to ensure the CEO sees it.
- **Formatting:** Using callouts ensures that Markdown headers, lists, and tables inside the reports are rendered natively by Obsidian.

## 🗺️ Visual Map (Expected Structure)
The sequence is optimized for **Interaction First**:

1.  **YAML Frontmatter**
2.  **System Actions** (Buttons)
3.  **System Connectivity** - `%%CONN%%`
4.  **Header** (`# YYYY-MM-DD – Daily`)
5.  **One thing to remember** - `%%MEMORY%%`
6.  **Backlog & Tasks** - `%%TASKS%%` / `%%QUICK_WINS%%`
7.  **Schedule** - `%%SCHEDULE%%` / `%%FOCUS%%`
8.  **Manual Planning** - `%%AI_PRIORITIES%%` / `%%MANUAL_TASKS%%`
9.  **Power Goals Selection**
10. **Goal Progress** - `%%GOAL_PROGRESS%%`
11. **AI Journaling** - `%%JOURNAL%%`
12. **Automated Dashboard** (Health, Finance, Content, etc.)

---
## 🤖 Manager Logic (`autonomous_daily_manager.py`)
The manager script performs surgical updates using the markers defined above. It runs in three distinct phases:
1. **Fetch:** Aggregates data from 20+ sources.
2. **Inject:** Replaces content between markers in the active Daily Note using `inject_marker` and `wrap_collapsible` logic.
3. **Commit:** Pushes the updated note to the Second Brain repository via Git.

---
*Documentation synchronized with exhaustive structural requirements 2026-04-01.*
