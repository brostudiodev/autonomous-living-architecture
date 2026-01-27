---
title: "S03: Data Layer"
type: "system"
status: "active"
system_id: "system-s03"
owner: "Michał"
updated: "2026-01-27"
---

# S03: Data Layer

## Purpose
Centralized PostgreSQL database providing foundation for autonomous financial intelligence, with optimized views and functions for real-time analysis and decision-making.

## Components

### Database Schema
- **Platform:** PostgreSQL 15+
- **Purpose:** Single source of truth for all financial data
- **Location:** Homelab Docker container

#### Core Tables
- **transactions:** All financial transactions with categorization
- **budgets:** Monthly budget allocations and thresholds
- **categories:** Hierarchical category structure
- **accounts:** Bank account information and metadata

### Analytics Views

#### v_real_savings_monthly
- **Purpose:** Corrected savings rate calculation (fixes 98% problem)
- **Innovation:** Separates operational income from system transactions
- **Range:** Shows realistic 5-35% savings rates
- **File:** `views/v_real_savings_monthly.sql`

#### v_monthly_pnl
- **Purpose:** Comprehensive profit & loss analysis
- **Features:** Income/expense breakdown by category
- **Trends:** 24-month historical analysis
- **File:** `views/v_monthly_pnl.sql`

#### v_budget_performance
- **Purpose:** Real-time budget tracking with projections
- **Features:** Utilization percentages, burn rates, variance analysis
- **Intelligence:** Month-end overspend projections
- **File:** `views/v_budget_performance.sql`

#### v_daily_cashflow
- **Purpose:** Daily transaction flow analysis
- **Features:** Moving averages, anomaly detection, trend analysis
- **Period:** 90-day rolling window
- **File:** `views/v_daily_cashflow.sql`

### Intelligent Functions

#### get_current_budget_alerts()
- **Purpose:** Real-time budget monitoring and alerting
- **Features:** Multi-severity alerts, recommended actions, projections
- **Returns:** Actionable intelligence for immediate response
- **File:** `functions/get_current_budget_alerts.sql`

#### get_budget_optimization_suggestions()
- **Purpose:** Automated budget optimization analysis
- **Features:** Identifies overspending/underutilization, confidence scoring
- **Returns:** Specific recommendations with potential savings
- **File:** `functions/get_budget_optimization_suggestions.sql`

## Key Innovations

### Real Savings Rate Calculation
Solves the "98% fake savings rate" problem by:
- Excluding INIT positions and internal transfers
- Distinguishing operational income from system transactions
- Using dual detection methods for wealth-building activities
- Providing realistic 5-35% savings range

### Autonomous Intelligence
- All business logic encapsulated in PostgreSQL functions
- Grafana visualization only (no processing in UI)
- Automated anomaly detection using statistical methods
- Predictive projections based on historical patterns

## Performance Optimizations

### Query Performance
- **Target:** <2 seconds for all views/functions
- **Methods:** Proper indexing, optimized JOINs, filtered result sets
- **Monitoring:** Query execution time tracking

### Data Freshness
- **Real-time:** Views always show current data
- **Automated:** n8n workflows maintain synchronization
- **Validation:** Daily freshness checks and alerts

## Data Model

### Schema Design Principles
- **Normalization:** Proper relational design
- **Audit Trail:** Created/updated timestamps on all tables
- **Hierarchical:** Category structure supports rollups
- **Temporal:** Time-series optimized queries

### Data Integrity
- **Constraints:** Foreign keys and check constraints
- **Validation:** Category consistency checks
- **Quality:** Automated anomaly detection
- **Accuracy:** Reconciliation processes

## Security Considerations

### Access Control
- **Application User:** Limited SELECT permissions for n8n/Grafana
- **Admin User:** Full schema management privileges
- **Network:** Docker network isolation
- **Backups:** Automated daily backups with encryption

### Data Privacy
- **Homelab Only:** All data remains within local environment
- **No External APIs:** No third-party data sharing
- **Encryption:** Transparent data encryption at rest
- **Retention Configurable:** Data retention policies

## Deployment Instructions

### Database Setup
```bash
# Create PostgreSQL container
docker run -d \
  --name postgres-finance \
  -e POSTGRES_DB=finance \
  -e POSTGRES_USER=finance_user \
  -e POSTGRES_PASSWORD=secure_password \
  -v /path/to/data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:15

# Deploy views and functions
psql -h localhost -U finance_user -d finance -f views/v_real_savings_monthly.sql
psql -h localhost -U finance_user -d finance -f views/v_monthly_pnl.sql
psql -h localhost -U finance_user -d finance -f views/v_budget_performance.sql
psql -h localhost -U finance_user -d finance -f views/v_daily_cashflow.sql
psql -h localhost -U finance_user -d finance -f functions/get_current_budget_alerts.sql
psql -h localhost -U finance_user -d finance -f functions/get_budget_optimization_suggestions.sql
```

### Validation Testing
```sql
-- Test real savings rate calculation
SELECT 
    period,
    real_savings_rate_pct,
    operational_income,
    actual_savings
FROM v_real_savings_monthly 
WHERE year = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY period_date DESC 
LIMIT 3;

-- Test alert generation
SELECT COUNT(*) as alert_count 
FROM get_current_budget_alerts();

-- Test optimization suggestions
SELECT 
    suggestion_type,
    COUNT(*) as count,
    SUM(potential_savings) as total_potential
FROM get_budget_optimization_suggestions()
GROUP BY suggestion_type;
```

## Monitoring and Maintenance

### Performance Monitoring
```sql
-- Slow query monitoring
SELECT query, mean_time, calls, total_time
FROM pg_stat_statements 
WHERE query LIKE '%v_%' OR query LIKE '%get_%'
ORDER BY mean_time DESC;

-- View usage statistics
SELECT schemaname, viewname, calls, total_time
FROM pg_stat_user_views
ORDER BY total_time DESC;
```

### Health Checks
```sql
-- Data freshness check
SELECT 
    MAX(transaction_date) as latest_transaction,
    COUNT(*) as transactions_last_7_days
FROM transactions
WHERE transaction_date >= CURRENT_DATE - INTERVAL '7 days';

-- Function execution test
SELECT 'get_current_budget_alerts()' as function_name, COUNT(*) as result_count
FROM get_current_budget_alerts()
UNION ALL
SELECT 'get_budget_optimization_suggestions()' as function_name, COUNT(*) as result_count
FROM get_budget_optimization_suggestions();
```

## Backup and Recovery

### Automated Backups
- **Daily:** Full database backup at 2:00 AM
- **Retention:** 30 days of daily backups
- **Compression:** gzip compressed backups
- **Encryption:** Optional backup encryption

### Recovery Procedures
```bash
# Restore from backup
pg_restore -h localhost -U finance_user -d finance backup_file.sql

# Point-in-time recovery (if WAL enabled)
pg_basebackup -h localhost -D /backup/base -U finance_user -v -P -W
```

## Related Systems
- [S05 Observability Dashboards](../S05_Observability-Dashboards/README.md) - Data visualization
- [S08 Automation Orchestrator](../S08_Automation-Orchestrator/README.md) - Automated workflows
- [G02 Autonomous Finance](../../10_GOALS/G02_Autonomous-Finance-Data-Command-Center/README.md) - Primary goal