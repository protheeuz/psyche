from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from db_models import User, Screening, Note  # Absolute import dari db_models tanpa prefix direktori
from schemas import UserCreate, UserResponse, ScreeningCreate, ScreeningResponse, NoteCreate, NoteResponse  # Absolute import dari schemas tanpa prefix direktori
from database import engine, get_db  # Absolute import dari database tanpa prefix direktori
from crud import get_user_by_email, create_user, create_screening, create_note  # Absolute import dari crud tanpa prefix direktori
from auth import verify_password  # Absolute import dari auth tanpa prefix direktori

app = FastAPI()

# Pengaturan CORS Middleware
origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:3000",  # Misal jika ada front-end lain
    "http://127.0.0.1:8000",
    "http://127.0.0.1:3000",
    "http://192.168.1.100:8000",  # Gantilah dengan IP lokal server Anda
    # Tambahkan origin lain yang diizinkan
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Membuat semua tabel di database
User.metadata.create_all(bind=engine)

@app.post("/register/", response_model=UserResponse)
def register(user: UserCreate, db: Session = Depends(get_db)):
    db_user = get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return create_user(db=db, user=user)

@app.post("/login/")
def login(user: UserCreate, db: Session = Depends(get_db)):
    db_user = get_user_by_email(db, email=user.email)
    if not db_user:
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    if not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    return {"message": "Login successful"}

@app.post("/screenings/", response_model=ScreeningResponse)
def create_screening(screening: ScreeningCreate, db: Session = Depends(get_db), user_id: int = Depends(get_db)):
    return create_screening(db=db, screening=screening, user_id=user_id)

@app.post("/notes/", response_model=NoteResponse)
def create_note(note: NoteCreate, db: Session = Depends(get_db), user_id: int = Depends(get_db)):
    return create_note(db=db, note=note, user_id=user_id)