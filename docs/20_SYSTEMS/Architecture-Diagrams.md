---
title: "Architecture Diagrams"
type: "documentation"
status: "active"
owner: "{{OWNER_NAME}}"
updated: "2026-02-19"
---

# Autonomous Living Architecture Diagrams

## Overview

This document contains high-level and low-level architectural diagrams for the autonomous-living ecosystem as of 2026-02-11.

## 🏗️ **HIGH-LEVEL SYSTEM ARCHITECTURE**

```mermaid
graph TB
    subgraph "User Interface Layer"
        TELEGRAM[Telegram Bot<br/>AndrzejSmartBot]
        TWIN_API[Digital Twin API<br/>Port 5677]
        WEBHOOK[Webhook API<br/>/intelligence-hub]
        N8N_CHAT[n8n Chat Interface]
        GRAFANA[Grafana Dashboards<br/>Port 3003]
    end

    subgraph "Intelligence & Orchestration Layer"
        G04[Digital Twin Hub<br/>WF001 Router]
        GEMINI[Google Gemini AI<br/>6 Custom Tools]
        N8N[n8n Platform<br/>Workflow Orchestration]
    end

    subgraph "Data Processing Layer"
        PROCESSOR[Content Processor<br/>Multi-format Support]
        ROUTER[Intelligent Router<br/>Intent Classification]
        INGESTION[Data Ingestion<br/>WF104 - 8hr Schedule]
    end

    subgraph "Domain Systems Layer"
        G01[Training System<br/>Body Fat Tracking]
        G03[Pantry Management<br/>AI Inventory]
        G05[Financial Command<br/>PostgreSQL + Alerts]
        G07[Health Integration<br/>Withings API]
    end

    subgraph "Storage & Monitoring Layer"
        POSTGRES[(PostgreSQL<br/>Partitioned 2012-2027)]
        SHEETS[Google Sheets<br/>User Entry Interface]
        GITHUB[GitHub<br/>Documentation Storage]
        PROMETHEUS[Prometheus<br/>Metrics Collection]
    end

    subgraph "Infrastructure Layer"
        DOCKER[Docker Compose<br/>Service Containerization]
        ALERTS[Alert System<br/>Slack + Telegram]
        BACKUP[Backup System<br/>Automated Daily]
    end

    %% User Interface Connections
    TELEGRAM --> G04
    WEBHOOK --> G04
    N8N_CHAT --> N8N
    GRAFANA --> PROMETHEUS

    %% Intelligence Layer Connections
    G04 --> GEMINI
    G04 --> PROCESSOR
    G04 --> ROUTER
    N8N --> G04
    N8N --> INGESTION

    %% Processing to Domain Systems
    PROCESSOR --> G01
    PROCESSOR --> G03
    PROCESSOR --> G05
    PROCESSOR --> G07
    ROUTER --> G01
    ROUTER --> G03
    ROUTER --> G05
    ROUTER --> G07
    INGESTION --> G01
    INGESTION --> G03
    INGESTION --> G05
    INGESTION --> G07

    %% Domain Systems to Storage
    G01 --> POSTGRES
    G03 --> POSTGRES
    G05 --> POSTGRES
    G07 --> SHEETS
    G04 --> GITHUB

    %% Monitoring & Observability
    G01 --> PROMETHEUS
    G03 --> PROMETHEUS
    G05 --> PROMETHEUS
    G07 --> PROMETHEUS
    PROMETHEUS --> ALERTS

    %% Infrastructure Support
    POSTGRES --> BACKUP
    GITHUB --> BACKUP
    SHEETS --> BACKUP
```

## 🔄 **DATA FLOW ARCHITECTURE**

