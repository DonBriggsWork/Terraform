
#######################################
# 5-nat.tf
#######################################
resource "aws_eip" "eip_nat" {
  domain = "vpc"

  tags = {
    Name = "eip_nat"
  }
}

resource "aws_nat_gateway" "gw_nat" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.sn_public_1.id

  tags = {
    Name = "gw_nat"
  }

  depends_on = [aws_internet_gateway.igw_public]
}
