# DevOps Assignment - Strategic Schedule (Updated)

## Overview
This schedule is designed for a 10-12 hour completion window, prioritizing learning and best practices over speed. Each phase builds upon the previous one, following DevOps principles. **Updated to address identified "gotchas" strategically.**

## Phase 1: Foundation & Critical Fixes (2-3 hours)
**Goal**: Fix critical issues and establish working local development environment

### 1.1 Application Analysis & Critical Fixes (1 hour)
- [ ] Examine the Python application structure
- [ ] **CRITICAL**: Fix database configuration (SQLite → PostgreSQL)
- [ ] **CRITICAL**: Add PostgreSQL driver dependency
- [ ] **CRITICAL**: Implement environment variable configuration
- [ ] **CRITICAL**: Add basic error handling and input validation
- [ ] Fix data types (ABV as Float instead of String)
- [ ] Add health check endpoint for load balancer
- [ ] Document all fixes made

### 1.2 Local Environment Setup (1 hour)
- [ ] Set up Python virtual environment
- [ ] Install dependencies (Poetry) - fix configuration issues
- [ ] Configure local PostgreSQL database
- [ ] Test application locally with proper error handling
- [ ] Document local setup in README
- [ ] Test all endpoints including health check

### 1.3 Docker Foundation & Security (1 hour)
- [ ] Review existing Dockerfile
- [ ] **SECURITY**: Fix root user issue (create non-root user)
- [ ] **SECURITY**: Add environment variable support
- [ ] Test Docker build locally
- [ ] Ensure 12-factor app compliance
- [ ] Test containerized application
- [ ] Validate security fixes

**Learning Focus**: Understanding application architecture, fixing critical production issues, containerization basics, and security best practices.

---

## Phase 2: Infrastructure Planning & Design (2-3 hours)
**Goal**: Design scalable, secure infrastructure that addresses identified issues

### 2.1 Infrastructure Architecture Design (1 hour)
- [ ] Plan VPC and networking structure
- [ ] Design ECS cluster architecture with health checks
- [ ] Plan RDS PostgreSQL setup with proper security
- [ ] Design ECR/container registry strategy
- [ ] Plan secrets management for database credentials
- [ ] Document infrastructure decisions and how they address the "gotchas"

### 2.2 Terraform Structure Planning (1 hour)
- [ ] Design Terraform module structure (networking, compute, database)
- [ ] Plan separation of concerns based on identified issues
- [ ] Design naming conventions
- [ ] Plan state management strategy
- [ ] Create Terraform directory structure
- [ ] Plan how to handle environment variables in infrastructure

### 2.3 Security & Best Practices Planning (1 hour)
- [ ] Plan IAM roles and policies for ECS tasks
- [ ] Design security groups for RDS and ECS
- [ ] Plan secrets management approach (AWS Secrets Manager)
- [ ] Design backup and disaster recovery for RDS
- [ ] Plan monitoring and logging (CloudWatch)
- [ ] Plan how to handle the session management issues in production

**Learning Focus**: Infrastructure as Code principles, AWS services, security best practices, and how infrastructure addresses application issues.

---

## Phase 3: Terraform Implementation (3-4 hours)
**Goal**: Implement infrastructure that properly supports the fixed application

### 3.1 Networking Foundation (1 hour)
- [ ] Implement VPC with public/private subnets
- [ ] Configure Internet Gateway and NAT Gateway
- [ ] Set up security groups with proper rules
- [ ] Configure route tables
- [ ] Test networking connectivity
- [ ] Ensure security groups allow proper database access

### 3.2 Database Infrastructure (1 hour)
- [ ] Implement RDS PostgreSQL instance with proper configuration
- [ ] Configure database security groups
- [ ] Set up database subnet group in private subnets
- [ ] Configure backup and maintenance windows
- [ ] **BONUS**: Implement PostgreSQL user and permission setup
- [ ] Test database connectivity from local environment

### 3.3 Container Registry (30 min)
- [ ] Implement ECR repository
- [ ] Configure repository policies
- [ ] Test image push/pull operations
- [ ] Set up lifecycle policies
- [ ] Configure ECR login for GitHub Actions

### 3.4 ECS Infrastructure (1-1.5 hours)
- [ ] Implement ECS cluster
- [ ] Create ECS task definition with proper environment variables
- [ ] Configure ECS service with health checks
- [ ] Set up application load balancer
- [ ] Configure auto-scaling (bonus)
- [ ] Ensure proper IAM roles for ECS tasks

**Learning Focus**: Terraform syntax, AWS resource relationships, infrastructure dependencies, and how infrastructure supports the fixed application.

---

## Phase 4: CI/CD Pipeline (2-3 hours)
**Goal**: Automate deployment pipeline with proper testing and validation

