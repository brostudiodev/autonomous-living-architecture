---
title: "Cron Jobs & Scheduled Tasks"
type: "system_doc"
status: "active"
owner: "{{OWNER_NAME}}"
review_cadence: "monthly"
created: "2026-02-20"
updated: "2026-02-20"
---

# Cron Jobs & Scheduled Tasks

Central documentation for all scheduled automation in the autonomous living system.

## Purpose

Track and document all time-based automation across the system to ensure reliability and enable troubleshooting.

## Scope

- **In Scope:** System crontab, n8n schedules, PostgreSQL pg_cron, GitHub Actions schedules
- **Out of Scope:** Real-time webhooks, event-driven triggers, manual executions

## System Crontab (Debian Host)

**Location:** `/etc/crontab` or `crontab -e`

| Time | Command | Description |
|------|---------|-------------|
| `0 5 * * *` | `autonomous_daily_manager.py` | Prepare daily Obsidian note |
| `#0 8 * * *` | `withings_to_sheets.py` | (commented out) Sync Withings data |

### Crontab Format

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6) (Sunday = 0)
│ │ │ │ │
* * * * * command to execute
```

### Common Expressions

| Expression | Meaning |
|------------|---------|
| `0 * * * *` | Every hour at minute 0 |
| `0 0 * * *` | Daily at midnight |
| `0 6 * * *` | Daily at 6 AM |
| `0 */6 * * *` | Every 6 hours |
| `0 8,20 * * *` | Twice daily (8 AM & 8 PM) |
| `0 0 * * 1` | Every Monday at midnight |

---

## n8n Schedule Triggers

### Morning Brief (Daily 6:45-6:55)

| Time | Workflow | File |
|------|----------|------|
| 6:45 | SVC_Daily-Calendar-Brief | `SVC_Daily-Calendar-Brief.json` |
| 6:46 | SVC_Daily-Tasks-Brief | `SVC_Daily-Tasks-Brief.json` |
| 6:47 | SVC_Daily-Weather-Brief | `SVC_Daily-Weather-Brief.json` |
| 6:48 | SVC_Daily-SmartHome-Brief | `SVC_Daily-SmartHome-Brief.json` |
| 6:49 | SVC_Daily-Workout-Suggestion | `SVC_Daily-Workout-Suggestion.json` |
| 6:50 | PROJ_Personal-Budget-Intelligence-System | `PROJ_Personal-Budget-Intelligence-System.json` |
| 6:55 | SVC_Email-Summary-Agent | `SVC_Email-Summary-Agent.json` |

### Other Scheduled Workflows

| Time | Workflow | Description |
|------|----------|-------------|
| 8:00 & 20:00 | Autonomous Finance - Daily Budget Alerts | Budget alerts |
| 12 hours | Autonomous Finance - Budget Sync | Financial data sync |
| 20:00 | WF105 Generate Activity Summaries | Daily summary generation |

---

## PostgreSQL pg_cron

Jobs scheduled inside the database using `pg_cron` extension.

| Job Name | Schedule | Function |
|----------|----------|----------|
| refresh-budget-performance | `0 0,12 * * *` | Refresh budget views |
| refresh-savings-rate | `0 */6 * * *` | Recalculate savings rate |

**Location:** Defined in `docs/20_SYSTEMS/S03_Data-Layer/README.md`

---

## GitHub Actions Scheduled Workflows

| Workflow | Schedule | Description |
|----------|----------|-------------|
| WF_G01_001 | `0 */6 * * *` | Sheets to GitHub sync |

**Location:** `.github/workflows/`

---

## Monitoring

To check if cron jobs are running:

```bash
# System crontab
grep CRON /var/log/syslog

# Or check individual logs
tail -f /home/{{USER}}/Documents/autonomous-living/scripts/withings.log
tail -f /home/{{USER}}/Documents/autonomous-living/_meta/daily_briefing.log

# n8n - check workflow execution history in n8n UI
```

---

## Timezone

All schedules use **local timezone (Europe/Warsaw / CET)** unless specified otherwise.

n8n handles timezone automatically via the Schedule Trigger node.

---

## Adding New Scheduled Tasks

### For n8n:
1. Add a **Schedule Trigger** node to the workflow
2. Set the time (hour/minute)
3. Workflow will run automatically at that time daily

### For System Crontab:
1. Edit crontab: `crontab -e`
2. Add entry: `0 6 * * * /path/to/command`
3. Save and exit

### For PostgreSQL:
```sql
SELECT cron.schedule('job-name', '0 * * * *', 'SELECT my_function();');
```

---

## Dependencies

| Component | Dependency | Purpose |
|-----------|------------|---------|
| System crontab | Debian cron daemon | Job execution |
| n8n schedules | n8n service running | Workflow triggers |
| pg_cron | PostgreSQL extension | Database jobs |
| GitHub Actions | GitHub Actions runner | CI/CD schedules |

### Required Access
- SSH access to homelab for system crontab
- n8n UI/API access
- PostgreSQL with pg_cron extension enabled

---

## Failure Modes

| Scenario | Detection | Response | Alert |
|----------|-----------|----------|-------|
| System crontab not running | No log entries in `/var/log/syslog` | Check cron service: `sudo systemctl status cron` | Check logs |
| n8n workflow missed schedule | Workflow execution history shows gap | Check n8n logs, verify schedule trigger | None (low priority) |
| pg_cron job failed | Check `cron.job_run_details` table | Re-run manually or fix function | Check database logs |
| GitHub Action skipped | No workflow run at scheduled time | Check Actions log | GitHub notification |
| All morning briefs fail | No Telegram messages at 6:45-7:00 | Check n8n service, network connectivity | Telegram alert |

### Monitoring Commands

```bash
# Check system cron is running
sudo systemctl status cron

# View cron execution log
grep CRON /var/log/syslog | tail -20

# Check n8n workflow executions
# Open n8n UI → Workflow → Execution list

# Check pg_cron jobs
SELECT * FROM cron.job_run_details ORDER BY end_time DESC LIMIT 10;
```

---

## Related Documentation

- [S03 Data Layer](../S03_Data-Layer/README.md) - Database scheduling
- [S08 Automation Orchestrator](../S08_Automation-Orchestrator/README.md) - n8n management
- [Service Registry](./Service-Registry.md) - All scheduled services
- [Daily Briefing SOP](../../30_SOPS/Daily-Briefing-Management.md)

---

*Owner: {{OWNER_NAME}}*  
*Last Updated: 2026-02-20*  
*Review Cadence: Monthly*
