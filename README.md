# NT548 DevOps Monorepo

This repository is a shared monorepo for NT548 Practical Assignments 01 and 02.

Assignment 01 now has concrete infrastructure code for Terraform and CloudFormation. Assignment 02 remains mostly scaffolded so the team can keep building on top of the same repository.

## Objectives

- Assignment 01: build the AWS infrastructure foundation with Terraform and CloudFormation for VPC, subnets, route tables, NAT Gateway, security groups, and EC2.
- Assignment 02: extend the same foundation with GitHub Actions, AWS CodeBuild, AWS CodePipeline, Jenkins, Docker, Kubernetes, and security/quality tooling.
- Keep everything in one capability-first monorepo instead of splitting the work into separate repositories.

## Repository Principles

- `infra/`: infrastructure as code, validation scripts, and infrastructure test cases.
- `services/`: business-oriented microservices such as `api-gateway`, `auth-service`, `catalog-service`, and `order-service`.
- `ci/`: shared CI/CD scripts and CodeBuild buildspec files.
- `deploy/`: repository-level Kubernetes base and environment overlays.
- `security/`: placeholders for Checkov, Trivy, Snyk, and related security tooling.
- `docs/`: architecture notes, conventions, runbooks, and assignment mapping.
- `reports/`: placeholders for assignment reports, screenshots, and submission artifacts.

## Assignment 01 Quick Start

1. Copy `.env.example` to `.env` and fill in AWS credentials plus `TF_VAR_allowed_ssh_cidr`.
2. Deploy or update the Terraform network stack in `infra/terraform/examples/network`.
3. Copy the resulting network IDs into `infra/terraform/environments/dev/local.auto.tfvars`.
4. Fill `TF_VAR_key_name` and `TF_VAR_image_id` once the AWS owner provides them.
5. Run the Terraform and CloudFormation checks under `infra/terraform/tests/` and `infra/cloudformation/tests/`.

## Team Onboarding

1. Read `docs/assignment-mapping/nt548-assignment-map.md`.
2. Split ownership by infrastructure domain or service before implementation starts.
3. Keep local secrets in `.env`, `local.auto.tfvars`, and `*.local.json` files only.
4. Update the README or report checklist of the area you own when implementation changes.

## Main Repository Layout

```text
.
|-- .github/
|-- ci/
|-- deploy/
|-- docs/
|-- infra/
|-- reports/
|-- security/
`-- services/
```
