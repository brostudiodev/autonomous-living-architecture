import os
import pandas as pd
import psycopg2
from datetime import datetime

# Paths to CSV files
SLOWNIK_CSV = "/home/{{USER}}/Documents/Magazynek_domowy - Slownik.csv"
SPIZARKA_CSV = "/home/{{USER}}/Documents/Magazynek_domowy - Spizarka.csv"

# DB Config
DB_CONFIG = {
    "dbname": "autonomous_pantry",
    "user": "{{DB_USER}}",
    "password: "{{GENERIC_API_SECRET}}",
    "host": "localhost",
    "port": "5432"
}

def sync_dictionary():
    if not os.path.exists(SLOWNIK_CSV):
        print(f"Error: {SLOWNIK_CSV} not found")
        return
    
    df = pd.read_csv(SLOWNIK_CSV)
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    for _, row in df.iterrows():
        # Mapping: Kategoria, Synonimy_AI, Domyślna_Jednostka, Próg_Krytyczny
        # To Table: category, ai_synonyms, default_unit, critical_threshold
        cur.execute("""
            INSERT INTO pantry_dictionary (category, ai_synonyms, default_unit, critical_threshold, updated_at)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (category) DO UPDATE SET
                ai_synonyms = EXCLUDED.ai_synonyms,
                default_unit = EXCLUDED.default_unit,
                critical_threshold = EXCLUDED.critical_threshold,
                updated_at = EXCLUDED.updated_at;
        """, (
            row['Kategoria'], 
            row['Synonimy_AI'] if pd.notna(row['Synonimy_AI']) else None,
            row['Domyślna_Jednostka'] if pd.notna(row['Domyślna_Jednostka']) else None,
            row['Próg_Krytyczny'] if pd.notna(row['Próg_Krytyczny']) else None,
            datetime.now()
        ))
    
    conn.commit()
    cur.close()
    conn.close()
    print("✅ Pantry Dictionary synced successfully.")

def sync_inventory():
    if not os.path.exists(SPIZARKA_CSV):
        print(f"Error: {SPIZARKA_CSV} not found")
        return
    
    df = pd.read_csv(SPIZARKA_CSV)
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    for _, row in df.iterrows():
        # Mapping: Kategoria, Aktualna_Ilość, Jednostka, Najblizsa_Waznosc, Ostatnia_Aktualizacja, Status, Próg_Krytyczny, Uwagi
        # To Table: category, current_quantity, unit, next_expiry, last_updated, status, critical_threshold, notes
        
        # Handle date parsing
        def parse_date(val):
            if pd.isna(val) or val == '': return None
            try: return datetime.strptime(str(val), "%Y-%m-%d").date()
            except: return None

        cur.execute("""
            INSERT INTO pantry_inventory (category, current_quantity, unit, next_expiry, last_updated, status, critical_threshold, notes, updated_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            ON CONFLICT (category) DO UPDATE SET
                current_quantity = EXCLUDED.current_quantity,
                unit = EXCLUDED.unit,
                next_expiry = EXCLUDED.next_expiry,
                last_updated = EXCLUDED.last_updated,
                status = EXCLUDED.status,
                critical_threshold = EXCLUDED.critical_threshold,
                notes = EXCLUDED.notes,
                updated_at = EXCLUDED.updated_at;
        """, (
            row['Kategoria'],
            row['Aktualna_Ilość'] if pd.notna(row['Aktualna_Ilość']) else 0,
            row['Jednostka'] if pd.notna(row['Jednostka']) else None,
            parse_date(row['Najblizsa_Waznosc']),
            parse_date(row['Ostatnia_Aktualizacja']),
            row['Status'] if pd.notna(row['Status']) else None,
            row['Próg_Krytyczny'] if pd.notna(row['Próg_Krytyczny']) else None,
            row['Uwagi'] if pd.notna(row['Uwagi']) else None,
            datetime.now()
        ))
    
    conn.commit()
    cur.close()
    conn.close()
    print("✅ Pantry Inventory synced successfully.")

if __name__ == "__main__":
    sync_dictionary()
    sync_inventory()
