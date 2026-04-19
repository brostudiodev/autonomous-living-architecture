---
title: "Service Registry & Infrastructure"
type: "documentation"
status: "active"
owner: "Michal"
updated: "2026-04-16"
---

# Service Registry & Infrastructure

## Overview

This document provides a comprehensive registry of all active services, APIs, endpoints, and infrastructure components in the autonomous-living ecosystem as of 2026-02-11.

## 🐳 **DOCKER SERVICES (PRODUCTION)**

### **Monitoring Stack**
```yaml
services:
  grafana:
    port: 3003
    purpose: Visualization dashboards
    status: Active
    dashboards: Financial, G01 Training, Goals Overview, System Health
  
  prometheus:
    port: 9090
    purpose: Metrics collection and storage
    status: Active
    retention: 200 hours
    scrape_interval: 15s
  
  g01-exporter:
    port: 8081
    purpose: Training metrics exporter
    status: Active
    metrics: body_fat_percentage, workout_frequency, training_volume
  
  goals-exporter:
    port: 8083
    purpose: Goals progress metrics exporter
    status: Active
    metrics: goal_completion, activity_frequency, progress_percentage
  
  node-exporter:
    port: 9100
    purpose: System metrics collection
    status: Active
    metrics: cpu, memory, disk, network
  
  glances:
    port: 61208
    purpose: Real-time Linux host monitoring for Home Assistant
    status: Active
    type: systemd (not Docker)
    metrics: cpu, memory, disk, network, processes
    integration: Home Assistant sensor
    docs: ../50_Automations/scripts/S01_glances_system_monitor.md

  digital-twin-api:
    port: 5677
    purpose: REST interface for life state
    status: Active
    endpoints: /status, /all, /health, /hydration, /roi, /tomorrow, /log_water, /log_coffee, /system/velocity, /health/anomalies

  activitywatch:
    port: 5600
    purpose: Passive attention and time tracking telemetry
    status: Active
    type: aw-server-rust (Docker)
    docs: ./S09_Productivity-Time/ActivityWatch.md

  ### **Database Services**
  ```yaml
  databases:
  postgresql_financial:
    host: localhost
    database: autonomous_finance
    partitions: 2012-2027
    status: Production Ready
    schemas: transactions, budgets, digital_twin_updates, finance_entries (Historical)

  postgresql_health:
    host: localhost
    database: autonomous_health
    status: Active
    tables: biometrics, water_log, caffeine_log, sleep_log, body_metrics, activity_log

  postgresql_digital_twin:
    host: localhost
    database: digital_twin_michal
    status: Active
    tables: strategic_memory, autonomy_roi, system_activity_log, person_attributes, ghost_predictions, decision_requests, activity_watch_events

  postgresql_pantry:
    host: localhost
    database: autonomous_pantry
    status: Active
    tables: pantry_inventory, pantry_dictionary
  ```

```

---

## 🔄 **AUTOMATION SERVICES (N8N)**

### **Morning Brief Services**
```yaml
morning_brief_workflows:
  SVC_Daily-Calendar-Brief:
    type: Daily Briefing
    status: Active
    schedule: 6:45 AM
    purpose: Today's calendar and focus blocks
    
  SVC_Daily-Tasks-Brief:
    type: Daily Briefing
    status: Active
    schedule: 6:46 AM
    purpose: Top priorities from goal Roadmaps
    
  SVC_Daily-Weather-Brief:
    type: Daily Briefing
    status: Active
    schedule: 6:47 AM
    purpose: Weather forecast, backyard temp, clothing
    
  SVC_Daily-SmartHome-Brief:
    type: Daily Briefing
    status: Active
    schedule: 6:48 AM
    purpose: Home sensor status
    
  SVC_Daily-Workout-Suggestion:
    type: Daily Briefing
    status: Active
    schedule: 6:49 AM
    purpose: Training recommendation
    
  PROJ_Personal-Budget-Intelligence:
    type: Daily Briefing
    status: Active
    schedule: 6:50 AM
    purpose: Financial status vs budget
    
  SVC_Email-Summary-Agent:
    type: Daily Briefing
    status: Active
    schedule: 6:55 AM
    purpose: Email triage and prioritization
```

