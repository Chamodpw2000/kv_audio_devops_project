# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
  # Access and secret keys should be configured via AWS CLI or environment variables
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "kv-audio-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "kv-audio-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "kv-audio-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "kv-audio-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "kv-audio-security-group"
  description = "Security group for KV Audio application"
  vpc_id      = aws_vpc.main.id
  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # MongoDB
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "MongoDB"
  }
  # Node.js Backend
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Node.js Backend"
  }
  # React Vite Frontend
  ingress {
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "React Vite Frontend"
  }
  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kv-audio-sg"
  }
}

# SSH Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "kv-audio-deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDe8AejGyM8siKt9jwM8DCtxiYzVjfnrZfIQ3ZnJF7mOB0Wyds9HoAtwkNFGu+s26aANscq6s0biRzJnqUDwl3uXg5dGdEYWN7ShKQMheM3mRi6K6g78WV1tdTP+TsdfMxaKmherQlOBrch+m9vX8DifEN/UEZco+LhB1EhMyGsjdWNB8BklDx8AGBN4sDkRTX9c7QQ5cZ2xAAIe2KmQYOPU/V0PCOAPKblTdGyX/3tfLwb8QzLA5/RJWi+9BSHDQd01wkHPtnJcOMNVaWkL9eFcHluUkvq+Xz3+ML7s3slZ3XPVy3DraMuxIAP3LkF8bD2PdKe6ctEF0jEmk1aHa1z system@LAPTOP-59GHARO8"
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                     = "ami-0f9d441b5d66d5f31" # Amazon Linux 2023 AMI for us-west-2
  instance_type           = "t2.medium" # Increased to handle Docker containers
  subnet_id               = aws_subnet.public.id
  vpc_security_group_ids  = [aws_security_group.app_sg.id]
  key_name                = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 30 # Increased disk space for Docker images
    volume_type = "gp2"
  }
  tags = {
    Name = "kv-audio-app-server"
  }
  depends_on = [
    aws_route_table_association.public,
    aws_subnet.public,
    aws_security_group.app_sg
  ]
}

# Output Values
output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "ssh_connection" {
  value = "ssh -i deployer-key.pem ec2-user@${aws_instance.app_server.public_ip}"
}

output "application_urls" {
  value = {
    frontend = "http://${aws_instance.app_server.public_ip}:5173"
    backend_api = "http://${aws_instance.app_server.public_ip}:3000"
    mongodb = "mongodb://${aws_instance.app_server.public_ip}:27017"
  }
}
