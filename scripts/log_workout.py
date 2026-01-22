# This is a simplified script to demonstrate the logic.
# In a real-world scenario, you would use a library like `inquirer` or `click`
# to create interactive prompts.

import csv
import datetime
import os
import yaml
import glob

# --- Configuration ---
TRAINING_PATH = "docs/10_GOALS/G01_Target-Body-Fat/Training"
CONFIG_PATH = os.path.join(TRAINING_PATH, "config")
SETS_CSV_PATH = os.path.join(TRAINING_PATH, "data/sets.csv")
WORKOUTS_CSV_PATH = os.path.join(TRAINING_PATH, "data/workouts.csv")
SESSION_TEMPLATE_PATH = os.path.join(TRAINING_PATH, "sessions/2026-SESSION-TEMPLATE.md")
SESSIONS_DIR = os.path.join(TRAINING_PATH, "sessions")

def choose_workout():
    """Lets the user choose a workout configuration."""
    workout_files = glob.glob(os.path.join(CONFIG_PATH, "workout_*.yml"))
    print("Please choose a workout:")
    for i, f in enumerate(workout_files):
        print(f"  {i+1}: {os.path.basename(f)}")
    
    choice = int(input("Enter your choice: ")) - 1
    
    with open(workout_files[choice], 'r') as f:
        return yaml.safe_load(f)

def log_workout():
    """Logs a new workout session."""
    today = datetime.date.today()
    date_str = today.strftime("%Y-%m-%d")
    
    workout_config = choose_workout()
    workout_id = workout_config['workout']['id']
    exercise_order = workout_config['exercise_order']
    
    # --- Inquirer/Click equivalent part START ---
    print(f"--- Logging New Workout: {workout_config['workout']['name']} ---")
    location = input("Enter location: ")
    duration_min = input("Enter duration (min): ")
    days_since_last = input("Days since last workout (optional): ")
    recovered = input("Enter recovered score (1-5): ")
    mood = input("Enter mood score (1-5): ")
    notes_session = input("Enter session notes (optional): ")

    workout_data = {
        'date': date_str,
        'workout_id': workout_id,
        'location': location,
        'duration_min': duration_min,
        'days_since_last_workout': days_since_last,
        'recovered_1_5': recovered,
        'mood_1_5': mood,
        'notes': notes_session
    }

    sets_data = []
    for exercise_id in exercise_order:
        print(f"\n--- {exercise_id} ---")
        weight_kg = input("Enter weight (kg): ")
        tut_s = input("Enter TUT (s): ")
        max_effort = input("Max effort (true/false): ").lower() == 'true'
        form_ok = input("Form OK (true/false): ").lower() == 'true'
        notes_set = input("Enter set notes (optional): ")
        
        sets_data.append({
            'date': date_str,
            'workout_id': workout_id,
            'exercise_id': exercise_id,
            'weight_kg': weight_kg,
            'tut_s': tut_s,
            'max_effort': max_effort,
            'form_ok': form_ok,
            'notes': notes_set
        })
    # --- Inquirer/Click equivalent part END ---

    # Append to CSVs
    with open(SETS_CSV_PATH, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=sets_data[0].keys())
        writer.writerows(sets_data)

    with open(WORKOUTS_CSV_PATH, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=workout_data.keys())
        writer.writerow(workout_data)

    # Optional: Create session markdown file
    create_note = input("\nCreate a detailed session note? (y/n): ").lower()
    if create_note == 'y':
        with open(SESSION_TEMPLATE_PATH, 'r') as f:
            template = f.read()
        
        session_md = template.replace("YYYY-MM-DD", date_str).replace("hit_fullbody_a", workout_id)
        session_file_path = os.path.join(SESSIONS_DIR, str(today.year), f"{date_str}__{workout_id}.md")
        
        with open(session_file_path, 'w') as f:
            f.write(session_md)
        print(f"Session note created at: {session_file_path}")

    print(f"\nWorkout for {date_str} logged successfully!")

if __name__ == "__main__":
    log_workout()