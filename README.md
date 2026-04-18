# NT548 DevOps Monorepo Skeleton

Khung monorepo chung cho bai tap thuc hanh 01 va 02 mon NT548.

## Muc tieu

- Bai 1: dat nen tang IaC voi Terraform va CloudFormation cho AWS network va EC2.
- Bai 2: mo rong voi GitHub Actions, AWS CodeBuild, AWS CodePipeline, Jenkins, Docker, Kubernetes va cac cong cu scan/lint.
- Repo nay chi chua skeleton de chia viec, chua chua implementation thuc te.

## Nguyen tac to chuc

- `infra/`: phan IaC va testing/linting lien quan.
- `services/`: microservices dat ten theo nghiep vu.
- `ci/`: script va buildspec cho cac he thong CI/CD.
- `deploy/`: manifest va overlays dung chung cap repo.
- `security/`: config placeholder cho cac cong cu security scan.
- `docs/`: kien truc, conventions, runbooks, mapping bai tap.
- `reports/`: khung bao cao nop bai.

## Khoi tao nhom

1. Doc `docs/assignment-mapping/nt548-assignment-map.md`.
2. Chon ownership theo module/service.
3. Dien TODO trong README cua thu muc minh phu trach.
4. Chi them implementation sau khi thong nhat conventions.

## Cay thu muc chinh

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
