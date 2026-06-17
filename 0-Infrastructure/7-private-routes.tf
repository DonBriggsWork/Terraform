
#######################################
# 7-private-routes.tf
#######################################
resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.vpc-DONSPACE.id


  tags = {
    Name = "rtb-private"
  }
}

resource "aws_route" "name" {
  route_table_id         = aws_route_table.rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw-nat.id
}