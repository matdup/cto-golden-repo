import type { AuditEvent } from "./audit.event";

/**
 * MVP audit logger.
 * Production evolution:
 * - structured logger (pino/winston)
 * - route to Loki / DB / object storage based on governance retention rules
 */
export class AuditService {
  emit(event: AuditEvent) {
    const safeEvent: AuditEvent = {
      ...event,
      // Ensure timestamp exists
      at: event.at || new Date().toISOString(),
    };
    // Never log secrets/PII in metadata.
    console.log(JSON.stringify({ type: "audit", ...safeEvent }));
  }
}