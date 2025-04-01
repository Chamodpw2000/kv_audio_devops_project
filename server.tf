# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Brand-New VPC Configuration
resource "aws_vpc" "brandnew_vpc" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "brandnew-audio-vpc"
  }
}

# Brand-New Public Subnet
resource "aws_subnet" "brandnew_public_subnet" {
  vpc_id                  = aws_vpc.brandnew_vpc.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "brandnew-audio-public-subnet"
  }
}

# Brand-New Internet Gateway
resource "aws_internet_gateway" "brandnew_igw" {
  vpc_id = aws_vpc.brandnew_vpc.id
  tags = {
    Name = "brandnew-audio-igw"
  }
}

# Brand-New Route Table
resource "aws_route_table" "brandnew_public_rt" {
  vpc_id = aws_vpc.brandnew_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.brandnew_igw.id
  }
  tags = {
    Name = "brandnew-audio-public-rt"
  }
}

# Brand-New Route Table Association
resource "aws_route_table_association" "brandnew_public_association" {
  subnet_id      = aws_subnet.brandnew_public_subnet.id
  route_table_id = aws_route_table.brandnew_public_rt.id
}

# Brand-New Security Group
resource "aws_security_group" "brandnew_app_sg" {
  name        = "brandnew-audio-security-group"
  description = "Security group for brand-new KV Audio application"
  vpc_id      = aws_vpc.brandnew_vpc.id

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
    Name = "brandnew-audio-sg"
  }
}

# Brand-New SSH Key Pair
resource "aws_key_pair" "brandnew_deployer" {
  key_name   = "brandnew-audio-deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDe8AejGyM8siKt9jwM8DCtxiYzVjfnrZfIQ3ZnJF7mOB0Wyds9HoAtwkNFGu+s26aANscq6s0biRzJnqUDwl3uXg5dGdEYWN7ShKQMheM3mRi6K6g78WV1tdTP+TsdfMxaKmherQlOBrch+m9vX8DifEN/UEZco+LhB1EhMyGsjdWNB8BklDx8AGBN4sDkRTX9c7QQ5cZ2xAAIe2KmQYOPU/V0PCOAPKblTdGyX/3tfLwb8QzLA5/RJWi+9BSHDQd01wkHPtnJcOMNVaWkL9eFcHluUkvq+Xz3+ML7s3slZ3XPVy3DraMuxIAP3LkF8bD2PdKe6ctEF0jEmk1aHa1z system@LAPTOP-59GHARO8"
}

# Brand-New EC2 Instance
resource "aws_instance" "brandnew_app_server" {
  ami                     = "ami-0f9d441b5d66d5f31"
  instance_type           = "t2.medium"
  subnet_id               = aws_subnet.brandnew_public_subnet.id
  vpc_security_group_ids  = [aws_security_group.brandnew_app_sg.id]
  key_name                = aws_key_pair.brandnew_deployer.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "brandnew-audio-app-server"
  }

  depends_on = [
    aws_route_table_association.brandnew_public_association,
    aws_subnet.brandnew_public_subnet,
    aws_security_group.brandnew_app_sg
  ]
}

# Output Values for Brand-New Infrastructure
output "brandnew_instance_public_ip" {
  value = aws_instance.brandnew_app_server.public_ip
}

output "brandnew_ssh_connection" {
  value = "ssh -i brandnew-deployer-key.pem ec2-user@${aws_instance.brandnew_app_server.public_ip}"
}

output "brandnew_application_urls" {
  value = {
    frontend   = "http://${aws_instance.brandnew_app_server.public_ip}:5173"
    backend_api = "http://${aws_instance.brandnew_app_server.public_ip}:3000"
    mongodb    = "mongodb://${aws_instance.brandnew_app_server.public_ip}:27017"
  }
}
