terraform {
  required_version = ">=1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.78.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
