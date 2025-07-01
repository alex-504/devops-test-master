import logging
import os
from dotenv import load_dotenv
from sqlalchemy.orm import Session
from sqlalchemy import text
from flask import Flask, jsonify, request
from beer_catalog.db import engine, session_local
from beer_catalog.beer import Base, Beer
from seed import seed_database

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

with app.app_context():
    Base.metadata.create_all(bind=engine)


@app.route("/")
def hello_there():
    return "Hello, There! \n"


@app.route("/health")
def health_check():
    """Health check endpoint for load balancer"""
    try:
        # Test database connection
        session = session_local()
        session.execute(text("SELECT 1"))
        session.close()
        return jsonify({"status": "healthy", "database": "connected"}), 200
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return jsonify({"status": "unhealthy", "error": str(e)}), 500


@app.route("/beers", methods=["GET"])
def get_all_beers():
    """Get all beers from the database"""
    try:
        session = session_local()
        beers = session.query(Beer).all()
        session.close()
        return jsonify(
            [
                {"id": b.id, "name": b.name, "style": b.style, "abv": b.abv}
                for b in beers
            ]
        )
    except Exception as e:
        logger.error(f"Error getting beers: {e}")
        return jsonify({"error": "Failed to retrieve beers"}), 500


@app.route("/beers", methods=["POST"])
def create_beer():
    """Create a new beer"""
    try:
        data = request.get_json()

        # Input validation
        if not data:
            return jsonify({"error": "No data provided"}), 400

        if "name" not in data or not data["name"]:
            return jsonify({"error": "Beer name is required"}), 400

        # Validate ABV if provided
        abv = data.get("abv")
        if abv is not None:
            try:
                abv = float(abv)
                if abv < 0 or abv > 100:
                    return jsonify({"error": "ABV must be between 0 and 100"}), 400
            except (ValueError, TypeError):
                return jsonify({"error": "ABV must be a valid number"}), 400

        session = session_local()
        beer = Beer(name=data["name"], style=data.get("style"), abv=abv)
        session.add(beer)
        session.commit()
        session.refresh(beer)
        session.close()

        logger.info(f"Created beer: {beer.name}")
        return (
            jsonify(
                {"id": beer.id, "name": beer.name, "style": beer.style, "abv": beer.abv}
            ),
            201,
        )
    except Exception as e:
        logger.error(f"Error creating beer: {e}")
        return jsonify({"error": "Failed to create beer"}), 500


@app.route("/seed", methods=["POST"])
def seed():
    try:
        seed_database()
        return jsonify({"message": "Database seeded with test beers"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Endpoint not found"}), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({"error": "Internal server error"}), 500
