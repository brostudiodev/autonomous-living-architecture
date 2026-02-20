---
title: "WF012: SVC Google Calendar"
type: "automation_spec"
status: "active"
automation_id: "WF012__svc-google-calendar"
goal_id: "goal-g04"
systems: ["S05", "S08"]
owner: "{{OWNER_NAME}}"
updated: "2026-02-11"
---

# WF012: SVC Google Calendar

## Purpose
Intelligent calendar assistant that processes natural Polish language requests using a "decisive AI" approach. Makes smart assumptions for missing information, executes calendar operations immediately, and provides transparent feedback on decisions made.

## Triggers
**Primary:** Sub-workflow execution from `ROUTER_Intelligence-Hub` when `intent.primary === "calendar"`

**Input Contract:**
```json
{
  "intent": {
    "primary": "calendar",
    "secondary": "check_availability|create_event|general",
    "entities": {
      "action": "check_availability|create_event|general", 
      "raw_query": "user's natural language request"
    }
  },
  "_router": {
    "trigger_source": "telegram|webhook|chat",
    "chat_id": "telegram_chat_id",
    "user_id": "user_identifier",
    "trace_id": "unique_execution_id"
  },
  "metadata": {
    "response_endpoint": {
      "type": "telegram|webhook|chat",
      "chat_id": "telegram_chat_id",
      "session_id": "chat_session_id"
    }
  }
}
```

## Processing Logic
### 1. Input Normalization

Node: Normalize Input (Code)

Purpose: Extract query from router's nested structure and provide temporal context.

Logic:
```javascript
// Extract query with fallback chain
const query = input.intent?.entities?.raw_query || 
              input.normalized?.text || 
              input.input?.raw_content || '';

// Add Warsaw timezone context
const now = new Date();
const currentDateTime = now.toLocaleString('pl-PL', { 
  timeZone: 'Europe/Warsaw',
  weekday: 'long', year: 'numeric', month: 'long', 
  day: 'numeric', hour: '2-digit', minute: '2-digit'
});

// ISO for precise calculations
const currentDateTimeISO = now.toISOString();

Output:

{
  "query": "czy mam jakies spotkanie w piatek o 15?",
  "action": "check_availability",
  "current_datetime": "środa, 11 lutego 2026, 16:02",
  "current_datetime_iso": "2026-02-11T16:02:31.746Z",
  "timezone": "Europe/Warsaw",
  "_router": {...},
  "metadata": {...}
}
```

### 2. AI Agent Processing

Node: Calendar Agent (LangChain Agent)

Model Configuration:

    Model: models/gemini-1.5-pro
    Temperature: 0.1 (consistent date parsing)
    Why not Flash Lite: Lacks reasoning capability for complex Polish entity extraction

Core Directive: ASSUME & ACT - Never ask for clarification

Assumption Hierarchy (Applied in Order):

    Missing Month: Current month (if date passed → next month)
    Missing Year: Current year (if date passed → next year)
    Missing Time: Default 10:00 (productive morning slot)
    Missing Duration: Default 60 minutes
    Ambiguous Title: Extract keywords, capitalize Polish names
    Location/Notes: Trailing words → event description

Polish Language Parsing Patterns:

Months: "stycznia/styczeń", "lutego/luty", "marca/marzec", "kwietnia/kwiecień"
Days: "poniedziałek", "wtorek", "środa/sroda", "czwartek", "piątek/piatek"
Times: "godz 15 40" = 15:40, "o 9" = 09:00, "1540" = 15:40
Relative: "jutro", "pojutrze", "za tydzień", "w przyszłym tygodniu"

Available Tools:
**Get Events Tool**

When: User asks "czy mam", "sprawdź", "co mam", "jak wygląda"

Search Strategy:

    Specific time: ±30 minutes window (e.g., "o 15" → 14:30-15:30)
    Day queries: Full day range (00:00-23:59)

Parameters:
```json
{
  "timeMin": "{{ $fromAI('searchStartTime', 'ISO 8601 start time like 2026-02-14T14:30:00+01:00') }}",
  "timeMax": "{{ $fromAI('searchEndTime', 'ISO 8601 end time like 2026-02-14T15:30:00+01:00') }}"
}
```

