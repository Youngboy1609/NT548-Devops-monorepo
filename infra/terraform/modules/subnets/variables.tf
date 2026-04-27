variable "name" {
  description = "Name prefix used for subnet resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the subnets."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for both subnets."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
