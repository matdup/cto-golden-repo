/**
 * Tenant context propagation contract.
 * The tenantId must be derived from a trusted source:
 * - JWT claim (preferred), validated by auth layer
 * - Header X-Tenant-Id only if validated against identity
 */
export type TenantContext = {
  tenantId: string;
};