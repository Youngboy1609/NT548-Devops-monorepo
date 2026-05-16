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

describe("catalog-service", () => {
  let app;

  before(async () => {
    app = await startTestServer({
      environment: "test",
      version: "0.2.0"
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
      service: "catalog-service",
      status: "ok"
    });
  });

  it("returns readiness status", async () => {
    const response = await fetch(`${app.url}/ready`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.deepEqual(body, {
      service: "catalog-service",
      status: "ready"
    });
  });

  it("returns service metadata", async () => {
    const response = await fetch(`${app.url}/info`);
    const body = await response.json();

    assert.equal(response.status, 200);
    assert.equal(body.service, "catalog-service");
    assert.equal(body.role, "Product catalog capability for NT548 microservices");
    assert.equal(body.environment, "test");
    assert.equal(body.version, "0.2.0");
    assert.match(body.timestamp, /^\d{4}-\d{2}-\d{2}T/);
  });
});
