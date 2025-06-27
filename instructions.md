# DevOps Coding Assignment

# Welcome Aboard!

## Description

This exercise evaluates your ability to build and manage infrastructure for a small web application. You’ll work with Terraform, Docker, GitHub Actions, and AWS to provision resources, configure deployments, and demonstrate infrastructure-as-code best practices.

## Business Background

### Infrastructure & Automation

The operations team is working on automating the deployment pipeline for a Python-based application. Our goal is to containerize the app, provision cloud infrastructure with Terraform, and define CI/CD workflows using GitHub Actions. We want to ensure deployments are consistent, secure, and easily maintainable across environments. The files for the app are [available on the bottom of this page](https://www.notion.so/DevOps-Coding-Assignment-21b34639248580998262d4c876a107cf?pvs=21). 

## Requirements

### Minimum Requirements

You’ll find a small Python application and a Terraform folder already included. Your task is to:

**Terraform**

Provision the following resources using Terraform:

- ECR repository for storing Docker images (you may use GitHub Container Registry instead).
- ECS cluster and ECS service to run the containerized app.
- RDS instance using PostgreSQL.
- (Bonus) Configure PostgreSQL users and permissions via Terraform.

Avoid using open source or prebuilt Terraform modules for ECS or networking—we want to evaluate your ability to build these from scratch.

**Application Setup**

- Add instructions in the README for how to run the app locally using a virtual environment.
- Locally, the app should run using `venv`; in production, it should be deployed using the provided Dockerfile.

### Automation Requirements

Set up CI/CD workflows using GitHub Actions:

- Run pull request checks.
- Build the Docker image.
- Push the image to the ECR or GitHub Container Registry.
- Deploy the app to a non-production (or production-like) ECS environment.

### Bonus Features (Time Permitting)

- Automate RDS user permission setup.
- Add secret management.
- Enable ECS Service Auto Scaling.

### Gotchas

There are intentional issues scattered throughout the provided setup—feel free to identify and fix them. Bonus points for documenting your findings and solutions.

## Additional Details

- Use Git for version control and submit your work as a zip file.
- The solution should be self-contained, able to run on a fresh AWS account with minimal setup.
- Follow best practices in Terraform: use modules, separate concerns (e.g., networking, services, databases), and use consistent naming.
- The app has only three endpoints:
    - Get all beers
    - Insert a beer
    - Seed database with beers (for test data)

## Final Notes

- Estimated time for completion: 3–4 hours.
- Evaluation criteria:
    - Infrastructure design and separation of concerns
    - Terraform and DevOps best practices
    - Code clarity and maintainability
    - Quality of documentation and automation
    - Problem-solving and debugging skills (especially around intentional flaws)

## Evaluation Points

- Is the infrastructure written for scalability and team collaboration?
- Are naming conventions, code structure, and documentation clear and standardized?
- Does the CI/CD pipeline ensure a smooth deployment experience?
- Is the system resilient and secure, with scope for handling higher loads?
- How well do you troubleshoot and fix hidden issues?