### **Production Workflows**
```yaml
workflows:
  WF001_Agent_Router:
    type: Digital Twin Router
    status: Production Ready
    webhook: master-telegram-router
    integrations: Telegram, GitHub, Google Gemini, OpenAI Whisper
    functions: Multi-channel input processing, AI analysis, content routing
  
  WF102_Budget_Alerts:
    type: Financial Monitoring
    status: Production Ready
    schedule: 8:00 AM & 8:00 PM
    integrations: PostgreSQL, Telegram, Slack
    functions: Budget threshold checking, alert generation, notification sending
  
  WF101_Transaction_Import:
    type: Data Processing
    status: Production Ready
    trigger: Manual/Automated
    integrations: Google Sheets, PostgreSQL
    functions: CSV processing, transaction categorization, data validation
  
  WF003_Training_Sync:
    type: Data Synchronization
    status: Production Ready
    schedule: Every 6 hours
    integrations: GitHub, Google Sheets
    functions: Training data validation, schema compliance, git commits
  
  WF104_Digital_Twin_Ingestion:
    type: Data Aggregation
    status: Production Ready
    schedule: Every 8 hours
    integrations: Google Sheets, PostgreSQL, Slack
    functions: Multi-source data collection, transformation, storage
  
  WF105_Pantry_Management:
    type: AI-Powered Inventory
    status: Production Ready
    trigger: Event-driven
    integrations: Google Gemini, Telegram, PostgreSQL
    functions: NLP processing, inventory management, grocery planning
    
  Autonomous_Finance_Budget_Sync:
    type: Data Synchronization
    status: Production Ready
    schedule: Every 12 hours
    integrations: Google Sheets, PostgreSQL
    functions: Financial data sync
```

---

## 🌐 **API ENDPOINTS & WEBHOOKS**

### **Active Endpoints**
```yaml
endpoints:
  telegram_router:
    url: /webhook/master-telegram-router
    method: POST
    purpose: Telegram bot interface
    authentication: Bot token
    rate_limit: 30 requests/minute
  
  intelligence_hub:
    url: /webhook/intelligence-hub
    method: POST
    purpose: External system integration
    authentication: API key
    format: JSON
  
  github_webhook:
    url: https://api.github.com/repos/brostudiodev/michal-second-brain-obsidian
    purpose: Documentation synchronization
    authentication: Personal Access Token
    events: push, pull_request
```

### **Placeholder Endpoints (Need Implementation)**
```yaml
placeholder_endpoints:
  llm_chat:
    url: YOUR_LLM_CHAT_WEBHOOK_URL
    purpose: Advanced AI conversation
    status: Placeholder
  
  task_creator:
    url: YOUR_TASK_CREATOR_WEBHOOK_URL
    purpose: Automated task generation
    status: Placeholder
  
  callback_handler:
    url: YOUR_CALLBACK_HANDLER_WEBHOOK_URL
    purpose: Event processing
    status: Placeholder
  
  intelligence_activator:
    url: YOUR_INTELLIGENCE_ACTIVATOR_WEBHOOK_URL
    purpose: Advanced workflow triggering
    status: Placeholder
```

---

## 🔗 **EXTERNAL INTEGRATIONS**

### **Authentication & Credentials**
```yaml
credentials:
  telegram_bot:
    name: "AndrzejSmartBot"
    type: Bot Token
    purpose: Multi-channel communication
    status: Active
  
  google_gemini:
    type: API Key
    purpose: AI analysis and content processing
    features: 6 custom tools, NLP, content extraction
    status: Active
  
  openai_whisper:
    type: API Key
    purpose: Voice transcription
    status: Active
  
  withings_health:
    type: OAuth 2.0
    purpose: Health data collection
    token_management: Automatic refresh
    status: Active
  
  google_sheets:
    type: Service Account
    purpose: Data entry interface
    spreadsheets: Training, Health, Goals, Pantry
    status: Active
  
  github:
    type: Personal Access Token
    repository: brostudiodev/michal-second-brain-obsidian
    purpose: Documentation and code synchronization
    status: Active
  
  slack:
    type: Bot Token
    purpose: Notification distribution
    channels: #health, #finance, #system-status
    status: Active
```

### **API Integrations**
```yaml
api_integrations:
  withings_api:
    base_url: https://wbsapi.withings.net
    endpoints: measure, getuser, getdevice
    data_types: weight, bmi, fat_ratio, muscle_mass, bone_mass, hydration
    rate_limit: 300 requests/hour
    status: Production Ready
  
  google_gemini_api: "{{GEMINI_API_KEY}}": https://generativelanguage.googleapis.com
    features: text_generation, content_analysis, tool_use
    custom_tools: 6 specialized functions
    status: Production Ready
```

---

## 📊 **PROMETHEUS METRICS CATALOG**

