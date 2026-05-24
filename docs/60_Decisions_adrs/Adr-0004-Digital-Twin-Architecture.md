---
title: "Adr-0004: Digital Twin as Cognitive Cortex"
type: "decision"
status: "accepted"
date: "2025-08-15"
updated: "2026-05-12"
deciders: ["Michał"]
---

# Adr-0004: Digital Twin as Cognitive Cortex (Evolution from Hub)

## Status
Accepted (v3.0 - Transitioned to Cognitive Cortex)

## Context
**Historical Note:** This ADR originally defined G04 as the "Central Hub" (Hub-and-Spoke). As of Q2 2026, the Hub-and-Spoke model has been superseded by the **Life-Nervous-System Architecture (Adr-0031)**.

## Decision
G04 Digital Twin is no longer the mandatory "Router" for all system traffic. Instead, it has been elevated to the **Cognitive Cortex and Memory Node** of the ecosystem.

### **New Architecture Pattern**
- **Mesh Node:** Digital Twin acts as a high-level subscriber to the RabbitMQ event bus.
- **Cognitive Layer:** Focuses on multi-domain reasoning, long-term memory, and semantic search.
- **State Observer:** Maintains the holistic state of the user by aggregating events into the Digital Twin database, but does not block other agents from communicating directly.

### **Core Responsibilities (Updated)**
1. **Long-Term Memory:** Persisting high-fidelity state snapshots from the event bus.
2. **Semantic Cortex:** Providing RAG (Retrieval-Augmented Generation) context to other agents via `/query` and `/status` endpoints.
3. **Deep Reasoning:** Handling complex queries that require historical cross-domain analysis.
4. **Identity Management:** Serving as the source of truth for "Personal Context" (Bio, Preferences, Goals).

### **Technical Implementation**
```python
# G04_digital_twin_engine.py
class DigitalTwinHub:
    def __init__(self):
        self.data_sources = ["G01", "G03", "G05", "G07", "G12", "Logistics"]
        self.state_store = PostgreSQLDigitalTwin()
    
    def aggregate_data(self):
        """Collect data from all connected systems and persist state"""
        # Implementation of health, finance, and logistics aggregation
```

### **Service Layer Decision (Added 2026-02-19)**
To enable real-time, low-latency access to the Digital Twin's state for the Intelligent Hub (n8n) and other consumers, I will implement a **FastAPI-based REST API**.

- **Purpose:** Decouples data aggregation logic from communication logic.
- **Port:** 5677 (adjacent to n8n for easy discovery).
- **Protocol:** REST/JSON.
- **State snapshots:** Every call to the `/status` endpoint triggers a persistence event to PostgreSQL for historical tracking.
- **Advanced Context (Added 2026-03-04):** The `/all` endpoint enriched with 7-day health trends, cross-domain correlations (e.g. Activity vs Weight), and strategic memory for continuity.

## Consequences

### **Positive Consequences**
- **Unified Context:** All systems have access to cross-domain data
- **Intelligent Coordination:** AI can optimize across multiple domains
- **Single Interface:** Users interact with one intelligent system instead of 12 separate ones
- **Data Consistency:** Central state management prevents inconsistencies
- **Cross-Domain Optimization:** Health data influences scheduling, financial constraints inform all systems
- **Scalability:** New systems can easily plug into central hub
- **Reduced Complexity:** Users don't need to understand 12 different systems

### **Negative Consequences**
- **Single Point of Failure:** Digital Twin becomes critical dependency
- **Complexity:** Hub system becomes complex itself
- **Performance Bottleneck:** All cross-system operations go through hub
- **Development Overhead:** Initial investment in building hub infrastructure
- **Maintenance Burden:** Hub system needs continuous maintenance and updates
- **Data Privacy Concerns:** Central hub contains all personal data

## Implementation

