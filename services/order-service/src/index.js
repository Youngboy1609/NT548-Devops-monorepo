import { createServer } from "./server.js";

const host = "0.0.0.0";
const port = Number.parseInt(process.env.PORT ?? "3000", 10);
const server = createServer();

server.listen(port, host, () => {
  console.log(`order-service listening on http://${host}:${port}`);
});

function shutdown(signal) {
  console.log(`${signal} received, shutting down order-service`);
  server.close(() => {
    process.exit(0);
  });
}

process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);
