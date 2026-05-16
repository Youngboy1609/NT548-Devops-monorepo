# Assignment 02 Report Area

Commit Markdown templates and text notes only. Do not commit generated PDFs, DOCX files, screenshots, Jenkins exports, or evidence folders.

Use `report-template.md` as the working structure. Generated report files should stay local because `.gitignore` excludes `reports/bai*/**/*.pdf`, `reports/bai*/**/*.docx`, `reports/bai*/**/*.html`, and `reports/bai*/evidence/`.

## Evidence Checklist

- GitHub Actions Terraform workflow with Checkov output.
- GitHub Actions CloudFormation workflow with cfn-lint, taskcat, and Checkov output.
- GitHub Actions Services workflow with tests, Docker build, and Kustomize render.
- CodeCommit repository or mirror screenshot.
- CodeBuild log showing CloudFormation package.
- CodePipeline success screenshot.
- CloudFormation stack outputs.
- Jenkins successful build screenshot.
- SonarQube result if configured.
- Trivy result if configured.
- Docker images and Kubernetes pods/services.
- HTTP responses for `/health`, `/ready`, `/info`, and `api-gateway` `/services`.
