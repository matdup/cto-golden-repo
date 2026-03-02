export type AuditEvent = {
  at: string; // RFC3339 timestamp
  actor?: string; // user id / service principal
  tenantId?: string;
  action: string; // stable action name
  resource?: string; // resource identifier
  outcome?: "success" | "failure";
  requestId?: string;
  metadata?: Record<string, unknown>;
};