## DevOps exercise

## Exercise
There is an app written in Python and a Terraform folder.

The `docker` folder contains a simple Dockerfile.

### Create the following resource:
In terraform:
- ECR resources (if you choose ECR, github registry is also fine)
- ECS Cluster
- ECS Service
- RDS Instance (postgres based)

### For the app:
You need a local setup for the project, i.e. some readme entry showing how to run the app on your machine

- We need to automate the build process
- Locally the app runs in a virtenv, but on prod it will run the Dockerfile

### CD/CI
- GitHub Actions Workflows
    - Pull Request Checks
    - Build image
    - Push image to ECR (or github registries)
    - Deployment of the app into non-prod envs (or prod like envs, if you have the time)

### Extras
- Postgres user and permission configuration in terraform
- There are intentional mistakes all over the place. Kudos if you find and solve them.

## App 
The small app in python has only two endpoints
- Get all beers
- Insert one beer
- Seed beers (for testing)

## Considerations
- More than the TF code to be running we will check the plan it generates. 
- Doesn't need to be perfect
- Avoid using open source modules for setting networking / ecs. We want to see your capabilities at writing the resources

## What will be evaluated
- Terraform best practices
- Structure of the terraform code
- Naming conventions
- Separation of concerns
- AWS knowledge



## How to test the app

Pre-requisites:
- PostgreSQL installed (brew install postgresql@14 on macOS)
- Python 3.11+ installed
- Poetry installed (pip install poetry)

Step 1: Cteate a PostgreSql database
```bash
brew install postgresql@14
```

Step 2: Create a virtual environment
```bash
cd app # if not in app already
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install Poetry (if not already installed)
pip install poetry

# Update Poetry lock file (after dependency changes)
poetry lock

# Install project dependencies
poetry install
```

**Step 3: Test with PostGres**
```bash
export DATABASE_URL="postgresql://localhost/beer_catalog"

# Create the database
createdb beer_catalog

# Run the Flask application
python -m flask --app beer_catalog/app run --debug
```

Step 4: Test endpoints
```bash
# Health check
curl http://127.0.0.1:5000/health
# Expected: {"status": "healthy", "database": "connected"}

# Get beers (initially empty)
curl http://127.0.0.1:5000/beers
# Expected: []

# Seed the database
python seed.py
# Expected: JSON output with seeding status

# Get beers (now populated)
curl http://127.0.0.1:5000/beers
# Expected: Array of beer objects
```

** Running the app with Sqlite**

**Step 1: Setup Python environment**
```bash
cd app
python3 -m venv venv
source venv/bin/activate
pip install poetry
poetry lock
poetry install
```

**Step 2: Run the app with Sqlite**
```bash
export DATABASE_URL="sqlite:///beers.db"
python -m flask --app beer_catalog/app run --debug
```

**Step 3: Test endpoints**
```bash
# Health check
curl http://127.0.0.1:5000/health
# Expected: {"status": "healthy", "database": "connected"}

# Get beers (initially empty)
curl http://127.0.0.1:5000/beers
# Expected: [] becase it is not seeded yet 

# Seed the database
python seed.py
# Expected: JSON output with seeding status

# Get beers (now populated)
curl http://127.0.0.1:5000/beers
# Expected: Array of beer objects

```



** Summary of DB tests:
| Step                | SQLite Command/Setting                        | PostgreSQL Command/Setting                        |
|---------------------|-----------------------------------------------|---------------------------------------------------|
| **Set DB URL**      | `export DATABASE_URL="sqlite:///beers.db"`    | `export DATABASE_URL="postgresql://localhost/beer_catalog"` |
| **Start Flask**     | `python -m flask --app beer_catalog/app run --debug` | `python -m flask --app beer_catalog/app run --debug` |
| **Seed Data**       | `python seed.py`                              | `python seed.py`                                  |
| **Test Endpoints**  | Same for both                                 | Same for both                                     |

## Useful commands

**Adding new beers**
```bash
url -X POST http://127.0.0.1:5000/beers \
  -H "Content-Type: application/json" \
  -d '{"name": "Heineken", "style": "Lager", "abv": 5.0}'
```

**Get all beers**
```bash
curl http://127.0.0.1:5000/beers
```

**Health check**
```bash
curl http://127.0.0.1:5000/health
```

**Seed the database**
- To reseed, first we need to clear the database
```bash
dropdb beer_catalog
createdb beer_catalog
python seed.py
```








