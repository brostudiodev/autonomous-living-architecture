---
title: "PROJ: Relationship Intelligence System (G09)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Relationship-Intelligence-System"
goal_id: "goal-g09"
systems: ["S03", "S08"]
owner: "Michal"
updated: "2026-04-14"
---

# PROJ_Relationship-Intelligence-System

## Purpose
The **Relationship Intelligence System** is an AI agent designed to help Michal maintain and optimize his social and professional networks. It monitors contact frequency, identifies overdue interactions, and suggests strategic outreach based on desired maintenance levels, ensuring no important relationship is neglected.

## Triggers
- **Sub-workflow:** Triggered by `ROUTER_Intelligent_Hub` when keywords related to "contact", "social", "relationship", or names are detected.
- **Manual Trigger:** Used for social strategy planning and network review.

## Inputs
- **Query:** Natural language string (e.g., "Kogo powinienem dzisiaj odświeżyć?", "When did I last speak to X?").
- **Metadata:** Chat ID, User ID, and Source Type.

## Processing Logic
1. **Normalization:** Extracts the query and cleanses command prefixes (e.g., `/social`). Resolves the session ID for memory persistence.
2. **PostgreSQL Ingestion:**
   - `Get Relationships`: Fetches the complete relationship list from the `relationships` table in `autonomous_life_logistics`. Sorts by `last_contact_date` ascending to surface neglected contacts.
3. **Hardened Error Handling (Apr 14):**
   - `Check DB Error`: Specifically validates that the `relationships` table exists.
   - `Handle DB Error`: If the table is missing, provides specific troubleshooting advice (e.g., verifying the Postgres credential points to `autonomous_life_logistics` rather than `digital_twin_michal`).
4. **Context Construction:** `Build AI Context` (JS Code) formats the relationship data into a JSON structure and adds the current date.
5. **Intelligence Layer:** Google Gemini (v1.5 Pro) identifies "overdue" contacts based on desired frequency and suggests outreach actions.
6. **Output:** Formats a prioritized outreach recommendation for the `Response Dispatcher`.

## AI Agent Configuration
- **Role:** Relationship Maintenance Partner (G09).
- **Language:** Matches user input (Polish/English).
- **Model:** Google Gemini (Temp 0.2).
- **Memory:** Windowed buffer for maintaining context across conversations.
- **Tools:** `relationship_sentinel` (Python script) for deeper analysis and automated reminders.

## Dependencies
### Systems
- [Automated Career Intelligence (G09)](../../../10_Goals/G09_Automated-Career-Intelligence/README.md)
- [Data Layer (S03)](../../../20_Systems/S03_Data-Layer/README.md) - PostgreSQL storage (`autonomous_life_logistics`).

### External Services
- **PostgreSQL Database:** Stores contact details, categories, and maintenance schedules.
- **Google Gemini API:** Core intelligence and outreach strategy.

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| Table Not Found | Node execution error (Relation Missing) | Explicit guidance to check database selection in n8n credentials. |
| DB Connection Failure | Node timeout | Agent informs user that relationship records are currently unavailable. |
| Missing Contact Name | Query with unknown person | Agent suggests adding the person to the relationship tracker. |
| Inconsistent Data | Contact frequency > 365 | Agent flags data integrity issue for manual correction. |

## Security Notes
- **Authority:** Read-only access to relationship data; write operations delegated to specialized tools.
- **Credential:** `zrLunD1UbOGzqNzS` (n8n managed).
- **Data Privacy:** Personal contact details (phone numbers, private notes) are processed only within the local network context.

## Manual Fallback
```bash
# Check most neglected relationships
psql -U root -d autonomous_life_logistics -c "SELECT name, last_contact_date, desired_frequency_days FROM relationships ORDER BY last_contact_date ASC LIMIT 5;"
```

---

*Documentation synchronized with PROJ_Relationship-Intelligence-System.json v1.1 (2026-04-14)*
