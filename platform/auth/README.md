# Auth

Auth integration blueprints and references.

Default stance:
- Managed auth first (Clerk, Auth0, etc.)
- Self-hosted only when compliance requires it (Keycloak, etc.)

Folders:
- clerk-setup/: managed auth setup notes + env vars
- oauth-examples/: OAuth flows examples (PKCE, service-to-service)

Rules:
- Never commit client secrets
- Prefer PKCE for public clients
- Rotate secrets and document rotation procedure