### **G01 Training Metrics**
```yaml
g01_metrics:
  body_fat_percentage:
    type: gauge
    description: Current body fat percentage (7-day moving average)
    labels: workout_type, measurement_source
  
  workout_frequency:
    type: counter
    description: Number of workouts completed
    labels: workout_type, intensity_level
  
  training_volume:
    type: gauge
    description: Total training load (weight × reps × sets)
    labels: exercise_category, muscle_group
  
  tut_compliance:
    type: gauge
    description: Time Under Tension compliance percentage
    labels: exercise_type, target_range
```

### **Goals Progress Metrics**
```yaml
goals_metrics:
  goal_completion_percentage:
    type: gauge
    description: Progress towards goal completion
    labels: goal_id, goal_category, quarter
  
  activity_frequency:
    type: counter
    description: Number of goal-related activities
    labels: goal_id, activity_type, success_status
  
  integration_coverage:
    type: gauge
    description: Percentage of systems integrated
    labels: integration_type, status
  
  system_health_score:
    type: gauge
    description: Overall system health indicator
    labels: system_id, health_category
```

### **System Metrics**
```yaml
system_metrics:
  uptime_seconds:
    type: counter
    description: System uptime in seconds
    labels: service_name, instance
  
  error_rate:
    type: gauge
    description: Error rate percentage
    labels: service_name, error_type
  
  response_time:
    type: histogram
    description: Response time distribution
    labels: endpoint, method, status_code
```

---

## 🔧 **AUTOMATION SCHEDULES**

### **Morning Brief (Daily 6:45-6:55)**
```yaml
morning_brief:
  calendar_brief:
    frequency: "0 6 * * *"     # Daily at 6:45 AM
    workflow: SVC_Daily-Calendar-Brief
    purpose: Today's meetings and focus blocks
    
  tasks_brief:
    frequency: "1 6 * * *"    # Daily at 6:46 AM
    workflow: SVC_Daily-Tasks-Brief
    purpose: Top priorities from goal Roadmaps
    
  weather_brief:
    frequency: "2 6 * * *"    # Daily at 6:47 AM
    workflow: SVC_Daily-Weather-Brief
    purpose: Weather forecast and clothing suggestions
    
  smarthome_brief:
    frequency: "3 6 * * *"    # Daily at 6:48 AM
    workflow: SVC_Daily-SmartHome-Brief
    purpose: Home sensor status (temp, energy, security)
    
  workout_suggestion:
    frequency: "4 6 * * *"    # Daily at 6:49 AM
    workflow: SVC_Daily-Workout-Suggestion
    purpose: Training recommendation based on recovery
    
  budget_brief:
    frequency: "5 6 * * *"    # Daily at 6:50 AM
    workflow: PROJ_Personal-Budget-Intelligence
    purpose: Financial status vs budget
    
  email_summary:
    frequency: "5 6 * * *"    # Daily at 6:55 AM
    workflow: SVC_Email-Summary-Agent
    purpose: Email triage and prioritization
```

### **Other Schedules**
```yaml
schedules:
  digital_twin_ingestion:
    frequency: "0 */8 * * *"  # Every 8 hours
    workflow: WF104
    purpose: Multi-system data collection
    duration: ~5 minutes
  
  budget_alerts:
    frequency: "0 8,20 * * *"     # Daily at 8 AM & 8 PM
    workflow: WF102
    purpose: Financial threshold monitoring
    duration: ~2 minutes
  
  budget_sync:
    frequency: "0 */12 * * *"     # Every 12 hours
    workflow: Autonomous Finance - Budget Sync
    purpose: Financial data synchronization
    
  training_sync:
    frequency: "0 */6 * * *"  # Every 6 hours
    workflow: WF003
    purpose: Training data validation and git sync
    duration: ~3 minutes
  
  health_data_sync:
    frequency: "0 */2 * * *"  # Every 2 hours
    script: withings_to_sheets.py
    purpose: Withings API data collection
    duration: ~1 minute

  google_tasks_sync:
    frequency: "0 5 * * *"     # Daily at 5 AM (via Daily Manager)
    script: G10_google_tasks_sync.py
    purpose: External task synchronization
    duration: ~1 minute

  activity_watch_sync:
    frequency: "*/15 * * * *"  # Every 15 minutes (via Global Sync)
    script: G10_activitywatch_sync.py
    purpose: Attention telemetry synchronization
    duration: ~1 minute
  
  goals_exporter_scrape:
    frequency: "*/15 * * * *"  # Every 15 seconds
    service: goals-exporter
    purpose: Goal metrics collection
    duration: ~5 seconds

  daily_note_preparation:
    frequency: "0 5 * * *"     # Daily at 5 AM
    script: autonomous_daily_manager.py
    purpose: Daily note creation and task injection
    duration: ~1 minute
```

