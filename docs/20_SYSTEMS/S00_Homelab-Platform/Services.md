---
title: "S00: Services Catalog"
type: "reference"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-07"
---

# Services Catalog

## Always-on (expected)
| Service | Purpose | Where hosted | Criticality | Notes |
|---|---|---|---|---|
| n8n | automation orchestrator | Docker Compose | high | S08 Automation Orchestrator - manages 15+ workflows |
| Home Assistant | home orchestration | TBD | high | G08 Smart Home - not yet implemented |
| PostgreSQL | data persistence layer | Docker Compose | critical | S03 Data Layer - financial, digital twin data |
| Grafana | observability dashboards | Docker Compose | high | G05 Finance dashboards, system monitoring |
| GitHub repository | source control & data source | GitHub | critical | S03 - source of truth for roadmaps & docs |

## On-demand (automation triggered)
| Service | Purpose | Trigger | Where hosted | Notes |
|---|---|---|---|---|
| Finance data ingestion | Bank statements & CSV import | WF103 (4-hourly) | n8n workflow | G05 - transaction processing |
| Budget alerts | Threshold monitoring | WF102 (daily) | n8n workflow | G05 - financial notifications |
| Digital twin sync | Multi-source data integration | WF104 (scheduled) | n8n workflow | G04 - ecosystem data aggregation |
| Activity summaries | Weekly progress reporting | WF105 (weekly) | n8n workflow | G09 - documentation automation |
| GitHub TODO extraction | Task list generation | On-demand | n8n workflow | G04/G12 - progress tracking |

## External dependencies
| Service | Purpose | Provider | SLA | Notes |
|---|---|---|---|---|
| Google Sheets API | Transaction data source | Google | Standard | G05 data import |
| Telegram Bot API | Alert notifications | Telegram | Standard | Budget alerts, TODO responses |
| Slack API | Team notifications | Slack | Standard | Activity summaries, alerts |
| GitHub API | Repository content access | GitHub | Standard | TODO extraction, CI/CD |

