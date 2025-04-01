# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Custom VPC Configuration (kv3)
resource "aws_vpc" "kv3_audio_vpc_2025" {
  cidr_block           = "10.5.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "kv3-audio-vpc-2025"
  }
}

# Custom Public Subnet (kv3)
resource "aws_subnet" "kv3_audio_public_subnet_2025" {
  vpc_id                  = aws_vpc.kv3_audio_vpc_2025.id
  cidr_block              = "10.5.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "kv3-audio-public-subnet-2025"
  }
}

# Custom Internet Gateway (kv3)
resource "aws_internet_gateway" "kv3_audio_igw_2025" {
  vpc_id = aws_vpc.kv3_audio_vpc_2025.id
  tags = {
    Name = "kv3-audio-igw-2025"
  }
}

# Custom Route Table (kv3)
resource "aws_route_table" "kv3_audio_public_rt_2025" {
  vpc_id = aws_vpc.kv3_audio_vpc_2025.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kv3_audio_igw_2025.id
  }
  tags = {
    Name = "kv3-audio-public-rt-2025"
  }
}

# Custom Route Table Association (kv3)
resource "aws_route_table_association" "kv3_audio_public_association_2025" {
  subnet_id      = aws_subnet.kv3_audio_public_subnet_2025.id
  route_table_id = aws_route_table.kv3_audio_public_rt_2025.id
}

# Custom Security Group (kv3)
resource "aws_security_group" "kv3_audio_app_sg_2025" {
  name        = "kv3-audio-security-group-2025"
  description = "Security group for audio application"
  vpc_id      = aws_vpc.kv3_audio_vpc_2025.id

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
    Name = "kv3-audio-sg-2025"
  }
}

# Custom SSH Key Pair (kv3)
resource "aws_key_pair" "kv3_audio_deployer_key_2025" {
  key_name   = "kv3-audio-deployer-key-2025"
  public_key = file("${path.module}/deployer-key.pub")
}

# Custom EC2 Instance (kv3)
resource "aws_instance" "kv3_audio_app_server_2025" {
  ami                    = "ami-0f9d441b5d66d5f31"
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.kv3_audio_public_subnet_2025.id
  vpc_security_group_ids = [aws_security_group.kv3_audio_app_sg_2025.id]
  key_name               = aws_key_pair.kv3_audio_deployer_key_2025.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
  
  # Basic user data to install Docker and Docker Compose
  user_data = <<-EOF
    #!/bin/bash
    # Update system packages
    yum update -y
    
    # Install Docker
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    
    # Install Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Create docker-compose-init.sh script that will be run after boot
    cat > /root/docker-compose-init.sh << 'EOFSCRIPT'
    #!/bin/bash
    
    # Get the instance public IP
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    
    # Create docker-compose.yml with the current IP address
    mkdir -p /app
    cat > /app/docker-compose.yml << EOFFILE
    version: '3'
    services:
      frontend:
        image: chamod62/kv-audio-production-frontend:latest
        ports:
          - "80:5173"
        restart: always
        depends_on:
          - api
        environment:
          - VITE_API_URL=http://$PUBLIC_IP:3000
      
      api:
        image: chamod62/kv-audio-production-api:latest
        ports:
          - "3000:3000"
        restart: always
        depends_on:
          - mongo
        environment:
          - MONGODB_URI=mongodb://mongo:27017/kv-audio-db
      
      mongo:
        image: chamod62/kv-audio-production-mongo:latest
        ports:
          - "27017:27017"
        restart: always
        volumes:
          - mongodb_data:/data/db
    
    volumes:
      mongodb_data:
    EOFFILE
    
    # Run docker-compose
    cd /app
    docker-compose pull
    docker-compose up -d
    EOFSCRIPT
    
    # Make the script executable
    chmod +x /root/docker-compose-init.sh
    
    # Run the script
    /root/docker-compose-init.sh
    
    # Make the script run on system reboot
    echo "@reboot root /root/docker-compose-init.sh" > /etc/cron.d/docker-compose-startup
  EOF

  tags = {
    Name = "kv3-audio-app-server-2025"
  }

  depends_on = [
    aws_route_table_association.kv3_audio_public_association_2025,
    aws_subnet.kv3_audio_public_subnet_2025,
    aws_security_group.kv3_audio_app_sg_2025
  ]
}

# Output Values for Custom Infrastructure (kv3)
output "kv3_audio_instance_public_ip_2025" {
  value = aws_instance.kv3_audio_app_server_2025.public_ip
}

output "kv3_audio_ssh_connection_2025" {
  value = "ssh -i deployer-key ec2-user@${aws_instance.kv3_audio_app_server_2025.public_ip}"
}

output "kv3_audio_application_urls_2025" {
  value = {
    frontend    = "http://${aws_instance.kv3_audio_app_server_2025.public_ip}"
    backend_api = "http://${aws_instance.kv3_audio_app_server_2025.public_ip}:3000"
    mongodb     = "mongodb://${aws_instance.kv3_audio_app_server_2025.public_ip}:27017"
  }
}