```mermaid
flowchart TD
    subgraph "Data Sources"
        USER[User Input<br/>Commands & Data]
        WITHINGS[Withings Scale<br/>Health Metrics]
        TRAINING[Training Log<br/>Workout Data]
        PANTRY[Pantry Scan<br/>Inventory Updates]
        TRANSACTIONS[Financial Transactions<br/>Bank/Spending]
    end

    subgraph "Ingestion & Processing"
        TELEGRAM_INGEST[Telegram Ingestion<br/>Voice/Text/Images]
        API_INGEST[API Webhook<br/>JSON Requests]
        SCHEDULED_INGEST[Scheduled Collection<br/>Every 8 Hours]
        N8N_WORKFLOWS[n8n Workflows<br/>15+ Active Flows]
    end

    subgraph "AI Processing & Analysis"
        GEMINI_AI[Google Gemini<br/>Natural Language Processing]
        CONTENT_EXTRACTION[Content Extraction<br/>YouTube/Pages/PDFs]
        INTENT_CLASSIFICATION[Intent Classification<br/>Command Routing]
        DATA_TRANSFORMATION[Data Transformation<br/>Normalization & Validation]
    end

    subgraph "Storage & Persistence"
        POSTGRES_DB[(PostgreSQL<br/>Primary Database)]
        SHEETS_DB[(Google Sheets<br/>User Interface)]
        GITHUB_SYNC[GitHub<br/>Version Control]
        PROMETHEUS_METRICS[Prometheus<br/>Time Series Data]
    end

    subgraph "Distribution & Output"
        TELEGRAM_RESPONSE[Telegram Responses<br/>Bot Conversations]
        SLACK_ALERTS[Slack Notifications<br/>System Alerts]
        GRAFANA_DASHBOARDS[Grafana Dashboards<br/>Visual Analytics]
        GITHUB_COMMITS[GitHub Commits<br/>Documentation Updates]
    end

    %% Data Ingestion Flows
    USER --> TELEGRAM_INGEST
    USER --> API_INGEST
    WITHINGS --> SCHEDULED_INGEST
    TRAINING --> N8N_WORKFLOWS
    PANTRY --> N8N_WORKFLOWS
    TRANSACTIONS --> N8N_WORKFLOWS

    %% Processing Flows
    TELEGRAM_INGEST --> GEMINI_AI
    API_INGEST --> GEMINI_AI
    SCHEDULED_INGEST --> DATA_TRANSFORMATION
    N8N_WORKFLOWS --> DATA_TRANSFORMATION

    GEMINI_AI --> CONTENT_EXTRACTION
    GEMINI_AI --> INTENT_CLASSIFICATION
    DATA_TRANSFORMATION --> POSTGRES_DB
    CONTENT_EXTRACTION --> GITHUB_SYNC
    INTENT_CLASSIFICATION --> N8N_WORKFLOWS

    %% Storage Connections
    POSTGRES_DB --> PROMETHEUS_METRICS
    N8N_WORKFLOWS --> SHEETS_DB
    N8N_WORKFLOWS --> POSTGRES_DB

    %% Output Distribution
    POSTGRES_DB --> GRAFANA_DASHBOARDS
    GEMINI_AI --> TELEGRAM_RESPONSE
    POSTGRES_DB --> SLACK_ALERTS
    CONTENT_EXTRACTION --> GITHUB_COMMITS
```

## 🏛️ **SYSTEM COMPONENT ARCHITECTURE**

