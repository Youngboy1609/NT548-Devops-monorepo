variable "name" {
  description = "Name prefix used for NAT Gateway resources."
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where the NAT Gateway will be created."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
