# NT548 DevOps Monorepo

Shared monorepo for NT548 Practical Assignments 01 and 02.

Assignment 01 provides the AWS infrastructure foundation with Terraform and CloudFormation. Assignment 02 adds CI/CD automation, quality gates, Docker, Jenkins, and Kubernetes deployment for four lightweight microservices.

## Repository Scope

- `infra/terraform/`: Terraform modules, environment roots, and validation scripts.
- `infra/cloudformation/`: CloudFormation templates, CodePipeline template, Taskcat config, and parameter examples.
- `.github/workflows/`: GitHub Actions for Terraform, CloudFormation, and services.
- `ci/codebuild/`: CodeBuild buildspecs for Terraform, CloudFormation, and services.
- `services/`: Node.js 20 microservices and per-service Docker/Sonar/Jenkins placeholders.
- `deploy/k8s/`: Kustomize base and `dev` overlay for local `kind`.
- `security/`: Checkov, Trivy, and future security-tool configuration.
- `docs/`: architecture notes, runbooks, conventions, and assignment mapping.
- `reports/`: tracked report templates only. Generated PDFs, DOCX files, screenshots, and evidence exports are ignored by Git.

## Lab 2 Quick Start

```bash
npm ci
npm test --workspaces --if-present
npm run docker:build
kubectl kustomize deploy/k8s/overlays/dev
```

For a local Kubernetes evidence run:

```bash
kind create cluster --name nt548-lab2
npm run docker:build
kind load docker-image nt548/api-gateway:lab2-local --name nt548-lab2
kind load docker-image nt548/auth-service:lab2-local --name nt548-lab2
kind load docker-image nt548/catalog-service:lab2-local --name nt548-lab2
kind load docker-image nt548/order-service:lab2-local --name nt548-lab2
kubectl apply -k deploy/k8s/overlays/dev
kubectl -n nt548-lab2 get pods,svc
kubectl -n nt548-lab2 port-forward svc/api-gateway 3000:3000
```

Then verify:

```bash
curl http://127.0.0.1:3000/health
curl http://127.0.0.1:3000/services
```

## Lab 1 Quick Start

1. Copy `.env.example` to `.env` and fill in AWS credentials plus safe local variables.
2. Deploy or update the Terraform network stack in `infra/terraform/examples/network`.
3. Copy the resulting network IDs into `infra/terraform/environments/dev/local.auto.tfvars`.
4. Fill `TF_VAR_key_name` and `TF_VAR_image_id` once the AWS owner provides them.
5. Run `pwsh infra/terraform/tests/Invoke-TerraformChecks.ps1`.
6. Run `pwsh infra/cloudformation/tests/Invoke-CloudFormationChecks.ps1 -Region ap-southeast-1`.

## CI/CD Entry Points

- GitHub Actions Terraform workflow: `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and Checkov.
- GitHub Actions CloudFormation workflow: `cfn-lint`, `taskcat lint`, and Checkov.
- GitHub Actions Services workflow: Node.js tests, Docker image builds, and Kubernetes manifest rendering.
- CodeBuild CloudFormation buildspec: lints templates and packages `main.yaml` for CodePipeline.
- Root `Jenkinsfile`: tests services, runs SonarQube if configured, builds Docker images, optionally scans with Trivy, and optionally deploys to `kind`.

Full handoff instructions for the deploy/test owner are in `docs/runbooks/lab2-person2-deploy.md`.
