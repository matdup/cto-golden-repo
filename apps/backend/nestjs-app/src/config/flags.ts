/**
 * Feature flags (env/config first).
 * MVP: keep minimal. Growth: add typed config + remote flags if needed.
 */
export const flags = {
  exampleFlag: process.env.EXAMPLE_FLAG === "true",
};