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
# ECS Task Execution Role - Allows ECS tasks to pull images from ECR and write logs
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Cluster - The kitchen for your containers
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# ECS Task Definition - The recipe for running your app container
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "beer-app"
      image     = var.app_image
      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DATABASE_URL"
          value = "postgresql://beer_admin:${var.db_password}@${var.db_host}:5432/beer_catalog"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      essential = true
    }
  ])
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

# DB Subnet Group - Tells RDS which subnets to use
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# RDS PostgreSQL Database - This is where our app data will be stored
# Think of it like a cloud database server

resource "aws_db_instance" "beer_database" {
  # Basic settings
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = "17.4"
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
  db_subnet_group_name   = aws_db_subnet_group.main.name # specifies which VPC/subnets to use

  # Tags
  tags = {
    Name = "Beer Catalog Database"
  }
}

# ECS Service - The manager that keeps your app running
resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id] # Run in the public subnet
    security_groups  = [aws_security_group.app.id] # Attach the app security group
    assign_public_ip = true # Needed for internet access
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution]

  tags = {
    Name = "${var.project_name}-service"
  }
}

resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/beer-catalog-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "ecs_task_failures" {
  alarm_name          = "ECS-Task-Failures"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ServiceTaskFailures"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm if any ECS task fails in the beer-catalog-service"
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app.name
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
  alarm_name          = "RDS-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm if RDS CPU utilization exceeds 80%"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.beer_database.id
  }
}
