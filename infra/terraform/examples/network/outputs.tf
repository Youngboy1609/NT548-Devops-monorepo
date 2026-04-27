output "vpc_id" {
  description = "Created VPC ID."
  value       = module.vpc.vpc_id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID."
  value       = module.vpc.internet_gateway_id
}

output "default_security_group_id" {
  description = "Default security group ID."
  value       = module.vpc.default_security_group_id
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = module.subnets.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID."
  value       = module.subnets.private_subnet_id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  description = "Private route table ID."
  value       = module.route_tables.private_route_table_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = module.nat_gateway.nat_gateway_id
}

output "network_route_tests" {
  description = "Values used to confirm public Internet egress via IGW and private Internet egress via NAT."
  value = {
    public_default_route_gateway_id      = module.route_tables.public_default_route_gateway_id
    private_default_route_nat_gateway_id = module.route_tables.private_default_route_nat_gateway_id
  }
}
