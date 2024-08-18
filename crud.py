from sqlalchemy.orm import Session
from db_models import User, Screening, Note  # Absolute import dari db_models tanpa prefix direktori
from schemas import NoteCreate, ScreeningCreate, UserCreate  # Absolute import dari schemas tanpa prefix direktori
from auth import get_password_hash  # Absolute import dari auth tanpa prefix direktori

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def create_user(db: Session, user: UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = User(email=user.email, username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def create_screening(db: Session, screening: ScreeningCreate, user_id: int):
    db_screening = Screening(**screening.dict(), user_id=user_id)
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