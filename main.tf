# 0-providers
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

# 1-vpc
#######################################
resource "aws_vpc" "vpc-DONSPACE" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-DONSPACE"
  }
}

# 2-igw
#######################################
resource "aws_internet_gateway" "igw-public" {
  vpc_id = aws_vpc.vpc-DONSPACE.id

  tags = {
    Name = "igw-public"
  }
}

# 3-public-subnets
#######################################
resource "aws_subnet" "sn_public" {
  vpc_id            = aws_vpc.vpc-DONSPACE.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sn-public"
  }
}

# 4-public-routes
#######################################
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc-DONSPACE.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-public.id
  }

  tags = {
    Name = "rt_public"
  }
}
resource "aws_route_table_association" "sn_public" {
  subnet_id      = aws_subnet.sn_public.id
  route_table_id = aws_route_table.rt_public.id
}
