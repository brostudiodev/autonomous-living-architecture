---
title: "Architecture Diagrams"
type: "documentation"
status: "active"
owner: "Michal"
updated: "2026-04-08"
---

# Autonomous Living Architecture Diagrams

## Overview

This document contains high-level and low-level architectural diagrams for the autonomous-living ecosystem as of 2026-04-08.

---

## 🎯 **CORE ARCHITECTURAL PATTERN: Python = Body, n8n = Brain**

This is the fundamental design principle governing all system architecture:

```mermaid
graph TB
    subgraph "🐍 PYTHON = BODY (Data & Execution)"
        PYTHON_SCRIPTS["Domain Scripts<br/>(G07, G05, G03...)"]
        DATA_LAYER["S03 Data Layer<br/>(PostgreSQL)"]
        EXTERNAL_APIS["External APIs<br/>(Zepp, Banks, Withings)"]
        
        EXTERNAL_APIS --> PYTHON_SCRIPTS
        PYTHON_SCRIPTS --> DATA_LAYER
    end

    subgraph "🧠 n8n = BRAIN (Intelligence & Routing)"
        N8N_ROUTER["WF001 Agent Router<br/>(Intent Classification)"]
        N8N_AI["Gemini LLM<br/>(Reasoning & Synthesis)"]
        N8N_WORKFLOWS["Sub-Workflows<br/>(Calendar, Finance, Inventory)"]
        
        N8N_ROUTER --> N8N_AI
        N8N_ROUTER --> N8N_WORKFLOWS
    end

    subgraph "📱 USER INTERFACE"
        TELEGRAM_USER["Telegram User"]
        OBSIDIAN_NOTE["Obsidian Daily Note"]
        GRAFANA["Grafana Dashboards"]
    end

    subgraph "🔄 BIDIRECTIONAL FLOW"
        USER_TO_SYSTEM["Direction 2: User Commands<br/>(Telegram → System)"]
        SYSTEM_TO_USER["Direction 1: Data Ingestion<br/>(APIs → PostgreSQL → User)"]
    end

    %% Direction 1: Data Ingestion
    EXTERNAL_APIS -->|"1. Pull data"| PYTHON_SCRIPTS
    PYTHON_SCRIPTS -->|"2. Write to DB"| DATA_LAYER
    DATA_LAYER -->|"3. Aggregate"| PYTHON_SCRIPTS
    PYTHON_SCRIPTS -->|"4. Inject into Obsidian"| OBSIDIAN_NOTE
    
    %% Direction 2: User Commands
    TELEGRAM_USER -->|"1. Send command"| N8N_ROUTER
    N8N_ROUTER -->|"2. Route to AI/Workflow"| N8N_AI
    N8N_AI -->|"3. Execute action"| N8N_WORKFLOWS
    N8N_WORKFLOWS -->|"4. Update DB/API"| DATA_LAYER
    
    %% Outbound Notifications
    PYTHON_SCRIPTS -->|"5. Notify user"| TELEGRAM_USER
    DATA_LAYER -->|"3b. Visualize"| GRAFANA

    style PYTHON_SCRIPTS fill:#e1f5fe
    style N8N_ROUTER fill:#f3e5f5
    style DATA_LAYER fill:#fff3e0
    style N8N_AI fill:#f3e5f5
```

### Pattern Rules

| Rule | Python (Body) | n8n (Brain) |
|------|---------------|--------------|
| **Responsibility** | Data ingestion, DB writes, calculations | Intent classification, AI reasoning, routing |
| **Triggers** | Cron schedules (06:00, 13:00, 16:00) | User input (Telegram, webhooks) |
| **Failure Mode** | Deterministic fallback | "Wait for n8n" state |
| **Examples** | `G07_zepp_sync.py`, `G05_finance_sync.py` | `WF001_Agent_Router`, `WF012_Calendar` |

> [!important]
> **Key Principle:** All LLM-based reasoning (Gemini) is strictly handled by n8n. Python scripts act as deterministic data providers and executors.

---

## 🔄 **BIDIRECTIONAL DATA FLOW ARCHITECTURE** *(NEW 2026-04-08)*

