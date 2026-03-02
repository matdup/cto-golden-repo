# Documentation (MkDocs)

This folder contains the **official technical documentation** for the Golden Repo.

## What lives here
- **Architecture**: system principles, edge decisions, multi-tenancy, SLOs
- **Contracts**: API documentation derived from `contracts/` (OpenAPI + schemas)
- **Guides**: how-to docs for contributors (setup, release safety, security)
- **Tech runbooks**: operational procedures (deploy, rollback, DR, alerts, migrations)
- **ADRs**: architectural decisions in a stable format

## Local usage
```bash
pip install mkdocs-material mkdocs-git-revision-date-localized-plugin mkdocs-git-authors-plugin
mkdocs serve -f docs/mkdocs.yml
```
--- 

## CI expectations
- mkdocs build --strict must pass
- Links must not be broken (MkDocs validation enabled)
- Use short, stable relative links inside docs/content

---

## Writing standards
- Prefer actionable docs: prerequisites, steps, verification, rollback.
- State assumptions explicitly (env, cloud provider, auth).
- Keep “marketing” out. This is operational documentation.

---

## Source of truth
- API specs are in contracts/. Docs in content/api/ are derived from those specs.
- Governance policies live in /governance.
- Ops coordination runbooks live in /ops-runbooks.