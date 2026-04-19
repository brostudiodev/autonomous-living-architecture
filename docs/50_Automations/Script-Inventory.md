# Script Inventory & Classification

This document provides a comprehensive list of all scripts in the `scripts/` directory, classified by their domain and functionality. This serves as the foundation for the upcoming script optimization phase.

## 🏗️ Classification Overview

| Category | Description |
| :--- | :--- |
| **G-Series (G01-G13)** | Goal-specific automations tied to the 12 Power Goals. |
| **Management & Orchestration** | Core system runners (Daily, Evening, Weekly). |
| **Infrastructure & System** | Heartbeat, backups, self-healing, and database maintenance. |
| **Utilities & Maintenance** | Link fixing, cleanup, and one-off migration/debug scripts. |

---

## 🎯 G-Series: Goal-Specific Automations

These scripts are the primary drivers of the 12 Power Goals.

### G01: Target Body Fat & Physical Performance
- **G01_monthly_reporter.py**: Generates a monthly summary of body composition and training progress. [Doc](./scripts/G01_monthly_reporter.md)
- **G01_progress_analyzer.py**: Analyzes weekly trends in weight and body fat vs. targets. [Doc](./scripts/G01_progress_analyzer.md)
- **G01_progressive_overload.py**: Calculates required weight increases based on previous performance. [Doc](./scripts/G01_progressive_overload.md)
- **G01_strength_auditor.py**: Audits TUT (Time Under Tension) and PRs. [Doc](./scripts/G01_strength_auditor.md)
- **G01_strength_gains_reporter.py**: Summarizes strength improvements across key lifts. [Doc](./scripts/G01_strength_gains_reporter.md)
- **G01_training_injector.py**: Injects daily workout targets into Obsidian. [Doc](./scripts/G01_training_injector.md)
- **G01_training_planner.py**: Generates a 4-week training block based on recovery state. [Doc](./scripts/G01_training_planner.md)

### G02: Automationbro Brand & Content
- **G02_brand_orchestrator.py**: Coordinates content distribution across LinkedIn and Substack. [Doc](./scripts/G02_brand_orchestrator.md)
- **G02_content_harvester.py**: Scrapes relevant news and ideas for content creation. [Doc](./scripts/G02_content_harvester.md)
- **G02_content_performance.py**: Tracks engagement metrics (views, likes, shares). [Doc](./scripts/G02_content_performance.md)
- **G02_substack_sync.py**: Syncs Substack subscriber and view data to Postgres. [Doc](./scripts/G02_substack_sync.md)

### G03: Autonomous Household Operations
- **G03_appliance_monitor.py**: Tracks energy usage and maintenance cycles of home appliances. [Doc](./scripts/G03_appliance_monitor.md)
- **G03_cart_aggregator.py**: Unifies pantry needs, meal plans, and manual items into one cart. [Doc](./scripts/G03_cart_aggregator.md)
- **G03_meal_planner.py**: Proposes weekly meals based on inventory and macros. [Doc](./scripts/G03_meal_planner.md)
- **G03_pantry_one_click.py**: Injects missing items directly into Google Tasks/Cart. [Doc](./scripts/G03_pantry_one_click.md)
- **G03_pantry_suggestor.py**: Analyzes stock levels and suggests restocks. [Doc](./scripts/G03_pantry_suggestor.md)
- **G03_predictive_pantry_decay.py**: Autonomously reduces inventory based on consumption models. [Doc](./scripts/G03_predictive_pantry_decay.md)
- **G03_price_scouter.py**: Compares prices across integrated supermarket APIs (Blix, etc.). [Doc](./scripts/G03_price_scouter.md)

### G04: Digital Twin Ecosystem
- **G04_digital_twin_api.py**: The FastAPI entry point for all system interactions. [Doc](./scripts/G04_digital_twin_api.md)
- **G04_digital_twin_engine.py**: The core intelligence layer for context processing. [Doc](./scripts/G04_digital_twin_engine.md)
- **G04_life_simulator.py**: The 6-month life outcome simulator and trend forecaster. [Doc](./scripts/G04_life_simulator.md)
- **G04_ghost_schema_reporter.py**: Measures the accuracy of system predictions vs. reality. [Doc](./scripts/G04_ghost_schema_reporter.md)
- **G04_knowledge_decay_monitor.py**: Flags stale notes and forgotten projects in the vault. [Doc](./scripts/G04_knowledge_decay_monitor.md)
- **G04_roi_tracker.py**: Quantifies time saved by each automation. [Doc](./scripts/G04_roi_tracker.md)
- **G04_telegram_bot.py**: The interactive interface for approvals and status. [Doc](./scripts/G04_telegram_bot.md)

