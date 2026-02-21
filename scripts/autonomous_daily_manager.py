import os
import re
import pandas as pd
from datetime import datetime
import psycopg2
from pantry_sync import sync_dictionary, sync_inventory

# Paths
OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
DAILY_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "01_Daily_Notes")
DAILY_TEMPLATE = os.path.join(OBSIDIAN_VAULT, "99_System/Templates/Daily/Daily Note Template.md")

# DB Configs
DB_BASE = {
    "user": "{{DB_USER}}",
    "password": "{{GENERIC_API_SECRET}}",
    "host": "localhost",
    "port": "5432"
}
DB_FINANCE = {**DB_BASE, "dbname": "autonomous_finance"}
DB_TRAINING = {**DB_BASE, "dbname": "autonomous_training"}
DB_PANTRY = {**DB_BASE, "dbname": "autonomous_pantry"}

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
        return f"- [ ] 💪 Check Workout Status (Error: {e})"
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

def get_grocery_budget_status():
    try:
        conn = psycopg2.connect(**DB_FINANCE)
        cur = conn.cursor()
        cur.execute("""
            SELECT remaining_amount, budget_status 
            FROM v_budget_performance 
            WHERE category_path LIKE '%Groceries%'
              AND budget_year = EXTRACT(YEAR FROM CURRENT_DATE)
              AND budget_month = EXTRACT(MONTH FROM CURRENT_DATE)
            LIMIT 1;
        """)
        res = cur.fetchone()
        cur.close()
        conn.close()
        if res:
            return {"remaining": float(res[0]), "status": res[1]}
    except:
        pass
    return None

def get_pantry_tasks():
    tasks = []
    budget = get_grocery_budget_status()
    budget_warn = ""
    if budget and budget["remaining"] <= 0:
        budget_warn = " ⚠️ (Budget Exceeded)"

    try:
        conn = psycopg2.connect(**DB_PANTRY)
        cur = conn.cursor()
        
        # 1. Low Stock Check
        cur.execute("SELECT category FROM pantry_inventory WHERE current_quantity <= critical_threshold AND critical_threshold IS NOT NULL;")
        low_items = [row[0] for row in cur.fetchall()]
        tasks.extend([f"- [ ] 🛒 Buy {item}{budget_warn} (Pantry Low - Predictor)" for item in low_items])
        
        # 2. Expiration Check (G03 Q1 Task)
        cur.execute("""
            SELECT category, next_expiry 
            FROM pantry_inventory 
            WHERE next_expiry IS NOT NULL 
              AND next_expiry <= CURRENT_DATE + INTERVAL '7 days';
        """)
        expiring_items = cur.fetchall()
        for item, expiry in expiring_items:
            days_left = (expiry - datetime.now().date()).days
            alert = "TODAY" if days_left <= 0 else f"in {days_left} days"
            tasks.append(f"- [ ] 📅 EXPIRING: {item} (Expires {alert})")
            
        cur.close()
        conn.close()
        return tasks
    except Exception as e:
        return [f"- [ ] 🛒 Check Pantry (Error connecting to DB: {e})"]

def generate_schedule(twin_state=None):
    # 1. Fetch Actual Calendar Events (G10)
    try:
        from G10_calendar_client import get_today_events
        cal_events = get_today_events()
    except Exception as e:
        print(f"Calendar Error: {e}")
        cal_events = []

    # 2. Build Base Schedule
    base_schedule = [
        ("06:00–09:00", "Deep Work: G04/G10 Foundation (Digital Twin & Productivity)"),
        ("09:00–12:00", "Professional Backlog (Six Sigma/DAC)"),
        ("12:00–14:00", "Household Admin & Bills"),
        ("14:00–17:00", "Growth / Learning (G06)"),
        ("17:00–18:00", "Workout / Recovery"),
        ("18:00–21:00", "Family / Personal"),
        ("21:00–22:00", "Daily Review & Log")
    ]

    # 3. Apply Twin State Adjustments (Recovery/Finance)
    if twin_state:
        health = twin_state.get("health", {})
        recovery = health.get("last_workout_recovery")
        days_since = health.get("days_since_workout", 0)
        
        # HIT Adjustment
        if recovery and recovery < 3:
            base_schedule[4] = ("17:00–18:00", "🧘 Mandatory Recovery (Low Recovery Score: {})".format(recovery))
        elif days_since >= 3:
            base_schedule[4] = ("17:00–18:00", "💪 HIT Workout (Due: {} days since last)".format(days_since))
        else:
            base_schedule[4] = ("17:00–18:00", "🚶 Active Recovery / Mobility")

        # Finance Adjustment
        finance = twin_state.get("finance", {})
        alerts = finance.get("active_budget_alerts", 0)
        if alerts > 0:
            base_schedule[2] = ("12:00–14:00", "💸 Household Admin (URGENT: {} Budget Alerts)".format(alerts))

    # 4. Merge Calendar Events
    final_schedule = []
    
    # Simple merge: Add all calendar events at the top if any, 
    # or intelligently insert them (for v1, we append a '📅 CALENDAR' section)
    for t, act in base_schedule:
        final_schedule.append(f"- {t} – {act}")
    
    if cal_events:
        final_schedule.append("\n---")
        final_schedule.append("### 📅 External Calendar Events (Today)")
        for event in cal_events:
            final_schedule.append(f"- {event['time']} – {event['summary']}")

    return "\n".join(final_schedule)

