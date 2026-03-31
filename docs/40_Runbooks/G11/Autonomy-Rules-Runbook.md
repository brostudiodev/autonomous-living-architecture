---
title: "Autonomy Rules Runbook"
type: "runbook"
status: "active"
owner: "Michal"
goal_id: "goal-g11"
systems: ["S08", "S11"]
updated: "2026-03-26"
---

# Autonomy Rules Runbook

## Purpose

This runbook defines the autonomy boundaries and decision execution rules for the `G11_decision_handler` automation. It establishes when the system can execute actions autonomously versus when human approval via Telegram is required.

## Scope

This runbook governs decision execution across:
- **G05 Financial:** Budget rebalancing, account transfers
- **G03 Household:** Procurement approvals, shopping decisions
- **G10 Productivity:** Schedule changes, calendar modifications

## Autonomy Levels

### Level 1: Fully Autonomous (No Approval Required)

Actions that can execute immediately without human intervention:

| Domain | Action | Threshold | Example |
|--------|--------|-----------|---------|
| Finance | Internal category rebalance | < 100 PLN | Move 50 PLN from "Entertainment" to "Savings" |
| Household | Low-stock notification | Any | Alert when item qty < reorder point |
| Schedule | Focus block protection | Any | Prevent meetings during Deep Work |

### Level 2: Telegram Approval Required

Actions that require explicit human approval via Telegram:

| Domain | Action | Threshold | Example |
|--------|--------|-----------|---------|
| Finance | Budget rebalance | ≥ 100 PLN | Move 200 PLN between budget categories |
| Finance | Inter-account transfer | Any | Transfer 500 PLN between accounts |
| Household | Grocery purchase | ≥ 50 PLN | Add 100 PLN grocery order to cart |
| Household | Promo purchase approval | Any | Approve buying promo item at different store |
| Schedule | Event modification | Any | Reschedule existing meeting |
| Schedule | New commitment | During Deep Work | Add meeting during protected time |

### Level 3: Explicit Confirmation Required

Actions that require detailed confirmation with preview:

| Domain | Action | Threshold | Example |
|--------|--------|-----------|---------|
| Finance | Multi-account rebalance | ≥ 500 PLN | Move funds across 3+ accounts |
| Finance | Investment action | Any | Buy/sell investment position |
| Household | Bulk shopping | ≥ 200 PLN | Full weekly grocery run |
| Schedule | Delete recurring event | Any | Remove weekly sync meeting |

## Cascading Resolution Logic
To prevent duplicate actions (e.g., adding the same item to a shopping list twice), the system implements **Cascading Resolution**:
- When a request is **APPROVED**, the system automatically scans for all older `PENDING` requests within the same domain and category.
- These older requests are marked as `SUPERSEDED` and silences their notifications.
- **Human Guidance:** Always approve the *latest* (highest ID) request for a specific item to ensure the most up-to-date data is used.

## Decision Handler Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    G11_decision_handler Flow                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Trigger received (from any Goal system)                     │
│                    │                                             │
│                    ▼                                             │
│  ┌─────────────────────────────────────────┐                    │
│  │     Classify Decision Type              │                    │
│  │     - Finance / Household / Schedule    │                    │
│  └─────────────────────────────────────────┘                    │
│                    │                                             │
│                    ▼                                             │
│  ┌─────────────────────────────────────────┐                    │
│  │     Check Autonomy Level                │                    │
│  │     - Level 1: Execute immediately      │                    │
│  │     - Level 2: Send Telegram approval   │                    │
│  │     - Level 3: Require explicit confirm │                    │
│  └─────────────────────────────────────────┘                    │
│                    │                                             │
│          ┌─────────┴─────────┐                                  │
│          ▼                   ▼                                  │
│    [Execute]           [Await Approval]                        │
│          │                   │                                  │
│          │                   ▼                                  │
│          │         ┌─────────────────┐                         │
│          │         │ Telegram Prompt │                         │
│          │         │ - Action detail│                         │
│          │         │ - Impact preview│                         │
│          │         │ - Approve/Deny  │                         │
│          │         └─────────────────┘                         │
│          │                   │                                  │
│          │         ┌─────────┴─────────┐                        │
│          │         ▼                   ▼                        │
│          │    [APPROVED]         [DENIED]                      │
│          │         │                   │                        │
│          │         ▼                   ▼                        │
│          │    [Execute]         [Log + Skip]                   │
│          │         │                   │                        │
│          └─────────┴───────────────────┘                        │
│                        │                                         │
│                        ▼                                         │
│              ┌─────────────────┐                               │
│              │ Log Result to   │                               │
│              │ system_activity │                               │
│              └─────────────────┘                               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Telegram Approval Format

