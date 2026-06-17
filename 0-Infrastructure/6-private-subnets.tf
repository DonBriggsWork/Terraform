
#######################################
# 6-private-subnets.tf
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
