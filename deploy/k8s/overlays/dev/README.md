# Dev Overlay

Local `kind` target for Lab 2 evidence.

```bash
kind create cluster --name nt548-lab2
npm run docker:build
kind load docker-image nt548/api-gateway:lab2-local --name nt548-lab2
kind load docker-image nt548/auth-service:lab2-local --name nt548-lab2
kind load docker-image nt548/catalog-service:lab2-local --name nt548-lab2
kind load docker-image nt548/order-service:lab2-local --name nt548-lab2
kubectl apply -k deploy/k8s/overlays/dev
kubectl -n nt548-lab2 get pods,svc
```
