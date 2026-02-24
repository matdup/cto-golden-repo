/**
 * Feature flags (env/config first).
 * Keep it simple in MVP, grow later.
 */
export const flags = {
  exampleFlag: process.env.EXAMPLE_FLAG === "true",
};
