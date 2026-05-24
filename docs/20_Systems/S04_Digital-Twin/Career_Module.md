# Module: Career & Skill Intelligence

## Purpose
The **Career Module** manages career-trajectory tracking, skill-gap analysis, and autonomous goal documentation. It bridges daily learning activities with long-term professional milestones.

## Capabilities
- **Skill Inventory**: Returns current proficiency levels for tracked skills.
- **Career Strategist**: Automatically updates proficiency based on study sessions and identifies market-demand gaps.
- **Autonomous Logging**: Synchronizes resolved system actions and daily achievements into Obsidian goal logs.
- **Goal Sync**: Extracts goal progress from daily notes to centralized documentation.

## API Endpoints
- `GET /api/v1/career/health`: Module health status.
- `GET /api/v1/career/skills`: Current skill proficiency list.
- `GET /api/v1/career/gaps`: Identified high-demand skill gaps.
- `POST /api/v1/career/sync`: Triggers full strategy and achievement sync.

## Events Emitted
- `skill_gap`: Emitted when a high-priority skill deficit is detected.
- `sync_complete`: Emitted after periodic strategy analysis.

## Dependencies
- **Database**: `autonomous_career`, `autonomous_learning`
- **Vault**: Obsidian Daily Notes & Goal Activity Logs.

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| Learning DB Offline | health check fails | Log error, strategist deferred. |
| Goal Doc Missing | FileNotFoundError | Skip specific goal log, notify in sync report. |