```mermaid
graph TB
    subgraph "External APIs"
        GEMINI_API[Google Gemini API<br/>AI Processing]
        OPENAI_WHISPER[OpenAI Whisper<br/>Voice Transcription]
        WITHINGS_API[Withings API<br/>Health Data]
        GITHUB_API[GitHub API<br/>Documentation Sync]
    end

    subgraph "Communication Layer"
        TELEGRAM_BOT[Telegram Bot<br/>AndrzejSmartBot]
        TWIN_API_SRV[Digital Twin API<br/>FastAPI]
        WEBHOOK_SERVER[Webhook Server<br/>Express.js]
        SLACK_BOT[Slack Bot<br/>Notifications]
    end

    subgraph "Workflow Engine"
        N8N_CORE[n8n Core<br/>Workflow Orchestration]
        WF001[WF001 Router<br/>Digital Twin Hub]
        WF102[WF102 Budget Alerts<br/>Financial Monitoring]
        WF105[WF105 Pantry AI<br/>Inventory Management]
    end

    subgraph "Data Services"
        G01_SERVICE[G01 Exporter<br/>Training Metrics]
        G03_SERVICE[G03 Service<br/>Pantry Intelligence]
        G05_SERVICE[G05 Service<br/>Financial Analysis]
        G07_SERVICE[G07 Service<br/>Health Sync]
    end

    subgraph "Storage Services"
        POSTGRES_SERVICE[PostgreSQL Service<br/>Primary Database]
        SHEETS_SERVICE[Google Sheets Service<br/>User Interface]
        FILE_STORAGE[File Storage<br/>Configuration & Logs]
    end

    subgraph "Monitoring Services"
        PROMETHEUS_SERVICE[Prometheus Service<br/>Metrics Collection]
        GRAFANA_SERVICE[Grafana Service<br/>Visualization]
        ALERT_MANAGER[Alert Manager<br/>Notification Routing]
    end

    %% API Connections
    N8N_CORE --> GEMINI_API
    N8N_CORE --> OPENAI_WHISPER
    G07_SERVICE --> WITHINGS_API
    WF001 --> GITHUB_API

    %% Communication Layer
    TELEGRAM_BOT --> WF001
    TWIN_API_SRV --> WF001
    WEBHOOK_SERVER --> WF001
    SLACK_BOT --> ALERT_MANAGER

    %% Workflow to Services
    WF001 --> G03_SERVICE
    WF102 --> G05_SERVICE
    WF105 --> G03_SERVICE
    N8N_CORE --> G07_SERVICE

    %% Services to Storage
    G01_SERVICE --> POSTGRES_SERVICE
    G03_SERVICE --> POSTGRES_SERVICE
    G05_SERVICE --> POSTGRES_SERVICE
    SHEETS_SERVICE --> FILE_STORAGE

    %% Monitoring Stack
    G01_SERVICE --> PROMETHEUS_SERVICE
    G03_SERVICE --> PROMETHEUS_SERVICE
    G05_SERVICE --> PROMETHEUS_SERVICE
    PROMETHEUS_SERVICE --> GRAFANA_SERVICE
    PROMETHEUS_SERVICE --> ALERT_MANAGER
```

## 🐳 **DEPLOYMENT ARCHITECTURE**

```mermaid
graph TB
    subgraph "Docker Host (Homelab)"
        subgraph "Application Containers"
            N8N_CONTAINER[n8n Container<br/>Workflow Engine]
            G01_CONTAINER[g01-exporter<br/>Port 8081]
            GOALS_CONTAINER[goals-exporter<br/>Port 8083]
        end

        subgraph "Database Containers"
            POSTGRES_CONTAINER[PostgreSQL Container<br/>Port 5432]
            BACKUP_CONTAINER[pg_dump Container<br/>Automated Backups]
        end

        subgraph "Monitoring Containers"
            PROMETHEUS_CONTAINER[Prometheus<br/>Port 9090]
            GRAFANA_CONTAINER[Grafana<br/>Port 3003]
            NODE_EXPORTER[Node Exporter<br/>Port 9100]
        end

        subgraph "External Services"
            PYTHON_SCRIPTS[Python Scripts<br/>Cron Jobs]
            GITHUB_ACTIONS[GitHub Actions<br/>CI/CD Pipeline]
        end
    end

    subgraph "External Platforms"
        TELEGRAM_PLATFORM[Telegram Platform<br/>Bot Hosting]
        GOOGLE_CLOUD[Google Cloud<br/>Sheets & APIs]
        GITHUB_PLATFORM[GitHub<br/>Repository Hosting]
        WITHINGS_PLATFORM[Withings Cloud<br/>Health Data]
    end

    %% Internal Container Connections
    N8N_CONTAINER --> POSTGRES_CONTAINER
    G01_CONTAINER --> POSTGRES_CONTAINER
    GOALS_CONTAINER --> POSTGRES_CONTAINER
    PROMETHEUS_CONTAINER --> G01_CONTAINER
    PROMETHEUS_CONTAINER --> GOALS_CONTAINER
    PROMETHEUS_CONTAINER --> NODE_EXPORTER
    GRAFANA_CONTAINER --> PROMETHEUS_CONTAINER

    %% External Connections
    N8N_CONTAINER --> TELEGRAM_PLATFORM
    PYTHON_SCRIPTS --> GOOGLE_CLOUD
    PYTHON_SCRIPTS --> WITHINGS_PLATFORM
    GITHUB_ACTIONS --> GITHUB_PLATFORM

    %% Backup Connections
    BACKUP_CONTAINER --> POSTGRES_CONTAINER
    BACKUP_CONTAINER --> GITHUB_PLATFORM
```

