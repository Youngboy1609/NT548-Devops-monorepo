# Terraform Docs

## Module graph

- `examples/network`: creates the Assignment 01 network foundation
- `modules/vpc`, `modules/subnets`, `modules/nat-gateway`, `modules/route-tables`: reusable network modules
- `modules/security-groups`, `modules/ec2`: reusable compute and security modules
- `environments/dev`: composes the security groups and EC2 instances on top of an existing network

## Naming and output conventions

- `project` and `environment` are the shared naming inputs across roots.
- `name_prefix` overrides the default `${project}-${environment}` resource prefix when needed.
- Tags always include `Project`, `Environment`, and `ManagedBy`.
- Outputs mirror the CloudFormation names where possible so reporting and verification stay consistent.
