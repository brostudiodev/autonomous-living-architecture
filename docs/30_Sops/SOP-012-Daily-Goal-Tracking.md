# SOP-012: Daily Goal Progress Tracking (Hybrid System)

## 🎯 Purpose
To ensure that every action taken towards the **12 Power Goals** is captured both through **Human Context** (Obsidian manual notes) and **System Telemetry** (automated script tracking), creating a complete audit trail for the Digital Twin.

## 🏗️ Structure (Obsidian Daily Note)
Every Daily Note contains two distinct goal-tracking sections:

1.  **### Choose Today’s Power Goals (max 3)**
    *   **Manual Entry:** The user selects up to 3 goals for a deep-focus session.
    *   **Fields:** `Did` (qualitative notes) and `Next` (planned steps).
    *   **Automation Trigger:** `G09_sync_daily_goals.py` (Manual: `Ctrl+Shift+G`).

2.  **### Goal Progress Tracking (Automated)**
    *   **System Entry:** Populated by `G12_goal_progress_orchestrator.py`.
    *   **Source:** Identified from completed tasks and system-level telemetry.
    *   **Markers:** Encapsulated in `%%GOAL_PROGRESS_START%%` and `%%GOAL_PROGRESS_END%%`.

## 🔄 Workflow

### Step 1: Manual Commitment (Evening/Morning)
*   Review the **Choose Today’s Power Goals (max 3)** list.
*   Check exactly **3 goals** you intend to move forward.
*   Optionally fill in the `Next` field to set your intention.

### Step 2: Automated Orchestration (Continuous)
*   As tasks are checked off (`- [x] task name`), the **Digital Twin Orchestrator** assigns them to a goal ID based on keyword analysis.
*   System-wide achievements (e.g., "G05: Auto-Rebalanced 3 Budgets") are injected into the automated section.

### Step 3: Evening Reflection & Sync
*   Open the Daily Note at the end of the day.
*   Fill in any qualitative notes in the **Choose Today’s Power Goals** section (Did/Next).
*   **Trigger Sync:** Run `Ctrl+Shift+G` or `python G09_sync_daily_goals.py`.
    *   This pushes your manual notes to the `Activity-log.md` in each goal's folder in the Git repository.

## 🛠️ Troubleshooting
*   **Goal markers missing:** If `%%GOAL_PROGRESS%%` is missing, the orchestrator will attempt a fallback update of the manual checkboxes. Ensure markers exist in `Daily Note Template.md`.
*   **Sync failure:** Verify that your goal links follow the format `[P - Workout - Reach Target Body Fat](P - Workout - Reach Target Body Fat.md)` and that the `GXX` code is correct.

---
*Created: 2026-03-29*  
*Version: v1.1 (Surgical Maintenance Update)*
