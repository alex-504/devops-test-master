# Variables for our beer app infrastructure
# These are like ingredients in a recipe - you can change them easily

# To set the Docker image for ECS, create a terraform.tfvars file with:
# app_image = "311450700715.dkr.ecr.ap-southeast-2.amazonaws.com/my-ecr-repo:latest"

variable "aws_region" {
  description = "Which AWS region to use (like us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name for our project (used for naming resources)"
  type        = string
  default     = "beer-catalog"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true # This hides the password in logs
}

variable "app_image" {
  description = "Docker image to use for the app (ECR URL)"
  type        = string
}

variable "db_host" {
  description = "RDS endpoint for the app"
  type        = string
} 