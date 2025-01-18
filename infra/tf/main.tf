# Configure the required AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure AWS provider with specified region
provider "aws" {
  region = var.aws_region
}

# Fetch the default VPC information
data "aws_vpc" "default" {
  default = true
}

# Fetch all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Jenkins Master Instance
# Primary Jenkins server that manages the CI/CD pipeline
resource "aws_instance" "jenkins_master" {
  count         = 1  # Set to desired number of instances (currently disabled)
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "MoniThor-Jenkins-Master"
    Managed_By  = "Terraform"
  }
}

# Docker Agent Instance
# Agent that runs docker containers
resource "aws_instance" "docker_agent" {
  count         = 1  # Set to desired number of instances (currently disabled)
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "MoniThor-Docker-Agent"
    Managed_By  = "Terraform"
  }
}

# Ansible Agent Instance
# Agent that runs ansible containers
resource "aws_instance" "ansible_agent" {
  count         = 1  # Set to desired number of instances (currently disabled)
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "MoniThor-Ansible-Agent"
    Managed_By  = "Terraform"
  }
}

# Monitoring Application Instances
# Production instances running the MoniThor monitoring application
resource "aws_instance" "monitoring_instances" {
  count         = 2  # Set to desired number of instances (currently disabled)
  ami           = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "MoniThor-Prod-Instance-${count.index + 1}"
    Managed_By  = "Terraform"
  }
}

# Application Load Balancer
# Distributes incoming application traffic across multiple targets
resource "aws_lb" "MoniThor_app_lb" {
  name               = "MoniThor-application-lb"
  internal           = false  # Internet-facing load balancer
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets           = data.aws_subnets.default.ids
    tags = {
    Name = "MoniThor-application-lb"
    Managed_By  = "Terraform"
  }
}

# Target Group
# Group of targets (EC2 instances) that the load balancer routes traffic to
resource "aws_lb_target_group" "MoniThor_app_tg" {
  name     = "MoniThor-app-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  # Health check configuration to monitor target health
  health_check {
    enabled             = true
    healthy_threshold   = 2    # Number of consecutive successful checks required
    interval            = 30   # Time between health checks (seconds)
    timeout             = 5    # Time to wait for a response (seconds)
    path                = "/"  # Health check endpoint
    unhealthy_threshold = 2    # Number of consecutive failed checks required
  }

  # Session stickiness configuration
  stickiness {
    type            = "lb_cookie"  # Load balancer-generated cookie
    cookie_duration = 86400        # Cookie validity period (24 hours)
    enabled         = true
  }
}
# Attach instances to target group
resource "aws_lb_target_group_attachment" "MoniThor_app_tg_attachment" {
  count            = 2  # Match the number of monitoring instances
  target_group_arn = aws_lb_target_group.MoniThor_app_tg.arn
  target_id        = aws_instance.monitoring_instances[count.index].id
  port             = 8080  # Port on which the monitoring application listens for incoming traffic
}

# Listener
# Defines how the load balancer should handle incoming requests
resource "aws_lb_listener" "MoniThor_app_listener" {
  load_balancer_arn = aws_lb.MoniThor_app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"  # Forward requests to target group
    target_group_arn = aws_lb_target_group.MoniThor_app_tg.arn
  }
}
