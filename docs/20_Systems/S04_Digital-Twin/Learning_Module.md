# Module: Learning

## Purpose
The **Learning Module** tracks study sessions and manages adaptive deadlines for certifications and career goals.

## Capabilities
- **Learning Goals**: Returns all active career/certification goals.
- **Session Sync**: Ingests study sessions into the database.
- **Velocity Tracking**: Recalculates deadlines and reports study velocity risks.

## API Endpoints
- `GET /api/v1/learning/health`: Module health status.
- `GET /api/v1/learning/goals`: Active certification goals.
- `POST /api/v1/learning/sessions/sync`: Ingest manual or automated study logs.

## Events Emitted
- `session_synced`: Emitted after new study sessions are successfully ingested.
- `sync_complete`: Emitted after periodic velocity analysis and deadline recalculation.

## Dependencies
- **Database**: `autonomous_learning`
- **Goal**: G06 (Certification Exams)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| DB Connection Failure | Health check fails | Log alert, retry in next sync loop. |
| Inconsistent Data | Velocity calculation yields impossible dates | Log warning, keep old deadline. |
