from beer_catalog.beer import Beer, Base
from beer_catalog.db import engine, session_local


def seed_data():
    session = session_local()

    if session.query(Beer).first():
        print("Database already seeded.")
        session.close()
        return

    beers = [
        Beer(name="Sapporo Premium", style="Lager", abv="5.0%"),
        Beer(name="Kirin Ichiban", style="Pale Lager", abv="5.0%"),
        Beer(name="Yebisu", style="Premium Lager", abv="5.5%"),
        Beer(name="Asahi Super Dry", style="Dry Lager", abv="5.2%"),
    ]

    session.add_all(beers)
    session.commit()
    print("Database seeded with sample beers.")
    session.close()


if __name__ == "__main__":
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    seed_data()
