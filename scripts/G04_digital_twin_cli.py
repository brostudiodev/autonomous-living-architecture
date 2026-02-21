import requests
import sys
import argparse
from datetime import datetime

API_URL = "http://localhost:5677"

def get_tasks(quarter=None):
    params = {}
    if quarter:
        params["quarter"] = quarter
        
    try:
        response = requests.get(f"{API_URL}/tasks", params=params)
        response.raise_for_status()
        data = response.json()
        
        print("
" + "="*50)
        print(f"🤖 DIGITAL TWIN: TODO LIST {('(' + quarter + ')') if quarter else '(ALL)'}")
        print("="*50)
        
        # 1. System Tasks (Only if no quarter filter)
        if data.get("system_tasks"):
            print("
🚨 SYSTEM ALERTS (Priority)")
            for t in data["system_tasks"]:
                print(f"  - [{t['source']}] {t['task']}")
        
        # 2. Google Tasks
        if data.get("google_tasks"):
            print("
📅 GOOGLE TASKS (Upcoming)")
            for t in data["google_tasks"]:
                due = f" [Due: {t['due'][:10]}]" if t.get('due') else ""
                print(f"  - {t['title']}{due}")

        # 3. Roadmap Tasks
        if data.get("roadmap_tasks"):
            current_q = None
            print("
🎯 ROADMAP ACTIONS (Q1-Q4)")
            for t in data["roadmap_tasks"]:
                if t['quarter'] != current_q:
                    current_q = t['quarter']
                    print(f"  --- {current_q} ---")
                print(f"  - [{t['goal']}] {t['task']}")
        
        if not data.get("system_tasks") and not data.get("google_tasks") and not data.get("roadmap_tasks"):
            print("
✅ No tasks found for the selected criteria.")
            
        print("="*50 + "
")
        
    except requests.exceptions.ConnectionError:
        print("
❌ Error: Digital Twin API is offline. Please start it with 'python G04_digital_twin_api.py'")
    except Exception as e:
        print(f"
❌ Error fetching tasks: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Digital Twin Task Manager")
    parser.add_argument("quarter", nargs="?", help="Optional quarter filter (e.g. Q1)")
    
    args = parser.parse_args()
    get_tasks(args.quarter)
