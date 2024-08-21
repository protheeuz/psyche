from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from db_models import User, Screening, Note
from schemas import UserCreate, UserResponse, ScreeningCreate, ScreeningResponse, NoteCreate, NoteResponse, LoginRequest
from database import engine, get_db
from crud import get_user_by_email, create_user, create_note, get_user_by_username, save_screening
from auth import verify_password
import logging

app = FastAPI()

# Konfigurasi logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Pengaturan CORS Middleware
origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://localhost:3000",
    "http://127.0.0.1:8000",
    "http://127.0.0.1:3000",
    "http://192.168.1.100:8000",
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
    logger.info(f"Attempt to register user with email: {user.email}")
    db_user = get_user_by_email(db, email=user.email)
    if db_user:
        logger.error(f"Email already registered: {user.email}")
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Tambahkan validasi untuk username
    db_username = get_user_by_username(db, user.username)
    if db_username:
        logger.error(f"Username already taken: {user.username}")
        raise HTTPException(status_code=400, detail="Username already taken")

    new_user = create_user(db=db, user=user)
    logger.info(f"User registered successfully: {new_user.email}")
    return new_user

@app.post("/login/")
def login(user: LoginRequest, db: Session = Depends(get_db)):
    db_user = get_user_by_username(db, username=user.username)
    if not db_user:
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    if not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    user_data = {
        "message": "Login successful",
        "access_token": "some_token_value",  # Example, 
        "user_id": db_user.id,  # Menggunakan kolom id sebagai user_id
        "full_name": db_user.full_name,
        "email": db_user.email,
        "username": db_user.username
    }

    logger.info(f"User data being sent: {user_data}")  # Log data yang dikirim
    
    return user_data

@app.post("/screenings/", response_model=ScreeningResponse)
def create_screening(screening: ScreeningCreate, db: Session = Depends(get_db)):
    return save_screening(db=db, screening=screening, user_id=screening.user_id)

@app.post("/notes/", response_model=NoteResponse)
def create_note(note: NoteCreate, db: Session = Depends(get_db), user_id: int = Depends(get_db)):
    return create_note(db=db, note=note, user_id=user_id)