output "public_security_group_id" {
  description = "ID of the security group attached to the public EC2 instance."
  value       = module.security_groups.public_security_group_id
}

output "private_security_group_id" {
  description = "ID of the security group attached to the private EC2 instance."
  value       = module.security_groups.private_security_group_id
}

output "public_instance_id" {
  description = "ID of the public EC2 instance."
  value       = module.ec2.public_instance_id
}

output "public_instance_public_ip" {
  description = "Public IP address of the public EC2 instance."
  value       = module.ec2.public_instance_public_ip
}

output "public_instance_private_ip" {
  description = "Private IP address of the public EC2 instance."
  value       = module.ec2.public_instance_private_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance."
  value       = module.ec2.private_instance_id
}

output "private_instance_private_ip" {
  description = "Private IP address of the private EC2 instance."
  value       = module.ec2.private_instance_private_ip
}

output "network_context" {
  description = "Network values supplied to this stack for verification and reporting."
  value = {
    vpc_id                    = var.vpc_id
    public_subnet_id          = var.public_subnet_id
    private_subnet_id         = var.private_subnet_id
    internet_gateway_id       = var.internet_gateway_id
    nat_gateway_id            = var.nat_gateway_id
    public_route_table_id     = var.public_route_table_id
    private_route_table_id    = var.private_route_table_id
    default_security_group_id = var.default_security_group_id
  }
}