**Create Event Tool**

When: Event creation without attendees specified

Parameters:
```json
{
  "start": "{{ $fromAI('startTime', 'ISO 8601 event start time') }}",
  "end": "{{ $fromAI('endTime', 'ISO 8601 event end time') }}",
  "summary": "{{ $fromAI('eventTitle', 'Polish event title extracted from query') }}"
}
```

**Create Event with Attendee Tool**

When: Email address explicitly provided in query

Parameters: Same as Create Event plus:
```json
{
  "attendees": ["{{ $fromAI('attendeeEmail', '{{EMAIL}}') }}"]
}
```

### 3. Response Formatting

Node: Format Response (Code)

Purpose: Structure AI output for dispatcher and preserve routing metadata.

Response Format:
```json
{
  "response_text": "✅ **Dodałem spotkanie do kalendarza**

📝 **Tytuł:** Okulista - {{OWNER_NAME}}
🗓️ **Data:** Wtorek, 17 lutego 2026
⏰ **Czas:** 15:40 - 16:40
📍 **Lokalizacja:** Krzywicka

**💡 Moje założenia:**
• Rok: 2026 (bieżący rok)
• Czas trwania: 60 minut (domyślnie)

**🎯 Optymalny format następnym razem:**
`Okulista - {{OWNER_NAME}} 17 lutego 15:40-16:30 ul. Krzywicka 12`",
  "success": true,
  "_router": {...},
  "metadata": {...},
  "calendar_action": "create_event",
  "user_query": "original query",
  "processed_at": "2026-02-11T16:02:35.123Z"
}
```

## Example Interactions
### Example 1: Minimal Input with Assumptions

Input: "dentysta 5 o 14"

AI Processing:

    Month: Current month (Feb) - day 5 passed → March
    Year: 2026 (current)
    Duration: 60 minutes (default)
    Title: "Dentysta" (capitalized)

Calendar Event Created:

    Start: 2026-03-05T14:00:00+01:00
    End: 2026-03-05T15:00:00+01:00
    Title: "Dentysta"

Response:
```
✅ **Dodałem spotkanie do kalendarza**

📝 **Tytuł:** Dentysta
🗓️ **Data:** Czwartek, 5 marca 2026
⏰ **Czas:** 14:00 - 15:00
📍 **Lokalizacja:** Nie podano

**💡 Moje założenia:**
• Miesiąc: Marzec (5 lutego już minęło)
• Rok: 2026 (bieżący rok)
• Czas trwania: 60 minut (domyślnie)

**🎯 Optymalny format następnym razem:**
`Dentysta 5 marca 14:00-15:00 ul. Przykładowa 12`
```

### Example 2: Complex Unstructured Input

Input: "Dodaj spotkanie do kalendarza: Okulista michal 17 luty godz 15 40 krzywicka"

AI Extraction:

    Title: "Okulista - {{OWNER_NAME}}" (name capitalized)
    Date: February 17, 2026
    Time: 15:40
    Duration: 60 minutes (default)
    Location: "Krzywicka" (added to description)

Response:
```
✅ **Dodałem spotkanie do kalendarza**

📝 **Tytuł:** Okulista - {{OWNER_NAME}}
🗓️ **Data:** Wtorek, 17 lutego 2026
⏰ **Czas:** 15:40 - 16:40
📍 **Lokalizacja:** Krzywicka

**💡 Moje założenia:**
• Rok: 2026 (bieżący rok)
• Czas trwania: 60 minut (domyślnie)

**🎯 Optymalny format następnym razem:**
`Okulista - {{OWNER_NAME}} 17 lutego 15:40-16:30 ul. Krzywicka 12`
```

### Example 3: Availability Check

Input: "czy mam jakies spotkanie w piatek o 15?"

AI Processing:

    Parse "piatek o 15" → next Friday 15:00
    Search window: 14:30-15:30
    Check Google Calendar for conflicts

Response (if free):
```
W piątek o 15:00 jesteś wolny ✅
```

Response (if busy):
```
W piątek o 15:00 masz: Spotkanie zespołu ⏰
Czas: 15:00-16:00
```

## Dependencies
### Systems

    S05 Intelligent Routing Hub
    S08 Personal Assistants

