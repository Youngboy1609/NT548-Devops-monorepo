# Service: api-gateway

Public entry point for the Lab 2 microservices demo.

## Endpoints

- `GET /health`
- `GET /ready`
- `GET /info`
- `GET /services`

## Run

```bash
npm test
node src/index.js
docker build -t nt548/api-gateway:lab2-local .
```

## Environment

- `AUTH_SERVICE_URL`
- `CATALOG_SERVICE_URL`
- `ORDER_SERVICE_URL`
