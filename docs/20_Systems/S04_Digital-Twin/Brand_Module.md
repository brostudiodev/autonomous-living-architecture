# Module: Brand

## Purpose
The **Brand Module** manages brand orchestration, content performance tracking, and audience growth intelligence. It synchronizes content from platforms like Substack and LinkedIn to provide a unified view of brand impact.

## Capabilities
- **Performance Tracking**: Aggregates social media engagement and subscriber growth metrics.
- **Substack Sync**: Synchronizes Substack articles to Obsidian and tracks subscriber metrics.
- **Performance Analysis**: Analyzes audience growth trends and predicts target achievement.

## API Endpoints
- `GET /api/v1/brand/health`: Module health status.
- `GET /api/v1/brand/status`: Current brand metrics.
- `GET /api/v1/brand/analysis`: Audience growth analysis and predictions.
- `POST /api/v1/brand/sync`: Triggers full content and metrics sync.

## Events Emitted
- `brand_metrics_updated`: Emitted when new engagement data is processed.
- `substack_synced`: Emitted after Substack feed ingestion.

## Dependencies
- **Database**: `digital_twin_michal` (brand_metrics table)
- **External**: Substack RSS, LinkedIn (manual/API)

## Failure Modes
| Scenario | Detection | Response |
|----------|-----------|----------|
| RSS Feed Offline | 404/Timeout on feedparser | Log error, skip article sync. |
| DB Error | psycopg2 exception | Log failure, alert via Sentinel. |