### **PostgreSQL pg_cron**
```yaml
pg_cron_jobs:
  refresh_budget_performance:
    frequency: "0 0,12 * * *"    # Midnight & noon
    function: refresh_budget_performance()
    purpose: Refresh materialized views
    
  refresh_savings_rate:
    frequency: "0 */6 * * *"     # Every 6 hours
    function: refresh_savings_rate()
    purpose: Recalculate savings rate metrics
```

---

## 📊 **INTERFACE-DATABASE CONNECTION MATRIX**

### UI Interfaces (REST APIs & Dashboards)

| Interface | Port | URL | Purpose |
|-----------|------|-----|---------|
| **Digital Twin API** | 5677 | `http://{{INTERNAL_IP}}:5677` | Life state, AI agent, data aggregation |
| **n8n Web UI** | 5678 | `http://localhost:5678` | Workflow automation engine |
| **Grafana** | 3003 | `http://localhost:3003` | Dashboards (Financial, Health, Goals) |
| **Prometheus** | 9090 | `http://localhost:9090` | Metrics collection |
| **Home Assistant** | 8123 | `http://{{INTERNAL_IP}}:8123` | Smart home control |
| **Telegram Bot** | - | `@YourSmartBot` | Daily briefings, alerts |

### Databases

| Database | Host | Tables |
|----------|------|--------|
| `autonomous_finance` | localhost:5432 | transactions, budgets, merchants, categories, accounts |
| `autonomous_health` | localhost:5432 | biometrics, water_log, caffeine_log, sleep_log, body_metrics |
| `autonomous_training` | localhost:5432 | workouts, workout_sets, exercises, measurements |
| `autonomous_pantry` | localhost:5432 | pantry_inventory, pantry_dictionary |
| `autonomous_learning` | localhost:5432 | learning_progress, subject_metrics |
| `autonomous_career` | localhost:5432 | skill_metrics, project_impact |
| `digital_twin_michal` | localhost:5432 | strategic_memory, autonomy_roi, system_activity_log |
| `autonomous_life_logistics` | localhost:5432 | logistics_items, document_expiries |

### External APIs (No Direct DB Access)

| Service | URL | Auth | Purpose |
|---------|-----|------|---------|
| **Home Assistant** | `http://{{INTERNAL_IP}}:8123/api/states` | Long-lived token (`HA_TOKEN`) | Smart home sensors, lights, climate, security |

### UI → Database Connections

| UI Interface | Database/API | Direction | Mechanism |
|--------------|--------------|-----------|-----------|
| **Digital Twin API** | `digital_twin_michal` | ← Read | psycopg2 |
| **Digital Twin API** | `autonomous_finance` | ← Read | psycopg2 |
| **Digital Twin API** | `autonomous_health` | ← Read | psycopg2 |
| **Digital Twin API** | `autonomous_pantry` | ← Read | psycopg2 |
| **Digital Twin API** | `autonomous_training` | ← Read | psycopg2 |
| **n8n workflows** | `autonomous_finance` | ←/→ | n8n Postgres node |
| **n8n workflows** | `autonomous_health` | ←/→ | n8n Postgres node |
| **n8n workflows** | `digital_twin_michal` | ←/→ | n8n Postgres node |
| **Grafana** | `autonomous_finance` | ← Read | PostgreSQL datasource |
| **Grafana** | `autonomous_health` | ← Read | PostgreSQL datasource |
| **Grafana** | Prometheus | ← Read | Prometheus datasource |
| **Python Scripts** | Home Assistant REST API | ← Read | requests + HA_TOKEN (Bearer) |
| **n8n workflows** | Home Assistant REST API | ←/→ | HTTP Request + HA webhook |

### External Services Sync

| Service | Target | Direction | Sync Frequency |
|---------|--------|-----------|----------------|
| **Google Sheets** (Training) | `autonomous_training` | ←/→ | Every 6h |
| **Google Sheets** (Health) | `autonomous_health` | ←/→ | Every 2h |
| **Google Sheets** (Pantry) | `autonomous_pantry` | ←/→ | On-demand |
| **Withings API** | → `autonomous_health` | → | Every 2h |
| **Zepp/Amazfit** | → `autonomous_health` | → | Every 6h |
| **Home Assistant REST API** | Python Scripts / n8n | ← Read | On-demand |
| **Home Assistant Webhooks** | n8n / Python | ←/→ | Event-driven |
| **Google Tasks** | Digital Twin | ←/→ | Daily |
| **Google Calendar** | n8n | ← Read | Daily 6:45 AM |

