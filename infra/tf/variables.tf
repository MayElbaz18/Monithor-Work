variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key name for EC2 instances"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EC2 instances"
  type        = string
}