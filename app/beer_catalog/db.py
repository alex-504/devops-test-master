import os
from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker

# Get database URL from environment variable (12-factor app principle #3)
DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "postgresql://postgres:postgres@localhost:5432/beer_catalog"
)

# Create PostgreSQL engine
engine = create_engine(DATABASE_URL, echo=True)

# Scoped session for thread-safe sessions in Flask
session_local = scoped_session(sessionmaker(bind=engine))