---

## 📁 **DATA STORAGE LOCATIONS**

### **File System Structure**
```yaml
data_locations:
  google_sheets:
    training_data:
      spreadsheet: "Training Journal"
      worksheets: ["Workouts", "Progress", "Configuration"]
      sync_frequency: Every 6 hours
    
    health_data:
      spreadsheet: "Health Metrics"
      worksheets: ["Withings Data", "Health Trends"]
      sync_frequency: Every 2 hours
    
    goals_data:
      spreadsheet: "Goals Tracking"
      worksheets: ["2026 Goals", "Quarterly Progress"]
      sync_frequency: Manual/Automated
  
  postgresql:
    financial_data:
      database: autonomous_finance
      tables: transactions, budgets, merchants, categories
      partitions: yearly (2012-2027)
      backup: Daily automated
    
    digital_twin:
      database: autonomous_finance
      tables: digital_twin_updates
      update_frequency: Every 8 hours
      retention: 1 year
  
  github:
    documentation:
      repository: brostudiodev/michal-second-brain-obsidian
      sync_frequency: Event-driven
      backup: Git version control
    
    configuration:
      repository: brostudiodev/autonomous-living
      sync_frequency: Event-driven
      backup: Git version control
```

---

## 🚨 **ALERTING CONFIGURATION**

### **Alert Rules & Channels**
```yaml
alerts:
  financial:
    budget_breaches:
      threshold: 80% of budget category
      channels: [telegram, slack]
      severity: warning
      
    savings_rate_decline:
      threshold: <5% monthly savings rate
      channels: [telegram, slack]
      severity: critical
  
  system_health:
    service_downtime:
      threshold: >5 minutes service unavailable
      channels: [slack]
      severity: critical
      
    integration_failure:
      threshold: >3 consecutive failed syncs
      channels: [slack]
      severity: warning
  
  health_data:
    measurement_missing:
      threshold: >24 hours without health data
      channels: [telegram]
      severity: warning
      
    anomaly_detected:
      threshold: Significant deviation from health trends
      channels: [telegram, slack]
      severity: warning
```

---

## 🔐 **SECURITY CONFIGURATION**

### **Access Controls**
```yaml
security:
  api_authentication:
    type: API Keys + OAuth 2.0
    rotation: Quarterly
    storage: Environment variables + encrypted secrets
  
  database_access:
    type: PostgreSQL roles
    readonly_role: dashboard_access
    readwrite_role: automation_services
    admin_role: system_administration
  
  network_security:
    docker_networks: bridge networks with port mapping
    firewall_rules: Only exposed ports (3003, 9090, 8081, 8083, 9100)
    ssl_termination: nginx reverse proxy (planned)
  
  git_security:
    ssh_keys: Ed25519 key pairs
    branch_protection: Main branch protected
    commit_signing: GPG signed commits (planned)
```

---

## 📈 **PERFORMANCE BASELINES**

### **Service Performance Targets**
```yaml
performance_targets:
  response_times:
    telegram_bot: <2 seconds
    webhooks: <1 second
    database_queries: <500ms
    api_calls: <3 seconds
  
  availability:
    critical_services: 99.9% uptime
    batch_processes: 99.5% success rate
    data_sync: 95% on-time completion
  
  throughput:
    data_ingestion: 1000 records/minute
    webhook_processing: 60 requests/minute
    metrics_collection: 100 metrics/second
```

---

## 🔄 **BACKUP & RECOVERY**

### **Backup Strategy**
```yaml
backups:
  database:
    postgresql:
      frequency: Daily automated
      retention: 30 days
      method: pg_dump + WAL archiving
      storage: Local + cloud backup
    
  configuration:
    docker_compose_files:
      frequency: On change
      retention: Git history
      method: Git version control
    
    n8n_workflows:
      frequency: On export
      retention: Git history
      method: JSON export + git commit
  
  application_data:
    google_sheets:
      frequency: API-based export
      retention: 90 days
      method: Google Takeout + local backup
```

---

## Conclusion

This service registry represents a **production-ready autonomous living ecosystem** with sophisticated integration between financial, health, training, and AI systems. The infrastructure demonstrates mature DevOps practices with proper monitoring, alerting, backup strategies, and security controls.

**Infrastructure Maturity: 9/10** - Highly sophisticated with production-grade reliability and observability.