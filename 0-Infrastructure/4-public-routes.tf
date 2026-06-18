
#######################################
# 4-public-routes.tf
#######################################
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc_DONSPACE.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_public.id
  }

  tags = {
    Name = "rtb_public"
  }
}

resource "aws_route_table_association" "sn_public_1" {
  subnet_id      = aws_subnet.sn_public_1.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "sn_public_2" {
  subnet_id      = aws_subnet.sn_public_2.id
  route_table_id = aws_route_table.rtb_public.id
}
