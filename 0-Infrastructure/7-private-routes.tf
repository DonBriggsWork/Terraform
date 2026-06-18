
#######################################
# 7-private-routes.tf
#######################################
resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc_DONSPACE.id


  tags = {
    Name = "rtb_private"
  }
}

resource "aws_route" "name" {
  route_table_id         = aws_route_table.rtb_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_nat.id
}