This diagram replaces the legacy DATA FLOW ARCHITECTURE (marked ⚠️ below).

```mermaid
flowchart TB
    subgraph "DIRECTION 1: DATA INGESTION (External APIs → User)"
        subgraph "External Sources"
            ZEPP["Zepp Cloud<br/>(Amazfit/Biometrics)"]
            WITHINGS["Withings Scale<br/>(Weight/Body Fat)"]
            BANKS["Banks<br/>(PKO, ING/Transactions)"]
            GOOGLE["Google<br/>(Calendar, Tasks)"]
            WEARABLE["Wearable Device"]
        end

        subgraph "🐍 PYTHON SCRIPTS (Body)"
            G07_SYNC["G07_zepp_sync.py<br/>06:15, 13:15, 16:15"]
            G07_WEIGHT["G07_weight_sync.py"]
            G05_SYNC["G05_finance_sync.py"]
            G05_BANK["G05_bank_ingest.py"]
            G03_SYNC["G03_pantry_sync.py"]
            G09_SYNC["G09_career_sync.py"]
        end

        subgraph "S03 Data Layer"
            HEALTH_DB["autonomous_health<br/>biometrics, sleep_log"]
            FINANCE_DB["autonomous_finance<br/>transactions, budgets"]
            PANTRY_DB["autonomous_pantry<br/>inventory, prices"]
            LOGISTICS_DB["autonomous_life_logistics"]
            TWIN_DB["digital_twin_michal<br/>system_activity_log"]
        end

        subgraph "G04 Digital Twin Engine"
            TWIN_ENGINE["G04_digital_twin_engine.py<br/>Aggregates all context"]
        end

        subgraph "G11 Global Sync"
            GLOBAL_SYNC["G11_global_sync.py<br/>Orchestrator (06:00, 13:00, 16:00)"]
        end

        subgraph "Output Layer"
            DAILY_NOTE["autonomous_daily_manager.py<br/>Obsidian Daily Note"]
            TELEGRAM_NOTIFY["G04_digital_twin_notifier.py<br/>Telegram Notifications"]
        end
    end

    subgraph "DIRECTION 2: USER COMMANDS (User → System → Action)"
        subgraph "Telegram User"
            USER_CMD["User Command<br/>/approve 45, 'Meeting Friday 10am'"]
            USER_VOICE["Voice Message"]
            USER_DOC["Photo/PDF/YouTube"]
        end

        subgraph "🧠 n8n INTELLIGENCE HUB"
            TELEGRAM_TRIGGER["Telegram Webhook<br/>Entry Point"]
            ROUTER["WF001 Agent Router<br/>Intent Classification"]
            
            subgraph "AI Processing"
                GEMINI["Gemini LLM<br/>Reasoning & Synthesis"]
            end
            
            subgraph "Sub-Workflows"
                WF_CALENDAR["WF012: Google Calendar<br/>check/create events"]
                WF_INVENTORY["WF010: Inventory<br/>add_item, check_stock"]
                WF_FINANCE["WF012: Budget Intelligence<br/>check_budget, categorize"]
                WF_TRAINING["WF011: Training<br/>log_workout, suggestions"]
            end

            subgraph "Intelligence Flows"
                CAPTURE["Intelligence Capture<br/>Save to Obsidian"]
                APPROVAL["Decision Approval<br/>Execute actions"]
            end
        end

        subgraph "Response"
            TELEGRAM_BOT["Telegram Bot<br/>@AndrzejAIBot"]
            API_UPDATE["Update DB/API/GitHub"]
        end
    end

    %% Direction 1 Flow
    ZEPP --> G07_SYNC
    WITHINGS --> G07_WEIGHT
    BANKS --> G05_BANK
    GOOGLE --> G05_SYNC
    WEARABLE --> G07_SYNC

    G07_SYNC --> HEALTH_DB
    G07_WEIGHT --> HEALTH_DB
    G05_BANK --> FINANCE_DB
    G05_SYNC --> FINANCE_DB
    G03_SYNC --> PANTRY_DB

    HEALTH_DB --> TWIN_DB
    FINANCE_DB --> TWIN_DB
    PANTRY_DB --> TWIN_DB

    TWIN_DB --> TWIN_ENGINE
    GLOBAL_SYNC --> TWIN_ENGINE
    TWIN_ENGINE --> DAILY_NOTE
    TWIN_ENGINE --> TELEGRAM_NOTIFY

    %% Direction 2 Flow
    USER_CMD --> TELEGRAM_TRIGGER
    USER_VOICE --> TELEGRAM_TRIGGER
    USER_DOC --> TELEGRAM_TRIGGER

    TELEGRAM_TRIGGER --> ROUTER
    ROUTER --> GEMINI
    ROUTER --> WF_CALENDAR
    ROUTER --> WF_INVENTORY
    ROUTER --> WF_FINANCE
    ROUTER --> WF_TRAINING

    GEMINI --> CAPTURE
    WF_CALENDAR --> TELEGRAM_BOT
    WF_INVENTORY --> TELEGRAM_BOT
    WF_FINANCE --> APPROVAL
    WF_TRAINING --> TELEGRAM_BOT

    CAPTURE --> TWIN_DB
    APPROVAL --> API_UPDATE

    style PYTHON_SCRIPTS fill:#e1f5fe
    style n8n_INTELLIGENCE_HUB fill:#f3e5f5
    style TWIN_DB fill:#fff3e0
    style TELEGRAM_BOT fill:#e8f5e9
```

