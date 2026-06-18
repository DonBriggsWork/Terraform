#######################################
# 2-igw.tf
#######################################
resource "aws_internet_gateway" "igw_public" {
  vpc_id = aws_vpc.vpc_DONSPACE.id

  tags = {
    Name = "igw_public"
  }
}
