# Assignment 01 Report

## Evidence checklist

- Network outputs from Terraform or CloudFormation:
  - `vpc_id` or `VpcId`
  - `public_subnet_id` or `PublicSubnetId`
  - `private_subnet_id` or `PrivateSubnetId`
  - `internet_gateway_id` or `InternetGatewayId`
  - `nat_gateway_id` or `NatGatewayId`
  - route table IDs and the default security group ID
- Terraform evidence:
  - `terraform plan` for `infra/terraform/environments/dev`
  - output from `Invoke-TerraformChecks.ps1`
  - output from `Verify-Assignment01Deployment.ps1`
- CloudFormation evidence:
  - output from `Invoke-CloudFormationChecks.ps1`
  - output from `Verify-Assignment01Stack.ps1`
  - the packaged template workflow used for `main.yaml`
- AWS Console screenshots:
  - public EC2 instance
  - private EC2 instance
  - public EC2 security group
  - private EC2 security group
- Connectivity proof:
  - SSH from the admin machine to the public EC2 instance
  - SSH hop from the public EC2 instance to the private EC2 instance
  - failed direct SSH attempt from the admin machine to the private EC2 instance

## Submission files

- Final Word or PDF report
- supporting screenshots
- final README instructions in the repository