## 🔗 **INTEGRATION ARCHITECTURE**

```mermaid
graph LR
    subgraph "Goal Systems"
        G01_NODE[G01 Training<br/>Health Metrics]
        G03_NODE[G03 Pantry<br/>Inventory Data]
        G04_NODE[G04 Digital Twin<br/>Central Hub]
        G05_NODE[G05 Finance<br/>Budget Data]
        G07_NODE[G07 Health<br/>Biometric Data]
    end

    subgraph "Integration Patterns"
        EVENT_DRIVEN[Event-Driven<br/>Real-time Triggers]
        SCHEDULED_SYNC[Scheduled<br/>Periodic Updates]
        REQUEST_RESPONSE[Request-Response<br/>API Calls]
        DATA_PIPELINE[Data Pipeline<br/>ETL Processing]
    end

    subgraph "Communication Channels"
        WEBHOOK_COMM[Webhooks<br/>HTTP POST]
        TELEGRAM_COMM[Telegram<br/>Bot Messages]
        SLACK_COMM[Slack<br/>Notifications]
        API_COMM[REST APIs<br/>JSON Data]
    end

    %% Integration Connections
    G01_NODE -- EVENT_DRIVEN --> G04_NODE
    G03_NODE -- SCHEDULED_SYNC --> G04_NODE
    G05_NODE -- REQUEST_RESPONSE --> G04_NODE
    G07_NODE -- DATA_PIPELINE --> G04_NODE

    G04_NODE -- WEBHOOK_COMM --> G01_NODE
    G04_NODE -- TELEGRAM_COMM --> G03_NODE
    G04_NODE -- SLACK_COMM --> G05_NODE
    G04_NODE -- API_COMM --> G07_NODE

    %% Cross-System Communication
    G03_NODE -- API_COMM --> G05_NODE
    G01_NODE -- EVENT_DRIVEN --> G05_NODE
    G07_NODE -- DATA_PIPELINE --> G01_NODE
```

## 📊 **DATA ARCHITECTURE**

```mermaid
erDiagram
    PERSON_ENTITY {
        uuid id PK
        timestamp created_at
        timestamp updated_at
        json knowledge_metrics
        json financial_metrics
        json activity_metrics
        json health_metrics
        text source_system
    }

    GOAL_ENTITY {
        uuid id PK
        timestamp created_at
        timestamp updated_at
        text goal_id
        text goal_name
        integer progress_percentage
        text status
        json metadata
        text source_system
    }

    DIGITAL_TWIN_UPDATE {
        uuid id PK
        timestamp created_at
        text entity_type
        uuid entity_id
        json update_data
        text source_system
        text update_type
    }

    TRANSACTION {
        uuid id PK
        timestamp transaction_date
        decimal amount
        text currency
        text description
        text category
        text merchant
        text account
    }

    TRAINING_SESSION {
        uuid id PK
        timestamp workout_date
        text workout_type
        integer duration_minutes
        json exercises_data
        decimal body_fat_percentage
        text perceived_exertion
    }

    HEALTH_METRIC {
        uuid id PK
        timestamp measurement_date
        decimal weight_kg
        decimal bmi
        decimal fat_percentage
        decimal muscle_mass_kg
        decimal bone_mass_kg
        decimal hydration_percentage
    }

    PANTRY_ITEM {
        uuid id PK
        timestamp created_at
        timestamp updated_at
        text item_name
        text category
        decimal quantity
        text unit
        date expiry_date
        decimal unit_price
        boolean low_stock_alert
    }

    %% Relationships
    PERSON_ENTITY ||--o{ DIGITAL_TWIN_UPDATE : generates
    GOAL_ENTITY ||--o{ DIGITAL_TWIN_UPDATE : generates
    PERSON_ENTITY ||--o{ TRANSACTION : owns
    PERSON_ENTITY ||--o{ TRAINING_SESSION : performs
    PERSON_ENTITY ||--o{ HEALTH_METRIC : measures
    PERSON_ENTITY ||--o{ PANTRY_ITEM : manages
```

