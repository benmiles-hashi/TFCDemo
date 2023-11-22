terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

    }
  }
}
provider "aws" {
  region = "us-east-1"
  access_key = var.AWS_ACCESS_ID
  secret_key = var.AWS_SECRET
}