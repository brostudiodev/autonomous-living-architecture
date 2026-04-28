---
title: "PROJ: Learning Intelligence System (G06)"
type: "automation_spec"
status: "active"
automation_id: "PROJ_Learning-Intelligence-System"
goal_id: "goal-g06"
systems: ["S03", "S06"]
owner: "Michał"
updated: "2026-04-15"
---

# PROJ_Learning-Intelligence-System (v2.0)

## Purpose
The **Learning Intelligence System** is an advanced AI agent (G06) designed to act as Michał's personal study coach and certification strategist. It autonomously tracks study velocity, assesses certification risk based on deadlines, and manages a technical knowledge base (Learning Concepts).

## Key Features (v2.0)
- **Mathematical Risk Assessment:** Pre-calculates `risk_status` (CRITICAL/URGENT) and `required_hours_per_week` directly in SQL.
- **Context-Rich Intelligence:** The "Build AI Context" node pre-aggregates weekly stats, subject breakdowns, and critical alerts before the LLM step.
- **Direct Action Tools:** Empowered to write back to the system via `LogStudySession` and `AddConcept` tools.
- **Historical Analysis:** Supports trend analysis by retrieving the last 30 study sessions and 20 recent concepts.

## Triggers
- **Sub-workflow:** Triggered by `ROUTER_Intelligent_Hub` for keywords: `learn`, `study`, `cert`, `exam`, `uczyć`, `nauka`.
- **Direct Call:** Can be executed directly with a `query` parameter.

## Inputs
- **query:** Natural language string (e.g., "Ile muszę się uczyć na AWS?").
- **chat_id / user_id:** Session identifiers for memory persistence.

## Processing Logic
1. **Normalization:** Extracts the core query and cleans command prefixes.
2. **Sequential Data Retrieval (PostgreSQL):**
   - `Get Skill Gaps`: Analyzes `v_skill_gap_analysis` for deadlines and completion %.
   - `Get Study Sessions`: Retrieves the last 30 logs from `study_sessions`.
   - `Get Concepts`: Fetches the last 20 entries from `learning_concepts`.
3. **Context Engineering:** A dedicated Code node calculates:
   - Total/Weekly study hours and impact scores.
   - Categorization of certifications by risk (Critical/Urgent/Behind).
4. **AI Reasoning (Learning AI Agent):**
   - Uses Google Gemini (Temp 0.1) with a strict "Study Coach" persona.
   - Evaluates velocity: >15h/week = 🔴 IMPOSSIBLE, <5h/week = ✅ ON TRACK.
5. **Tool Execution:** If instructed, the agent calls `G06_log_study_session` or `G06_add_concept` via HTTP POST to the Digital Twin API.

## AI Agent Configuration
- **Model:** Google Gemini (Temp 0.1).
- **Memory:** `Simple Memory` (Window Buffer) for conversational context.
- **Tools:**
  - `LogStudySession`: Logs `subject`, `duration_minutes`, `impact_score`, `notes`.
  - `AddConcept`: Saves `title`, `content`, `tags`, `related_goals`.

## Dependencies
### Systems
- [Certification Exams (G06)](../../../10_Goals/G06_Certification-Exams/README.md)
- [Data Layer (S03)](../../../20_Systems/S03_Data-Layer/README.md) - Database: `autonomous_learning`.

## Error Handling
| Failure Scenario | Detection | Response |
|----------|-----------|----------|
| Empty Database | `IF: Has Data?` fails | Returns friendly onboarding message + alerts admin via Gmail. |
| DB Connection Loss | Node Error | Reports system unavailability and logs failure. |
| Invalid Subject | Tool Validation | Agent asks for one of the valid subjects (AWS, AI/ML, Six Sigma). |

## Security Notes
- **API Access:** Communicates with Digital Twin API via internal IP `{{INTERNAL_IP}}`.
- **Credentials:** Uses n8n-managed PostgreSQL credentials for `autonomous_learning`.

---

*Documentation updated for PROJ_Learning-Intelligence-System.json v2.0 (2026-04-15)*
