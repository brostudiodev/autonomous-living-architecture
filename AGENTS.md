# AGENTS.md - Agent Guidelines for Autonomous Living Repository

## Repository Overview
This is an execution repository for the 12 Power Goals of 2026, containing automation scripts, data validation, and documentation. The repo is designed to be maintainable by AI agents and future maintainers.

## Build/Test/Validation Commands

### Python Scripts
- **Run data validation**: `python3 scripts/validate_data.py`
  - Validates CSV data integrity in training logs
  - Checks for missing values and unknown exercise IDs
  - Exits with code 1 on validation failure

- **Run workout logger**: `python3 scripts/log_workout.py`
  - Interactive script to log workout sessions
  - Creates CSV entries and optional session notes

### Dependencies
- **Install Python dependencies**: `pip install pandas pyyaml`
  - Required for data validation and workout logging scripts
  - Python 3.11+ recommended

- **Install for development**: `python3 -m pip install --upgrade pip && pip install pandas pyyaml`

### Testing Single Components
- **Test data validation**: `python3 -c "import sys; sys.path.append('.'); from scripts.validate_data import validate_data; validate_data()"`
- **Syntax check**: `python3 -m py_compile scripts/validate_data.py scripts/log_workout.py`

### GitHub Actions
- **Manual trigger validation**: Use GitHub's "workflow_dispatch" on "Validate Workout Journal Data"
- **Manual sync**: Use "workflow_dispatch" on "G01 Training Sync" workflow

## Code Style Guidelines

### Python Standards
- **Python version**: 3.11+
- **Import order**: Standard library → Third-party → Local imports
- **Style**: Follow PEP 8 with 4-space indentation
- **Line length**: Max 88 characters (Black standard)
- **Docstrings**: Use triple quotes, describe purpose and parameters

### File Naming Conventions
- **Python scripts**: `snake_case.py` (e.g., `validate_data.py`)
- **Config files**: `snake_case.yml` (e.g., `workout_hit_fullbody_a.yml`)
- **Data files**: `snake_case.csv` (e.g., `sets.csv`, `workouts.csv`)
- **Documentation**: `kebab-case.md` (e.g., `CONTRIBUTING.md`)

### YAML Configuration Standards
- **Exercise IDs**: Use `ex_` prefix, snake_case, stable forever
- **Workout IDs**: Use descriptive names like `hit_fullbody_a`
- **Version field**: Always include `version: 1` in config files
- **Comments**: Include IMPORTANT notices for stable identifiers

### Error Handling
- **Always validate inputs** before processing
- **Use try/catch blocks** for file I/O operations
- **Print descriptive error messages** with context
- **Exit with code 1** on validation failures
- **Use sys.exit()** for script termination on errors

### Data Integrity Rules
- **CSV files**: Must have all required columns populated
- **Exercise references**: Must exist in exercises.yml
- **Date format**: Use ISO format "YYYY-MM-DD"
- **Boolean values**: Store as lowercase "true"/"false" in CSVs
- **Numeric values**: No null values in weight_kg, tut_s, bodyfat_pct columns

### Security & Safety
- **No secrets committed** to repository
- **Use environment variables** for sensitive data (URLs, tokens)
- **Validate all external data** before using
- **Use safe_load()** for YAML parsing

### Automation Standards
- **Documentation required** for all automation changes
- **Include purpose, inputs/outputs, dependencies**
- **Add observability** (log locations, failure detection)
- **Test manually** before committing automation scripts

### GitHub Conventions
- **Branch naming**: Use descriptive names linked to goals
- **Commit messages**: Prefix with goal ID (e.g., "G01: sync training CSVs")
- **PR requirements**: Link to Goal/System, update docs
- **Workflow naming**: Use descriptive names with purpose

### Code Organization
- **Scripts in `/scripts`**: Reusable automation tools
- **Data in `/data`**: CSV files with structured data
- **Config in `/config`**: YAML configuration files
- **Docs in `/docs`**: Goal-specific documentation
- **Workflows in `/.github/workflows`**: CI/CD automation

### Logging Standards
- **Use print()** for simple scripts (complex logging not needed)
- **Include section headers** with "---" prefix
- **Print validation status** clearly
- **Include file paths** in error messages for debugging

### Interactive Scripts
- **Use input()** for simple user interaction
- **Provide clear prompts** with examples
- **Offer optional features** (like session note creation)
- **Validate user input** when possible