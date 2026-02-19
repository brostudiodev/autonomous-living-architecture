import os
import psycopg2
import json
import uuid
from datetime import datetime

# DB Configs
DB_BASE = {
    "user": "root",
    "password": "admin",
    "host": "localhost",
    "port": "5432"
}

DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}
DB_TRAINING = {**DB_BASE, "dbname": "autonomous_training"}

# Fixed UUID for Michal (Person)
PERSON_UUID = "00000000-0000-0000-0000-000000000001"

class DigitalTwinEngine:
    def __init__(self):
        self.state = {
            "health": {},
            "finance": {},
            "timestamp": datetime.now().isoformat()
        }

    def get_health_status(self):
        try:
            conn = psycopg2.connect(**DB_TRAINING)
            cur = conn.cursor()
            
            # Last workout
            cur.execute("SELECT workout_date, duration_min, recovery_score FROM workouts ORDER BY workout_date DESC LIMIT 1;")
            res = cur.fetchone()
            if res:
                last_workout = res[0]
                self.state["health"]["last_workout"] = last_workout.strftime("%Y-%m-%d")
                self.state["health"]["days_since_workout"] = (datetime.now().date() - last_workout).days
                self.state["health"]["last_workout_duration"] = res[1]
                self.state["health"]["last_workout_recovery"] = res[2]
            
            # Last body composition
            cur.execute("SELECT measurement_date, bodyweight_kg, bodyfat_pct FROM v_body_composition ORDER BY measurement_date DESC LIMIT 1;")
            res = cur.fetchone()
            if res:
                self.state["health"]["last_measurement"] = res[0].strftime("%Y-%m-%d")
                self.state["health"]["bodyweight_kg"] = float(res[1])
                self.state["health"]["bodyfat_pct"] = float(res[2])
            
            cur.close()
            conn.close()
        except Exception as e:
            self.state["health"]["error"] = f"DB Training Error: {str(e)}"

    def get_finance_status(self):
        try:
            conn = psycopg2.connect(**DB_FINANCE)
            cur = conn.cursor()
            
            # Month-to-Date Net
            query = """
            SELECT SUM(CASE WHEN type = 'Income' THEN amount ELSE -amount END) 
            FROM transactions 
            WHERE EXTRACT(YEAR FROM transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE)
              AND EXTRACT(MONTH FROM transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE);
            """
            cur.execute(query)
            res = cur.fetchone()
            self.state["finance"]["mtd_net"] = float(res[0]) if res and res[0] is not None else 0.0
            
            # Active budget alerts
            cur.execute("SELECT count(*) FROM get_current_budget_alerts();")
            alert_count = cur.fetchone()[0]
            self.state["finance"]["active_budget_alerts"] = alert_count
            
            cur.close()
            conn.close()
        except Exception as e:
            self.state["finance"]["error"] = f"DB Finance Error: {str(e)}"

    def persist_state(self):
        """Save the current state to digital_twin_updates table"""
        try:
            conn = psycopg2.connect(**DB_FINANCE)
            cur = conn.cursor()
            
            # Insert health state
            cur.execute(
                "INSERT INTO digital_twin_updates (entity_type, entity_id, update_data, source_system, update_type) VALUES (%s, %s, %s, %s, %s)",
                ('health', PERSON_UUID, json.dumps(self.state["health"]), 'g04_engine', 'status_sync')
            )
            
            # Insert finance state
            cur.execute(
                "INSERT INTO digital_twin_updates (entity_type, entity_id, update_data, source_system, update_type) VALUES (%s, %s, %s, %s, %s)",
                ('finance', PERSON_UUID, json.dumps(self.state["finance"]), 'g04_engine', 'status_sync')
            )
            
            conn.commit()
            cur.close()
            conn.close()
            return True
        except Exception as e:
            print(f"Error persisting state: {e}")
            return False

    def generate_summary(self):
        self.get_health_status()
        self.get_finance_status()
        
        # Persist to DB for long-term tracking/API
        self.persist_state()
        
        now_str = datetime.now().strftime('%Y-%m-%d %H:%M')
        summary = f"🤖 Digital Twin Status Summary ({now_str})\n"
        summary += "="*40 + "\n"
        
        f = self.state["finance"]
        if "error" in f:
            summary += f"💰 FINANCE: Error: {f['error']}\n"
        else:
            summary += f"💰 FINANCE: MTD Net: {f.get('mtd_net', 'N/A')} PLN | Alerts: {f.get('active_budget_alerts', 0)}\n"
        
        h = self.state["health"]
        if "error" in h:
            summary += f"💪 HEALTH: Error: {h['error']}\n"
        else:
            summary += f"💪 HEALTH: Last HIT: {h.get('last_workout', 'N/A')} ({h.get('days_since_workout', 'N/A')}d ago)\n"
            summary += f"⚖️ BODY: {h.get('bodyweight_kg', 'N/A')} kg | {h.get('bodyfat_pct', 'N/A')}% BF\n"
        
        return summary

if __name__ == "__main__":
    engine = DigitalTwinEngine()
    print(engine.generate_summary())
