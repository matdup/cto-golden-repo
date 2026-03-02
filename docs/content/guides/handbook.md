# CI/CD handbook

This handbook defines how CI/CD is expected to work in the Golden Repo.

## Philosophy
- **Safety > speed** for production changes
- **Deterministic builds**
- **Security gates are real** (not “best effort”)
- **Fast feedback on PRs**, stricter gates on main

## Minimum pipeline stages
1. **Validation**
   - lint / formatting
   - type checks (if applicable)
   - unit sanity checks
2. **Tests**
   - unit + integration (as available)
   - coverage reporting (where feasible)
3. **Security**
   - secret scanning (gitleaks)
   - dependency scan (trivy/snyk where configured)
   - container scan when Dockerfile exists
   - IaC scan for terraform
4. **Artifacts**
   - coverage reports
   - SBOM for images (when built)
   - SARIF uploads for GitHub Security
5. **Deploy (main only)**
   - gated, environment-aware
   - post-deploy health checks
   - rollback hook exists

## Branch rules (recommended)
- `main` protected
- PR required for merge
- Required checks:
  - CI workflows relevant to the changed paths
  - security suite
- Optional: code owners approval for sensitive areas

## Security gates (recommended defaults)
- Block merge when:
  - secrets detected
  - critical vulnerabilities in container/FS scans
- Allow policy-based exceptions only with documented justification.

## Coverage
Coverage targets depend on the project maturity.
- MVP: aim for meaningful tests on core flows; do not block on coverage if it blocks shipping
- Growth: introduce minimum threshold (e.g. 70–80%)
- Scale/compliance: enforce thresholds with exceptions process

## Deploy safety
The deployment mechanism varies (compose, k8s, managed services),
but the rules do not:
- health checks are mandatory
- rollback is mandatory
- log request IDs end-to-end
- observability is validated (metrics/logs reachable)

## What to do when CI fails
1. Fix the issue or revert the change
2. If failure is flaky:
   - capture evidence (logs, rerun links)
   - create an issue to fix flakiness
3. If security gate blocks:
   - patch/update dependency
   - if you must ship: documented exception with owner approval (time-boxed)

## Incident linkage
When a release causes incident:
- follow `ops-runbooks/incident-response.md`
- open a postmortem ticket
- add prevention item to roadmap

## Appendix: snippets
### Go (tests + race)
```yaml
- run: go test -v -race -coverprofile=coverage.out -covermode=atomic ./...
```

### Node (lint + build)
```yaml
- run: npm ci --audit --fund=false
- run: npm run lint --if-present
- run: npm run build
```

### Terraform (fmt/validate)
```yaml
- run: terraform fmt -check -recursive
- run: terraform validate
```