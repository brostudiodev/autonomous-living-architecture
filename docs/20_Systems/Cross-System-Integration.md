---
title: "Cross-System Integration Architecture"
type: "documentation"
status: "active"
owner: "Michał"
updated: "2026-04-16"
---

# Cross-System Integration Architecture

## Overview

This document provides a comprehensive overview of all active data flows and integrations between systems in the autonomous-living ecosystem. It represents the **actual implemented connections** between production systems as of 2026-04-16.

## Integration Classification

### 🟢 **Active Integrations** (Production-ready data flows)
### 🟡 **Planned Integrations** (Designed but not implemented)
### ⚪ **Potential Integrations** (Logical connections not yet built)

---

## 🟢 **ACTIVE INTEGRATIONS**

### **G04 Digital Twin → Central Data Hub**

#### **Data Ingestion (Every 15 minutes / 8 hours)**
```
Source Systems → G04 Digital Twin → PostgreSQL Storage
```

**Active Data Sources:**
- **G10 Productivity Data:** ActivityWatch (Window/App telemetry), Google Tasks, Calendar
- **G05 Financial Data:** Budget metrics, transaction summaries, savings rates
- **G01 Training Data:** Workout frequency, body fat trends, performance metrics
- **G07 Health Data:** Withings metrics, biometric trends, health indicators
- **G03 Pantry Data:** Inventory status, grocery planning, household operations
- **Obsidian Vault:** Documentation metrics, goal progress, activity logs

#### **Total Recall: Cross-Domain SQL Analytics (NEW Mar 31)**
The **Total Recall** architecture allows the AI Agent to bypass domain-specific endpoints and perform direct, read-only SQL queries across multiple PostgreSQL databases.
- **Mechanism:** `DigitalTwinAPI` `/query` endpoint.
- **Access:** `health` (biometrics), `finance` (transactions), `twin` (memory/tasks), `training` (workouts), `career` (skills/market), `learning` (study history).
- **Use Case:** AI-driven correlation analysis (e.g., "Mood vs. Net Worth" or "Sleep vs. Spending").

#### **Career-Learning Strategic Steering (NEW Apr 27)**
A closed-loop system connecting professional development with market demand and public brand presence.
- **G06 Learning → G09 Career:** Automated synchronization of study hours into proficiency boosts in the Skill Inventory.
- **G09 Career ↔ G13 Content:** Career Strategist analyzes proficiency gaps against market demand and injects high-priority themes into the Content Idea harvest.
- **n8n Market Scout → G09 Career:** Real-time market demand updates autonomously steer the system's professional focus.

#### **Financial Wealth & FIRE Layer (NEW Apr 27)**
Expands beyond cash-flow to long-term financial autonomy.
- **G05 Finance ↔ G11 Mission:** Automated Net Worth tracking and FIRE progress milestones dynamically injected into the daily Golden Mission.

#### **Output & Broadcasting**
```
G04 Digital Twin → Telegram Bot → User Interaction
G04 Digital Twin → Obsidian Vault → Daily Note Enrichment
G04 Digital Twin → Slack Notifications → System Alerts
```

---

### **Financial Integration Network**

#### **G05 ↔ G03 (Pantry Management)**
```
G03 Shopping Lists → G05 Budget Analysis → Affordability Check → G03 Response
```
- **Real-time budget checking** before grocery list generation
- **Expense tracking** for household purchases
- **Budget alerts** when grocery spending approaches limits

#### **G05 ↔ G04 (Digital Twin)**
```
G05 Financial Metrics → G04 Data Ingestion → Cross-System Context
```
- **Financial health indicators** for overall system context
- **Budget performance** for strategic decision making
- **Savings trends** for long-term planning

---

### **Health & Performance Integration**

#### **G07 ↔ G01 (Training System)**
```
G07 Health Metrics → G01 Training Optimization → Performance Adjustments
```
- **Readiness-Based Progression:** Training planner now suggests weight/TUT adjustments based on G07 biological readiness.
- **Body composition data** informs training intensity.
- **Health indicators** guide workout planning and recovery.

#### **G07 ↔ G04 (Digital Twin)**
```
G07 Biometric Data → G04 Health Dashboard → Health Insights
```
- **Real-time health status** for overall system awareness
- **Trend analysis** for predictive health management
- **Cross-correlation** with training and nutrition data

---

### **Productivity & Context Integration**

#### **G10 ↔ G04 (Digital Twin)**
- **Attention Telemetry:** ActivityWatch (S09) sends passive app/window usage to the Twin for deep work analysis.
- **Mood Engine:** Correlates Health, Finance, and Logistics to autonomously suggest daily note markers.
- **Calendar Enforcer:** Syncs optimized schedule blocks from the Twin Engine to Google Calendar.

#### **Google Tasks ↔ Obsidian Synchronization**
```
Google Tasks API → G10 Sync Script → Autonomous Daily Manager → Obsidian Daily Note
```
- **Unification of external capture** with internal daily planning
- **Context-aware task injection** based on system priorities

---

### **System Status Audit**
- **G11 Mapper:** System Connectivity Map → Daily Note Health Check.
- **System Activity Heartbeat:** Centralized logging of all G-series script executions.

---

## 🟡 **PLANNED INTEGRATIONS**

### **Smart Home Integration (G08 - Documentation Only)**
```
IoT Sensors → G08 Smart Home → G04 Digital Twin → Automation Triggers
```

**Planned Features:**
- **Environmental monitoring** integrated with health tracking
- **Energy consumption** linked to financial tracking
- **Automated routines** coordinated with goal scheduling

---

## 📊 **DATA FLOW ARCHITECTURE**

### **Primary Data Bus Pattern**
```
Individual Systems → G04 Digital Twin → Processing → Distribution → Consumers
```

**Data Transformation Pipeline:**
1. **Collection:** Scheduled and event-driven data gathering
2. **Normalization:** Standardized format and units conversion
3. **Enrichment:** Context addition and cross-system correlation
4. **Distribution:** Multi-channel broadcasting and storage

---

## 🔧 **TECHNICAL INTEGRATION STACK**

### **Message Bus & Orchestration**
- **n8n Workflows:** Visual workflow orchestration platform
- **Digital Twin API:** RESTful gateway (FastAPI) with `BackgroundTasks` for timeout prevention.
- **PostgreSQL:** Primary data storage (SSOT) with relational schemas.

---

## Conclusion

The autonomous-living ecosystem has achieved **Level 5 Maturity** with the launch of **Passive Attention Telemetry** and automated deep work analysis. The system now possesses the ability to correlate any data point across its internal databases while autonomously quantifying human focus.

**Integration Maturity: 9.5/10** - Sophisticated, cross-domain, and self-documenting.
