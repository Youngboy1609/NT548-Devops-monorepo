# Service: auth-service

Authentication boundary for the Lab 2 microservices demo.

## Endpoints

- `GET /health`
- `GET /ready`
- `GET /info`

## Run

```bash
npm test
node src/index.js
docker build -t nt548/auth-service:lab2-local .
```
