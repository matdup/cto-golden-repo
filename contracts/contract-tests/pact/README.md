# Contract Tests (Pact)

Consumer-driven contract testing.

Used when:
- Frontend and backend evolve independently
- Multiple services depend on same API

---

## Principles

- Consumer defines expectations
- Provider verifies compliance
- Breaking change detected before deployment

---

## Workflow

1. Consumer generates pact file
2. Pact published to broker (if used)
3. Provider verifies pact
4. CI blocks incompatible change

---

## When Required

- Multiple independent teams
- Public API used externally
- Enterprise integrations

For MVP, optional but recommended.