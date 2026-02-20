---
title: "G02: Metrics"
type: "goal_metrics"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Metrics

## KPI list
| Metric | Target | How measured | Frequency | Owner |
|---|---:|---|---|---|
| Substack: Open Rate (%) | TBD | Substack Analytics | TBD | {{OWNER_NAME}} |
| Substack: New Subscribers | TBD | Substack Analytics | TBD | {{OWNER_NAME}} |
| LinkedIn: Article Views | TBD | LinkedIn Analytics | TBD | {{OWNER_NAME}} |
| LinkedIn: Post Reach | TBD | LinkedIn Analytics | TBD | {{OWNER_NAME}} |
| LinkedIn: Engagement Rate | TBD | LinkedIn Analytics | TBD | {{OWNER_NAME}} |

## Leading indicators
- ...

## Lagging indicators
- ...

## Data Integration Strategy for Grafana Dashboard

To integrate the content performance metrics (currently stored in `performance.csv`) with a central Grafana dashboard, the data needs to be stored in a database accessible by Grafana. Given the existing infrastructure, PostgreSQL is the recommended choice.

### 1. PostgreSQL Table Schema

A dedicated table `content_performance_metrics` should be created in the PostgreSQL database.

```sql
CREATE TABLE IF NOT EXISTS content_performance_metrics (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    platform VARCHAR(50) NOT NULL,
    article_id VARCHAR(255), -- Or article_title, depending on how content is identified
    open_rate DECIMAL(5, 2), -- Percentage
    new_subscribers INTEGER,
    article_views INTEGER,
    post_reach INTEGER,
    engagement_rate DECIMAL(5, 4), -- Percentage or ratio
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster querying by date and platform
CREATE INDEX IF NOT EXISTS idx_cpm_date_platform ON content_performance_metrics (date, platform);
```

### 2. n8n Workflow for CSV Import

An n8n workflow (`WF_G02_001_ImportContentMetrics.json`) will be created to automate the import of `performance.csv` data into the `content_performance_metrics` PostgreSQL table.

**Workflow Steps:**
1.  **Read CSV:** A "Read Binary File" node to read `autonomous-living/docs/10_GOALS/G02_Automationbro-Recognition/data/performance.csv`.
2.  **Parse CSV:** A "CSV" node to parse the file content into JSON objects.
3.  **Process Items:** Iterate through each row of the parsed CSV.
4.  **Database Upsert:** For each row, an "PostgreSQL" node will perform an UPSERT operation:
    *   **INSERT** new records if `date`, `platform`, and `article_id` combination does not exist.
    *   **UPDATE** existing records if a matching combination is found (to handle manual corrections or re-imports).
    *   Ensure data types are correctly mapped (e.g., empty strings or '-' are converted to NULL for numeric fields).

### 3. Grafana Dashboard Creation

Once data is flowing into the PostgreSQL database, a new Grafana dashboard can be created.

**Dashboard Name:** `G02 - Content Performance`

**Key Panels to Include:**
-   **Substack Open Rate Trend:** Line graph showing `open_rate` over time, filtered by `platform = 'Substack'`.
-   **New Subscribers Trend:** Line graph showing `new_subscribers` over time.
-   **LinkedIn Article Views:** Bar chart or line graph showing `article_views` per `article_id` or over time.
-   **LinkedIn Engagement Rate:** Line graph showing `engagement_rate` over time.
-   **Overview Table:** A table displaying the latest metrics for all content pieces.

**Next Steps:**
-   Execute the SQL to create the `content_performance_metrics` table.
-   Develop and deploy the n8n workflow `WF_G02_001_ImportContentMetrics.json`.
-   Create the Grafana dashboard `G02 - Content Performance`.