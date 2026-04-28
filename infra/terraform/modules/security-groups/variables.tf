variable "name" {
  description = "Name prefix used for security group resources."
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID used by the security groups."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Admin CIDR allowed to SSH into the public EC2 instance."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
