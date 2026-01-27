---
title: "S08: Automation Orchestrator"
type: "system"
status: "active"
system_id: "system-s08"
owner: "Michał"
updated: "2026-01-27"
---

# S08: Automation Orchestrator

## Purpose
Centralized automation management platform using n8n to coordinate financial workflows, ensuring autonomous operation of the Financial Command Center with minimal human intervention.

## Components

### n8n Workflow Engine
- **Platform:** n8n (open-source workflow automation)
- **Location:** Homelab Docker container
- **Purpose:** Orchestrate all financial automation workflows

### Active Financial Workflows

#### WF101: Finance Import Transactions
- **File:** `WF101__finance-import-transactions.json/.md`
- **Schedule:** Every 6 hours
- **Purpose:** Budget optimization analysis and recommendations
- **Function:** Calls `get_budget_optimization_suggestions()`

#### WF102: Finance Budget Alerts
- **File:** `WF102__finance-budget-alerts.json/.md`
- **Schedule:** Every 12 hours (8:00 AM, 8:00 PM UTC)
- **Purpose:** Budget threshold monitoring and alerting
- **Function:** Calls `get_current_budget_alerts()`

## Architecture

### Workflow Components
1. **Schedule Trigger:** Automated execution based on cron expressions
2. **Database Integration:** PostgreSQL queries using stored procedures
3. **Conditional Logic:** Filter and process only relevant data
4. **Message Formatting:** Human-readable notification preparation
5. **Notification Delivery:** Slack integration for alert delivery

### Data Flow
```
Schedule → Database Query → Condition Check → Format → Notify
```

## Dependencies

### Required Systems
- **S03 Data Layer:** PostgreSQL database with financial functions
- **S05 Observability:** Grafana dashboards (receives data from S03)
- **External Services:** Slack API for notifications

### Database Requirements
- Functions: `get_budget_optimization_suggestions()`, `get_current_budget_alerts()`
- Views: All financial views for dashboard queries
- Tables: transactions, budgets, categories, accounts

### Infrastructure Requirements
- Docker host for n8n container
- PostgreSQL network connectivity
- Slack API credentials
- Sufficient storage for workflow execution logs

## Configuration

### Environment Variables
```bash
# Database Connection
POSTGRES_HOST=postgresql
POSTGRES_PORT=5432
POSTGRES_DB=finance
POSTGRES_USER=finance_user
POSTGRES_PASSWORD=secure_password

# Slack Integration
SLACK_BOT_TOKEN=xoxb-your-bot-token
SLACK_CHANNEL=finance-alerts

# n8n Configuration
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=secure_admin_password
```

### Workflow Credentials
- **PostgreSQL Finance DB:** Database connection credentials
- **Slack Finance Alerts:** Slack bot token for notifications

## Monitoring and Maintenance

### Health Checks
```bash
# Check n8n container status
docker ps | grep n8n

# Check recent workflow executions
curl -H "Authorization: Bearer $N8N_API_TOKEN" \
     "http://localhost:5678/api/v1/executions?limit=10"

# Check database connectivity from n8n
docker exec n8n_container psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -c "SELECT 1;"
```

### Performance Metrics
- **Expected Runtime:** <2 seconds per workflow
- **Success Rate:** >99% (network/database dependent)
- **Alert Latency:** <5 minutes from threshold breach
- **Daily Executions:** 6 total (4x WF101, 2x WF102)

### Log Monitoring
```bash
# Check n8n logs for errors
docker logs n8n_container --since 24h | grep ERROR

# Monitor workflow execution times
docker logs n8n_container | grep "Workflow execution finished"
```

## Security Considerations

### Access Control
- n8n UI protected by basic authentication
- Database credentials stored securely in n8n credential manager
- Slack tokens encrypted at rest
- Network isolation within Docker network

### Data Privacy
- All financial data remains within homelab environment
- No external API calls for financial data
- Minimal logs stored (execution status only)
- No sensitive data in notification messages

## Troubleshooting

### Common Issues
| Symptom | Likely Cause | Solution |
|---|---|---|
| Workflow not executing | Schedule misconfiguration | Check cron expression and timezone |
| Database connection failed | Network/credential issue | Verify connectivity and credentials |
| No notifications sent | Slack API error | Check bot permissions and token |
| High false positive rate | Budget thresholds too low | Adjust alert thresholds in budgets table |

### Recovery Procedures
1. **Workflow Failure:** Manual execution via n8n UI
2. **Database Issues:** Check connectivity, restart PostgreSQL
3. **Notification Issues:** Verify Slack workspace integration
4. **Performance Issues:** Check resource constraints, scale horizontally

## Backup and Recovery

### Automated Backups
- n8n workflow JSON files versioned in documentation
- Database backups include all required functions and views
- Configuration managed via environment variables

### Disaster Recovery
1. Restore PostgreSQL database from backup
2. Deploy n8n container with environment variables
3. Import workflows from documentation repository
4. Verify credentials and test execution
5. Monitor first automated execution cycles

## Related Systems
- [S03 Data Layer](../S03_Data-Layer/README.md) - Data source
- [S05 Observability Dashboards](../S05_Observability-Dashboards/README.md) - Visualization
- [G02 Autonomous Finance](../../10_GOALS/G02_Autonomous-Finance-Data-Command-Center/README.md) - Primary goal
- [Financial Workflows](../../50_AUTOMATIONS/n8n/workflows/) - Workflow definitions