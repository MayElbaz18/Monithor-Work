terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}


# Jenkins Master Instance
resource "aws_instance" "jenkins_master" {
  count         = 0
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "Jenkins-Master"
  }
}

# Jenkins Agent Instances
resource "aws_instance" "jenkins_agents" {
  count         = 0
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "Jenkins-Agent-${count.index + 1}"
  }
}

# Monitoring Application Instances
resource "aws_instance" "monitoring_instances" {
  count         = 0
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "Monitoring-Instance-${count.index + 1}"
  }
}

# Load Balancer for Monitoring Application
# resource "aws_elb" "prod_lb" {
#   name               = "prod-load-balancer"
#   availability_zones = ["us-east-1a", "us-east-1b"]

#   listener {
#     instance_port     = 80
#     instance_protocol = "HTTP"
#     lb_port           = 80
#     lb_protocol       = "HTTP"
#   }

#   health_check {
#     target              = "HTTP:80/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   instances = aws_instance.monitoring_instances[*].id
# }
