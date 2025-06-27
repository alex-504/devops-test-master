from sqlalchemy.orm import Session
from flask import Flask, jsonify, request
from beer_catalog.db import engine, session_local
from beer_catalog.beer import Base, Beer

app = Flask(__name__)

with app.app_context():
    Base.metadata.create_all(bind=engine)


@app.route("/")
def hello_there():
    return "Hello, There! \n"


@app.route("/beers", methods=["GET"])
def get_all_beers():
    session = session_local()
    beers = session.query(Beer).all()
    session.close()
    return jsonify(
        [{"id": b.id, "name": b.name, "style": b.style, "abv": b.abv} for b in beers]
    )


@app.route("/beers", methods=["POST"])
def create_beer():
    data = request.get_json()
    session = session_local()
    beer = Beer(name=data["name"], style=data.get("style"), abv=data.get("abv"))
    session.add(beer)
    session.commit()
    session.refresh(beer)
    session.close()
    return (
        jsonify(
            {"id": beer.id, "name": beer.name, "style": beer.style, "abv": beer.abv}
        ),
        201,
    )
