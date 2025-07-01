from beer_catalog.db import session_local
from beer_catalog.beer import Beer


def seed_database():
    session = session_local()
    beers = [
        Beer(name="Heineken", style="Lager", abv=5.0),
        Beer(name="Guinness", style="Stout", abv=4.2),
        Beer(name="Sierra Nevada", style="Pale Ale", abv=5.6),
    ]
    session.add_all(beers)
    session.commit()
    session.close()


if __name__ == "__main__":
    seed_database()
    print("Database seeded with test beers.")