## 🔐 **SECURITY ARCHITECTURE**

```mermaid
graph TB
    subgraph "Authentication Layer"
        OAUTH2[OAuth 2.0<br/>Withings, Google]
        API_KEYS[API Keys<br/>Gemini, OpenAI]
        BOT_TOKENS[Bot Tokens<br/>Telegram, Slack]
        SSH_KEYS[SSH Keys<br/>GitHub Access]
    end

    subgraph "Authorization Layer"
        ROLE_BASED[Role-Based Access<br/>PostgreSQL Roles]
        SERVICE_ACCOUNTS[Service Accounts<br/>Google Sheets]
        NETWORK_POLICIES[Network Policies<br/>Docker Networks]
        API_RATE_LIMITS[Rate Limiting<br/>API Protection]
    end

    subgraph "Encryption Layer"
        DATA_TRANSIT[Data in Transit<br/>TLS/SSL]
        DATA_AT_REST[Data at Rest<br/>PostgreSQL Encryption]
        SECRET_STORAGE[Secret Storage<br/>Environment Variables]
        BACKUP_ENCRYPTION[Backup Encryption<br/>GPG Encryption]
    end

    subgraph "Monitoring & Audit"
        ACCESS_LOGS[Access Logs<br/>Request Tracking]
        AUDIT_TRAIL[Audit Trail<br/>Database Logs]
        SECURITY_ALERTS[Security Alerts<br/>Anomaly Detection]
        COMPLIANCE_REPORTS[Compliance Reports<br/>GDPR Compliance]
    end

    %% Security Flow
    OAUTH2 --> ROLE_BASED
    API_KEYS --> API_RATE_LIMITS
    BOT_TOKENS --> NETWORK_POLICIES
    SSH_KEYS --> SECRET_STORAGE

    ROLE_BASED --> DATA_TRANSIT
    SERVICE_ACCOUNTS --> DATA_AT_REST
    NETWORK_POLICIES --> BACKUP_ENCRYPTION
    API_RATE_LIMITS --> ACCESS_LOGS

    DATA_TRANSIT --> AUDIT_TRAIL
    DATA_AT_REST --> SECURITY_ALERTS
    SECRET_STORAGE --> COMPLIANCE_REPORTS
```

---

## 📋 **DIAGRAM LEGEND**

### **Component Types**
- **Hexagons:** External Systems/Platforms
- **Rectangles:** Internal Services/Components
- **Cylinders:** Data Storage/Databases
- **Diamonds:** Decision Points/Processors
- **Circles:** Users/Actors

### **Connection Types**
- **Solid Arrows:** Direct data flow/synchronous calls
- **Dashed Arrows:** Event-driven/asynchronous communication
- **Double Arrows:** Bidirectional communication
- **Dotted Lines:** Potential/Planned connections

### **Color Coding (when viewed with compatible viewers)**
- **Blue:** User Interface Layer
- **Green:** Intelligence/Orchestration Layer
- **Orange:** Domain Systems Layer
- **Purple:** Storage/Monitoring Layer
- **Gray:** Infrastructure Layer

---

*All diagrams reflect the current production implementation as of 2026-02-11*