import os
import psycopg2
import json
import uuid
from datetime import datetime

# DB Configs
DB_BASE = {
    "user": "{{DB_USER}}",
    "password": "{{GENERIC_API_SECRET}}",
    "host": os.getenv("DB_HOST", "localhost"),
    "port": "5432"
}

DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}
DB_TRAINING = {**DB_BASE, "dbname": "autonomous_training"}
DB_PANTRY = {**DB_BASE, "dbname": "autonomous_pantry"}

# Fixed UUID for Michal (Person)
PERSON_UUID = "00000000-0000-0000-0000-000000000001"

class DigitalTwinEngine:
    def __init__(self):
        self.state = {
            "health": {},
            "finance": {},
            "pantry": {},
            "timestamp": datetime.now().isoformat()
        }

    def get_health_status(self):
        try:
            conn = psycopg2.connect(**DB_TRAINING)
            cur = conn.cursor()
            cur.execute("SELECT workout_date, duration_min, recovery_score FROM workouts ORDER BY workout_date DESC LIMIT 1;")
            res = cur.fetchone()
            if res:
                last_workout = res[0]
                self.state["health"]["last_workout"] = last_workout.strftime("%Y-%m-%d")
                self.state["health"]["days_since_workout"] = (datetime.now().date() - last_workout).days
                self.state["health"]["last_workout_duration"] = res[1]
                self.state["health"]["last_workout_recovery"] = res[2]
            
            cur.execute("SELECT measurement_date, bodyweight_kg, bodyfat_pct FROM v_body_composition ORDER BY measurement_date DESC LIMIT 1;")
            res = cur.fetchone()
            if res:
                self.state["health"]["last_measurement"] = res[0].strftime("%Y-%m-%d")
                self.state["health"]["bodyweight_kg"] = float(res[1])
                self.state["health"]["bodyfat_pct"] = float(res[2])
            cur.close()
            conn.close()
        except Exception as e:
            self.state["health"]["error"] = str(e)

    def get_finance_status(self):
        try:
            conn = psycopg2.connect(**DB_FINANCE)
            cur = conn.cursor()
            query = """
            SELECT SUM(CASE WHEN type = 'Income' THEN amount ELSE -amount END) 
            FROM transactions 
            WHERE EXTRACT(YEAR FROM transaction_date) = EXTRACT(YEAR FROM CURRENT_DATE)
              AND EXTRACT(MONTH FROM transaction_date) = EXTRACT(MONTH FROM CURRENT_DATE);
            """
            cur.execute(query)
            res = cur.fetchone()
            self.state["finance"]["mtd_net"] = float(res[0]) if res and res[0] is not None else 0.0
            cur.execute("SELECT count(*) FROM get_current_budget_alerts();")
            self.state["finance"]["active_budget_alerts"] = cur.fetchone()[0]
            cur.close()
            conn.close()
        except Exception as e:
            self.state["finance"]["error"] = str(e)

    def get_pantry_status(self):
        try:
            conn = psycopg2.connect(**DB_PANTRY)
            cur = conn.cursor()
            # Count items below threshold
            cur.execute("SELECT category FROM pantry_inventory WHERE current_quantity <= critical_threshold AND critical_threshold IS NOT NULL;")
            low_items = [row[0] for row in cur.fetchall()]
            self.state["pantry"]["low_stock_items"] = low_items
            self.state["pantry"]["low_stock_count"] = len(low_items)
            cur.close()
            conn.close()
        except Exception as e:
            self.state["pantry"]["error"] = str(e)

    def get_google_tasks(self):
        """Fetch tasks from Google Tasks API using the G10 sync script."""
        try:
            from G10_google_tasks_sync import get_upcoming_tasks
            return get_upcoming_tasks()
        except Exception as e:
            print(f"Google Tasks Error: {e}")
            return []

    def get_roadmap_tasks(self, quarter_filter=None):
        """Extract roadmap tasks from all goals, optionally filtered by quarter (e.g., 'Q1')."""
        goals_path = "/home/{{USER}}/Documents/autonomous-living/docs/10_Goals"
        tasks = []
        if not os.path.exists(goals_path):
            return tasks

        for goal_dir in sorted(os.listdir(goals_path)):
            if not goal_dir.startswith("G"): continue
            roadmap_file = os.path.join(goals_path, goal_dir, "Roadmap.md")
            if os.path.exists(roadmap_file):
                with open(roadmap_file, 'r') as f:
                    lines = f.readlines()
                
                current_quarter = None
                for line in lines:
                    if "## Q" in line:
                        current_quarter = re.search(r"Q\d", line).group(0)
                        continue
                    
                    if quarter_filter and current_quarter != quarter_filter:
                        continue
                    
                    if "- [ ]" in line:
                        tasks.append({
                            "goal": goal_dir[:3],
                            "quarter": current_quarter,
                            "task": line.replace("- [ ]", "").strip()
                        })
        return tasks

    def get_system_tasks(self):
        """Fetch tasks generated by system state (pantry, workouts, finance)."""
        tasks = []
        # Pantry
        self.get_pantry_status()
        for item in self.state["pantry"].get("low_stock_items", []):
            tasks.append({"source": "Pantry", "task": f"Buy {item} (Low Stock)"})
        
        # Workout
        self.get_health_status()
        if self.state["health"].get("days_since_workout", 0) >= 3:
            tasks.append({"source": "Health", "task": "💪 HIT Workout (Due)"})
            
        # Finance
        self.get_finance_status()
        if self.state["finance"].get("active_budget_alerts", 0) > 0:
            tasks.append({"source": "Finance", "task": f"Review {self.state['finance']['active_budget_alerts']} Budget Alerts"})
            
        return tasks

    def persist_state(self):
        try:
            conn = psycopg2.connect(**DB_FINANCE)
            cur = conn.cursor()
            for entity in ["health", "finance", "pantry"]:
                cur.execute(
                    "INSERT INTO digital_twin_updates (entity_type, entity_id, update_data, source_system, update_type) VALUES (%s, %s, %s, %s, %s)",
                    (entity, PERSON_UUID, json.dumps(self.state[entity]), 'g04_engine', 'status_sync')
                )
            conn.commit()
            cur.close()
            conn.close()
        except Exception as e:
            print(f"Persistence Error: {e}")

    def generate_summary(self):
        self.get_health_status()
        self.get_finance_status()
        self.get_pantry_status()
        self.persist_state()
        
        now_str = datetime.now().strftime('%Y-%m-%d %H:%M')
        summary = f"🤖 Digital Twin Status Summary ({now_str})\n"
        summary += "="*40 + "\n"
        
        f = self.state["finance"]
        summary += f"💰 FINANCE: MTD Net: {f.get('mtd_net', 'N/A')} PLN | Alerts: {f.get('active_budget_alerts', 0)}\n"
        
        h = self.state["health"]
        summary += f"💪 HEALTH: Last HIT: {h.get('last_workout', 'N/A')} ({h.get('days_since_workout', 'N/A')}d ago) | BF: {h.get('bodyfat_pct', 'N/A')}%\n"
        
        p = self.state["pantry"]
        if p.get("low_stock_count", 0) > 0:
            summary += f"🛒 PANTRY: 🚨 {p['low_stock_count']} items low: {', '.join(p['low_stock_items'][:3])}...\n"
        else:
            summary += f"🛒 PANTRY: ✅ All essential items in stock.\n"
        
        return summary

if __name__ == "__main__":
    engine = DigitalTwinEngine()
    print(engine.generate_summary())
