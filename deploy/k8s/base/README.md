# Kubernetes Base

Reusable manifests for the Lab 2 microservices:

- `api-gateway`
- `auth-service`
- `catalog-service`
- `order-service`

The base creates namespace `nt548-lab2`, one shared ConfigMap, one Deployment, and one ClusterIP Service per microservice. Use overlays for environment-specific image tags or settings.
