---
title: "n8n Workflow Schedule Master List"
type: "schedule_master"
status: "active"
owner: "Michal"
updated: "2026-04-10"
---

# n8n Workflow Schedule Master List

All scheduled workflows in the Brain (n8n) automation system. Times are in Warsaw timezone (Europe/Warsaw).

## Daily Morning Briefings (6:00 - 7:00)

| Time | Workflow | Purpose | Status |
|------|---------|---------|--------|
| 6:40 AM | SVC_Daily-SmartHome-Brief | Smart home status briefing | active |
| 6:45 AM | SVC_Daily-Calendar-Brief | Today's calendar | active |
| 6:46 AM | SVC_Daily-Tasks-Brief | Top priorities from goals | active |
| 6:47 AM | SVC_Daily-Weather-Brief | Weather forecast | active |
| 6:48 AM | SVC_Daily-SmartHome-Brief | Smart home status briefing | active |
| 6:49 AM | SVC_Daily-Workout-Suggestion | HIT training recommendation | inactive |
| 6:50 AM | PROJ_Personal-Budget-Intelligence | Budget summary | active |
| 6:55 AM | SVC_Email-Summary-Agent | Email triage | active |

## Finance Sync (Every 6-12 hours)

| Time | Workflow | Purpose | Status |
|------|---------|---------|--------|
| Every 6h | Autonomous Finance - 2026 Data Sync | Transaction sync | active |
| Every 12h | Autonomous Finance - Budget Sync | Budget sync | active |
| 8 AM, 8 PM | Autonomous Finance - Daily Budget Alerts | Budget alerts | inactive |

## System Monitoring

| Time | Workflow | Purpose | Status |
|------|---------|---------|--------|
| Every 60 min (8-21) | SVC_Workflow-Heartbeat-Monitor | Workflow health | active |

## Household Operations

| Time | Workflow | Purpose | Status |
|------|---------|---------|--------|
| Every 12h | svc_autonomous-pantry-data-sync | Pantry sync | active |
| Every 12h | SVC_Autonomous-Pantry-Data-Sync | Pantry sync | active |

## Expense Calendar (G05)

| Time | Workflow | Purpose | Status |
|------|---------|---------|--------|
| Every 6h | svc_expense-calendar-data-sync | Expense sync | active |
| Daily 8 AM | svc_expense-calendar-alerts | Expense alerts | active |

## Intelligence & Optimization

| Time | Workflow | Purpose | Status |
|------|---------|---------|--------|
| Daily | SVC_Autonomous-Schedule-Negotiator | Schedule optimization | active |
| Daily | SVC_Autonomous-Friction-Resolver | Friction resolution | active |
| 8 PM | svc_reflection-provider | Daily reflection | active |

## Telegram-Triggered

| Trigger | Workflow | Command | Status |
|---------|----------|---------|--------|
| Telegram | ROUTER_Intelligent_Hub | /any command | active |

## Manual/On-Demand Only (No Schedule)

These workflows are triggered only by other workflows or manually:

- ROUTER_Intelligent_Hub
- SVC_Input-Normalizer
- SVC_Response-Dispatcher
- SVC_Format-Detector-Extractor
- SVC_Intelligence-Processor
- SVC_Notification-Dispatcher
- SVC_Digital-Twin-Status
- SVC_Digital-Twin-Morning-Briefing
- SVC_Google-Calendar
- SVC_Zepp-Health-Sync
- SVC_Digital-Twin-Todos
- SVC_Digital-Twin-Tasks
- SVC_Digital-Twin-Report
- SVC_Digital-Twin-Planner-Today
- SVC_Digital-Twin-Planner-Tomorrow
- SVC_Digital-Twin-Suggested
- SVC_Digital-Twin-Harvest
- SVC_Digital-Twin-OS
- SVC_Digital-Twin-Vision (inactive)
- SVC_Digital-Twin-Shopping-List
- SVC_Digital-Twin-Log-Coffee
- SVC_Digital-Twin-Planner-Map
- SVC_Digital-Twin-Career-Data
- PROJ_Expense_Calendar
- PROJ_Inventory-Management
- PROJ_Training-Intelligence-System
- PROJ_Personal-Budget-Intelligence-System

---

## How to Read This File

- **Active** = Currently running in n8n
- **Inactive** = Deactivated in n8n but potentially re-activatable
- Times are in 24h format (Europe/Warsaw timezone)
- "Every X" means recurring interval

## Quick Reference (Morning)

| Hour | Workflows |
|------|----------|
| 6:40 | SmartHome Brief |
| 6:45 | Calendar Brief |
| 6:46 | Tasks Brief |
| 6:47 | Weather Brief |
| 6:48 | SmartHome Brief |
| 6:49 | Workout Suggestion (inactive) |
| 6:55 | Email Summary |

## Cron Reference (Advanced)

| Workflow | Cron Expression |
|----------|---------------|
| Finance Budget Sync | Every 12 hours |
| Finance Data Sync | Every 6 hours |
| Budget Alerts | `0 8,20 * * *` (8 AM, 8 PM) |
| Heartbeat Monitor | Every 60 minutes |
| Reflection Provider | Daily (specific time TBD) |