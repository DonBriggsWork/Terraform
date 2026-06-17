
#######################################
# 5-nat.tf
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
