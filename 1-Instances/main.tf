# ==============================================================================
# INPUT VARIABLES
# ==============================================================================

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The target AWS Region for all resources"
}

variable "environment" {
  type        = string
  default     = "development"
  description = "The deployment environment tag"
}

variable "project_name" {
  type        = string
  default     = "config-01"
  description = "The prefix applied to resource naming conventions"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The EC2 instance size/type (Free Tier eligible)"
}

variable "key_pair_name" {
  type        = string
  default     = "kp_DonBriggsGroup"
  description = "The name of the pre-existing AWS Key Pair for SSH access"
}

# ==============================================================================
# DATA SOURCES (RETRIEVING EXISTING INFRASTRUCTURE)
# ==============================================================================

# 1. Look up the pre-existing Amazon Linux 2023 (AL2023) AMI
data "aws_ami" "al2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "description"
    values = ["Amazon Linux 2023 AMI *"]
  }

  owners = ["137112412989"] # Amazon
}

# 2. Look up your existing VPC (vpc_DONSPACE) by Tag Name or ID
data "aws_vpc" "target_vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc_DONSPACE"]
  }
}

# 3. Look up your existing Subnet (sn_public_1) within that VPC
data "aws_subnet" "target_subnet" {
  vpc_id = data.aws_vpc.target_vpc.id

  filter {
    name   = "tag:Name"
    values = ["sn_public_1"]
  }
}

# ==============================================================================
# SECURITY GROUPS (BOUND TO THE TARGET VPC)
# ==============================================================================

resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web instances permitting HTTP and SSH inside the target VPC"
  vpc_id      = data.aws_vpc.target_vpc.id

  # Inbound HTTP Access
  ingress {
    description = "Allow inbound HTTP web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTPS Access
  ingress {
    description = "Allow inbound HTTPS web traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound SSH Access
  ingress {
    description = "Allow SSH management traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  egress {
    description = "Permit all outbound connection responses"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-security-group"
    Environment = var.environment
  }
}

# ==============================================================================
# EC2 INSTANCE PROVISIONING & BOOTSTRAPPING
# ==============================================================================

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = data.aws_subnet.target_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data shell script to install LAMP stack elements and WordPress on AL2023
  user_data = <<-EOF
    #!/bin/bash
    # Update system packages
    dnf update -y

    # Install Apache, PHP 8.2 (AL2023 default PHP version), and required PHP modules
    dnf install -y httpd wget php php-core php-fpm php-mysqli php-json php-gd php-xml php-mbstring

    # Start and enable Apache and PHP-FPM services
    systemctl start httpd
    systemctl enable httpd
    systemctl start php-fpm
    systemctl enable php-fpm

    # Download and extract the latest WordPress installation files
    wget https://wordpress.org/latest.tar.gz -P /tmp
    tar -xzf /tmp/latest.tar.gz -C /tmp
    
    # Clean default Apache directory content and copy WordPress files
    rm -rf /var/www/html/*
    cp -r /tmp/wordpress/* /var/www/html/

    # Set proper ownership permissions for the Apache web server user
    chown -R apache:apache /var/www/html/
    chmod -R 755 /var/www/html/
  EOF

  tags = {
    Name        = var.project_name
    Environment = var.environment
  }
}

# ==============================================================================
# OUTPUTS
# ==============================================================================

output "vpc_id" {
  value       = data.aws_vpc.target_vpc.id
  description = "The ID of the targeted VPC"
}

output "subnet_id" {
  value       = data.aws_subnet.target_subnet.id
  description = "The ID of the targeted subnet"
}

output "instance_id" {
  value       = aws_instance.app_server.id
  description = "The newly provisioned EC2 application server ID"
}

output "instance_public_ip" {
  value       = aws_instance.app_server.public_ip
  description = "The public IP address assigned to the EC2 instance"
}