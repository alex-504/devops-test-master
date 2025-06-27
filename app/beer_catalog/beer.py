from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Float

Base = declarative_base()


class Beer(Base):
    __tablename__ = "beers"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    style = Column(String(50))
    abv = Column(Float)

    def __repr__(self):
        return f"<Beer(name={self.name}, style={self.style}, abv={self.abv})>"
