# Terraform Example: network

This example creates the Assignment 01 network foundation:

- 1 VPC
- 1 public subnet
- 1 private subnet
- 1 Internet Gateway
- 1 NAT Gateway
- 1 public route table
- 1 private route table

## What to verify

- The public route table sends `0.0.0.0/0` traffic to the Internet Gateway.
- The private route table sends `0.0.0.0/0` traffic to the NAT Gateway.
- The public subnet auto-assigns public IP addresses and the private subnet does not.

## Commands

```powershell
terraform init
terraform validate
terraform plan
```
