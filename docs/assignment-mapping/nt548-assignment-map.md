# NT548 Assignment Mapping

## Assignment 01

- `infra/terraform/`: modules and environments for VPC, subnets, route tables, NAT Gateway, security groups, and EC2.
- `infra/cloudformation/`: templates and parameter files for the same infrastructure scope.
- `reports/bai1/`: report files, supporting screenshots, and result notes.

## Assignment 02

- `.github/workflows/`: GitHub Actions placeholders for Terraform, CloudFormation, and services.
- `ci/codebuild/`: buildspec placeholders for AWS CodeBuild.
- `services/`: seeded microservices and CI/CD skeletons for Jenkins, Docker, and SonarQube.
- `deploy/k8s/` and `services/*/deploy/k8s/`: layout for Kubernetes manifests.
- `security/`: config placeholders for Checkov, Trivy, and Snyk.
- `reports/bai2/`: report files, supporting screenshots, and result notes.

## Suggested member split

- Member 1: Terraform + GitHub Actions + Checkov
- Member 2: CloudFormation + CodeBuild + CodePipeline + taskcat/cfn-lint
- Member 3: Microservices + Jenkins + Docker + Kubernetes + SonarQube
