# ECR Repository - This is where we store our Docker images
# Think of it like a private Docker Hub for AWS

resource "aws_ecr_repository" "beer_app" {
  name = "${var.project_name}-app"

  # This makes sure images are encrypted for security
  encryption_configuration {
    encryption_type = "AES256"
  }

  # This adds a tag to help us identify it
  tags = {
    Name = "Beer Catalog App Repository"
  }
}

# VPC - Virtual Private Cloud (our private network)
# Think of it like a private neighborhood for our app

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # Our network range
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway - The main gate to the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnet - Where our app can access the internet
# Think of it like houses near the main road

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"        # Smaller range within our VPC
  availability_zone = "${var.aws_region}a" # Which AWS data center

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Private Subnet - Where our database lives (more secure)
# Think of it like houses in the back of the neighborhood

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"        # Different range
  availability_zone = "${var.aws_region}b" # Different data center for redundancy

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

# Route Table for Public Subnet - The map that lets public subnet use the main gate
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0" # All traffic
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# App Security Group - Allows HTTP (5000) from anywhere
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow HTTP access to app"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# DB Security Group - Allows PostgreSQL (5432) only from app security group
resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Allow DB access from app only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow PostgreSQL from app SG"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

# RDS PostgreSQL Database - This is where our app data will be stored
# Think of it like a cloud database server

resource "aws_db_instance" "beer_database" {
  # Basic settings
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro" # Smallest/cheapest option

  # Database settings
  db_name  = "beer_catalog"
  username = "beer_admin"
  password = var.db_password

  # Storage
  allocated_storage = 20 # 20GB
  storage_type      = "gp2"

  # Security
  skip_final_snapshot    = true                       # For demo purposes
  vpc_security_group_ids = [aws_security_group.db.id] # defines firewall rules for AWS RDS

  # Tags
  tags = {
    Name = "Beer Catalog Database"
  }
}
