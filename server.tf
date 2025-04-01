# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Custom VPC Configuration
resource "aws_vpc" "media_vpc_2025" {
  cidr_block           = "10.3.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "media-vpc-2025"
  }
}

# Custom Public Subnet
resource "aws_subnet" "media_public_subnet_2025" {
  vpc_id                  = aws_vpc.media_vpc_2025.id
  cidr_block              = "10.3.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "media-public-subnet-2025"
  }
}

# Custom Internet Gateway
resource "aws_internet_gateway" "media_igw_2025" {
  vpc_id = aws_vpc.media_vpc_2025.id
  tags = {
    Name = "media-igw-2025"
  }
}

# Custom Route Table
resource "aws_route_table" "media_public_rt_2025" {
  vpc_id = aws_vpc.media_vpc_2025.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.media_igw_2025.id
  }
  tags = {
    Name = "media-public-rt-2025"
  }
}

# Custom Route Table Association
resource "aws_route_table_association" "media_public_association_2025" {
  subnet_id      = aws_subnet.media_public_subnet_2025.id
  route_table_id = aws_route_table.media_public_rt_2025.id
}

# Custom Security Group
resource "aws_security_group" "media_app_sg_2025" {
  name        = "media-security-group-2025"
  description = "Security group for media application"
  vpc_id      = aws_vpc.media_vpc_2025.id

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
    Name = "media-sg-2025"
  }
}

# Custom SSH Key Pair
resource "aws_key_pair" "media_deployer_key_2025" {
  key_name   = "media-deployer-key-2025"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDe8AejGyM8siKt9jwM8DCtxiYzVjfnrZfIQ3ZnJF7mOB0Wyds9HoAtwkNFGu+s26aANscq6s0biRzJnqUDwl3uXg5dGdEYWN7ShKQMheM3mRi6K6g78WV1tdTP+TsdfMxaKmherQlOBrch+m9vX8DifEN/UEZco+LhB1EhMyGsjdWNB8BklDx8AGBN4sDkRTX9c7QQ5cZ2xAAIe2KmQYOPU/V0PCOAPKblTdGyX/3tfLwb8QzLA5/RJWi+9BSHDQd01wkHPtnJcOMNVaWkL9eFcHluUkvq+Xz3+ML7s3slZ3XPVy3DraMuxIAP3LkF8bD2PdKe6ctEF0jEmk1aHa1z system@LAPTOP-59GHARO8"
}

# Custom EC2 Instance
resource "aws_instance" "media_app_server_2025" {
  ami                     = "ami-0f9d441b5d66d5f31"
  instance_type           = "t2.medium"
  subnet_id               = aws_subnet.media_public_subnet_2025.id
  vpc_security_group_ids  = [aws_security_group.media_app_sg_2025.id]
  key_name                = aws_key_pair.media_deployer_key_2025.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "media-app-server-2025"
  }

  depends_on = [
    aws_route_table_association.media_public_association_2025,
    aws_subnet.media_public_subnet_2025,
    aws_security_group.media_app_sg_2025
  ]
}

# Output Values for Custom Infrastructure
output "audio_ssh_connection_2025" {
  value = aws_instance.media_app_server_2025.public_ip
}

output "media_ssh_connection_2025" {
  value = "ssh -i media-deployer-key-2025.pem ec2-user@${aws_instance.media_app_server_2025.public_ip}"
}

output "media_application_urls_2025" {
  value = {
    frontend   = "http://${aws_instance.media_app_server_2025.public_ip}:5173"
    backend_api = "http://${aws_instance.media_app_server_2025.public_ip}:3000"
    mongodb    = "mongodb://${aws_instance.media_app_server_2025.public_ip}:27017"
  }
}
