# NT548 DevOps Monorepo Skeleton

This repository is a shared monorepo skeleton for NT548 Practical Assignments 01 and 02.

It is intentionally scaffold-only. The goal is to give the team a clean starting point for collaboration, ownership split, and implementation planning before adding real infrastructure code, service code, or deployment logic.

## Objectives

- Assignment 01: build the AWS infrastructure foundation with Terraform and CloudFormation for VPC, subnets, route tables, NAT Gateway, security groups, and EC2.
- Assignment 02: extend the same foundation with GitHub Actions, AWS CodeBuild, AWS CodePipeline, Jenkins, Docker, Kubernetes, and security/quality tooling.
- Keep everything in one capability-first monorepo instead of splitting the work into separate repositories.

## Repository Principles

- `infra/`: infrastructure as code, validation, and infrastructure-related test scaffolding.
- `services/`: business-oriented microservices such as `api-gateway`, `auth-service`, `catalog-service`, and `order-service`.
- `ci/`: shared CI/CD scripts and CodeBuild buildspec files.
- `deploy/`: repository-level Kubernetes base and environment overlays.
- `security/`: placeholders for Checkov, Trivy, Snyk, and related security tooling.
- `docs/`: architecture notes, conventions, runbooks, and assignment mapping.
- `reports/`: placeholders for assignment reports, screenshots, and submission artifacts.

## Team Onboarding

1. Read `docs/assignment-mapping/nt548-assignment-map.md`.
2. Split ownership by module or service before implementation starts.
3. Fill in the TODO sections inside the README files of the area you own.
4. Add real implementation only after the team agrees on conventions, boundaries, and responsibilities.

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
