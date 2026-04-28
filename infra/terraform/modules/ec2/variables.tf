variable "name" {
  description = "Name prefix used for EC2 resources."
  type        = string
}

variable "image_id" {
  description = "AMI ID used by both EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "Instance type used by both EC2 instances."
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair used to access the instances."
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID for the public EC2 instance."
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet ID for the private EC2 instance."
  type        = string
}

variable "public_security_group_id" {
  description = "Security group ID attached to the public EC2 instance."
  type        = string
}

variable "private_security_group_id" {
  description = "Security group ID attached to the private EC2 instance."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
