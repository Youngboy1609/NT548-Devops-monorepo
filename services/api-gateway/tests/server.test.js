import assert from "node:assert/strict";
import { after, before, describe, it } from "node:test";
import { createServer } from "../src/server.js";

async function startTestServer(options = {}) {
  const server = createServer(options);

  await new Promise((resolve) => {
    server.listen(0, "127.0.0.1", resolve);
  });

  const { port } = server.address();

  return {
    url: `http://127.0.0.1:${port}`,
    close: () => new Promise((resolve) => server.close(resolve))
  };
}

describe("api-gateway", () => {
  let app;

  before(async () => {
    app = await startTestServer({
      environment: "test",
      version: "0.2.0",
      upstreams: {
        auth: "http://auth-service:3000",
        catalog: "http://catalog-service:3000",
        order: "http://order-service:3000"
      }
    });
  });

  after(async () => {
    await app.close();
  });

  it("returns health status", async () => {
    const response = await fetch(`${app.url}/health`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.deepEqual(body, {
      service: "api-gateway",
      status: "ok"
    });
  });

  it("returns readiness status", async () => {
    const response = await fetch(`${app.url}/ready`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.deepEqual(body, {
      service: "api-gateway",
      status: "ready"
    });
  });

  it("returns service metadata", async () => {
    const response = await fetch(`${app.url}/info`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.service, "api-gateway");
    assert.equal(body.role, "Public entry point for NT548 microservices");
    assert.equal(body.environment, "test");
    assert.equal(body.version, "0.2.0");
    assert.match(body.timestamp, /^\d{4}-\d{2}-\d{2}T/);
  });

  it("returns configured upstream services", async () => {
    const response = await fetch(`${app.url}/services`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.deepEqual(body.services, [
      { name: "auth-service", url: "http://auth-service:3000" },
      { name: "catalog-service", url: "http://catalog-service:3000" },
      { name: "order-service", url: "http://order-service:3000" }
    ]);
  });

  it("returns 404 for unknown routes", async () => {
    const response = await fetch(`${app.url}/missing`);
    const body = await response.json();

    assert.equal(response.status, 404);
    assert.deepEqual(body, {
      error: "not_found",
      message: "Route not found"
    });
  });
});