---

## 📱 **TELEGRAM BOT ARCHITECTURE**

The Telegram bot has two separate data flows:

```mermaid
graph LR
    subgraph "INBOUND (User → System) - n8n Webhook"
        USER_MSG["User sends message<br/>/approve 45, 'Meeting Friday'"]
        TELEGRAM_CLOUD["Telegram Cloud<br/>api.telegram.org"]
        N8N_WEBHOOK["n8n Webhook<br/>WF001_Agent_Router"]
        
        USER_MSG --> TELEGRAM_CLOUD
        TELEGRAM_CLOUD -->|"Telegram Webhook"| N8N_WEBHOOK
    end

    subgraph "OUTBOUND (System → User) - Python Script"
        PYTHON_NOTIFIER["G04_digital_twin_notifier.py<br/>Python Script"]
        TELEGRAM_API["Telegram API<br/>api.telegram.org"]
        USER_PHONE["User Phone<br/>@AndrzejAIBot"]
        
        PYTHON_NOTIFIER -->|"sendMessage"| TELEGRAM_API
        TELEGRAM_API --> USER_PHONE
    end

    style N8N_WEBHOOK fill:#f3e5f5
    style PYTHON_NOTIFIER fill:#e1f5fe
```

### Telegram Architecture Notes

| Direction | Component | Status | Reason |
|-----------|-----------|--------|--------|
| **INBOUND** | Python polling bot (`G04_telegram_bot.py`) | ❌ Deprecated (2026-04-08) | 409 Conflict with n8n webhook |
| **INBOUND** | n8n Telegram Webhook | ✅ Active | WF001_Agent_Router receives all user input |
| **OUTBOUND** | `G04_digital_twin_notifier.py` | ✅ Active | Sends all notifications, CEO briefings, alerts |

> [!note]
> **Current Setup:** 
> - Inbound messages → n8n (via webhook)
> - Outbound notifications → Python script (via Telegram API)
> - Both use the same Telegram Bot token (`TELEGRAM_BOT_TOKEN`)

---

## 🏗️ **HIGH-LEVEL SYSTEM ARCHITECTURE**

