# Multi-cloud setup

This guide describes how to keep a portable infrastructure posture.

## Principle
- Keep cloud-specific details behind Terraform modules.
- Use environment separation (`dev/staging/prod`).
- Centralize secrets in a secret manager or GitHub Actions secrets.

## Baseline practices
- Tagging and cost allocation for all resources (FinOps)
- IAM least privilege
- Remote Terraform state with locking
- Separate DNS/TLS responsibilities

## Terraform workflow (recommended)
- `plan` on PR
- `apply` only on protected branches/environments
- Block destroy actions by default unless explicitly approved

## Verification
- `terraform validate` passes
- `tflint` passes
- security scan passes (`tfsec` or equivalent)