### **Phase 1: Data Aggregation Layer**
- Implement scheduled data collection from all systems
- Create unified data models for cross-domain data
- Build data validation and normalization pipeline
- Implement data freshness monitoring
- **Engine Completion (2026-02-19):** `G04_digital_twin_engine.py` unifies Training and Finance databases.

### **Phase 2: Intelligence Layer**
- Integrate Google Gemini for AI processing
- Implement intent classification for user requests
- Build cross-domain analysis capabilities
- Create recommendation engine for optimization suggestions
- **API Completion (2026-02-19):** `G04_digital_twin_api.py` exposes state via FastAPI on port 5677.

### **Phase 3: Communication Interface**
- Implement Telegram bot as primary interface
- Create webhook endpoints for external integrations
- Build natural language processing for Polish and English
- Implement multi-modal content processing (voice, images, documents)
- **Hub Integration (2026-02-19):** n8n service `SVC_Digital-Twin-Status` connects Hub to REST API.

### **Phase 4: Orchestration Engine**
- Implement cross-system workflow coordination
- Create event-driven action triggers
- Build dependency resolution system
- Implement conflict resolution for competing actions

### **Phase 5: Integration Scaling**
- Create standardized integration APIs for new systems
- Implement dynamic service discovery
- Build integration testing framework
- Create documentation and integration patterns

## Alternatives Considered

### **Alternative 1: Decentralized Mesh Architecture**
- Each system communicates directly with others
- No central hub, peer-to-peer communication
**Rejected:**
- Exponential complexity as systems grow (N² connections)
- No unified user interface
- Difficult to maintain consistency
- Higher network overhead
- Complex dependency management

### **Alternative 2: Multiple Domain Hubs**
- Separate hubs for different domains (health hub, finance hub, etc.)
- Limited cross-domain communication
**Rejected:**
- Still creates silos between domains
- Users need to interact with multiple hubs
- Misses opportunities for cross-domain optimization
- Higher total complexity across multiple hubs

### **Alternative 3: Event Bus Architecture**
- Systems publish events to central message bus
- Other systems subscribe to relevant events
- No central intelligence, just event routing
**Rejected:**
- No unified intelligence or coordination
- Difficult to implement cross-domain logic
- Complex event schema management
- No single user interface for coordination

### **Alternative 4: Manual Integration**
- Each system operates independently
- Users manually coordinate between systems
- No automated cross-system communication
**Rejected:**
- Defeats purpose of autonomous living
- High manual overhead
- No cross-domain optimization
- Poor user experience

## Related Decisions
- [Adr-0003](Adr-0003-Technology-Stack-Selection.md) - Technology Stack Selection
- [Adr-0007](Adr-0007-Multi-Channel-Data-Ingestion.md) - Multi-Channel Data Ingestion
- [Adr-0010](Adr-0010-Hub-and-Spoke-Integration.md) - Hub-and-Spoke Integration Pattern
- [Adr-0016](Adr-0016-Event-Driven-Architecture.md) - Event-Driven Architecture

## Metrics

### **Success Criteria**
- **Integration Coverage:** 100% of systems connected to Digital Twin
- **Data Freshness:** <2 hours latency from source to hub
- **Cross-Domain Actions:** >50% of optimizations involve multiple systems
- **User Satisfaction:** <2 second response time for complex queries
- **System Intelligence:** AI suggestions improve outcomes >70% of time

### **Performance Targets**
- **Hub Response Time:** <3 seconds for cross-domain queries
- **Data Aggregation:** <30 minutes for full ecosystem sync
- **AI Processing:** <5 seconds for intent classification and planning
- **Orchestration Latency:** <1 minute from trigger to coordinated action

### **Reliability Requirements**
- **Hub Uptime:** >99.95% availability
- **Data Consistency:** >99.9% consistency across systems
- **Recovery Time:** <5 minutes from hub failure to recovery
- **Error Rate:** <1% of coordinated actions fail

---

*Last updated: 2026-02-19*