When Level 2 or 3 approval is required, the Telegram message format:

```
🤖 Autonomous Decision Request

📋 Action: [Brief description]
💰 Amount: [Value if financial]
⏰ Impact: [What changes]

[Preview details]

Approve? 
/approve [request_id]
/deny [request_id]
```

## Failure Handling

### If Telegram Approval Times Out (24 hours)

| Priority | Action |
|----------|--------|
| High | Re-send notification, alert via alternative channel |
| Medium | Log as "Pending Approval", skip this cycle |
| Low | Archive request, notify in weekly summary |

### If Execution Fails

| Error Type | Response |
|------------|----------|
| API Error | Retry 3x with exponential backoff |
| Auth Failure | Alert immediately, require re-authentication |
| Insufficient Funds | Deny execution, notify user of reason |
| Rate Limit | Queue for next execution window |

### Recovery Procedures

1. **Check execution status:**
   ```bash
   # View recent decision executions
   grep "decision_handler" _meta/daily-logs/*.log
   ```

2. **View pending approvals:**
   ```bash
   # Query pending decisions
   python scripts/G11_decision_handler.py --status
   ```

3. **Force retry failed decision:**
   ```bash
   # Retry specific decision
   python scripts/G11_decision_handler.py --retry {request_id}
   ```

4. **Cancel pending decision:**
   ```bash
   # Cancel pending approval
   python scripts/G11_decision_handler.py --cancel {request_id}
   ```

## Safety Guardrails

### Hard Stops (Cannot Be Bypassed)

- **Single transaction > 1000 PLN** - Always requires approval
- **Net negative daily savings** - Block budget rebalance
- **Schedule conflict during 2+ hour block** - Block event creation
- **Negative inventory item** - Block removal, require correction

### Soft Limits (Configurable)

| Limit | Default | Can Override |
|-------|---------|-------------|
| Auto-rebalance frequency | Max 2x/day | Via Telegram |
| Housekeeping budget | 500 PLN/month | Via Telegram |
| Focus block minimum | 1 hour | Always protected |

## Configuration

### Threshold Adjustments

Edit `decision_thresholds` in the configuration:

```yaml
# autonomous-living/config/decision_rules.yaml
finance:
  auto_rebalance_limit: 100  # PLN
  approval_required_above: 100  # PLN
  explicit_confirm_above: 500  # PLN

household:
  auto_approve_shopping: 50  # PLN
  approval_required_above: 50  # PLN
  bulk_purchase_threshold: 200  # PLN

schedule:
  protect_deep_work: true
  min_focus_block: 60  # minutes
  max_auto_reschedule: 3  # per day
```

## Related Documentation

- [G11 Meta-System Integration](../../10_Goals/G11_Meta-System-Integration-Optimization/README.md)
- [G11 Decision Handler Automation](../../50_Automations/scripts/G11_decision_handler.md)
- [Telegram Approval SOP](../../30_Sops/Telegram-Approval-SOP.md)
- [G05 Financial Systems](../G05/README.md)
- [G03 Household Systems](../G03/README.md)
- [G10 Productivity Systems](../G10/README.md)

---

*Owner: Michal*  
*Review Cadence: Monthly*  
*Last Updated: 2026-03-26*
