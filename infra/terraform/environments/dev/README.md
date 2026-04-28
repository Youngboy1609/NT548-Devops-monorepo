# Terraform Environment: dev

This root stack deploys the Assignment 01 compute and security layer on top of an already-created network.

## What this stack expects

- Existing network values from person 1:
  - `vpc_id`
  - `public_subnet_id`
  - `private_subnet_id`
- Optional verification values:
  - `internet_gateway_id`
  - `nat_gateway_id`
  - `public_route_table_id`
  - `private_route_table_id`
  - `default_security_group_id`
- Compute inputs from your local `.env`:
  - `TF_VAR_allowed_ssh_cidr`
  - `TF_VAR_key_name`
  - `TF_VAR_image_id`
  - `TF_VAR_instance_type`

## Local files

- `.env` in the repository root for AWS credentials and scalar `TF_VAR_*` values
- `local.auto.tfvars` in this directory for existing network IDs and optional tag overrides
- `assignment01.auto.tfvars.example` as the committed example of the local file structure

## Commands

```powershell
terraform -chdir=infra/terraform/environments/dev init
terraform -chdir=infra/terraform/environments/dev validate
terraform -chdir=infra/terraform/environments/dev plan
```