```mermaid
graph TB
    subgraph "User Interface Layer"
        TELEGRAM_IN["Telegram (INBOUND)<br/>User messages → n8n Webhook"]
        TELEGRAM_OUT["Telegram (OUTBOUND)<br/>G04_digital_twin_notifier.py"]
        TWIN_API[Digital Twin API<br/>Port 5677]
        WEBHOOK[Webhook API<br/>/intelligence-hub]
        N8N_CHAT[n8n Chat Interface]
        GRAFANA[Grafana Dashboards<br/>Port 3003]
        OBSIDIAN[Obsidian Vault<br/>Daily Notes]
    end

    subgraph "🧠 Intelligence & Orchestration Layer (n8n = Brain)"
        G04[G04 Digital Twin<br/>Context Provider]
        GEMINI[Google Gemini AI<br/>Reasoning & Synthesis]
        RULES[G11 Rules Engine<br/>Policy Enforcer]
        N8N[n8n Platform<br/>WF001 Agent Router]
    end

    subgraph "🐍 Data Processing Layer (Python = Body)"
        PROCESSOR[Content Processor<br/>Multi-format Support]
        ROUTER[Intelligent Router<br/>Intent Classification]
        INGESTION[Data Ingestion<br/>06:00, 13:00, 16:00 Cron]
        GHOST[G04 Ghost Schema<br/>Self-Calibration]
        SYNC_SCRIPTS["Domain Scripts<br/>G07, G05, G03..."]
    end

    subgraph "Domain Systems Layer"
        G01[Training System<br/>Body Fat Tracking]
        G03[Pantry Management<br/>AI Inventory]
        G05[Financial Command<br/>PostgreSQL + Alerts]
        G07[Health Integration<br/>Withings API]
    end

    subgraph "Storage & Monitoring Layer"
        POSTGRES[(PostgreSQL<br/>Single Source of Truth)]
        SHEETS[Google Sheets<br/>Human Entry Interface]
        GITHUB[GitHub<br/>Documentation Storage]
        PROMETHEUS[Prometheus<br/>Metrics Collection]
    end

    subgraph "Infrastructure Layer"
        DOCKER[Docker Compose<br/>Service Containerization]
        BACKUP[Backup System<br/>Automated Daily]
    end

    %% Telegram Split - INBOUND vs OUTBOUND
    TELEGRAM_IN -->|"1. Webhook"| N8N
    N8N -->|"2. Route to sub-workflows"| RULES
    RULES -->|"3. Execute actions"| SYNC_SCRIPTS
    
    TELEGRAM_OUT -->|"4. Notifications"| POSTGRES
    
    %% Other Inputs
    WEBHOOK --> N8N
    N8N_CHAT --> N8N
    GRAFANA --> PROMETHEUS

    %% Intelligence Layer
    G04 --> GEMINI
    G04 --> PROCESSOR
    G04 --> ROUTER
    G04 --> RULES
    RULES --> GHOST
    GHOST --> RULES
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
    INGESTION --> GHOST

    %% Domain Systems to Storage
    SYNC_SCRIPTS --> G01
    SYNC_SCRIPTS --> G03
    SYNC_SCRIPTS --> G05
    SYNC_SCRIPTS --> G07
    
    G01 --> POSTGRES
    G03 --> POSTGRES
    G05 --> POSTGRES
    G07 --> POSTGRES
    G04 --> GITHUB
    POSTGRES --> OBSIDIAN

    %% Monitoring & Observability
    G01 --> PROMETHEUS
    G03 --> PROMETHEUS
    G05 --> PROMETHEUS
    G07 --> PROMETHEUS
    PROMETHEUS --> GRAFANA

    %% Infrastructure Support
    POSTGRES --> BACKUP
    GITHUB --> BACKUP
    SHEETS -- "Backup Only" --> BACKUP

    %% Telegram Outbound from Rules
    RULES --> TELEGRAM_OUT
    G04 --> TELEGRAM_OUT

    style TELEGRAM_IN fill:#e8f5e9
    style TELEGRAM_OUT fill:#e8f5e9
    style SYNC_SCRIPTS fill:#e1f5fe
    style N8N fill:#f3e5f5
```

## 🔄 **DATA FLOW ARCHITECTURE** (Legacy - See Bidirectional Flow Above)

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
        POSTGRES_DB[(PostgreSQL<br/>Single Source of Truth)]
        SHEETS_UI[(Google Sheets<br/>Human Interface)]
        GITHUB_DOCS[GitHub<br/>Versioned Documentation]
        PROMETHEUS_METRICS[Prometheus<br/>Time Series Data]
    end

    subgraph "Distribution & Output"
        TELEGRAM_RESPONSE[Telegram Responses<br/>Bot Conversations]
        SLACK_ALERTS[Slack Notifications<br/>System Alerts]
        GRAFANA_DASHBOARDS[Grafana Dashboards<br/>Visual Analytics]
        OBSIDIAN_LOGS[Obsidian Daily Notes<br/>Mission Briefings]
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
    CONTENT_EXTRACTION --> GITHUB_DOCS
    INTENT_CLASSIFICATION --> N8N_WORKFLOWS

    %% Storage Connections
    POSTGRES_DB --> PROMETHEUS_METRICS
    N8N_WORKFLOWS -- "Bidirectional Sync" --- SHEETS_UI
    N8N_WORKFLOWS --> POSTGRES_DB

    %% Output Distribution
    POSTGRES_DB --> GRAFANA_DASHBOARDS
    GEMINI_AI --> TELEGRAM_RESPONSE
    POSTGRES_DB --> SLACK_ALERTS
    POSTGRES_DB --> OBSIDIAN_LOGS