def generate_insights(twin_state, cal_events, mins_tasks):
    insights = []
    if twin_state:
        health = twin_state.get("health", {})
        recovery = health.get("last_workout_recovery")
        if recovery and recovery < 3:
            insights.append(f"- 🧘 Schedule prioritized for **recovery** (Score: {recovery}/5).")
        
        finance = twin_state.get("finance", {})
        if finance.get("active_budget_alerts", 0) > 0:
            insights.append(f"- 💸 High focus on **finance admin** due to {finance['active_budget_alerts']} budget breaches.")

    if not cal_events:
        insights.append("- 📅 No external calendar conflicts detected.")
    
    if mins_tasks:
        insights.append(f"- 🎯 Roadmap engine suggesting {len(mins_tasks)} critical Q1 actions.")

    return "\n### 🧠 Director's Insights\n" + "\n".join(insights) + "\n"

def get_digital_twin_briefing():
    try:
        # Import G04 engine if possible
        from G04_digital_twin_engine import DigitalTwinEngine
        engine = DigitalTwinEngine()
        return engine.generate_summary()
    except Exception as e:
        return f"🤖 Digital Twin Offline: {e}"

def get_roadmap_mins():
    """Extract next 3 incomplete Q1 tasks from Roadmap files across all goals."""
    goals_path = "/home/{{USER}}/Documents/autonomous-living/docs/10_GOALS"
    mins = []
    
    # List all goal directories
    if not os.path.exists(goals_path):
        return mins

    for goal_dir in sorted(os.listdir(goals_path)):
        if not goal_dir.startswith("G"):
            continue
            
        roadmap_file = os.path.join(goals_path, goal_dir, "Roadmap.md")
        if os.path.exists(roadmap_file):
            with open(roadmap_file, 'r') as f:
                lines = f.readlines()
            
            in_q1 = False
            for line in lines:
                if "## Q1" in line:
                    in_q1 = True
                    continue
                if line.startswith("## Q2"): # Stop at next quarter
                    break
                
                if in_q1 and "- [ ]" in line:
                    task_text = line.replace("- [ ]", "").strip()
                    mins.append(f"- [ ] **{goal_dir[:3]}**: {task_text}")
                    break # Only take the first incomplete task per goal
        
        if len(mins) >= 5: # Limit to 5 suggestions total
            break
            
    return mins

def get_google_tasks_summary():
    """Fetch tasks from Google Tasks API using the G10 sync script."""
    try:
        from G10_google_tasks_sync import get_upcoming_tasks
        tasks = get_upcoming_tasks()
        if not tasks:
            return None
        
        formatted_tasks = []
        for t in tasks:
            due_str = f" 📅 {t['due'][:10]}" if t.get('due') else ""
            formatted_tasks.append(f"- [ ] {t['title']}{due_str} #google-tasks")
        
        return "\n### 🤖 Google Tasks Sync (External)\n" + "\n".join(formatted_tasks) + "\n"
    except Exception as e:
        # Check if it's just a missing client_secret error
        if "client_secret.json not found" in str(e):
            return "\n> [!warning] Google Tasks: client_secret.json missing in scripts/\n"
        return f"\n> [!error] Google Tasks Error: {e}\n"

