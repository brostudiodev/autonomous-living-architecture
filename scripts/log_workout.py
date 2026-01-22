# This is a simplified script to demonstrate the logic.
# In a real-world scenario, you would use a library like `inquirer` or `click`
# to create interactive prompts.

import csv
import datetime
import os
import yaml

# --- Configuration ---
TRAINING_PATH = "docs/10_GOALS/G01_Target-Body-Fat/Training"
EXERCISE_LIBRARY_PATH = os.path.join(TRAINING_PATH, "plans/exercise_library.yml")
SETS_CSV_PATH = os.path.join(TRAINING_PATH, "data/sets.csv")
SESSIONS_CSV_PATH = os.path.join(TRAINING_PATH, "data/sessions.csv")
SESSION_TEMPLATE_PATH = os.path.join(TRAINING_PATH, "templates/hit_session.md")
SESSIONS_DIR = os.path.join(TRAINING_PATH, "sessions")

def get_exercises():
    """Loads the exercise library."""
    with open(EXERCISE_LIBRARY_PATH, 'r') as f:
        return yaml.safe_load(f)

def log_workout():
    """Logs a new workout session."""
    today = datetime.date.today()
    date_str = today.strftime("%Y-%m-%d")
    
    exercises = get_exercises()
    
    # --- Inquirer/Click equivalent part START ---
    # Here you would prompt the user for session details
    print("--- Logging New HIT Session ---")
    duration_min = input("Enter duration (min): ")
    readiness = input("Enter readiness (1-5): ")
    stress = input("Enter stress (1-5): ")
    
    session_data = {
        'date': date_str,
        'session_name': 'Full Body HIT',
        'duration_min': duration_min,
        'readiness_1_5': readiness,
        'stress_1_5': stress,
        'notes_tags': '' # User could add tags here
    }
    
    sets_data = []
    for exercise_info in exercises:
        exercise = exercise_info['exercise']
        print(f"\n--- {exercise} ---")
        weight_kg = input("Enter weight (kg): ")
        reps = input("Enter reps: ")
        tuttle = input("Enter TUTTLE (e.g. 4-1-4): ")
        rpe = input("Enter RPE (1-10): ")
        notes = input("Enter notes (optional): ")
        
        sets_data.append({
            'date': date_str,
            'exercise': exercise,
            'weight_kg': weight_kg,
            'reps': reps,
            'tuttle': tuttle,
            'rpe': rpe,
            'notes': notes
        })
    # --- Inquirer/Click equivalent part END ---

    # Append to CSVs
    with open(SETS_CSV_PATH, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=sets_data[0].keys())
        writer.writerows(sets_data)

    with open(SESSIONS_CSV_PATH, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=session_data.keys())
        writer.writerow(session_data)

    # Create session markdown file
    with open(SESSION_TEMPLATE_PATH, 'r') as f:
        template = f.read()
    
    session_md = template.replace("{{DATE}}", date_str)
    session_file_path = os.path.join(SESSIONS_DIR, str(today.year), f"{date_str}__hit.md")
    
    with open(session_file_path, 'w') as f:
        f.write(session_md)
        
    print(f"\nWorkout for {date_str} logged successfully!")
    print(f"Session file created at: {session_file_path}")

if __name__ == "__main__":
    # This script is meant to be run from the root of the autonomous-living repo.
    # To make it runnable from anywhere, you might need to adjust path handling.
    # For now, we assume CWD is the repo root.
    if not os.path.exists("autonomous-living"):
        print("This script should be run from the parent directory of 'autonomous-living'")
    else:
        os.chdir("autonomous-living")
        log_workout()
