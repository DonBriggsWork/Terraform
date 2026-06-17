
#######################################
# 4-public-routes.tf
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
