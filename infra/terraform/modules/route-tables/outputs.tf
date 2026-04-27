output "public_route_table_id" {
  description = "ID of the route table that sends Internet traffic to the Internet Gateway."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the route table that sends outbound Internet traffic to the NAT Gateway."
  value       = aws_route_table.private.id
}

output "public_default_route_gateway_id" {
  description = "Gateway ID used by the public 0.0.0.0/0 route."
  value       = var.internet_gateway_id
}

output "private_default_route_nat_gateway_id" {
  description = "NAT Gateway ID used by the private 0.0.0.0/0 route."
  value       = var.nat_gateway_id
}
