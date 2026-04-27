variable "name" {
  description = "Name prefix used for route table resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that owns the route tables."
  type        = string
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway used by the public route table."
  type        = string
}

variable "nat_gateway_id" {
  description = "ID of the NAT Gateway used by the private route table."
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID associated with the public route table."
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID associated with the private route table."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
