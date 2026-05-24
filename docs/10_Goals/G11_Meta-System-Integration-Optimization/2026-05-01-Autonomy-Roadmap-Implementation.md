# G11 Autonomous System Orchestration Update

## 🗓️ Date: 2026-05-01

### 🛠️ Purpose
Documentation of the transition from human-triggered automation to a permanent, event-driven system orchestration (EDA).

### 🚀 Implementation Details

#### 1. Permanent Event Listener (G11)
- **Script:** `{{ROOT_LOCATION}}/autonomous-living/modules/meta/scripts/G11_event_listener.py`
- **Service Name:** `eda-orchestrator`
- **Status:** Deployed via `docker-compose.yml`
- **Logic:** 
    - Background daemon listening to RabbitMQ `life.events`.
    - Handles `health.#`, `finance.#`, and `meta.warning.#` routing keys.
    - Successfully processes and logs `large_transaction_detected` and `transaction_categorized` events.

#### 2. Enhanced Financial Intelligence (G05)
- **Emitter Integration:** Added `G11_event_emitter` to `G05_bank_ingest.py` and `G05_llm_categorizer.py`.
- **New Events:**
    - `finance.warning.large_transaction_detected`: Triggered for transactions $\ge$ 1,000 PLN.
    - `finance.info.transaction_categorized`: Triggered upon successful AI auto-categorization.

#### 3. n8n Routing Hub (G04)
- **Workflow:** `EVENT_Health-Ops-Orchestrator` (ID: `geLMcpUFLegOX7OQ`)
- **Fix:** Restored Telegram Webhook routing to `master-telegram-router/webhook`.
- **Update:** Added `finance_warning` switch route to support reactive financial workflows.

### ⚠️ Failure Modes Encountered
- **Webhook Collision:** `EVENT_Digital-Twin-Decision-Resolver` was overwriting the Telegram webhook URL. Resolved by deactivating the conflicting workflow.
- **Credential Mismatch:** `SVC_Response-Dispatcher` had hardcoded credentials. Resolved by implementing **Dynamic Bot Credential Routing**.

### 📝 Next Steps
- [ ] Implement specific reaction logic for `finance.warning` in n8n (e.g., prompt for receipts).
- [ ] Connect `eda-orchestrator` to automated health recovery scripts (G07 integration).

---
*Created per Documentation-Standard.md on 2026-05-01*
