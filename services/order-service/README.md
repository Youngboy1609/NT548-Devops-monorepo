# Service: order-service

Order processing capability for the Lab 2 microservices demo.

## Endpoints

- `GET /health`
- `GET /ready`
- `GET /info`

## Run

```bash
npm test
node src/index.js
docker build -t nt548/order-service:lab2-local .
```