### 4.1 GitHub Actions Foundation (1 hour)
- [ ] Set up GitHub repository secrets for AWS credentials
- [ ] Create basic workflow structure
- [ ] Configure AWS credentials in GitHub Actions
- [ ] Test basic workflow execution
- [ ] Plan how to handle environment variables in CI/CD

### 4.2 Build Pipeline (1 hour)
- [ ] Implement Docker build workflow
- [ ] Configure image tagging strategy
- [ ] Set up image push to ECR
- [ ] Add build validation and testing
- [ ] **BONUS**: Add security scanning for Docker images
- [ ] Test the complete build pipeline

### 4.3 Deployment Pipeline (1 hour)
- [ ] Implement ECS deployment workflow
- [ ] Configure blue-green deployment strategy
- [ ] Set up deployment validation with health checks
- [ ] Add rollback capabilities
- [ ] **BONUS**: Add automated testing in deployment pipeline
- [ ] Test the complete deployment pipeline

**Learning Focus**: CI/CD principles, GitHub Actions, deployment strategies, and automation best practices.

---

## Phase 5: Testing & Optimization (1-2 hours)
**Goal**: Ensure everything works correctly and validate all fixes

### 5.1 End-to-End Testing (1 hour)
- [ ] Test complete deployment pipeline
- [ ] Validate application functionality (all endpoints)
- [ ] Test database connectivity and data persistence
- [ ] Verify security configurations work properly
- [ ] Test error handling and validation
- [ ] Test auto-scaling (if implemented)
- [ ] Validate all "gotcha" fixes are working

### 5.2 Documentation & Cleanup (1 hour)
- [ ] Update README with complete instructions
- [ ] Document all infrastructure decisions and why they were made
- [ ] Create troubleshooting guide
- [ ] Document all issues found and how they were resolved
- [ ] Document the "gotchas" and their fixes for the recruiter
- [ ] Clean up temporary resources
- [ ] Create final presentation of the solution

**Learning Focus**: Testing methodologies, documentation best practices, and production readiness.

---

## DevOps Principles Applied

### 12-Factor App Compliance
- [ ] Codebase: Single codebase tracked in version control
- [ ] Dependencies: Explicitly declared and isolated
- [ ] Config: Stored in environment variables (FIXED)
- [ ] Backing Services: Treated as attached resources (PostgreSQL)
- [ ] Build, Release, Run: Strictly separated build and run stages
- [ ] Processes: Stateless and share-nothing
- [ ] Port Binding: Self-contained and export services via port binding
- [ ] Concurrency: Scale out via the process model
- [ ] Disposability: Fast startup and graceful shutdown
- [ ] Dev/Prod Parity: Keep development, staging, and production as similar as possible
- [ ] Logs: Treat logs as event streams
- [ ] Admin Processes: Run admin/management tasks as one-off processes

### SOLID Principles in Infrastructure
- **Single Responsibility**: Each Terraform module has one clear purpose
- **Open/Closed**: Infrastructure can be extended without modification
- **Liskov Substitution**: Modules can be replaced with compatible alternatives
- **Interface Segregation**: Use specific IAM policies and security groups
- **Dependency Inversion**: Depend on abstractions (variables) not concrete implementations

## Success Criteria
- [ ] Application runs locally with virtual environment
- [ ] Application runs in Docker container securely
- [ ] Infrastructure provisions successfully with Terraform
- [ ] CI/CD pipeline builds and deploys automatically
- [ ] Application is accessible and functional in AWS
- [ ] **ALL intentional issues are identified and resolved**
- [ ] Documentation is complete and clear
- [ ] Code follows best practices and is maintainable
- [ ] **Security issues are addressed**
- [ ] **Error handling is robust**

## Time Allocation Summary
- **Phase 1**: 2-3 hours (Foundation + Critical Fixes)
- **Phase 2**: 2-3 hours (Planning)
- **Phase 3**: 3-4 hours (Implementation)
- **Phase 4**: 2-3 hours (Automation)
- **Phase 5**: 1-2 hours (Testing & Documentation)

**Total Estimated Time**: 10-15 hours

## Key Changes from Original Schedule

### **Phase 1 Enhancements:**
- **Critical fixes first**: Address the most important issues before building infrastructure
- **Security focus**: Fix Docker and application security issues early
- **Error handling**: Add robust error handling before deployment

### **Phase 2 Enhancements:**
- **Issue-aware planning**: Design infrastructure that specifically addresses the "gotchas"
- **Security by design**: Plan security measures from the beginning

### **Phase 3-5 Enhancements:**
- **Validation focus**: Ensure each phase validates the fixes from previous phases
- **Documentation**: Track all issues and their resolutions

## Notes
- Each phase now specifically addresses the identified "gotchas"
- The schedule prioritizes fixing critical issues before building infrastructure
- Security and error handling are addressed early and throughout
- Documentation includes tracking of all issues found and resolved
- Focus on quality and best practices rather than rushing to completion 