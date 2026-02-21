import psycopg2
from datetime import datetime

# DB Config
DB_FINANCE = {
    "dbname": "autonomous_finance",
    "user": "{{DB_USER}}",
    "password": "{{GENERIC_API_SECRET}}",
    "host": "localhost",
    "port": "5432"
}

def fix_car_payment_budget():
    """Automatically adjust the Car Payment budget to eliminate noise."""
    try:
        conn = psycopg2.connect(**DB_FINANCE)
        cur = conn.cursor()
        
        # 1. Update Car Payment budget to 1650.00 PLN (Fixed)
        query = """
        UPDATE budgets 
        SET budget_amount = 1650.00,
            notes = 'Auto-adjusted by G05 Optimizer: Fixed expense reconciliation',
            updated_at = CURRENT_TIMESTAMP
        FROM categories 
        WHERE budgets.category_id = categories.category_id 
          AND categories.category_name = 'Transportation' 
          AND categories.subcategory_name = 'Car Payment'
          AND budgets.budget_year = EXTRACT(YEAR FROM CURRENT_DATE)
          AND budgets.budget_month = EXTRACT(MONTH FROM CURRENT_DATE);
        """
        cur.execute(query)
        rows_updated = cur.rowcount
        conn.commit()
        
        if rows_updated > 0:
            print(f"✅ Fixed {rows_updated} Car Payment budget entries.")
        else:
            print("⚠️ No matching Car Payment budget found for the current month.")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ Database error: {e}")

def get_suggested_rebalancing():
    """Identify budgets that are over and suggest rebalancing from under-utilized areas."""
    try:
        conn = psycopg2.connect(**DB_FINANCE)
        cur = conn.cursor()
        
        # Pull budget alerts
        cur.execute("SELECT category_path, actual_amount, budget_amount, utilization_pct FROM get_current_budget_alerts();")
        alerts = cur.fetchall()
        
        if not alerts:
            print("✅ All budgets are on track. No rebalancing needed.")
            return

        print("
--- 💸 G05 Autonomous Rebalancing Scout ---")
        for alert in alerts:
            path, actual, budget, pct = alert
            if pct > 100:
                overage = actual - budget
                print(f"🚨 OVERAGE: {path} (+{overage:.2f} PLN)")
        
        # Find potential "Donors" (Low utilization categories)
        cur.execute("""
            SELECT category_path, remaining_amount 
            FROM v_budget_performance 
            WHERE budget_status = 'ON_TRACK' 
              AND budget_year = EXTRACT(YEAR FROM CURRENT_DATE)
              AND budget_month = EXTRACT(MONTH FROM CURRENT_DATE)
              AND remaining_amount > 50
            ORDER BY remaining_amount DESC;
        """)
        donors = cur.fetchall()
        if donors:
            print("
💡 Potential Savings Buffers (Donors):")
            for donor in donors:
                print(f"  - {donor[0]}: {donor[1]:.2f} PLN available")
                
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ Rebalancing scout error: {e}")

if __name__ == "__main__":
    fix_car_payment_budget()
    get_suggested_rebalancing()