### G05: Autonomous Financial Command Center
- **G05_bank_ingest.py**: Imports transactions from bank CSVs/APIs. [Doc](./scripts/G05_bank_ingest.py)
- **G05_budget_rebalancer.py**: Suggests fund movements to clear budget breaches. [Doc](./scripts/G05_budget_rebalancer.md)
- **G05_finance_anomaly_detector.py**: Detects unusual spending spikes. [Doc](./scripts/G05_finance_anomaly_detector.md)
- **G05_finance_sync.py**: Syncs data between Google Sheets and Postgres. [Doc](./scripts/G05_finance_sync.md)
- **G05_llm_categorizer.py**: Uses LLMs to categorize uncategorized transactions. [Doc](./scripts/G05_llm_categorizer.md)
- **G05_preemptive_rebalancer.py**: Automatically rebalances before breaches occur based on friction forecasts. [Doc](./scripts/G05_preemptive_rebalancer.md)
- **G05_tax_savings_agent.py**: Scans for new income and generates decision requests for tax/savings allocations. [Doc](./scripts/G05_tax_savings_agent.md)

### G06: Certification Exams & Atomic Learning
- **G06_learning_ingester.py**: Captures atomic notes from web/books into the vault. [Doc](./scripts/G06_learning_ingester.md)
- **G06_study_velocity.py**: Tracks progress against exam deadlines. [Doc](./scripts/G06_study_velocity.md)
- **G06_learning_deadline_recalculator.py**: Adjusts deadlines based on actual velocity. [Doc](./scripts/G06_learning_deadline_recalculator.md)

### G07: Predictive Health Management
- **G07_health_recovery_pro.py**: Adjusts life/load based on HRV and Sleep. [Doc](./scripts/G07_health_recovery_pro.md)
- **G07_bio_nutrition_agent.py**: Bio-optimized supplement and nutrition advice. [Doc](./scripts/G07_bio_nutrition_agent.md)
- **G07_illness_detector.py**: Flags biological anomalies suggesting oncoming illness. [Doc](./scripts/G07_illness_detector.md)
- **G07_zepp_sync.py**: Syncs biometric data from Zepp Cloud. [Doc](./scripts/G07_zepp_sync.md)
- **G07_weight_sync.py**: Syncs weight from Withings/Smart Scale. [Doc](./scripts/G07_weight_sync.md)

### G08: Predictive Smart Home Orchestration
- **G08_hardware_monitor.py**: Monitors Homelab server vitals (CPU, Temp). [Doc](./scripts/G08_hardware_monitor.md)
- **G08_home_monitor.py**: Reads status of all Home Assistant sensors. [Doc](./scripts/G08_home_monitor.md)
- **G08_pre_bed_advisor.py**: Suggests optimal bedroom cooling/lighting for sleep. [Doc](./scripts/G08_pre_bed_advisor.md)
- **G08_contextual_security.py**: Calendar-aware security and energy proposals. [Doc](./scripts/G08_contextual_security.md)

### G09: Automated Career Intelligence
- **G09_career_evidence_collector.py**: Aggregates technical wins from git/Jira. [Doc](./scripts/G09_career_evidence_collector.md)
- **G09_technical_win_harvester.py**: Specifically extracts "conventional commits" for brand building. [Doc](./scripts/G09_technical_win_harvester.md)
- **G09_sync_daily_goals.py**: Synchronizes goal activities from the Daily Note to Goal logs. [Doc](./scripts/G09_sync_daily_goals.md)

### G10: Intelligent Productivity & Time Architecture
- **G10_calendar_enforcer.py**: Protects deep work blocks in Google Calendar. [Doc](./scripts/G10_calendar_enforcer.md)
- **G10_focus_intelligence.py**: Predicts optimal focus windows based on energy. [Doc](./scripts/G10_focus_intelligence.md)
- **G10_schedule_optimizer.py**: Autonomously rearranges tasks to fit current readiness. [Doc](./scripts/G10_schedule_optimizer.md)
- **G10_schedule_negotiator.py**: AI-led schedule negotiation with biometrics and tasks. [Doc](./scripts/G10_schedule_negotiator.md)
- **G10_intelligence_sync.py**: Syncs daily note metrics (mood, energy) to Postgres. [Doc](./scripts/G10_intelligence_sync.md)
- **G10_tomorrow_planner.py**: Generates the "Primary Directive" for the next day. [Doc](./scripts/G10_tomorrow_planner.md)
- **G10_zone_in_orchestrator.py**: Prepares the workspace context for the current mission. [Doc](./scripts/G10_zone_in_orchestrator.md)
- **G10_activitywatch_sync.py**: Syncs ActivityWatch events to DB for productivity analysis. [Doc](./scripts/G10_activitywatch_sync.md)

