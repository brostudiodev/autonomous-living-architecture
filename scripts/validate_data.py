# scripts/validate_data.py
import os
import pandas as pd
import yaml
import sys

# --- Configuration ---
TRAINING_PATH = "docs/10_GOALS/G01_Target-Body-Fat/Training"
EXERCISE_LIBRARY_PATH = os.path.join(TRAINING_PATH, "plans/exercise_library.yml")
SETS_CSV_PATH = os.path.join(TRAINING_PATH, "data/sets.csv")
MEASUREMENTS_CSV_PATH = os.path.join(TRAINING_PATH, "data/measurements.csv")

def validate_data():
    """Validates the CSV data."""
    print("--- Validating Data Integrity ---")
    errors = False

    # Load exercise library
    with open(EXERCISE_LIBRARY_PATH, 'r') as f:
        valid_exercises = [e['exercise'] for e in yaml.safe_load(f)]

    # Validate sets.csv
    try:
        sets_df = pd.read_csv(SETS_CSV_PATH)
        print(f"Validating {SETS_CSV_PATH}...")

        # Check for missing values in key columns
        for col in ['date', 'exercise', 'weight_kg', 'reps', 'rpe']:
            if sets_df[col].isnull().any():
                print(f"  ERROR: Missing values found in column '{col}'")
                errors = True

        # Check if exercises are in the library
        unknown_exercises = sets_df[~sets_df['exercise'].isin(valid_exercises)]
        if not unknown_exercises.empty:
            print(f"  ERROR: Unknown exercises found: {unknown_exercises['exercise'].unique()}")
            errors = True
        
        print("  Validation for sets.csv passed.")

    except Exception as e:
        print(f"  ERROR: Failed to validate {SETS_CSV_PATH}: {e}")
        errors = True

    # Validate measurements.csv
    try:
        measurements_df = pd.read_csv(MEASUREMENTS_CSV_PATH)
        print(f"Validating {MEASUREMENTS_CSV_PATH}...")

        for col in ['date', 'bodyweight_kg']:
             if measurements_df[col].isnull().any():
                print(f"  ERROR: Missing values found in column '{col}'")
                errors = True
        
        print("  Validation for measurements.csv passed.")

    except Exception as e:
        print(f"  ERROR: Failed to validate {MEASUREMENTS_CSV_PATH}: {e}")
        errors = True

    if errors:
        print("\nValidation failed!")
        sys.exit(1)
    else:
        print("\nAll data validated successfully!")

if __name__ == "__main__":
    if not os.path.exists("autonomous-living"):
        print("This script should be run from the parent directory of 'autonomous-living'")
    else:
        os.chdir("autonomous-living")
        validate_data()
