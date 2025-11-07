# Variables for Terraform configuration

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bastion_key_name" {
  description = "Key pair name for bastion host"
  type        = string
  default     = "bastion-key"
}

variable "asg_key_name" {
  description = "Key pair name for ASG instances"
  type        = string
  default     = "bastion-key"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (leave empty to use latest Amazon Linux)"
  type        = string
  default     = ""
}