# Issues Found - "Gotchas" in the Assignment

## 🎯 Intentional Issues Identified

### 1. **Database Configuration Issues**

#### **Issue 1.1: Wrong Database Type**
- **Location**: `app/beer_catalog/db.py`
- **Problem**: Using SQLite instead of PostgreSQL
- **Code**: `engine = create_engine("sqlite:///beers.db", echo=True)`
- **Impact**: Assignment requires PostgreSQL RDS, but app is configured for SQLite
- **Fix Needed**: Configure for PostgreSQL with environment variables

#### **Issue 1.2: Missing Environment Configuration**
- **Location**: `app/beer_catalog/db.py`
- **Problem**: Hardcoded database connection string
- **Impact**: Violates 12-factor app principle #3 (Config)
- **Fix Needed**: Use environment variables for database configuration

### 2. **Application Architecture Issues**

#### **Issue 2.1: Missing Error Handling**
- **Location**: `app/beer_catalog/app.py`
- **Problem**: No error handling in API endpoints
- **Lines**: 18-22, 25-35
- **Impact**: Application will crash on database errors or invalid input
- **Fix Needed**: Add proper error handling and validation

#### **Issue 2.2: Session Management Issues**
- **Location**: `app/beer_catalog/app.py`
- **Problem**: Manual session management without proper cleanup
- **Impact**: Potential memory leaks and connection pool exhaustion
- **Fix Needed**: Use context managers or dependency injection

#### **Issue 2.3: Missing Input Validation**
- **Location**: `app/beer_catalog/app.py` line 27
- **Problem**: No validation for required fields or data types
- **Code**: `beer = Beer(name=data["name"], style=data.get("style"), abv=data.get("abv"))`
- **Impact**: Application will crash if "name" is missing
- **Fix Needed**: Add proper input validation

### 3. **Data Model Issues**

#### **Issue 3.1: Wrong Data Type for ABV**
- **Location**: `app/beer_catalog/beer.py` line 12
- **Problem**: ABV stored as String instead of Float/Decimal
- **Code**: `abv = Column(String)`
- **Impact**: Can't perform numerical operations on ABV values
- **Fix Needed**: Change to Float or Decimal type

#### **Issue 3.2: Missing Constraints**
- **Location**: `app/beer_catalog/beer.py`
- **Problem**: No length constraints on String fields
- **Impact**: Potential database performance issues and data integrity problems
- **Fix Needed**: Add appropriate length constraints

### 4. **Docker Issues**

#### **Issue 4.1: Missing Environment Variables**
- **Location**: `docker/Dockerfile`
- **Problem**: No environment variable configuration for database
- **Impact**: Container can't connect to external database
- **Fix Needed**: Add environment variable support

#### **Issue 4.2: Security Issue - Running as Root**
- **Location**: `docker/Dockerfile`
- **Problem**: Container runs as root user
- **Impact**: Security vulnerability
- **Fix Needed**: Create non-root user

### 5. **Dependencies Issues**

#### **Issue 5.1: Missing PostgreSQL Driver**
- **Location**: `app/pyproject.toml`
- **Problem**: No PostgreSQL driver in dependencies
- **Impact**: Can't connect to PostgreSQL database
- **Fix Needed**: Add `psycopg2-binary` or `asyncpg`

#### **Issue 5.2: Poetry Configuration Mismatch**
- **Location**: `app/pyproject.toml`
- **Problem**: Poetry package configuration doesn't match actual structure
- **Code**: `packages = [{include = "app", from = "src"}]`
- **Impact**: Poetry won't install correctly
- **Fix Needed**: Fix package configuration

### 6. **Infrastructure Issues**

#### **Issue 6.1: Empty Terraform Configuration**
- **Location**: `terraform/main.tf`
- **Problem**: File is completely empty
- **Impact**: No infrastructure defined
- **Fix Needed**: Implement all required AWS resources

#### **Issue 6.2: Missing Required Providers**
- **Location**: `terraform/versions.tf`
- **Problem**: PostgreSQL provider included but no PostgreSQL resources defined
- **Impact**: Unused provider dependency
- **Fix Needed**: Either use the provider or remove it

