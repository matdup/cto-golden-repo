# Architecture Principles

These principles define how systems must be designed in this repository.

---

## 1. Modular Monolith First

- Default architecture: modular monolith
- Bounded contexts enforced at folder level
- No microservices without scaling justification

Microservices are introduced only if:
- Clear domain isolation
- Independent scaling need
- Team scaling requirement

---

## 2. Contracts as Source of Truth

- OpenAPI defines API surface
- JSON Schemas define events/errors
- Breaking changes require version bump
- Contracts validated in CI

---

## 3. Explicit Boundaries

- Domain layer framework-agnostic
- Infrastructure depends inward
- No circular dependencies
- Shared folder strictly technical

---

## 4. Observability by Default

Every service must expose:
- `/health`
- `/ready`
- Metrics endpoint
- Structured logs

SLOs must exist for production services.

---

## 5. Security by Design

- No secrets in code
- Principle of least privilege
- JWT validation explicit
- Rate limiting at edge
- Input validation mandatory

---

## 6. Failure is Expected

- Idempotent operations
- Retry with backoff
- No silent failures
- Explicit error handling

---

## 7. Infrastructure as Code

- Terraform required for cloud resources
- No manual infra drift
- Plan required before apply
- Destroy actions gated

---

Architecture must favor:
Clarity > Cleverness  
Determinism > Magic  
Resilience > Optimism