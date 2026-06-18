#######################################
# 3-public-subnets.tf
#######################################
resource "aws_subnet" "sn_public_1" {
  vpc_id                  = aws_vpc.vpc_DONSPACE.id
  cidr_block              = "10.66.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn_public_1"
  }
}

resource "aws_subnet" "sn_public_2" {
  vpc_id                  = aws_vpc.vpc_DONSPACE.id
  cidr_block              = "10.66.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn_public_2"
  }
}
