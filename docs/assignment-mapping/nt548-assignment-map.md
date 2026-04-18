# NT548 Assignment Mapping

## Bai tap 01

- `infra/terraform/`: modules va environments cho VPC, subnet, route tables, NAT Gateway, security groups, EC2.
- `infra/cloudformation/`: templates va parameters cho cung tap tai nguyen.
- `reports/bai1/`: bao cao, hinh anh minh hoa, ghi chu ket qua.

## Bai tap 02

- `.github/workflows/`: GitHub Actions placeholders cho Terraform, CloudFormation, services.
- `ci/codebuild/`: buildspec placeholders cho CodeBuild.
- `services/`: seed microservices va skeleton CI/CD cho Jenkins/Docker/Sonar.
- `deploy/k8s/` va `services/*/deploy/k8s/`: layout cho Kubernetes manifests.
- `security/`: config placeholders cho Checkov, Trivy, Snyk.
- `reports/bai2/`: bao cao, hinh anh minh hoa, ghi chu ket qua.

## Suggested member split

- Thanh vien 1: Terraform + GitHub Actions + Checkov
- Thanh vien 2: CloudFormation + CodeBuild + CodePipeline + taskcat/cfn-lint
- Thanh vien 3: Microservices + Jenkins + Docker + Kubernetes + SonarQube
