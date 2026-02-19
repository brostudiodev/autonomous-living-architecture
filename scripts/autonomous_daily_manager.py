import os
import pandas as pd
from datetime import datetime
import psycopg2
from psycopg2 import sql

# Paths
OBSIDIAN_VAULT = "/home/michal/Documents/Obsidian Vault"
DAILY_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "01_Daily_Notes")
DAILY_TEMPLATE = os.path.join(OBSIDIAN_VAULT, "99_System/Templates/Daily/Daily Note Template.md")

# DB Configs
DB_BASE = {
    "user": "{{DB_USER}}",
    "password: "{{API_SECRET}}",
    "host": "localhost",
    "port": "5432"
}
DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}
DB_TRAINING = {**DB_BASE, "dbname": "autonomous_training"}

def get_today_file():
    today_str = datetime.now().strftime("%Y-%m-%d")
    return os.path.join(DAILY_NOTES_DIR, f"{today_str}.md")

def create_from_template(today_file):
    if not os.path.exists(DAILY_TEMPLATE):
        return False
    with open(DAILY_TEMPLATE, 'r') as f:
        template = f.read()
    now = datetime.now()
    content = template.replace("{{date}}", now.strftime("%Y-%m-%d"))
    content = content.replace("{{date:YYYY-MM-DD}}", now.strftime("%Y-%m-%d"))
    content = content.replace("{{date:dddd}}", now.strftime("%A"))
    week_str = now.strftime("%Y-W%U")
    content = content.replace("{{date:gggg-[W]ww}}", week_str)
    with open(today_file, 'w') as f:
        f.write(content)
    return True

def analyze_workouts():
    try:
        conn = psycopg2.connect(**DB_TRAINING)
        cur = conn.cursor()
        cur.execute("SELECT workout_date FROM workouts ORDER BY workout_date DESC LIMIT 1;")
        res = cur.fetchone()
        cur.close()
        conn.close()
        if res:
            last_workout = res[0]
            days_since = (datetime.now().date() - last_workout).days
            if days_since >= 3:
                return f"- [ ] 💪 HIT Workout (Due: {days_since} days since last session)"
    except Exception as e:
        return f"Error analyzing workouts: {e}"
    return None

def get_budget_alerts():
    alerts = []
    try:
        conn = psycopg2.connect(**DB_FINANCE)
        cur = conn.cursor()
        cur.execute("SELECT category_path, utilization_pct, recommended_action FROM get_current_budget_alerts();")
        rows = cur.fetchall()
        for row in rows:
            category, pct, action = row
            alerts.append(f"- [ ] 💸 Finance: {category} ({pct}% utilized) - {action}")
        cur.close()
        conn.close()
    except Exception as e:
        print(f"DB Finance Error: {e}")
    return alerts

def get_pantry_tasks():
    return [
        "- [ ] 🛒 Buy Jajka (Pantry Low - Predictor)",
        "- [ ] 🛒 Buy Chleb (Pantry Low - Predictor)"
    ]

def generate_schedule():
    return "- 06:00–09:00 – Deep Work: G04/G10 Foundation\n- 09:00–12:00 – Professional Backlog (Six Sigma/DAC)\n- 12:00–14:00 – Household Admin & Bills\n- 14:00–17:00 – Growth / Learning (G06)\n- 17:00–18:00 – Workout (if due) / Recovery\n- 18:00–21:00 – Family / Personal\n- 21:00–22:00 – Daily Review & Log"

def update_daily_note():
    today_file = get_today_file()
    if not os.path.exists(today_file):
        if not create_from_template(today_file):
            return

    with open(today_file, 'r') as f:
        content = f.read()

    tasks_to_add = []
    workout_task = analyze_workouts()
    if workout_task and workout_task not in content:
        tasks_to_add.append(workout_task)
    
    budget_alerts = get_budget_alerts()
    for alert in budget_alerts:
        if alert not in content:
            tasks_to_add.append(alert)
    
    for task in get_pantry_tasks():
        if task not in content:
            tasks_to_add.append(task)

    if "🤖 Suggested Schedule" not in content:
        schedule = "\n--- \n### 🤖 Suggested Schedule (Autonomous)\n" + generate_schedule() + "\n"
        if "## Schedule / Time Blocks" in content:
            content = content.replace("## Schedule / Time Blocks", "## Schedule / Time Blocks\n" + schedule)
        else:
            content += schedule

    if tasks_to_add:
        if "### 🤖 Autonomous Task Suggestions" not in content:
            task_block = "\n### 🤖 Autonomous Task Suggestions\n" + "\n".join(tasks_to_add) + "\n"
            if "## Tasks (manual planning)" in content:
                content = content.replace("## Tasks (manual planning)", "## Tasks (manual planning)\n" + task_block)
            else:
                content += task_block
        else:
            for task in tasks_to_add:
                if task not in content:
                    content = content.replace("### 🤖 Autonomous Task Suggestions", f"### 🤖 Autonomous Task Suggestions\n{task}")

    with open(today_file, 'w') as f:
        f.write(content)
    print(f"✅ Successfully updated {today_file} from database sources.")

if __name__ == "__main__":
    update_daily_note()
