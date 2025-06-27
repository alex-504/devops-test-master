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