def get_goal_recommendations(twin_state=None):
    """Suggest 3 goals based on staleness, energy, and roadmap urgency."""
    goals_path = "/home/{{USER}}/Documents/autonomous-living/docs/10_GOALS"
    recommendations = []
    goal_metadata = []

    if not os.path.exists(goals_path):
        return None

    # 1. Analyze Staleness
    for goal_dir in sorted(os.listdir(goals_path)):
        if not goal_dir.startswith("G"): continue
        
        goal_id = goal_dir[:3]
        log_file = os.path.join(goals_path, goal_dir, "ACTIVITY_LOG.md")
        last_date = None
        
        if os.path.exists(log_file):
            with open(log_file, 'r') as f:
                content = f.read()
                # Find all ## YYYY-MM-DD
                dates = re.findall(r"## (\d{4}-\d{2}-\d{2})", content)
                if dates:
                    last_date = datetime.strptime(max(dates), "%Y-%m-%d").date()
        
        days_stale = (datetime.now().date() - last_date).days if last_date else 99
        goal_metadata.append({
            "id": goal_id,
            "name": goal_dir[4:].replace("-", " "),
            "stale": days_stale,
            "is_foundation": goal_id in ["G04", "G05", "G10", "G12"]
        })

    # 2. Logic: Priority Selection
    # Sort by staleness primarily
    goal_metadata.sort(key=lambda x: x['stale'], reverse=True)

    # Filter by energy (if state exists)
    energy_score = 3 # default
    if twin_state and "health" in twin_state:
        # Assuming we might have energy or sleep quality in the future, 
        # for now let's use recovery_score as a proxy if available
        energy_score = twin_state["health"].get("last_workout_recovery", 3)

    # Pick 1 stale foundation goal
    stale_foundations = [g for g in goal_metadata if g['is_foundation']]
    if stale_foundations:
        rec = stale_foundations[0]
        recommendations.append(f"- **{rec['id']}** ({rec['name']}): Foundation needs maintenance (Stale: {rec['stale']}d)")

    # Pick 1 stale growth goal
    stale_growth = [g for g in goal_metadata if not g['is_foundation']]
    if stale_growth:
        rec = stale_growth[0]
        recommendations.append(f"- **{rec['id']}** ({rec['name']}): High growth potential, priority due (Stale: {rec['stale']}d)")

    # Pick 1 based on energy
    if energy_score <= 2:
        # Suggest a "Low Energy" task - typically Documentation or Finance Admin
        recommendations.append("- **G12** (Process Documentation): Low energy detected. Perfect for system hardening.")
    else:
        # Suggest the next most stale item
        already_picked = [r.split("**")[1] for r in recommendations]
        remaining = [g for g in goal_metadata if g['id'] not in already_picked]
        if remaining:
            rec = remaining[0]
            recommendations.append(f"- **{rec['id']}** ({rec['name']}): Strategic gap detected (Stale: {rec['stale']}d)")

    return "\n### 🤖 Recommended Focus for Today (Intelligence)\n" + "_System suggestions based on staleness and capacity:_\n" + "\n".join(recommendations[:3]) + "\n"

def get_next_steps():
    """Extract the 'Next Step' from the latest log entry for each goal."""
    goals_path = "/home/{{USER}}/Documents/autonomous-living/docs/10_GOALS"
    next_steps = {}

    if not os.path.exists(goals_path):
        return next_steps

    for goal_dir in sorted(os.listdir(goals_path)):
        if not goal_dir.startswith("G"): continue
        
        goal_id = goal_dir[:3]
        log_file = os.path.join(goals_path, goal_dir, "ACTIVITY_LOG.md")
        
        if os.path.exists(log_file):
            with open(log_file, 'r') as f:
                content = f.read()
                # Find the last occurrence of "**Next Step:** " until the end of the line or next marker
                matches = re.findall(r"\*\*Next Step:\*\*\s*(.*?)\n", content)
                if matches:
                    step = matches[-1].strip()
                    if step and step.lower() != "tbd" and not step.startswith("- **Code:"):
                        next_steps[goal_id] = step
    return next_steps

