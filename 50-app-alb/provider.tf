terraform {
  required_providers {
      aws = {
      source = "hashicorp/aws"
      version = "5.58.0"
    }
  }
backend "s3" {
  bucket = "expense-infra-dev-remote-state-1"
  key = "expense-infra-dev-app-alb"
  region = "us-east-1"
  dynamodb_table="expense-infra-dev-locking-1"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

