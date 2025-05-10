data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# resource "aws_key_pair" "id_ed25519" {
#   key_name   = "id_ed25519"
#   public_key = file("~/.ssh/id_ed25519.pub")

#   tags = {
#     Name = "id_ed25519"
#   }
# }
