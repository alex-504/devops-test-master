# Provider Configuration - This tells Terraform how to connect to AWS
# Think of it like connecting to the kitchen before you can cook

provider "aws" {
  region = var.aws_region
} 