---
title: "WF106: Training Intelligence System"
type: "automation_spec"
status: "active"
automation_id: "WF106__Training-Intelligence-System"
goal_id: "goal-gXX" # Please specify your Training/Health goal ID
systems: ["S03", "S07"]
owner: "Michal"
updated: "2026-02-12"
---

# WF106: Training Intelligence System

## Purpose
Bilingual (Polish/English) AI-powered training assistant that analyzes HIT (High Intensity Training) data from PostgreSQL database, applies Mike Mentzer methodology principles, and delivers contextual responses to natural language queries via router workflow integration.

## Triggers

### Primary: Execute Workflow Trigger
- **Node:** `When Executed by Router`
- **Type:** `Execute Workflow Trigger`
- **When:** Called by router workflow when user sends `/training ...` commands
- **Input Format:**
```json
{
  "query": "/training jaki ciężar miałem przy pompkach?",
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "user_id": "123456",
  "username": "Michal",
  "days_lookback": 60
}

Secondary: Manual Trigger

    Node: Manual Trigger (Testing)
    Purpose: Local testing and debugging in n8n UI
    Behavior: Uses default parameters and dummy metadata

Inputs
From Router Workflow

    query (string): Full user text including /training command
        Examples: "/training how many sets did I do 3 days ago?", "/training kiedy był ostatni trening?"
    chat_id (string/number, optional): Response routing identifier
    source_type (string, optional): Origin platform (telegram, discord, api)
    user_id (string/number, optional): User identifier
    username (string, optional): Display name
    days_lookback (number, optional): Data window size (default: 60 days)

From PostgreSQL Database

    workouts table: workout_date, template_id, location, duration_min, recovery_score, mood_score, days_since_last_workout, notes
    workout_sets table: workout_date, template_id, exercise_id, weight_kg, tut_seconds, max_effort, form_ok, notes
    measurements table: measurement_date, bodyweight_kg, bodyfat_pct, notes

Processing Logic
1. Input Normalization (Normalize Router Input)

Responsibilities:

    Strip /training command prefix: rawText.replace(/^\/training\s*/i, '').trim()
    Set intelligent default if empty: cleanQuery || 'Show me my training summary'
    Advanced Language Detection:

const polishKeywords = ['jaki', 'kiedy', 'ile', 'ostatni', 'trening', 'ćwiczenie', 'ciężar', 'pompki', 'waga', 'zrobiłem', 'miałem'];
const englishKeywords = ['what', 'when', 'how', 'many', 'last', 'workout', 'exercise', 'weight', 'sets', 'did', 'was'];
// Language = highest keyword match count

    Forward router metadata (chat_id, source_type, user_id, username)

2. Parallel Database Retrieval

Token-Optimized SQL Queries:

-- Workouts Query
SELECT 
  'workouts' as table,
  workout_date as date,
  template_id as template,
  location as loc,
  duration_min as duration,
  days_since_last_workout as rest_days,
  recovery_score as recovery,
  mood_score as mood,
  notes,
  created_at
FROM workouts 
WHERE workout_date >= CURRENT_DATE - INTERVAL '${days} days' 
ORDER BY workout_date DESC;

-- Sets Query (with progression data)
SELECT 
  'workout_sets' as table,
  workout_date as date,
  template_id as template,
  exercise_id as exercise,
  weight_kg as weight,
  tut_seconds as tut,
  max_effort as failure,
  form_ok as form,
  notes,
  created_at
FROM workout_sets 
WHERE workout_date >= CURRENT_DATE - INTERVAL '${days} days' 
ORDER BY workout_date DESC, exercise_id;

-- Measurements Query (body composition)
SELECT 
  'measurements' as table,
  measurement_date as date,
  bodyweight_kg as weight,
  bodyfat_pct as bodyfat,
  notes,
  created_at
FROM measurements 
WHERE measurement_date >= CURRENT_DATE - INTERVAL '${days} days' 
ORDER BY measurement_date DESC;

3. HIT Intelligence Engine (Code: HIT Intelligence Engine)

Core Analytics:

Data Classification & Raw Storage:

    Separate merged data into typed arrays using SQL table field
    Build comprehensive raw_data structure for manual extraction

HIT Progression Analysis (Mike Mentzer Principles):

// For each exercise, compare latest vs previous session
if (latest.weight > previous.weight) {
  status = 'PROGRESSING';  // Weight increased ✅
  action = 'excellent';
} else if (latest.weight === previous.weight && latest.tut >= 60) {
  status = 'TUT_READY';    // Time Under Tension threshold reached
  action = 'increase_weight';  // Ready for progression
} else if (latest.weight < previous.weight) {
  status = 'REGRESSED';    // Performance decline ⚠️
  action = 'check_recovery';
}

Recovery Analysis:

// HIT-specific recovery assessment
if (avgRestDays < 2 && avgRecovery < 4) {
  status = 'OVERTRAINING_RISK';  // Too frequent, low recovery
} else if (avgRestDays >= 3 && avgRestDays <= 5 && avgRecovery >= 4) {
  status = 'OPTIMAL';  // Ideal HIT frequency
} else if (avgRestDays > 7) {
  status = 'UNDERTRAINING';  // Excessive rest
}

Workout Enrichment:

    Calculate total TUT (Time Under Tension) per workout
    Compute intensity factor (% sets to muscular failure)
    Average weight per workout
    Nest sets within workouts for context preservation

Alert Generation:

    workout_overdue_Xd: No training in 7+ days
    ready_for_increase_Xex: Exercises ready for weight progression (TUT ≥ 60s)
    regression_detected_Xex: Performance decline detected
    overtraining_risk: Frequency vs recovery mismatch

4. AI Context Preparation (Prepare AI Context)

Merges user query metadata with training intelligence for LLM consumption.
5. AI Agent Processing (AI Agent)

Dynamic Bilingual Prompting:

Polish Version:

Jesteś osobistym trenerem i analitykiem danych Michala, specjalizującym się w metodzie HIT...

**ZASADY ODPOWIEDZI:**
1. Odpowiadaj TYLKO na podstawie dostępnych danych
2. Jeśli brak danych - powiedz "Brak danych dla tego zapytania"
3. NIE zadawaj pytań dodatkowych - daj konkretną odpowiedź
4. Używaj konkretnych liczb, dat i wartości z danych
5. Krótko i na temat - max 5-6 linijek
6. Przy pytaniach o ćwiczenia szukaj po polu 'ex' (exercise_id)
7. Daty w formacie YYYY-MM-DD
8. Dla "X dni temu" oblicz datę względem najnowszego treningu

English Version: (Same rules translated)

AI Capabilities:

    Calculate relative dates ("3 days ago" from latest workout)
    Match exercises by ID (handles "pompki" → "push_ups")
    Provide specific metrics (weights, TUT values, dates)
    Analyze HIT progression status per exercise
    Never ask follow-up questions
    Return "no data" if information unavailable

6. Response Formatting (Format Response → Return to Router)

Standardizes output for router consumption with metadata preservation.
Outputs
Success Response

{
  "response_text": "💪 W ostatnim treningu (2024-02-09) przy push_ups użyłeś 25kg przez 65s. Osiągnąłeś TUT 60s+ - czas zwiększyć ciężar do 27.5kg! 🚀",
  "chat_id": "{{TELEGRAM_CHAT_ID}}",
  "source_type": "telegram",
  "metadata": {
    "response_endpoint": { "type": "telegram", "chat_id": "{{TELEGRAM_CHAT_ID}}" },
    "language": "pl",
    "username": "Michal"
  },
  "query": "jaki ciężar miałem przy pompkach?",
  "summary": {
    "last_workout": "2024-02-09",
    "days_since": 3,
    "workouts_analyzed": 15,
    "language": "pl"
  },
  "success": true,
  "timestamp": "2026-02-12T10:30:00Z"
}

No Data Response

{
  "response_text": "❌ Brak danych treningowych w bazie.

Sprawdź:
• Synchronizację Google Sheets
• Dane w arkuszu
• Połączenie z bazą danych",
  "success": false,
  "error": "no_training_data"
}

Email Alert (Database Empty)

    To: {{EMAIL}}
    Subject: ⚠️ Training Database Empty - YYYY-MM-DD
    Body: Troubleshooting checklist for sync workflow, Google Sheets, database connectivity

Dependencies
Systems

    S03 Data Layer - PostgreSQL autonomous_training database
    S07 AI Infrastructure - Google Gemini Chat Model integration

External Services

    PostgreSQL Database: autonomous_training schema (Docker container)
    Google Gemini API: Chat model for bilingual natural language processing
    Gmail API: Administrative alert delivery

Credentials

    Postgres account autonomous_training docker (n8n ID: haLW6cBWakuIUaNj)
    Google Gemini(PaLM) Api account 2 (n8n ID: x9Jp7ab2PivcIEj9)
    Gmail account (n8n ID: ZKOV4vsgAhk74S3u)

Error Handling
Failure Scenario 	Detection 	Response 	Alert
No training data in DB 	IF: Has Training Data? returns false 	Send bilingual "no data" message + email alert 	Gmail to admin
PostgreSQL connection failure 	Database node error 	Workflow execution failure 	n8n error log
Invalid user query 	AI Agent cannot parse 	Return "Brak danych..." / "No data available" 	None (graceful)
Language detection ambiguity 	Equal PL/EN keyword matches 	Default to English 	None (acceptable)
Missing router metadata 	chat_id or source_type null 	Use fallback values 	Log warning
AI Agent timeout/failure 	Gemini API unavailable 	n8n retry (3x), then fail 	Workflow error
Malformed database response 	Unexpected data structure 	JavaScript error in Code node 	Workflow error
Monitoring
Success Metrics

    Response time < 5 seconds from trigger to completion
    AI provides data-backed answers (no hallucinations)
    95%+ query coverage with available data
    Correct bilingual detection and response

Alert Conditions

    Database returns 0 rows for 2+ consecutive executions → Email alert
    Workflow failures > 3 in 24 hours → Manual investigation
    AI timeout rate > 10% → Check Gemini API status

Manual Fallback
Option 1: Direct Database Query

-- Latest workout
SELECT * FROM workouts ORDER BY workout_date DESC LIMIT 1;

-- Exercise-specific history
SELECT workout_date, weight_kg, tut_seconds 
FROM workout_sets 
WHERE exercise_id = 'push_ups' 
ORDER BY workout_date DESC LIMIT 5;

-- Current measurements
SELECT * FROM measurements ORDER BY measurement_date DESC LIMIT 1;

Option 2: Check Data Sync

-- Verify data freshness
SELECT MAX(created_at) as last_sync FROM workouts;
-- If stale, manually trigger WF105__Autonomous-Training-Data-Sync

Option 3: Manual Response

    Query database directly using above SQL
    Format response manually based on detected user language
    Send via appropriate channel (Telegram/Discord/etc.)

Example Conversations
Weight Query (Polish)

User: /training jaki ciężar miałem przy pompkach?
System:

💪 Push-ups (ostatnie 3 sesje):
• 2024-02-09: 25kg → 65s (failure ✓)
• 2024-02-05: 22.5kg → 62s (failure ✓)  
• 2024-02-01: 22.5kg → 58s

💡 Osiągnąłeś TUT 60s+ - czas zwiększyć do 27.5kg!

Training Summary (English)

User: /training when was my last workout?
System:

💪 Last Workout: 2024-02-09
📍 Location: home | ⏱️ Duration: 45 min
🏋️ Exercises: 4 (bench_press, pull_ups, squats, overhead_press)
📈 Total TUT: 280s, Intensity: 75% (3/4 sets to failure)
😊 Recovery: 5/5, Mood: 5/5

Progression Check (Polish)

User: /training czy mogę zwiększyć ciężar?
System:

✅ Gotowe do progresji (3 ćwiczenia):
• push_ups: 25kg → 27.5kg (TUT: 65s)
• pull_ups: 15kg → 17.5kg (TUT: 63s)
• squats: 80kg → 85kg (TUT: 68s)

✋ Kontynuuj obecny ciężar:
• bench_press: 60kg (TUT: 52s - za wcześnie)

Related Documentation
SOPs

    Daily-Review-SOP.md - Training data review procedures
    Weekly-Training-Review.md - HIT progression analysis

Runbooks

    Database-Backup-Restore.md - PostgreSQL recovery
    n8n-Workflow-Troubleshooting.md - Generic debugging

Systems

    S03 Data Layer - PostgreSQL schema and data model
    S07 AI Infrastructure - LLM integration patterns

Related Workflows

    WF101__Router.md - Main command router
    WF105__Autonomous-Training-Data-Sync.md - Google Sheets to PostgreSQL sync
