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

## How to Deploy This Infrastructure to AWS 👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻👈🏻

This project is ready to be deployed to AWS using Terraform. Follow these steps to connect your resources to your AWS account and provide all required variables.

---

### 1. **Set Up AWS Credentials**

Terraform needs AWS credentials to create resources in your account.  
You can provide credentials in several ways, but the most common is using the AWS CLI:

```sh
aws configure
```
- Enter your AWS Access Key ID
- Enter your AWS Secret Access Key
- Enter your default region (e.g., us-east-1)
- Enter your default output format (json is fine)

Alternatively, you can set these as environment variables:
```sh
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=us-east-1
```

---

### 2. **Set Required Terraform Variables**

Some resources require variables that must be provided at runtime, such as your database password and the Docker image for your app.

You can provide these variables in several ways:

**A. As environment variables:**
```sh
export TF_VAR_db_password="yourStrongPassword"
export TF_VAR_app_image="123456789012.dkr.ecr.us-east-1.amazonaws.com/beer-catalog-app:latest"
```

**B. As command-line arguments:**
```sh
terraform apply -var="db_password=yourStrongPassword" -var="app_image=123456789012.dkr.ecr.us-east-1.amazonaws.com/beer-catalog-app:latest"
```

**C. In a `terraform.tfvars` file:**
```hcl
db_password = "yourStrongPassword"
app_image   = "123456789012.dkr.ecr.us-east-1.amazonaws.com/beer-catalog-app:latest"
```

---

### 3. **Initialize and Validate Terraform**

```sh
terraform init
terraform validate
```

---

### 4. **Plan and Apply**

**Preview the changes:**
```sh
terraform plan
```

**Apply the changes (provision resources):**
```sh
terraform apply
```

---

### 5. **Notes**

- You must have sufficient AWS permissions to create VPCs, subnets, ECS, RDS, ECR, and IAM roles.
- The `app_image` variable should point to a Docker image you have pushed to your ECR repository.
- The `db_password` should be a strong password for your PostgreSQL database.
- No AWS resources will be created until you run `terraform apply`.
- You can destroy all resources with:
  ```sh
  terraform destroy
  ```

---

**If you do not have an AWS account, you can still review and validate the code with `terraform validate`.**

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

## 🐳 ECS (Elastic Container Service) Setup

This project uses AWS ECS Fargate to run the Beer Catalog app in a scalable, managed container environment.

### What's Set Up
- **ECS Cluster**: The environment where your containers run
- **Task Definition**: The "recipe" for your app container (image, ports, env vars)
- **Task Execution Role**: Lets ECS pull images from ECR and write logs
- **ECS Service**: Keeps your app running and accessible in the public subnet

### How to Configure the App Image
- Set the `app_image` variable to the full ECR image URL you want to deploy (e.g., `123456789012.dkr.ecr.us-east-1.amazonaws.com/beer-catalog-app:latest`).
- You can do this via environment variable, command-line flag, or `terraform.tfvars` (see AWS deployment instructions above).

### How to Access the App
- After deployment, the app will be running in the public subnet on port 5000.
- You can find the public IP by checking the ECS task in the AWS console (or by adding a Terraform output for the task ENI/public IP).
- If you add a load balancer, update this section to explain how to access the app via the load balancer DNS name.

### Notes
- The ECS service is set to run 1 copy of your app by default. You can scale this by changing the `desired_count` in the Terraform code.
- For production, consider adding a load balancer and auto-scaling.








