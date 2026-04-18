# Contributing Guide

## Working rules

- Create a separate branch for each task.
- Open pull requests early and merge later.
- Do not commit secrets, state files, build artifacts, or binaries.
- Update the README/TODO file of the area you own before adding implementation.

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
