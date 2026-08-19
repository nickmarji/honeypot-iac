variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "AWS CLI named profile to authenticate with"
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/20"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-east-2a"
}

variable "ami_id" {
  description = "AMI ID for the honeypot instance (Amazon Linux 2023 recommended)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "admin_ip" {
  description = "Your IP address in CIDR notation, allowed to reach the real admin SSH port (2222)"
  type        = string
}

variable "project_name" {
  description = "Name prefix used to tag all resources"
  type        = string
  default     = "honeypot"
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = "launch-wizard-1"
}
