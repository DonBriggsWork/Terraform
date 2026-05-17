#######################################
# 2-igw.tf
#######################################
resource "aws_internet_gateway" "igw-public" {
  vpc_id = aws_vpc.vpc-DONSPACE.id

  tags = {
    Name = "igw-public"
  }
}
