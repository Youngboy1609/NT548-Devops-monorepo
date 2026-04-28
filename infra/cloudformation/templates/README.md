# CloudFormation Templates

## Stack layout

- `main.yaml`: packages and orchestrates the full Assignment 01 stack
- `network.yaml`: creates the VPC, subnets, Internet Gateway, NAT Gateway, route tables, and exports the default security group ID
- `security.yaml`: creates the public and private EC2 security groups
- `compute.yaml`: creates the public and private EC2 instances

## Recommended commands

```powershell
aws cloudformation package `
  --template-file infra/cloudformation/templates/main.yaml `
  --s3-bucket <artifact-bucket> `
  --output-template-file infra/cloudformation/templates/packaged-main.yaml

aws cloudformation create-stack `
  --stack-name nt548-dev-assignment01 `
  --template-body file://infra/cloudformation/templates/packaged-main.yaml `
  --parameters file://infra/cloudformation/parameters/dev/main.local.json
```

Use `update-stack` instead of `create-stack` after the first deployment.
