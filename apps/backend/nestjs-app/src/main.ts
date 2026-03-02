/**
 * Backend entrypoint (MVP-safe).
 * This file intentionally avoids pretending NestJS is fully wired if deps are not present.
 *
 * When you add NestJS:
 * - implement bootstrap()
 * - wire controllers, validation pipes, logging, shutdown hooks
 */

import http from "node:http";
import { randomUUID } from "node:crypto";

const port = Number(process.env.PORT ?? 8080);
if (!Number.isFinite(port) || port <= 0) {
  console.error(`Invalid PORT=${process.env.PORT}`);
  process.exit(1);
}

const server = http.createServer((req, res) => {
  const url = req.url ?? "/";
  const method = req.method ?? "GET";
  const reqId = (req.headers["x-request-id"] as string) || randomUUID();

  res.setHeader("x-request-id", reqId);
  res.setHeader("content-type", "application/json; charset=utf-8");
  res.setHeader("x-content-type-options", "nosniff");
  res.setHeader("x-frame-options", "DENY");
  res.setHeader("referrer-policy", "no-referrer");

  if (method === "GET" && url === "/health") {
    res.statusCode = 200;
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  if (method === "GET" && url === "/ready") {
    // Hook for DB/Redis checks later. MVP: always ready.
    res.statusCode = 200;
    res.end(JSON.stringify({ ready: true }));
    return;
  }

  res.statusCode = 404;
  res.end(JSON.stringify({ error: { code: "not_found", request_id: reqId } }));
});

server.listen(port, () => {
  console.log(`🚀 nestjs-app (bootstrap placeholder) listening on :${port}`);
});