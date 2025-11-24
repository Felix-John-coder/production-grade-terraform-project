terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "felix-aws-bucket-terraform"
    key            = "development/terraform.tfstate"
    dynamodb_table = "dynamo_name_terrafrmlock"
    encrypt        = true
    region         = "eu-north-1"
  }
}