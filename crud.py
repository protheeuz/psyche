import logging
from sqlalchemy.orm import Session
from db_models import User, Screening, Note
from schemas import NoteCreate, ScreeningCreate, UserCreate
from auth import get_password_hash

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def get_user_by_username(db: Session, username: str):
    return db.query(User).filter(User.username == username).first()

def create_user(db: Session, user: UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        username=user.username,
        full_name=user.full_name,  
        hashed_password=hashed_password
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def save_screening(db: Session, screening: ScreeningCreate, user_id: int):
    screening_data = screening.dict()
    screening_data.pop('user_id')  
    
    db_screening = Screening(**screening_data, user_id=user_id)
    db.add(db_screening)
    db.commit()
    db.refresh(db_screening)
    return db_screening


def create_note(db: Session, note: NoteCreate, user_id: int):
    db_note = Note(**note.dict(), user_id=user_id)
    db.add(db_note)
    db.commit()
    db.refresh(db_note)
    return db_note