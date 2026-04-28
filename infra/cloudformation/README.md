# CloudFormation

This area contains the CloudFormation implementation for Assignment 01 and the validation scaffolding that Assignment 02 can build on later.

## Assignment 01 scope

- `templates/network.yaml`: VPC, subnets, Internet Gateway, NAT Gateway, default security group output, and route tables
- `templates/security.yaml`: public/private EC2 security groups
- `templates/compute.yaml`: public/private EC2 instances
- `templates/main.yaml`: nested-stack orchestration of the full Assignment 01 stack

## Local workflow

1. Copy `infra/cloudformation/parameters/dev/main.example.json` to `main.local.json`.
2. Replace only the runtime-specific values, especially `KeyName` and `ImageId`.
3. Run `pwsh ./infra/cloudformation/tests/Invoke-CloudFormationChecks.ps1 -S3Bucket <artifact-bucket>`.
4. Package `templates/main.yaml`, then create or update the stack with the local parameter file.
