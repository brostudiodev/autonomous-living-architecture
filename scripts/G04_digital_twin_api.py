from fastapi import FastAPI, HTTPException
from typing import Optional
import json
import psycopg2
from datetime import datetime
from G04_digital_twin_engine import DigitalTwinEngine, DB_FINANCE, PERSON_UUID

app = FastAPI(title="Digital Twin API", version="1.0.0")
engine = DigitalTwinEngine()

@app.get("/")
async def root():
    return {"message": "Digital Twin API is online", "persona": "Agent Zero"}

@app.get("/status")
async def get_status():
    """Returns the full human-readable status summary and raw state."""
    summary = engine.generate_summary()
    return {
        "summary": summary,
        "state": engine.state
    }

@app.get("/health")
async def get_health():
    """Returns detailed health state."""
    engine.get_health_status()
    return engine.state["health"]

@app.get("/finance")
async def get_finance():
    """Returns detailed finance state."""
    engine.get_finance_status()
    return engine.state["finance"]

@app.get("/tasks")
async def get_tasks(quarter: Optional[str] = None):
    """Consolidated tasks view with optional quarter filtering (e.g., Q1)."""
    # 1. Google Tasks
    google_tasks = engine.get_google_tasks()
    
    # 2. Roadmap Tasks (Filtered by quarter if provided)
    roadmap_tasks = engine.get_roadmap_tasks(quarter_filter=quarter)
    
    # 3. System Tasks (Alerts, Health, Finance)
    # Only show if not filtering for a specific roadmap quarter
    system_tasks = []
    if not quarter:
        system_tasks = engine.get_system_tasks()
        
    return {
        "quarter_filtered": quarter,
        "google_tasks": google_tasks,
        "roadmap_tasks": roadmap_tasks,
        "system_tasks": system_tasks
    }

@app.get("/history")
async def get_history(limit: int = 5):
    """Returns historical state updates from the database."""
    try:
        conn = psycopg2.connect(**DB_FINANCE)
        cur = conn.cursor()
        cur.execute(
            "SELECT entity_type, update_data, created_at FROM digital_twin_updates ORDER BY created_at DESC LIMIT %s",
            (limit * 2,) # limit*2 because we insert 2 records (health, finance) per sync
        )
        rows = cur.fetchall()
        history = []
        for row in rows:
            history.append({
                "entity": row[0],
                "data": row[1],
                "timestamp": row[2].isoformat()
            })
        cur.close()
        conn.close()
        return history
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5677)
