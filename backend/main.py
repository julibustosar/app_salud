from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
import uuid
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Hábitos para app_salud")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Permite conexiones de cualquier puerto/URL
    allow_credentials=True,
    allow_methods=["*"], # Permite GET, POST, PUT, DELETE
    allow_headers=["*"],
)

class Habit(BaseModel):
    id: str = ""
    name: str
    frequency: str
    isCompleted: bool = False

db_habits = []

@app.get("/habits")
def get_habits():
    return db_habits

@app.post("/habits", response_model=Habit)
def create_habit(habit: Habit):
    if not habit.id:
        habit.id = str(uuid.uuid4())
    
    db_habits.append(habit)
    return habit

@app.put("/habits/{habit_id}")
def update_habit(habit_id: str, updated_habit: Habit):
    for i, habit in enumerate(db_habits):
        if habit.id == habit_id:
            db_habits[i] = updated_habit
            return updated_habit
    return {"error": "Hábito no encontrado"}

@app.delete("/habits/{habit_id}")
def delete_habit(habit_id: str):
    global db_habits
    db_habits = [h for h in db_habits if h.id != habit_id]
    return {"message": "Hábito eliminado exitosamente"}