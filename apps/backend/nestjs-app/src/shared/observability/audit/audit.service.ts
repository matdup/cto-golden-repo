import type { AuditEvent } from "./audit.event";

export class AuditService {
  emit(event: AuditEvent) {
    // Placeholder: wire to logs / Loki / DB later
    console.log("[AUDIT]", event);
  }
}
