import http from "node:http";

const SERVICE_NAME = "order-service";
const SERVICE_ROLE = "Order processing capability for NT548 microservices";

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    "content-type": "application/json; charset=utf-8"
  });
  response.end(JSON.stringify(payload));
}

export function createServer(options = {}) {
  const environment = options.environment ?? process.env.NODE_ENV ?? "development";
  const version = options.version ?? process.env.SERVICE_VERSION ?? "0.2.0";

  return http.createServer((request, response) => {
    const url = new URL(request.url, "http://localhost");

    if (request.method === "GET" && url.pathname === "/health") {
      sendJson(response, 200, {
        service: SERVICE_NAME,
        status: "ok"
      });
      return;
    }

    if (request.method === "GET" && url.pathname === "/ready") {
      sendJson(response, 200, {
        service: SERVICE_NAME,
        status: "ready"
      });
      return;
    }

    if (request.method === "GET" && url.pathname === "/info") {
      sendJson(response, 200, {
        service: SERVICE_NAME,
        role: SERVICE_ROLE,
        environment,
        version,
        timestamp: new Date().toISOString()
      });
      return;
    }

    sendJson(response, 404, {
      error: "not_found",
      message: "Route not found"
    });
  });
}
