# CloudFormation Docs

## Conventions

- `main.yaml` is the Assignment 01 entry point and must be packaged before deployment.
- `network.yaml`, `security.yaml`, and `compute.yaml` are the nested building blocks of the stack.
- Parameters stay environment-specific in `infra/cloudformation/parameters/<env>/main.local.json`.
- Outputs are named to mirror the Terraform outputs whenever the underlying resource is the same.

## Validation flow

1. Run `pwsh ./infra/cloudformation/tests/Invoke-CloudFormationChecks.ps1 -S3Bucket <artifact-bucket>`.
2. Package `templates/main.yaml` into `templates/packaged-main.yaml`.
3. Create or update the stack with the local parameter file.
4. Run `pwsh ./infra/cloudformation/tests/Verify-Assignment01Stack.ps1`.
