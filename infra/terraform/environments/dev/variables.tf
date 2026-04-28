variable "aws_region" {
  description = "AWS region for the compute stack."
  type        = string
  default     = "ap-southeast-1"
}

variable "project" {
  description = "Project name used in resource tags."
  type        = string
  default     = "nt548"
}

variable "environment" {
  description = "Environment name used in resource tags."
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Optional explicit name prefix used for resources."
  type        = string
  default     = null
}

variable "allowed_ssh_cidr" {
  description = "Admin CIDR allowed to SSH into the public EC2 instance."
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "allowed_ssh_cidr must be a valid CIDR block."
  }
}

variable "key_name" {
  description = "Existing EC2 key pair name."
  type        = string

  validation {
    condition     = trimspace(var.key_name) != "" && var.key_name != "REPLACE_ME" && var.key_name != "replace_me"
    error_message = "key_name must be set to a real EC2 key pair name."
  }
}

variable "image_id" {
  description = "AMI ID used by both EC2 instances."
  type        = string

  validation {
    condition     = startswith(var.image_id, "ami-")
    error_message = "image_id must start with 'ami-'."
  }
}

variable "instance_type" {
  description = "EC2 instance type used by both instances."
  type        = string
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "Existing VPC ID from the network layer."
  type        = string
}

variable "public_subnet_id" {
  description = "Existing public subnet ID from the network layer."
  type        = string
}

variable "private_subnet_id" {
  description = "Existing private subnet ID from the network layer."
  type        = string
}

variable "internet_gateway_id" {
  description = "Optional Internet Gateway ID kept for verification context."
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "Optional NAT Gateway ID kept for verification context."
  type        = string
  default     = null
}

variable "public_route_table_id" {
  description = "Optional public route table ID kept for verification context."
  type        = string
  default     = null
}

variable "private_route_table_id" {
  description = "Optional private route table ID kept for verification context."
  type        = string
  default     = null
}

variable "default_security_group_id" {
  description = "Optional default VPC security group ID kept for verification context."
  type        = string
  default     = null
}

variable "tags" {
  description = "Extra tags merged into all Terraform-managed resources."
  type        = map(string)
  default     = {}
}
