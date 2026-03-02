# 🔐 JWT Validation Strategy

## Edge vs Application-Level Validation

### Option 1 — Validate at Edge (Traefik)

Use forwardAuth or OIDC middleware.

Pros:
- Blocks invalid traffic early
- Reduces backend load

Cons:
- Limited fine-grained authorization
- Harder claim-based logic

### Option 2 — Validate in Application (Recommended)

JWT verification inside backend service.

Pros:
- Full RBAC control
- Per-tenant logic
- Fine-grained authorization

Decision:
JWT signature validation MAY happen at edge.
Authorization MUST happen at application layer.