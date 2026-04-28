# CloudFormation Tests

## Validation script

```powershell
pwsh ./infra/cloudformation/tests/Invoke-CloudFormationChecks.ps1 -S3Bucket <artifact-bucket>
```

The script:

- validates `network.yaml`, `security.yaml`, and `compute.yaml`
- runs `cfn-lint` when the tool is installed locally
- packages `main.yaml` into `packaged-main.yaml` when `-S3Bucket` is provided
- validates the packaged main template after packaging

## Deployment verification script

```powershell
pwsh ./infra/cloudformation/tests/Verify-Assignment01Stack.ps1 `
  -StackName nt548-dev-assignment01 `
  -AllowedSshCidr 66.249.66.195/32
```

## Required manual SSH proof

- SSH from the admin machine to the public EC2 instance
- SSH from the public EC2 instance to the private EC2 instance
- A failed direct SSH attempt from the admin machine to the private EC2 instance
