import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: __ENV.VUS ? parseInt(__ENV.VUS, 10) : 5,
  duration: __ENV.DURATION || "30s",
};

const BASE_URL = __ENV.BASE_URL;

export default function () {
  if (!BASE_URL) throw new Error("BASE_URL is required");

  const res = http.get(`${BASE_URL}/health`);
  check(res, {
    "status is 200": (r) => r.status === 200,
  });

  sleep(1);
}