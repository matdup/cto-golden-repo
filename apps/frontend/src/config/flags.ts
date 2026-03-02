const isTrue = (v: string | undefined) => (v ?? "").toLowerCase() === "true";

/**
 * Feature flags: env/config first.
 * Must remain safe for client exposure (NEXT_PUBLIC_ only).
 */
export const flags = {
  demoMode: isTrue(process.env.NEXT_PUBLIC_DEMO_MODE),
};