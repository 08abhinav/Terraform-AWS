terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket  =  var.bucket_name
    key     =  "terraform-aws-project-statefile/terraform.tfstate"
    region  =  "us-east-1"
    encrypt =  true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
