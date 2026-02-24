export type AuditEvent = {
  at: string;
  actor?: string;
  action: string;
  resource?: string;
  metadata?: Record<string, unknown>;
};
