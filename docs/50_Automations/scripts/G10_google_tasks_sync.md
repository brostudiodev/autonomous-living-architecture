---
title: "Automation Spec: G10_google_tasks_sync.py"
type: "automation_spec"
status: "active"
automation_id: "G10_google_tasks_sync"
goal_id: "goal-g10"
systems: ["S10"]
owner: "Michal"
updated: "2026-04-15"
---

# 🤖 Automation Spec: G10_google_tasks_sync.py

## 📝 Overview
**Purpose:** Synchronizes Google Tasks across multiple task lists into the local Digital Twin environment. It handles authentication, deduplication, and filtering to ensure high-quality task data for triage.
**Goal Alignment:** G10 (Intelligent Productivity) and G04 (Digital Twin).

## ⚡ Technical Details
- **Language:** Python 3.x
- **Triggers:** Part of `G11_global_sync.py` and `autonomous_daily_manager.py`.
- **Databases:** None (Returns objects to callers).
- **Dependencies:** `google-api-python-client`, `google-auth-oauthlib`.

## 🛠️ Logic Flow
1. **Authentication:** 
   - Attempts User Token refresh (`google_tasks_token.pickle`).
   - Fallback to Service Account if user token fails.
2. **List Discovery:** Fetches all available task lists from Google account.
3. **Task Retrieval:** 
   - Iterates through lists (My Tasks, Missions (Autonomous), Suggestions, etc.).
   - Fetches uncompleted tasks.
4. **Deduplication:** Fuzzy matches by title (or status prefix) to keep only the most recent version.
5. **Stale Filter:** Removes tasks due more than 1 year ago.
6. **Limit & Sort:**
   - Sorts by due date.
   - **Limit:** Increased to 50 tasks (previously 15) to prevent hiding current tasks behind older ones.

## 📤 Outputs
- **Task Objects:** List of dictionaries containing `title`, `due`, `list`, and `notes`.

## ⚠️ Known Issues / Maintenance
- **Pickle Refresh:** If the token is manually revoked, `google_tasks_token.pickle` must be deleted to trigger re-auth.
- **API Quotas:** Massive list counts may trigger rate limiting.

---
*Updated: 2026-04-15 | Increased sync depth to 50 tasks for better visibility.*
