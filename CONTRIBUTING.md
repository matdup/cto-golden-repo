# Contributing Guidelines

## Principles

- Security-first
- Tests before merge
- Infrastructure as Code
- No breaking changes without ADR

---

## Pull Request Requirements

- Conventional Commits
- Linked issue
- Passing CI
- Security scan green
- Contract tests green
- Documentation updated if needed

---

## Forbidden

- Secrets in Git
- Direct push to main
- Bypassing CI
- Undocumented infra changes

---

## Branch Strategy

main → production-ready  
staging → pre-prod validation  
feature/* → development  

---

## ADR Required When

- Changing architecture
- Changing cloud provider abstraction
- Changing auth strategy
- Breaking API contracts