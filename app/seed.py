import logging
from beer_catalog.beer import Beer, Base
from beer_catalog.db import engine, session_local

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def seed_data():
    """Seed the database with sample beer data"""
    try:
        session = session_local()

        if session.query(Beer).first():
            logger.info("Database already seeded.")
            session.close()
            return

        beers = [
            Beer(name="Sapporo Premium", style="Lager", abv=5.0),
            Beer(name="Kirin Ichiban", style="Pale Lager", abv=5.0),
            Beer(name="Yebisu", style="Premium Lager", abv=5.5),
            Beer(name="Asahi Super Dry", style="Dry Lager", abv=5.2),
        ]

        session.add_all(beers)
        session.commit()
        logger.info("Database seeded with sample beers.")
        session.close()
    except Exception as e:
        logger.error(f"Error seeding database: {e}")
        raise


if __name__ == "__main__":
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    seed_data()
