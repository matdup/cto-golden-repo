/**
 * Health controller placeholder (Nest-ready).
 * When NestJS is wired, expose:
 * - GET /health
 * - GET /ready
 */
export function health() {
  return { status: "ok" };
}

export function ready() {
  return { ready: true };
}