```

## 🏛️ **SYSTEM COMPONENT ARCHITECTURE**

```mermaid
graph TB
    subgraph "External APIs"
        GEMINI_API[Google Gemini API<br/>AI Processing]
        OPENAI_WHISPER[OpenAI Whisper<br/>Voice Transcription]
        WITHINGS_API[Withings API<br/>Health Data]
        GITHUB_API[GitHub API<br/>Documentation Sync]
        TELEGRAM_API[Telegram API<br/>api.telegram.org]
    end

    subgraph "Communication Layer"
        TELEGRAM_IN[Telegram INBOUND<br/>n8n Webhook Trigger]
        TELEGRAM_OUT[Telegram OUTBOUND<br/>G04_digital_twin_notifier.py]
        TWIN_API_SRV[Digital Twin API<br/>FastAPI]
        WEBHOOK_SERVER[Webhook Server<br/>/intelligence-hub]
    end

    subgraph "Workflow Engine (n8n = Brain)"
        N8N_CORE[n8n Core<br/>Workflow Orchestration]
        WF001[WF001 Router<br/>Digital Twin Hub]
        WF102[WF102 Budget Alerts<br/>Financial Monitoring]
        WF105[WF105 Pantry AI<br/>Inventory Management]
    end

    subgraph "Data Services (Python = Body)"
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

    %% Communication Layer - Telegram Split
    TELEGRAM_IN -->|"Webhook trigger"| WF001
    TELEGRAM_OUT -->|"sendMessage"| TELEGRAM_API
    TWIN_API_SRV --> WF001
    WEBHOOK_SERVER --> WF001
    ALERT_MANAGER --> TELEGRAM_OUT

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

    style TELEGRAM_IN fill:#e8f5e9
    style TELEGRAM_OUT fill:#e8f5e9
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
- **Rectangles (Blue 🟦):** Python Scripts (Body) - Data & Execution
- **Rectangles (Purple 🟪):** n8n Workflows (Brain) - Intelligence & Routing
- **Cylinders (Orange 🟧):** PostgreSQL Databases (Data Layer)
- **Hexagons:** External APIs/Services
- **Circles (Green 🟩):** User Interface (Telegram, Obsidian)

### **Color Coding**
- 🟦 **Light Blue:** Python Scripts (Deterministic execution)
- 🟪 **Light Purple:** n8n Workflows (AI intelligence)
- 🟧 **Light Orange:** PostgreSQL (Data persistence)
- 🟩 **Light Green:** User Interface (Telegram, Obsidian)

### **Architecture Pattern**
- **🐍 Python = Body:** Pulls data from external APIs, writes to PostgreSQL, generates daily notes
- **🧠 n8n = Brain:** Receives user input, classifies intent, routes to sub-workflows, triggers AI processing

### **Connection Types**
- **Solid Arrows:** Direct data flow/synchronous calls
- **Dashed Arrows:** Event-driven/asynchronous communication
- **Double Arrows:** Bidirectional communication
- **Dotted Lines:** Potential/Planned connections

---

### **Telegram Architecture Note**
- **Inbound (User → System):** Via n8n Webhook → WF001 Agent Router
- **Outbound (System → User):** Via Python (`G04_digital_twin_notifier.py`) → Telegram API

---

*Core Architecture Pattern documented: 2026-04-08*
*Bidirectional Flow Architecture documented: 2026-04-08*
*Telegram split architecture documented: 2026-04-08*