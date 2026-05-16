# Lab 2 Person 2 Deploy And Test Runbook

Person 1 owns code, pipeline definitions, and report skeleton. Person 2 owns real credentials, deploy execution, test evidence, and screenshots.

## Required Tools

- Node.js 20 and npm.
- Docker.
- kind and kubectl.
- AWS CLI configured for `ap-southeast-1`.
- Terraform.
- cfn-lint, taskcat, Checkov.
- Jenkins with Docker access.
- Optional but recommended: SonarQube and Trivy.

## GitHub Actions Evidence

Create a PR or push to the lab branch and capture:

- Terraform workflow showing `fmt`, `init`, `validate`, and Checkov.
- CloudFormation workflow showing `cfn-lint`, `taskcat lint`, and Checkov.
- Services workflow showing Node.js tests, Docker build, and Kustomize render.

## Terraform Manual Deploy

GitHub Actions intentionally does not run `terraform apply`.

```bash
terraform -chdir=infra/terraform/examples/network init
terraform -chdir=infra/terraform/examples/network plan
terraform -chdir=infra/terraform/examples/network apply
terraform -chdir=infra/terraform/environments/dev init
terraform -chdir=infra/terraform/environments/dev plan
terraform -chdir=infra/terraform/environments/dev apply
```

Capture outputs, VPC/subnet/route table/NAT screenshots, security group screenshots, EC2 screenshots, and SSH hop proof.

## CodeCommit And CodePipeline

Mirror this repository to CodeCommit:

```bash
git remote add codecommit https://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/<repo-name>
git push codecommit <branch-name>:main
```

Create or reuse an S3 artifact bucket, then deploy the pipeline template:

```bash
aws cloudformation deploy \
  --region ap-southeast-1 \
  --template-file infra/cloudformation/templates/codepipeline.yaml \
  --stack-name nt548-lab2-pipeline \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    CodeCommitRepoName=<repo-name> \
    BranchName=main \
    ArtifactBucketName=<artifact-bucket-name> \
    AllowedSshCidr=<your-public-ip>/32 \
    KeyName=<ec2-keypair-name> \
    ImageId=<ami-id> \
    InstanceType=t2.micro \
    EnvironmentName=dev
```

Capture CodeCommit source, CodeBuild logs, CodePipeline success, and CloudFormation stack outputs.

## Jenkins, Docker, Kubernetes, SonarQube

Local smoke test:

```bash
npm ci
npm test --workspaces --if-present
npm run docker:build
kind create cluster --name nt548-lab2
kind load docker-image nt548/api-gateway:lab2-local --name nt548-lab2
kind load docker-image nt548/auth-service:lab2-local --name nt548-lab2
kind load docker-image nt548/catalog-service:lab2-local --name nt548-lab2
kind load docker-image nt548/order-service:lab2-local --name nt548-lab2
kubectl apply -k deploy/k8s/overlays/dev
kubectl -n nt548-lab2 get pods,svc
kubectl -n nt548-lab2 rollout status deployment/api-gateway
kubectl -n nt548-lab2 port-forward svc/api-gateway 3000:3000
```

HTTP checks:

```bash
curl http://127.0.0.1:3000/health
curl http://127.0.0.1:3000/services
```

For Jenkins evidence, configure the root `Jenkinsfile` and set these build parameters:

- `DOCKER_REGISTRY=nt548`
- `IMAGE_TAG=lab2-local`
- `DEPLOY_TO_KIND=true` when the Jenkins agent can access Docker, kind, and kubectl.
- `SONAR_HOST_URL` and `SONAR_TOKEN` as secret environment variables if SonarQube is available.
- `TRIVY_EXIT_CODE=1` only when the team wants Jenkins to fail on high or critical image findings.

Capture Jenkins stages, SonarQube project page if used, Trivy output if used, Kubernetes pods/services, and HTTP responses.
