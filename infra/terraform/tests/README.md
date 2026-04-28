# Terraform Tests

## Validation script

```powershell
pwsh ./infra/terraform/tests/Invoke-TerraformChecks.ps1
```

The script validates:

- `infra/terraform/examples/network`
- `infra/terraform/environments/dev`
- `terraform plan` for `infra/terraform/environments/dev` when `TF_VAR_key_name` and `TF_VAR_image_id` are set to real values

## Deployment verification script

```powershell
pwsh ./infra/terraform/tests/Verify-Assignment01Deployment.ps1 `
  -VpcId vpc-xxxxxxxx `
  -PublicSubnetId subnet-xxxxxxxx `
  -PrivateSubnetId subnet-xxxxxxxx `
  -PublicSecurityGroupId sg-public `
  -PrivateSecurityGroupId sg-private `
  -PublicInstanceId i-public `
  -PrivateInstanceId i-private `
  -AllowedSshCidr 66.249.66.195/32 `
  -InternetGatewayId igw-xxxxxxxx `
  -NatGatewayId nat-xxxxxxxx `
  -PublicRouteTableId rtb-public `
  -PrivateRouteTableId rtb-private `
  -DefaultSecurityGroupId sg-default
```

## Required manual SSH proof

- SSH from the admin machine to the public EC2 instance
- SSH from the public EC2 instance to the private EC2 instance
- A failed direct SSH attempt from the admin machine to the private EC2 instance

## Evidence to keep

- `terraform plan` output for `infra/terraform/environments/dev`
- script output from `Invoke-TerraformChecks.ps1`
- script output from `Verify-Assignment01Deployment.ps1`
- AWS Console screenshots for both EC2 instances and both security groups
