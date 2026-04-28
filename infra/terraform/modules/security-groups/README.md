# Terraform Module: security-groups

## Purpose

Separate security groups for the public EC2 instance and the private EC2 instance.

## Inputs

- `name`: name prefix used for both security groups
- `vpc_id`: existing VPC ID from the network layer
- `allowed_ssh_cidr`: admin CIDR allowed to SSH into the public EC2 instance
- `tags`: shared tags for both security groups

## Outputs

- `public_security_group_id`
- `private_security_group_id`
