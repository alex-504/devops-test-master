from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String

Base = declarative_base()


class Beer(Base):
    __tablename__ = "beers"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    style = Column(String)
    abv = Column(String)

    def __repr__(self):
        return f"<Beer(name={self.name}, style={self.style}, abv={self.abv})>"
