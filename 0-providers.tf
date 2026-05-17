#######################################
# 0-providers.tf
#######################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.44.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

## Note: Initial infrastructure based upon video training
##     Author: Anton Putra
##     Title : Terraform AWS VPC Tutorial - Public, Private Subnets
##     url   : https://www.youtube.com/watch?v=TQ_V9TYoRvw&t=672s