---
title: "S09: Productivity & Time"
type: "system"
status: "active"
owner: "Michał"
updated: "2026-02-07"
---

# S09: Productivity & Time

## Purpose
Implement AI-powered productivity system that measures and improves effective productive hours by Dec 31, 2026. Increase productive output by 40% without working more total time, automate context switching and optimal task-time matching, and reduce manual planning time by 80%.

## Scope
- Included: ActivityWatch time tracking, AI-powered pattern analysis, Automated daily planning, Smart calendar optimization, Home Assistant focus mode integration, Context-aware break management, Energy pattern matching
- Excluded: Employee monitoring, Team productivity tracking, Time billing integration, Project management for teams

## Interfaces
- Inputs: Application usage data from ActivityWatch, Calendar events and schedules, Manual context logging via terminal aliases, Daily energy/focus reflections, Task completion data, Project progress metrics
- Outputs: Productivity insights, Optimized daily schedules, Focus mode automation, Break recommendations, Pattern-based task suggestions, Performance metrics dashboards
- APIs/events: ActivityWatch API, Google Calendar API, Claude API (analysis), Home Assistant API (environment control), Obsidian API (planning), Time-series database for metrics

## Dependencies
- Services: ActivityWatch for tracking, Claude API for analysis, Google Calendar API for scheduling, Home Assistant for environmental control, Obsidian for planning, Time-series database for metrics
- Hardware: Homelab with Docker capability, ActivityWatch deployment, Smart devices for focus mode (lighting/temperature control)
- Credentials (names only): activitywatch_api, google_calendar_credentials, claude_api_key, home_assistant_api, obsidian_api, timeseries_db_credentials

## Observability
- Logs: ActivityWatch data collection logs, Pattern analysis job executions, Calendar optimization results, Focus mode automation triggers, API sync failures
- Metrics: Daily productive hours, Context switching frequency, Focus session quality, Planning time reduction percentage, Task completion rates, Energy pattern accuracy
- Alerts: Unusual productivity patterns, Missed focus sessions, Calendar conflicts, Data collection gaps, System automation failures

## Runbooks / SOPs
- Related SOPs: ActivityWatch setup and configuration, Calendar optimization procedures, Focus mode environment setup, Energy tracking procedures, Productivity analysis interpretation
- Related runbooks: Productivity data backup/recovery, Calendar conflict resolution, Focus environment troubleshooting, Pattern analysis tuning