def update_daily_note():
    # 1. Sync Foundation Data (G03)
    try:
        sync_dictionary()
        sync_inventory()
    except Exception as e:
        print(f"Sync error: {e}")

    # 1b. G11 Meta-System Health Check
    try:
        from G11_meta_mapper import generate_map
        api_health, doc_status = generate_map()
    except Exception as e:
        print(f"Meta-mapper error: {e}")
        api_health = "❌ Error"
        doc_status = "❌ Error"

    # 2. Daily Note Preparation
    today_file = get_today_file()
    if not os.path.exists(today_file):
        if not create_from_template(today_file):
            print("Could not create daily note from template.")
            return

    with open(today_file, 'r') as f:
        content = f.read()

    # 3. Dynamic Tasks
    tasks_to_add = []
    
    workout_task = analyze_workouts()
    if workout_task: tasks_to_add.append(workout_task)
    
    tasks_to_add.extend(get_budget_alerts())
    tasks_to_add.extend(get_pantry_tasks())

    # 3b. Roadmap MINS
    mins_tasks = get_roadmap_mins()

    # 3c. Google Tasks
    google_tasks_block = get_google_tasks_summary()

    # 4. Briefing
    try:
        from G04_digital_twin_engine import DigitalTwinEngine
        engine = DigitalTwinEngine()
        briefing = engine.generate_summary()
        twin_state = engine.state
    except Exception as e:
        briefing = f"🤖 Digital Twin Offline: {e}"
        twin_state = None

    # 4b. Generate Insights
    # Get cal_events again or just pass None for now as it's inside generate_schedule
    # Optimization: We should ideally fetch cal_events once. For now, let's just pass empty.
    insights = generate_insights(twin_state, [], mins_tasks)

    # 4c. Goal Recommendations
    goal_recs = get_goal_recommendations(twin_state)

    # 4d. Strategic Carryover (Next Steps)
    carryover_steps = get_next_steps()

    # 5. Inject into Content
    # Add System Health summary
    health_status = f"\n> [!health] 🛠️ **System Connectivity:** Digital Twin API: {api_health} | Docs (G12): {doc_status} | [Full Map](G11_System_Connectivity_Map.md)\n"
    if "## Digital Twin Briefing" not in content:
        content = content.replace("# 2026", "# 2026" + health_status + insights)

    # Add Digital Twin Briefing at top of reflection or after schedule
    if briefing and "## Digital Twin Briefing" not in content:
        briefing_block = f"\n## Digital Twin Briefing\n```\n{briefing}\n```\n"
        if "## Schedule / Time Blocks" in content:
            content = content.replace("## Schedule / Time Blocks", briefing_block + "## Schedule / Time Blocks")
        else:
            content += briefing_block

    # Update Schedule
    new_schedule_content = f"### 🤖 Suggested Schedule (Autonomous)\n{generate_schedule(twin_state)}\n"
    
    if "### 🤖 Suggested Schedule (Autonomous)" in content:
        # We need to find the block between '### 🤖 Suggested Schedule (Autonomous)' and the next '---'
        content = re.sub(
            r"### 🤖 Suggested Schedule \(Autonomous\)\n.*?\n---", 
            f"{new_schedule_content}---", 
            content, 
            flags=re.DOTALL
        )
    else:
        # Add new block after the section header
        if "## Schedule / Time Blocks" in content:
            content = content.replace("## Schedule / Time Blocks", f"## Schedule / Time Blocks\n\n---\n{new_schedule_content}---\n")
    
    # Update Autonomous Tasks
    if tasks_to_add or mins_tasks or google_tasks_block or goal_recs:
        task_sections = []
        if goal_recs:
            task_sections.append(goal_recs)
        if google_tasks_block:
            task_sections.append(google_tasks_block)
        if mins_tasks:
            task_sections.append("### 🤖 Autonomous MINS Suggestions (Roadmap)\n" + "\n".join(mins_tasks))
        if tasks_to_add:
            task_sections.append("### 🤖 Autonomous Task Suggestions (Status)\n" + "\n".join(tasks_to_add))
            
        combined_task_block = "\n" + "\n\n".join(task_sections) + "\n"
        
        if "## Tasks (manual planning)" in content:
            # If we already have the section, we need to be careful not to duplicate headers
            # Simplified approach: If ANY of our headers exist, replace the whole area
            if "### 🤖 Autonomous MINS Suggestions" in content or "### 🤖 Autonomous Task Suggestions" in content or "### 🤖 Google Tasks Sync" in content or "### 🤖 Recommended Focus" in content:
                # This regex captures from the first suggested header to the start of the next main section (##)
                content = re.sub(
                    r"### 🤖 (Google Tasks|Autonomous|Recommended).*?(?=\n## )", 
                    combined_task_block.strip(), 
                    content, 
                    flags=re.DOTALL
                )
            else:
                content = content.replace("## Tasks (manual planning)", "## Tasks (manual planning)" + combined_task_block)
        else:
            content += combined_task_block

    # 6. Strategic Carryover (Injection)
    if carryover_steps:
        for gid, step in carryover_steps.items():
            # Pattern logic:
            # 1. Find the goal identifier: **GXX**
            # 2. Match everything until the Next: marker
            # 3. Capture the Next: marker and any following whitespace
            # 4. Ensure we don't overwrite if there's already meaningful content (optional, but safer)
            
            # This regex looks for the GID block and targets the whitespace immediately after "**Next:**"
            pattern = rf"(\*\*({gid})\*\*\s*–.*?- \*\*Next:\*\*)(\s*)(?=\n|$)"
            
            # Check if there is already content there
            # We search for the pattern and check what's after it
            match = re.search(pattern, content, re.DOTALL)
            if match:
                current_whitespace = match.group(3)
                # If there's already content (more than just a newline/space), we skip to avoid overwriting your manual work
                # However, the user wants 'pre-filling', so we only fill if it's currently empty
                content = re.sub(pattern, rf"\1 {step}", content, count=1, flags=re.DOTALL)

    with open(today_file, 'w') as f:
        f.write(content)
    print(f"✅ Successfully updated {today_file} with Digital Twin insights.")

if __name__ == "__main__":
    update_daily_note()
