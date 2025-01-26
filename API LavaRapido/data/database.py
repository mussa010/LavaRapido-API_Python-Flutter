from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base

usuario = "teste"
senha = "teste!123"
hostname = "localhost"
porta = 3306
bancoDados = "lavarapido"

engine = create_engine(url= f"mysql+pymysql://{usuario}:{senha}@{hostname}:{str(porta)}/{bancoDados}")

SessionLocal = sessionmaker(
    autocommit = False,
    autoflush = False,
    bind = engine
)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()