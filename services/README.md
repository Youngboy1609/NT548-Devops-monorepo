# Services

Lab 2 uses four Node.js 20 microservices with no database dependency:

- `api-gateway`
- `auth-service`
- `catalog-service`
- `order-service`

## Standard Endpoints

Each service exposes:

- `GET /health`: liveness status.
- `GET /ready`: readiness status.
- `GET /info`: service metadata, version, environment, and timestamp.

`api-gateway` also exposes:

- `GET /services`: configured upstream service URLs from environment variables.

## Local Commands

```bash
npm ci
npm test --workspaces --if-present
npm run docker:build
```

Run one service locally:

```bash
cd services/api-gateway
PORT=3000 node src/index.js
```

On PowerShell:

```powershell
$env:PORT="3000"; node src/index.js
```

## Runtime Variables

- `PORT`: defaults to `3000`.
- `SERVICE_VERSION`: defaults to `0.2.0`.
- `NODE_ENV`: defaults to `development`.
- `AUTH_SERVICE_URL`, `CATALOG_SERVICE_URL`, `ORDER_SERVICE_URL`: used by `api-gateway`.
