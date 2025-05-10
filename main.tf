# Dev Environment Cloud
resource "aws_vpc" "vpc_dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc_DevSpace"
  }
}

# Dev PUBLIC subnet
resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1a" # Change to your desired AZ

  tags = {
    Name = "dev_public_subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "allow_dev_sg" {
  name        = "Dev security group"
  description = "Allow required inbound and outbound traffic"
  vpc_id      = aws_vpc.vpc_dev.id

  ingress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev_node" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.dev_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_dev_sg.id]
  key_name                    = "key_us-west-1"
  associate_public_ip_address = true
  user_data                   = file("userdata.tpl")

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name = "dev-node"
  }
}
#   provisioner "local-exec" {
#     command  = templatefile("linux-ssh-config.tpl", 
#     {
#       hostname = self.public_ip,
#       user     = "ubuntu",
#       identityfile = "~/.ssh/id_ed25519" 
#     })
#     interpreter = ["bash", "-c"]
#   }

# }