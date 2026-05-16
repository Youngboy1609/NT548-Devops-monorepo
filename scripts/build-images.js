import { spawnSync } from "node:child_process";

const services = [
  "api-gateway",
  "auth-service",
  "catalog-service",
  "order-service"
];

const imagePrefix = process.env.DOCKER_REGISTRY || "nt548";
const imageTag = process.env.IMAGE_TAG || "lab2-local";

for (const service of services) {
  const image = `${imagePrefix}/${service}:${imageTag}`;
  const result = spawnSync(
    "docker",
    ["build", "--pull", "-t", image, `services/${service}`],
    {
      stdio: "inherit",
      shell: process.platform === "win32"
    }
  );

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}
