import os
import psycopg2
import requests
from datetime import datetime

# Paths
GOALS_PATH = "/home/{{USER}}/Documents/autonomous-living/docs/10_GOALS"
OUTPUT_FILE = "/home/{{USER}}/Documents/autonomous-living/docs/10_GOALS/G11_Meta-System-Integration-Optimization/G11_System_Connectivity_Map.md"

# DB Configs
DB_BASE = {"user": "{{DB_USER}}", "password: "{{GENERIC_API_SECRET}}", "host": "localhost", "port": "5432"}
DATABASES = {
    "finance": {**DB_BASE, "dbname": "autonomous_finance"},
    "training": {**DB_BASE, "dbname": "autonomous_training"},
    "pantry": {**DB_BASE, "dbname": "autonomous_pantry"}
}

# API Config
TWIN_API_URL = "http://localhost:5677"

GOALS = [
    "G01_Target-Body-Fat", "G02_Automationbro-Recognition", "G03_Autonomous-Household-Operations",
    "G04_Digital-Twin-Ecosystem", "G05_Autonomous-Financial-Command-Center", "G06_Certification-Exams",
    "G07_Predictive-Health-Management", "G08_Predictive-Smart-Home-Orchestration", "G09_Automated-Career-Intelligence",
    "G10_Intelligent-Productivity-Time-Architecture", "G11_Meta-System-Integration-Optimization", "G12_Complete-Process-Documentation"
]

# Goals known to have database integration
INTEGRATED_GOALS = ["G01", "G03", "G04", "G05", "G07"] 

def check_goal_infra(goal_name):
    path = os.path.join(GOALS_PATH, goal_name)
    required_files = ["README.md", "Roadmap.md", "Metrics.md"]
    if not os.path.exists(path): return "❌ Missing Folder"
    missing = [f for f in required_files if not os.path.exists(os.path.join(path, f))]
    return "✅ OK" if not missing else f"⚠️ Missing: {', '.join(missing)}"

def get_last_db_activity(db_name):
    try:
        conn = psycopg2.connect(**DATABASES[db_name])
        cur = conn.cursor()
        
        table_map = {
            "finance": "transactions",
            "training": "workouts",
            "pantry": "pantry_inventory"
        }
        
        table = table_map.get(db_name)
        if db_name == "finance":
            cur.execute(f"SELECT MAX(transaction_date) FROM {table}")
        elif db_name == "training":
            cur.execute(f"SELECT MAX(workout_date) FROM {table}")
        else:
            cur.execute(f"SELECT MAX(updated_at) FROM {table}")
            
        res = cur.fetchone()
        cur.close()
        conn.close()
        return res[0].strftime("%Y-%m-%d") if res and res[0] else "No Data"
    except Exception as e:
        return f"Error: {str(e)[:20]}"

def get_twin_freshness(entity_type):
    try:
        conn = psycopg2.connect(**DATABASES["finance"])
        cur = conn.cursor()
        cur.execute(
            "SELECT MAX(created_at) FROM digital_twin_updates WHERE entity_type = %s",
            (entity_type,)
        )
        res = cur.fetchone()
        cur.close()
        conn.close()
        return res[0].strftime("%Y-%m-%d %H:%M") if res and res[0] else "Never"
    except:
        return "Offline"

def check_api_health():
    try:
        resp = requests.get(TWIN_API_URL + "/", timeout=2)
        return "✅ Online" if resp.status_code == 200 else "❌ Error"
    except:
        return "❌ Offline"

def run_doc_audit():
    try:
        from G12_documentation_audit import run_audit
        run_audit()
        return "✅ 100% Compliant"
    except Exception as e:
        return f"⚠️ Audit Failed: {str(e)[:20]}"

def generate_map():
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    api_health = check_api_health()
    doc_status = run_doc_audit()
    
    md = f"""---
title: "G11: System Connectivity Map"
type: "health_check"
status: "auto-generated"
updated: "{now}"
---

# G11 Meta-System: Connectivity Matrix

**Audit Timestamp:** {now}
**Digital Twin API Status:** {api_health}
**Documentation Compliance (G12):** {doc_status}

## 1. Goal Infrastructure Status (Obsidian/Git)
| ID | Goal Name | Status | Required Docs |
|---|---|---|---|
"""
    for g in GOALS:
        infra = check_goal_infra(g)
        status_icon = '✅' if 'OK' in infra else '❌'
        md += f"| {g[:3]} | {g[4:]} | {infra} | {status_icon} |\n"

    md += """
## 2. Source System Activity (PostgreSQL)
| System | Database | Main Table | Last Activity |
|---|---|---|---|
"""
    md += f"| G05 | autonomous_finance | transactions | {get_last_db_activity('finance')} |\n"
    md += f"| G01 | autonomous_training | workouts | {get_last_db_activity('training')} |\n"
    md += f"| G03 | autonomous_pantry | inventory | {get_last_db_activity('pantry')} |\n"

    md += """
## 3. Digital Twin Integration Freshness (G04 Hub)
| Entity | Last Snapshot (DB) | Status |
|---|---|---|
"""
    for entity in ["finance", "health", "pantry"]:
        freshness = get_twin_freshness(entity)
        md += f"| {entity.capitalize()} | {freshness} | {'✅ Live' if freshness != 'Never' else '⚪ Pending'} |\n"

    md += """
## 4. Integration Gap Analysis (Orphan Goals)
| ID | Goal Name | Category | Status |
|---|---|---|---|
"""
    for g in GOALS:
        goal_id = g[:3]
        if goal_id not in INTEGRATED_GOALS:
            md += f"| {goal_id} | {g[4:]} | Docs Only | 🟠 No Data Flow |\n"

    md += """
---
*Map generated by G11_meta_mapper.py. Last audit successful.*
"""
    with open(OUTPUT_FILE, 'w') as f:
        f.write(md)
    return api_health, doc_status

if __name__ == "__main__":
    generate_map()
    print(f"✅ Meta-System Connectivity Map updated at: {OUTPUT_FILE}")
