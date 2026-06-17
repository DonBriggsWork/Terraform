#######################################
# 1-vpc.tf
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
