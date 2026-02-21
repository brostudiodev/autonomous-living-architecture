---
title: "Adr-0008: Real Savings Rate Calculation"
type: "decision"
status: "accepted"
date: "2025-09-01"
deciders: ["{{OWNER_NAME}}"]
consulted: []
informed: []
---

# Adr-0008: Real Savings Rate Calculation

## Status
Accepted

## Context
The financial system (G05) needs to calculate meaningful savings rate for personal wealth building. Traditional savings rate calculations were showing unrealistic 98% rates due to accounting artifacts:

### **Problem with Traditional Calculation**
- **INIT Transactions:** Large internal transfers inflate "income" side
- **System Transfers:** Moving money between accounts counts as both income and expense
- **Accounting Noise:** Reconciling transactions creates artificial income/expense pairs
- **Misleading Metrics:** 98% savings rate doesn't reflect real wealth-building behavior

### **Impact**
- **Poor Decision Making:** Can't determine if actually saving money
- **Budget Planning:** Unrealistic expectations for future savings
- **Goal Setting:** Incorrect financial targets based on fake metrics
- **Performance Tracking:** Can't measure real financial progress

## Decision
I will implement a "Real Savings Rate" calculation that excludes accounting artifacts and focuses on operational cash flow.

### **Calculation Formula**
```
Real Income = Operational Income (external sources only)
Real Expenses = Operational Expenses (external spending only)
Real Savings Rate = (Real Income - Real Expenses) / Real Income
```

### **Classification Rules**

#### **Operational Income (Counted)**
- Salary and wages
- Business income
- Investment returns
- Freelance income
- Any money coming from external sources

#### **System Transactions (Excluded)**
- INIT transfers between accounts
- Account reconciling entries
- Internal transfers
- Accounting adjustments
- Category reclassifications

#### **Operational Expenses (Counted)**
- Daily living expenses (food, housing, transport)
- Discretionary spending
- Bills and utilities
- Any money going to external recipients

### **Technical Implementation**
```sql
-- Enhanced transaction categorization
CREATE OR REPLACE FUNCTION categorize_transaction_type(
    description TEXT,
    amount DECIMAL,
    source_account TEXT,
    target_account TEXT
) RETURNS TEXT AS $$
BEGIN
    -- System transfers detection
    IF source_account IS NOT NULL AND target_account IS NOT NULL THEN
        RETURN 'system_transfer';
    
    -- INIT transactions detection
    IF description ~*INIT* OR description ~*reconcile* THEN
        RETURN 'system_transaction';
    
    -- Default to operational
    RETURN 'operational';
END;
$$ LANGUAGE plpgsql;

-- Real savings rate calculation
CREATE OR REPLACE FUNCTION calculate_real_savings_rate(
    start_date DATE,
    end_date DATE
) RETURNS DECIMAL(5,2) AS $$
DECLARE
    real_income DECIMAL;
    real_expenses DECIMAL;
    real_savings_rate DECIMAL;
BEGIN
    -- Sum only operational transactions
    SELECT COALESCE(SUM(CASE 
        WHEN amount > 0 AND transaction_type = 'operational' THEN amount 
        ELSE 0 
    END), 0) INTO real_income
    FROM transactions 
    WHERE transaction_date BETWEEN start_date AND end_date;
    
    SELECT COALESCE(SUM(CASE 
        WHEN amount < 0 AND transaction_type = 'operational' THEN ABS(amount) 
        ELSE 0 
    END), 0) INTO real_expenses
    FROM transactions 
    WHERE transaction_date BETWEEN start_date AND end_date;
    
    -- Calculate real rate
    IF real_income > 0 THEN
        real_savings_rate := ((real_income - real_expenses) / real_income) * 100;
    ELSE
        real_savings_rate := 0;
    END IF;
    
    RETURN real_savings_rate;
END;
$$ LANGUAGE plpgsql;

-- Automated classification trigger
CREATE OR REPLACE FUNCTION auto_classify_transaction()
RETURNS TRIGGER AS $$
BEGIN
    NEW.transaction_type := categorize_transaction_type(
        NEW.description, 
        NEW.amount, 
        NEW.source_account, 
        NEW.target_account
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply classification to new transactions
CREATE TRIGGER classify_transaction_trigger
    BEFORE INSERT OR UPDATE ON transactions
    FOR EACH ROW
    EXECUTE FUNCTION auto_classify_transaction();
```

