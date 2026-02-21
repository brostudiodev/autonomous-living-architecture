import os
import csv
import datetime
import yaml
import glob
import re
import psycopg2
from pathlib import Path

# --- Configuration ---
TRAINING_PATH = "/home/{{USER}}/Documents/autonomous-living/docs/10_Goals/G01_Target-Body-Fat/Training"
CONFIG_PATH = os.path.join(TRAINING_PATH, "config")
SETS_CSV_PATH = os.path.join(TRAINING_PATH, "data/sets.csv")
WORKOUTS_CSV_PATH = os.path.join(TRAINING_PATH, "data/workouts.csv")
SESSIONS_DIR = os.path.join(TRAINING_PATH, "sessions")
OBSIDIAN_VAULT = "/home/{{USER}}/Documents/Obsidian Vault"
DAILY_NOTES_DIR = os.path.join(OBSIDIAN_VAULT, "01_Daily_Notes")

DB_TRAINING = {
    "dbname": "autonomous_training",
    "user": "{{DB_USER}}",
    "password": "{{GENERIC_API_SECRET}}",
    "host": "localhost",
    "port": "5432"
}

def get_today_obsidian_data():
    """Extract mood and energy from today's daily note."""
    today_str = datetime.date.today().strftime("%Y-%m-%d")
    note_path = os.path.join(DAILY_NOTES_DIR, f"{today_str}.md")
    data = {"mood": 3, "energy": 3} # Defaults
    
    if os.path.exists(note_path):
        with open(note_path, 'r') as f:
            content = f.read()
            # Extract mood: - 3 - normal
            mood_match = re.search(r"mood:\s*
\s*-\s*(\d+)", content)
            if mood_match:
                data["mood"] = int(mood_match.group(1))
            else:
                # Fallback for " - 😐 ok" style
                if "ok" in content.lower(): data["mood"] = 3
                elif "great" in content.lower(): data["mood"] = 5
                
            energy_match = re.search(r"energy:\s*
\s*-\s*(\d+)", content)
            if energy_match:
                data["energy"] = int(energy_match.group(1))
    return data

def get_last_workout_stats(workout_id):
    """Fetch last weights and TUT for each exercise in this workout."""
    stats = {}
    try:
        with open(SETS_CSV_PATH, 'r') as f:
            reader = csv.DictReader(f)
            # Sort by date descending
            rows = sorted(list(reader), key=lambda x: x['date'], reverse=True)
            for exercise_id in set(row['exercise_id'] for row in rows if row['workout_id'] == workout_id):
                for row in rows:
                    if row['workout_id'] == workout_id and row['exercise_id'] == exercise_id:
                        stats[exercise_id] = {
                            "weight": row['weight_kg'],
                            "tut": row['tut_s']
                        }
                        break
    except Exception as e:
        print(f"Error reading last stats: {e}")
    return stats

def get_recovery_score():
    """Get recovery score from DB (Digital Twin context)."""
    try:
        conn = psycopg2.connect(**DB_TRAINING)
        cur = conn.cursor()
        cur.execute("SELECT recovery_score FROM workouts ORDER BY workout_date DESC LIMIT 1;")
        res = cur.fetchone()
        cur.close()
        conn.close()
        return res[0] if res else 3
    except:
        return 3

def choose_workout():
    workout_files = glob.glob(os.path.join(CONFIG_PATH, "workout_*.yml"))
    print("
--- 🤖 Smart Workout Logger ---")
    for i, f in enumerate(workout_files):
        print(f"  {i+1}: {os.path.basename(f)}")
    
    choice = int(input("Choose workout (1-{}): ".format(len(workout_files)))) - 1
    with open(workout_files[choice], 'r') as f:
        return yaml.safe_load(f)

def log_workout():
    today = datetime.date.today()
    date_str = today.strftime("%Y-%m-%d")
    
    workout_config = choose_workout()
    workout_id = workout_config['workout']['id']
    exercise_order = workout_config['exercise_order']
    
    obsidian_data = get_today_obsidian_data()
    recovery = get_recovery_score()
    last_stats = get_last_workout_stats(workout_id)

    print(f"
--- Logging: {workout_config['workout']['name']} ({date_str}) ---")
    print(f"Auto-filled: Mood={obsidian_data['mood']}, Energy={obsidian_data['energy']}, Recovery={recovery}")
    
    location = input(f"Location [Home]: ") or "Home"
    duration = input(f"Duration (min) [45]: ") or "45"
    
    workout_data = {
        'date': date_str,
        'workout_id': workout_id,
        'location': location,
        'duration_min': duration,
        'days_since_last_workout': '', # Can be empty as manager calculates it
        'recovered_1_5': recovery,
        'mood_1_5': obsidian_data['mood'],
        'notes': ''
    }

    sets_data = []
    for ex_id in exercise_order:
        last = last_stats.get(ex_id, {"weight": "0", "tut": "0"})
        print(f"
>> {ex_id} (Last: {last['weight']}kg, {last['tut']}s)")
        
        weight = input(f"   Weight kg [{last['weight']}]: ") or last['weight']
        tut = input(f"   TUT s [{last['tut']}]: ") or last['tut']
        
        sets_data.append({
            'date': date_str,
            'workout_id': workout_id,
            'exercise_id': ex_id,
            'weight_kg': weight,
            'tut_s': tut,
            'max_effort': 'true',
            'form_ok': 'true',
            'notes': ''
        })

    # Save
    with open(SETS_CSV_PATH, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=sets_data[0].keys())
        writer.writerows(sets_data)

    with open(WORKOUTS_CSV_PATH, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=workout_data.keys())
        writer.writerow(workout_data)

    print(f"
✅ Workout logged! Saved to CSVs.")

if __name__ == "__main__":
    log_workout()
