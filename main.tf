#######################################
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

#######################################
# 1-vpc
#######################################
resource "aws_vpc" "vpc-DONSPACE" {
  cidr_block       = "10.66.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-DONSPACE"
  }
}

#######################################
# 2-igw
#######################################
resource "aws_internet_gateway" "igw-public" {
  vpc_id = aws_vpc.vpc-DONSPACE.id

  tags = {
    Name = "igw-public"
  }
}

#######################################
# 3-public-subnets
#######################################
resource "aws_subnet" "sn-public-1" {
  vpc_id                  = aws_vpc.vpc-DONSPACE.id
  cidr_block              = "10.66.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-public-1"
  }
}

resource "aws_subnet" "sn-public-2" {
  vpc_id                  = aws_vpc.vpc-DONSPACE.id
  cidr_block              = "10.66.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-public-2"
  }
}

#######################################
# 4-public-routes
#######################################
resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc-DONSPACE.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-public.id
  }

  tags = {
    Name = "rtb-public"
  }
}
resource "aws_route_table_association" "sn-public-1" {
  subnet_id      = aws_subnet.sn-public-1.id
  route_table_id = aws_route_table.rtb-public.id
}

resource "aws_route_table_association" "sn-public-2" {
  subnet_id      = aws_subnet.sn-public-2.id
  route_table_id = aws_route_table.rtb-public.id
}

#######################################
# 5-nat
#######################################
resource "aws_eip" "eip-nat" {
  domain = "vpc"

  tags = {
    Name = "eip-nat"
  }
}

resource "aws_nat_gateway" "gw-nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.sn-public-1.id

  tags = {
    Name = "gw-nat"
  }

  depends_on = [aws_internet_gateway.igw-public]
}

#######################################
# 6-private-subnets
#######################################
resource "aws_subnet" "sn-private-1" {
  vpc_id            = aws_vpc.vpc-DONSPACE.id
  cidr_block        = "10.66.10.0/24"
  availability_zone = "us-east-1e"

  tags = {
    Name = "sn-private-1"
  }
}

resource "aws_subnet" "sn-private-2" {
  vpc_id            = aws_vpc.vpc-DONSPACE.id
  cidr_block        = "10.66.11.0/24"
  availability_zone = "us-east-1f"

  tags = {
    Name = "sn-private-2"
  }
}

#######################################
# 7-private-routes
#######################################
resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.vpc-DONSPACE.id
  
  
  tags = {
    Name = "rtb-private"
  }
}

resource "aws_route" "name" {
  route_table_id = aws_route_table.rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.gw-nat.id
}