### External Services

    Google Calendar API: OAuth2 access to {{EMAIL}}
    Google Gemini API: LLM inference for natural language processing

### Credentials

    googleCalendarOAuth2Api (n8n credential ID: jiW5gqDnwMGtX50g)
    googlePalmApi (n8n credential ID: x9Jp7ab2PivcIEj9)

## Error Handling
| Failure Scenario | Detection | Response | Alert |
|---|---|---|---|
| Google Calendar API Error | HTTP 4xx/5xx from Calendar nodes | Return Polish error message to user | n8n execution failure log |
| Gemini API Timeout | Agent node execution >30s | Return "Przepraszam, spróbuj ponownie" | n8n execution failure log |
| Missing Query | Normalize Input validation fails | Throw error with trace_id | Router contract violation alert |
| Invalid Date Extraction | Google Calendar rejects ISO timestamp | AI re-attempts with default assumptions | Manual review of prompt |
| Quota Exceeded | API returns 429 Too Many Requests | Return "Zbyt wiele zapytań, spróbuj za minutę" | Admin notification |

Error Response Format:
```json
{
  "response_text": "❌ Przepraszam, nie udało się połączyć z kalendarzem. Spróbuj ponownie za chwilę.",
  "success": false,
  "error_type": "api_error",
  "_router": {...},
  "metadata": {...}
}
```

## Monitoring
### Success Metrics

    Response Time: <5 seconds (95th percentile)
    Success Rate: >95% (successful event creation/retrieval)
    Assumption Accuracy: <5% user corrections within 5 minutes

### Performance Characteristics

    Average execution time: 3-4 seconds
    Token: "{{GENERIC_API_SECRET}}" per request: ~800 tokens (input + output)
    Estimated cost per request: ~$0.0006
    Monthly cost (50 requests/day): ~$0.90

### Alert Conditions

    3 consecutive workflow failures
    Response time >10 seconds
    Google Calendar API quota >80% used

### Logging
```javascript
console.log(`[CALENDAR] ${trace_id} | Action: ${action} | Query: "${query.substring(0,50)}" | Success: ${success} | Duration: ${duration}ms`);
```

## Manual Fallback

If automation fails:

    Open Google Calendar: https://calendar.google.com
    Create event manually using details from user query
    Notify user: Send manual confirmation via same channel
    Log incident: Add entry to goal-g04/ACTIVITY.md

Fallback Response Template:
```
❌ Przepraszam, wystąpił problem z automatycznym dodaniem.
Proszę dodaj ręcznie:
📝 [extracted title]
🗓️ [extracted date]
⏰ [extracted time]
🔗 https://calendar.google.com
```

## Testing Checklist

Before deployment:

    Test minimal input: "dentysta 5"
    Test full details: "Okulista - {{OWNER_NAME}} 17 lutego 15:40-16:30 ul. Krzywicka 12"
    Test availability: "czy mam spotkanie jutro?"
    Test day overview: "co mam w piątek?"
    Test past dates: "spotkanie 5" (when today is 11th)
    Test Polish inflections: "piatek", "piątek", "piatku"
    Test time formats: "godz 15 40", "o 15", "1540"
    Verify assumptions in responses
    Verify optimal format suggestions
    Test error scenarios (invalid credentials)
    Verify timezone correctness (Europe/Warsaw)

## Performance Optimization

Current Bottlenecks:

    Gemini API latency: 1-2 seconds
    Google Calendar API calls: 0.5-1 second
    n8n workflow overhead: 0.3-0.5 seconds

Optimization Opportunities:

    Caching: Store recent availability checks (5-minute TTL)
    Batching: Combine multiple calendar operations
    Model optimization: Fine-tune prompt for faster inference

## Related Documentation

Parent Workflows:

    WF001__router-intelligence-hub - Main router that calls this service
    WF013__svc-response-dispatcher - Handles response routing

Goal Documentation:

    G04 Autonomous Calendar Management

SOPs:

    Calendar-Operations.md - Daily usage patterns
    AI-Agent-Troubleshooting.md - Debugging guide

Systems:

    S05 Intelligent Routing Hub
    S08 Personal Assistants
