---
title: "G03: Roadmap"
type: "goal_roadmap"
status: "active"
owner: "Michał"
updated: "2026-04-19"
goal_id: "goal-g03"
---

# Roadmap (2026)

## Q1 (Jan–Mar)
- [x] **Pantry Management System v1.0 Deployed:** Controlled by the **Standard AI Agent** with natural language support.
- [x] **Direct Data Sync:** Implemented Google Sheets to PostgreSQL synchronization (no CSV files).
- [x] Integrate pantry consumption data with grocery automation (WF101)
- [x] **Predictive Restocking Engine:** Implemented real-time analysis of PostgreSQL pantry data (v1.1) ✅ (Feb 28)
- [x] Connect household budget constraints from G05 (Autonomous Finance) via S05 Finance ✅ (Master Brain integration)
- [x] Begin feeding household operational data into G12 (Meta-System) for cross-system optimization ✅ (G11 Mapper)
- [x] Expand pantry system to include expiration date tracking and alerts ✅ (G03 Expiration Alerting)
- [x] **Autonomous Meal Commitment (Chef's Choice):** Automated daily meal selection based on stock and expiry ✅ (Mar 03)
- [x] **Cart Aggregation v1.0:** Unified shopping manifest combining low stock and meal requirements ✅ (Mar 03)
- [x] **On-Demand Shopping List:** API endpoint `/shopping_list` for real-time procurement generation ✅ (Mar 06)
- [x] **Urgent Daily Injection:** Automated dashboard section for high-priority household needs ✅ (Mar 06)
- [x] **Last Mile Procurement (v1.5):** Direct 'One-Click' links for Biedronka, Lidl, and Blix.pl in manifest ✅ (Mar 23)
- [x] **Agentic Procurement (v2.0):** Proactive Telegram approval requests for critical stock restocking ✅ (Mar 25)
- [x] **Level 5 Autonomous Procurement:** auto_procurement now FULL authority ✅ (Mar 27)

## Q2 (Apr–Jun) - Optimization Phase

> [!tip] 🚀 **Q2 Focus: System Stability & Minor Improvements**
- [x] **System Stability Audit:** ✅ (Apr 16)
  - [x] **Sub-task: Pantry Sync Check** - Ensure Google Sheets to PostgreSQL sync without gaps ✅ (Apr 16)
  - [x] **Sub-task: PRICE_SCOUTER v2** - Fixed path mapping and script failure in sync loop ✅ (Apr 16)
- [ ] **Minor Improvements:**
  - [ ] **Sub-task: Appliance Monitor Optimization** - Fine-tune power monitoring thresholds
  - [ ] **Sub-task: Burn Rate Calibration** - Adjust predictive consumption based on recent accuracy

> [!tip] 🚀 **High-Impact Autonomy Tasks**
- [x] **Price Intelligence (G03-PI):** Cheapest Basket algorithm for Lidl vs Biedronka vs Dino - provide recommendations ✅ (Mar 23)
- [x] **Cross-Store Optimization:** Recommend which store to visit based on current promos ✅ (Mar 23)
- [x] **Predictive consumption modeling:** Linked Ghost Schema accuracy to burn rate buffers & enabled 3-day Telegram alerts ✅ (Mar 27)
- [x] **Pantry Location Architecture:** Upgraded to 5 physical locations (Spizarka, Gabinet, Bathroom x2, Laundry) ✅ (Mar 28)
- [x] **Performance Nutrition Auto-Pilot:** Link HIT schedule to recovery staples procurement ✅ (Mar 28)
- [x] **Pantry One-Click Aggregation (v2.1):** Automatically pushes pantry needs and meal ingredients to "Shopping" Google Tasks list ✅ (Apr 01)
> 
> **Architecture:** System analyzes → Sends recommendation/notification → User or HA takes action

- [x] Deploy AI meal planning engine with approval workflow and calendar integration ✅ (Mar 03)
- [x] Implement predictive reordering for top 30 household items based on burn rate ✅ (Mar 06)
- [x] **Phase: Price Intelligence (G03-PI):** (Mar 18)
    - [x] Prototype `G03_price_sync_blix.py` targeting Biedronka/Lidl aggregators.
    - [x] Implement "Cheapest Basket" algorithm for Lidl vs. Biedronka vs. Dino.
    - [x] Integrate Auchan Direct scraping for bulk item price comparison.
- [x] Build appliance health monitoring with predictive failure detection (power monitoring) ✅ (Apr 09)
- [x] **Appliance Maintenance Integration (G03-AMI):** Integrated filters and salt status into the G04 life sentinel for unified mission injection ✅ (Apr 19)

## Q3 (Jul–Sep) - Phase: Intelligence-Led Procurement
- [x] Implement "Auto-Cart" integration (Agent populates manifest for shopping) ✅ (Mar 03)
- [x] **Cross-Store Optimization:** Agent recommends which store to visit based on current 7-day promos. (Mar 18)
- [x] Predictive consumption modeling (Agent knows when you will run out of X)
- [ ] Achieve 100% Procurement Intelligence (User knows exactly where to go for best ROI)

## Q4 (Oct–Dec)
- [ ] Transition from approval workflows to fully autonomous operation
- [ ] Implement self-healing capabilities for common system failures
- [ ] Deploy meta-optimization analyzing cross-system efficiencies
- [ ] Full integration with G08 (Predictive Smart Home Orchestration)
- [ ] Document lessons learned and strategy for 2027

## Dependencies
- **Systems:** S03 (Data Layer for inventory, sensor data), S05 (Finance for budget integration), S07 (Smart Home for device control), S08 (Automation Orchestrator for workflows)
- **External:** Google Sheets API, n8n, various smart device APIs
- **Other goals:** G05 (Autonomous Finance) for budget, G08 (Smart Home Orchestration) for device integration, G12 (Meta-System) for overall optimization.
