import json
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
            result = {"status": "skipped", "message": "Database already seeded"}
            print(json.dumps(result, indent=2))
            session.close()
            return result

        beers = [
            Beer(name="Sapporo Premium", style="Lager", abv=5.0),
            Beer(name="Kirin Ichiban", style="Pale Lager", abv=5.0),
            Beer(name="Yebisu", style="Premium Lager", abv=5.5),
            Beer(name="Asahi Super Dry", style="Dry Lager", abv=5.2),
            Beer(name="Krill", style="IPA", abv=6.5),
        ]

        session.add_all(beers)
        session.commit()

        result = {
            "status": "success",
            "message": "Database seeded with sample beers",
            "beers_added": len(beers),
            "beers": [
                {"name": beer.name, "style": beer.style, "abv": beer.abv}
                for beer in beers
            ],
        }
        print(json.dumps(result, indent=2))
        session.close()
        return result
    except Exception as e:
        error_result = {"status": "error", "message": f"Error seeding database: {e}"}
        print(json.dumps(error_result, indent=2))
        logger.error(f"Error seeding database: {e}")
        raise


if __name__ == "__main__":
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    seed_data()
