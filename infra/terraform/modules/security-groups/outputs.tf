output "public_security_group_id" {
  description = "ID of the security group attached to the public EC2 instance."
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "ID of the security group attached to the private EC2 instance."
  value       = aws_security_group.private.id
}
