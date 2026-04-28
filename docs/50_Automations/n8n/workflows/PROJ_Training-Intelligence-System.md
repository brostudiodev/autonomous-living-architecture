---
title: "N8N Workflow: Training Intelligence System"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Training-Intelligence-System"
goal_id: "goal-g01"
systems: ["S03", "S04"]
owner: "Michał"
updated: "2026-04-18"
---

# Training Intelligence System (N8N)

## Purpose
An autonomous agentic workflow that provides deep intelligence and analysis for Michał's training data. It interfaces with the `autonomous_training` database to answer queries about workout history, progression, and body composition.

## Triggers
- **ExecuteWorkflowTrigger**: Called by the central Router or Digital Twin API.
- **Manual Trigger**: For testing and debugging.

## Inputs
- **`query`**: Natural language question about training or weight.
- **`days_lookback`**: Number of days to retrieve data for (Default: **90 days**, upgraded from 60 on Apr 18).

## Processing Logic
1.  **Normalization**: Extracts the clean query and sets the `days_lookback`.
2.  **Data Retrieval**: Performs parallel PostgreSQL queries to:
    -   Fetch workout sessions (`workouts` table).
    -   Fetch detailed sets and failure data (`workout_sets` table).
    -   Fetch bodyweight and body fat measurements (`measurements` table).
3.  **Context Building**: A JavaScript code node merges the raw SQL results into a compact, hierarchical JSON object optimized for LLM token efficiency.
4.  **AI Analysis**: A Gemini-powered agent uses the HIT (High Intensity Training) philosophy to analyze the data and formulate a response.
5.  **Response Formatting**: Standardizes the output for the Router or Telegram.

## Key Features
- **HIT Philosophy Aware**: The agent understands concepts like TUT (Time Under Tension), muscular failure, and recovery requirements.
- **Bi-lingual**: Supports Polish and English automatically.
- **90-Day Vision (NEW Apr 18)**: Expanded data lookback from 60 to 90 days to ensure full coverage of historical months (e.g., February data remains visible in April).

## Verification & Fallback
- **Database Connection**: Uses `haLW6cBWakuIUaNj` credentials.
- **Empty Data Handling**: Sends a Gmail alert if no training data is found in the specified range.
- **Manual Fallback**: If the agent fails, use direct SQL queries via `/query training | SELECT...` in Digital Twin API.