### 7. **Missing Features**

#### **Issue 7.1: No Health Check Endpoint**
- **Location**: `app/beer_catalog/app.py`
- **Problem**: No health check endpoint for load balancer
- **Impact**: ECS service won't know if app is healthy
- **Fix Needed**: Add `/health` endpoint

#### **Issue 7.2: No Logging Configuration**
- **Location**: `app/beer_catalog/app.py`
- **Problem**: No structured logging
- **Impact**: Difficult to debug in production
- **Fix Needed**: Add proper logging configuration

## 🚀 Fix Strategy

### Priority 1 (Critical for Basic Functionality)
1. Fix database configuration (SQLite → PostgreSQL)
2. Add PostgreSQL driver dependency
3. Implement environment variable configuration
4. Add basic error handling

### Priority 2 (Important for Production)
1. Fix data types (ABV as Float)
2. Add input validation
3. Implement proper session management
4. Add health check endpoint

### Priority 3 (Best Practices)
1. Fix Docker security (non-root user)
2. Add logging configuration
3. Fix Poetry configuration
4. Add data constraints

### Priority 4 (Infrastructure)
1. Implement Terraform resources
2. Configure proper IAM roles
3. Set up security groups
4. Implement CI/CD pipeline

## 📝 Notes for Implementation

- **12-Factor App Compliance**: Most issues violate 12-factor app principles
- **SOLID Principles**: Current code doesn't follow single responsibility principle
- **Security**: Multiple security issues need addressing
- **Scalability**: Current design won't scale in production

## 🎯 Learning Opportunities

These "gotchas" are actually excellent learning opportunities:
- **Database Migration**: Learn how to migrate from SQLite to PostgreSQL
- **Environment Configuration**: Understand 12-factor app principles
- **Error Handling**: Learn proper error handling patterns
- **Security**: Understand container and application security
- **Infrastructure as Code**: Start from scratch with proper structure

## Issue: ECS App Could Not Connect to RDS (Database Connection Refused)

### **Symptoms:**
- ECS tasks were repeatedly stopping with exit code 1.
- CloudWatch logs showed:
  - `sqlalchemy.exc.OperationalError: (psycopg2.OperationalError) connection to server at "localhost" (127.0.0.1), port 5432 failed: Connection refused`
- Health check endpoint was not responding; app was not running.

### **Root Cause:**
- The application was trying to connect to a PostgreSQL database at `localhost` inside the container, but the actual database was running on AWS RDS in a private subnet.
- The ECS task definition was only passing `DB_HOST` or missing the correct `DATABASE_URL` environment variable, so the app defaulted to `localhost`.

### **Troubleshooting Steps:**
1. **Checked ECS task status:**
   - Noticed tasks were stopping quickly after launch.
2. **Enabled CloudWatch logging:**
   - Updated ECS task definition to send logs to CloudWatch for easier debugging.
3. **Reviewed CloudWatch logs:**
   - Found clear Python stack trace showing connection attempts to `localhost`.
4. **Reviewed environment variables:**
   - Realized the app expected a `DATABASE_URL` env var, not just `DB_HOST`.
5. **Checked RDS endpoint and credentials:**
   - Confirmed the correct RDS endpoint, username, and password.

### **Solution:**
- Updated the ECS task definition in Terraform to set the `DATABASE_URL` environment variable:
  ```hcl
  environment = [
    {
      name  = "DATABASE_URL"
      value = "postgresql://beer_admin:${var.db_password}@${var.db_host}:5432/beer_catalog"
    }
  ]
  ```
- Added `db_host` as a Terraform variable and set it to the RDS endpoint.
- Re-applied Terraform to update the ECS service and task definition.
- Verified the app was running and healthy by hitting the `/health` endpoint.

### **Key Learnings:**
- Always check CloudWatch logs for ECS task failures—they provide detailed error messages.
- Ensure your app's environment variables match what the code expects (e.g., `DATABASE_URL`).
- Use Terraform variables to avoid hardcoding sensitive or environment-specific values.
- ECS task definition changes require a new revision and service update.

--- 