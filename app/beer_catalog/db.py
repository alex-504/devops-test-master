from sqlalchemy import create_engine

from sqlalchemy.orm import scoped_session, sessionmaker

# SQLite engine
engine = create_engine("sqlite:///beers.db", echo=True)

# Scoped session for thread-safe sessions in Flask
session_local = scoped_session(sessionmaker(bind=engine))
