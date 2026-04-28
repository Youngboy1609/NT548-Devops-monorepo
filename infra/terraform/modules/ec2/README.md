# Terraform Module: ec2

## Purpose

Provision the public and private EC2 instances required for Assignment 01.

## Inputs

- `name`: name prefix used for both EC2 instances
- `image_id`: AMI ID used by both instances
- `instance_type`: EC2 instance type
- `key_name`: existing EC2 key pair name
- `public_subnet_id`: subnet ID for the public instance
- `private_subnet_id`: subnet ID for the private instance
- `public_security_group_id`: security group ID for the public instance
- `private_security_group_id`: security group ID for the private instance
- `tags`: shared tags for both instances

## Outputs

- `public_instance_id`
- `public_instance_public_ip`
- `public_instance_private_ip`
- `private_instance_id`
- `private_instance_private_ip`