### **Dashboard Integration**
```sql
-- Materialized view for efficient dashboard queries
CREATE MATERIALIZED VIEW real_savings_rate_mview AS
SELECT 
    DATE_TRUNC('month', transaction_date) as month,
    calculate_real_savings_rate(
        DATE_TRUNC('month', transaction_date)::date,
        (DATE_TRUNC('month', transaction_date) + INTERVAL '1 month')::date - INTERVAL '1 day'
    ) as real_savings_rate,
    calculate_traditional_savings_rate(
        DATE_TRUNC('month', transaction_date)::date,
        (DATE_TRUNC('month', transaction_date) + INTERVAL '1 month')::date - INTERVAL '1 day'
    ) as traditional_savings_rate,
    COUNT(*) as transaction_count,
    SUM(CASE WHEN transaction_type = 'operational' THEN 1 ELSE 0 END) as operational_count
FROM transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month DESC;

-- Refresh schedule
SELECT cron.schedule('refresh-savings-rate', '0 */6 * * *', 
    'REFRESH MATERIALIZED VIEW CONCURRENTLY real_savings_rate_mview;');
```

## Consequences

### **Positive Consequences**
- **Accurate Metrics:** Real savings rate shows 5-35% instead of fake 98%
- **Better Decisions:** Financial planning based on actual saving behavior
- **Realistic Goals:** Targets based on real wealth-building capacity
- **Improved Budgeting:** Budget alerts based on operational expenses only
- **Trust in System:** Users can trust financial metrics
- **Behavioral Insights:** Can identify real spending patterns and saving opportunities

### **Negative Consequences**
- **Implementation Complexity:** Requires sophisticated transaction classification
- **Data Migration:** Need to reclassify historical transactions
- **Maintenance Overhead:** Rules need updates as transaction patterns change
- **Edge Cases:** Some legitimate transactions might be misclassified
- **User Education:** Users need to understand different calculation method

## Implementation

### **Phase 1: Classification Rules**
- Implement transaction type categorization function
- Create rules for detecting system transactions
- Build manual classification interface for edge cases
- Test classification accuracy on historical data

### **Phase 2: Calculation Engine**
- Implement real savings rate calculation function
- Create materialized views for efficient querying
- Build automated classification triggers
- Implement historical data reclassification

### **Phase 3: Dashboard Integration**
- Update Grafana dashboards with real savings rate
- Add comparative views (real vs traditional)
- Create alerts for significant changes in saving patterns
- Implement savings rate trend analysis

### **Phase 4: User Interface**
- Update Google Sheets interface with new metrics
- Add explanations for calculation methodology
- Create user controls for manual classification corrections
- Implement educational tooltips and guidance

## Alternatives Considered

### **Alternative 1: Manual Classification Only**
- Users manually classify each transaction
- No automatic detection
**Rejected:**
- High manual overhead for users
- Inconsistent classification
- User fatigue leads to abandonment
- Delayed insights due to manual processing

### **Alternative 2: Machine Learning Classification**
- Train ML model on historical classifications
- Automated learning and adaptation
**Rejected:**
- Requires large labeled dataset
- Complex implementation and maintenance
- Risk of model drift and incorrect classifications
- Overkill for predictable transaction patterns

### **Alternative 3: Keep Traditional Calculation**
- Continue using existing 98% calculation
- Focus on explaining limitations to users
**Rejected:**
- Metrics remain misleading
- Doesn't solve core problem
- Users lose trust in financial system
- No actual improvement in decision making

### **Alternative 4: Separate Tracking Systems**
- Track "real" transactions separately from accounting
- Two parallel financial systems
**Rejected:**
- Double data entry overhead
- User confusion between systems
- Increased complexity without solving core issue
- Maintenance burden of two systems

## Related Decisions
- [Adr-0006](./Adr-0006-PostgreSQL-Partitioning.md) - PostgreSQL Partitioning Strategy
- [Adr-0009](./Adr-0009-Centralized-Observability.md) - Centralized Observability Stack
- [Adr-0014](./Adr-0014-Security-by-Design.md) - Security by Design Implementation

## Metrics

### **Success Criteria**
- **Accuracy Rate:** >95% of transactions correctly classified
- **Realistic Range:** Savings rate shows 5-35% instead of 98%
- **User Trust:** Users report higher confidence in financial metrics
- **Decision Quality:** Financial planning based on real metrics improves outcomes
- **Data Quality:** <1% of transactions require manual reclassification

### **Performance Targets**
- **Calculation Time:** <2 seconds for monthly savings rate
- **Dashboard Load:** <3 seconds for financial dashboards
- **Classification Speed:** Real-time classification for new transactions
- **View Refresh:** <30 seconds for materialized view refresh

### **Quality Assurance**
- **Audit Trail:** Complete history of classification changes
- **Reconciliation:** Monthly review of classification accuracy
- **User Feedback:** Easy mechanism for correcting misclassifications
- **Documentation:** Clear explanation of calculation methodology

---

*Last updated: 2026-02-11*