# NT548 Assignment Mapping

## Assignment 01

- `infra/terraform/modules/`: VPC, subnets, route tables, NAT Gateway, security groups, and EC2 modules.
- `infra/terraform/examples/network/`: network root used by the first infrastructure owner.
- `infra/terraform/environments/dev/`: compute/security root that consumes existing network IDs.
- `infra/cloudformation/templates/`: equivalent CloudFormation templates for network, security, compute, and nested orchestration.
- `infra/*/tests/`: local validation scripts.
- `reports/bai1/`: report checklist and local-only generated evidence.

## Assignment 02

- `.github/workflows/terraform.yml`: Terraform fmt/init/validate plus Checkov. It never runs `terraform apply`.
- `.github/workflows/cloudformation.yml`: cfn-lint, taskcat lint, and CloudFormation Checkov.
- `.github/workflows/services.yml`: Node.js tests, Docker builds, and Kustomize render.
- `ci/codebuild/terraform-buildspec.yml`: Terraform checks in CodeBuild.
- `ci/codebuild/cloudformation-buildspec.yml`: cfn-lint, taskcat, Checkov, and `aws cloudformation package`.
- `ci/codebuild/services-buildspec.yml`: Node.js tests, Docker builds, and Trivy image scans.
- `infra/cloudformation/templates/codepipeline.yaml`: CodeCommit to CodeBuild to CloudFormation pipeline.
- `Jenkinsfile`: microservice CI/CD pipeline for tests, SonarQube, Docker, optional Trivy, and optional `kind` deploy.
- `services/{api-gateway,auth-service,catalog-service,order-service}/`: Lab 2 microservices.
- `deploy/k8s/`: Kubernetes base and dev overlay for `kind`.
- `reports/bai2/`: report skeleton and evidence checklist.

## Suggested 2-Member Split For Assignment 02

- Person 1: owns code, repository configuration, GitHub Actions, CodeBuild buildspecs, CodePipeline template, Jenkinsfile, Dockerfiles, K8s manifests, service source code, Sonar/Trivy config, and report skeleton.
- Person 2: owns AWS credentials, CodeCommit mirror, real Terraform/CloudFormation deploys, CodeBuild/CodePipeline execution, Jenkins/Sonar runtime setup, kind deploy, validation commands, screenshots, and final report evidence.
