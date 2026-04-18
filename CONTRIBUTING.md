# Contributing Guide

## Working rules

- Tao branch rieng cho tung task.
- Mo pull request som, merge muon.
- Khong commit secrets, state files, artifacts, hay binary.
- Cap nhat README/TODO cua phan minh phu trach truoc khi them implementation.

## Suggested ownership split

- Member 1: Terraform + Checkov + GitHub Actions.
- Member 2: CloudFormation + cfn-lint + taskcat + CodeBuild/CodePipeline.
- Member 3: Microservices + Docker + Jenkins + Kubernetes + SonarQube.

## Commit style

- `docs: ...`
- `chore: ...`
- `feat(terraform): ...`
- `feat(cloudformation): ...`
- `feat(service): ...`