### G11: Meta-System Integration & Optimization
- **G11_decision_proposer.py**: Proposes autonomous actions for the rules engine. [Doc](./scripts/G11_decision_proposer.md)
- **G11_decision_handler.py**: Executes approved autonomous decisions. [Doc](./scripts/G11_decision_handler.md)
- **G11_rules_engine.py**: The core logic for authority and autonomy levels. [Doc](./scripts/G11_rules_engine.md)
- **G11_global_sync.py**: The master script that orchestrates the entire system. [Doc](./scripts/G11_global_sync.md)
- **G11_system_vital_sentinel.py**: Monitors infrastructure and auto-restarts failed services. [Doc](./scripts/G11_system_vital_sentinel.md)
- **G11_db_recovery_shield.py**: Automated backup and restoration testing. [Doc](./scripts/G11_db_recovery_shield.md)
- **G11_documentation_security_scanner.py**: Scans documentation for sensitive data exposures. [Doc](./scripts/G11_documentation_security_scanner.md)
- **G11_friction_resolver.py**: Bridges qualitative frustrations and quantitative frictions for automation proposals. [Doc](./scripts/G11_friction_resolver.md)

### G12: Complete Process Documentation
- **G12_auto_documenter.py**: Automatically generates documentation for new scripts. [Doc](./scripts/G12_auto_documenter.md)
- **G12_auto_did_logger.py**: Autonomously logs daily achievements from Git, DB, and Tasks. [Doc](./scripts/G12_auto_did_logger.md)
- **G12_stale_docs_monitor.py**: Identifies documentation needing updates. [Doc](./scripts/G12_stale_docs_monitor.md)
- **G12_vault_janitor.py**: Maintains vault hygiene and organization. [Doc](./scripts/G12_vault_janitor.md)
- **G12_knowledge_agent.py**: Natural language search interface for the Obsidian Vault. [Doc](./scripts/G12_knowledge_agent.md)

### G13: Content Generation (New Domain)
- **G13_content_draft_agent.py**: Generates LinkedIn/Substack drafts from technical wins. [Doc](./scripts/G13_content_draft_agent.md)

---

## 🏎️ Management & Orchestration

These scripts manage the execution lifecycle of the entire system.

- **autonomous_daily_manager.py**: The "Morning Brief" and daily sync runner.
- **autonomous_evening_manager.py**: The "Evening Shutdown" and tomorrow planning runner.
- **autonomous_weekly_manager.py**: The "Weekly Review" and roadmap auditing runner.

---

## 🛠️ Infrastructure & Utility Scripts

Maintenance and setup scripts.

- **G11_log_system.py**: Standardized logging utility used by all scripts.
- **setup_twin_memory.py**: Initializes the strategic memory tables.
- **pantry_sync.py**: Syncs the master pantry dictionary from Sheets to DB.
- **fix_links.py / fix_links_v2.py**: Maintains link integrity in the Obsidian Vault.
- **cleanup_duplicates.py**: Removes redundant entries in Postgres tables.
- **standardize_goals_fm.py**: Ensures consistent YAML frontmatter across all goal files.

---

## 📦 Archived & Deprecated Scripts

These scripts have been moved to `scripts/archive/` as they are either broken, redundant, or superseded by newer logic. They are preserved for reference and can be restored if similar functionality is required.

- **G02_content_generator.py**: AI drafting logic. Superseded by G13_content_draft_agent.
- **G02_idea_generator.py**: Content idea generation. Moved to n8n workflows.
- **G02_linkedin_drafter.py**: LinkedIn specific drafting. Consolidated into G13.
- **G02_substack_scout.py**: Market research for Substack. Currently out of scope.
- **G04_digital_twin_listener.py**: Event-driven DB listener. Architecture moved to REST API polling/push.
- **G09_career_sync.py**: Legacy career DB setup. Replaced by unified intelligence schema.
- **G13_substack_draft_generator.py**: Redundant drafting logic. Consolidated into G13_content_draft_agent.
- **G13_linkedin_draft_generator.py**: Redundant drafting logic. Consolidated into G13_content_draft_agent.
- **test_sheets_pantry.py**: Legacy testing script for Google Sheets integration.

---

*Last Updated: 2026-04-19*  
*Inventory based on `{{ROOT_LOCATION}}/autonomous-living/scripts/`*
