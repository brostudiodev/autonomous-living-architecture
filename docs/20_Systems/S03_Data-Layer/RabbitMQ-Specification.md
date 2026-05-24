---
title: "S03: RabbitMQ Messaging Specification"
type: "technical_spec"
status: "active"
owner: "Michał"
updated: "2026-05-12"
---

# S03: RabbitMQ Messaging Specification (The Life Bus)

## 🎯 Purpose
This document defines the real-time messaging topology for the Autonomous Living ecosystem. RabbitMQ serves as the **Real-Time Reactive Layer** (The Life Bus) of the ecosystem, enabling sub-50ms situational awareness and reactive automation. While PostgreSQL stores the history, RabbitMQ broadcasts the *Now*.

## 🏗️ Core Topology

### Exchange: `life.events`
- **Type:** `topic`
- **Durable:** `true`
- **Purpose:** Central hub for all system-wide telemetry and state changes.

### Dead Letter Architecture (NEW May 12)
To prevent the silent drop of failed events, a **Dead Letter Exchange (DLX)** and **Dead Letter Queue (DLQ)** have been implemented.
- **DLX:** `life.events.dlx` (Type: `topic`)
- **DLQ:** `life.events.dlq` (Durable)
- **Policy:** `dlx-policy` applies to all production queues, automatically routing NACK'd (non-requeued) messages to the DLQ.

### The RED-Dispatcher (RED-Dispatcher)
The **Reactive Event-Driven Dispatcher (RED-Dispatcher)** (`G11_event_listener.py`) is the primary consumer. It translates raw events into immediate system actions.
- **Fault Tolerance:** If a processing error occurs, the dispatcher issues a `basic_nack(requeue=False)`, which triggers the DLX routing.

---

## 📥 Active Queues & Bindings

### 1. `eda-orchestrator` (n8n Reactive Layer)
- **Durable:** `true`
- **DLX Active:** `true`
- **Purpose:** Triggers autonomous recovery and notification workflows in n8n.
- **Bindings:**
    - `health.warning.#` (e.g., Low Readiness)
    - `household.warning.#` (e.g., Maintenance Required)
    - `meta.warning.#` (e.g., Script Failures)

### 2. `n8n-health-updates` (Specific Ingestion)
- **Durable:** `true`
- **DLX Active:** `true`
- **Purpose:** Targeted biometrics processing.
- **Bindings:**
    - `health.*.biometric_inserted`

### 3. `system-maintenance` (Operational Alerts)
- **Durable:** `true`
- **DLX Active:** `true`
- **Purpose:** Catch-all for meta-level warnings.
- **Bindings:**
    - `meta.warning.*`

### 4. `life.events.dlq` (Dead Letter Queue)
- **Durable:** `true`
- **Purpose:** Repository for events that failed processing (poison pills, schema mismatches).
- **Source:** `life.events.dlx` (#)

---

## 📤 Producers (Emitters)

| Source | Method | Key Pattern | Payload |
|--------|--------|-------------|---------|
| **G04 Engine** | `update_entity_state()` | `[type].info.state_updated` | Full state snapshot |
| **G04 API** | `POST /emit` | User-defined | Custom JSON |
| **G03 Appliance**| `monitor_appliances()`| `household.info.*` | Cycle/Maintenance data |
| **G07 Health** | `zepp_sync()` | `health.info.biometric_inserted` | Raw biometric JSON |

---

## 🛠️ Management & Troubleshooting

### UI Management
The RabbitMQ Management Console is available at `http://{{INTERNAL_IP}}:15672`.
- **Username:** `admin` (or `${RABBITMQ_USER}`)
- **Password:** `admin` (or `${RABBITMQ_PASS}`)

### Initialization Script
The topology is automatically provisioned on container startup via:
`{{ROOT_LOCATION}}/autonomous-living/infrastructure/rabbitmq/init.sh`

### Common Fixes
- **Queue Backup:** If `eda-orchestrator` queue fills up, verify n8n container is healthy and connected.
- **Connection Refused:** Ensure `rabbitmq` container status is `healthy`. The API uses "Smart Host Detection" to switch between `rabbitmq` (inside Docker) and `localhost`.

---

## 📜 Security Notes
- Messaging is currently internal-only (isolated within `autonomous-net`).
- All messages are persistent (`delivery_mode: 2`) to survive broker restarts.

---
*Updated: 2026-05-01 by Digital Twin Assistant*
