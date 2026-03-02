# Frontend (Next.js)

Production-ready Next.js App Router frontend for the Golden Repo.

## Goals
- Fast MVP delivery with safe defaults
- Strict environment-driven configuration
- i18n-ready by design (en/fr)
- CI/CD-friendly (lint, build, e2e smoke)

## Requirements
- Node.js >= 20
- npm (lockfile committed)
- Optional for e2e: Playwright browsers (`npx playwright install --with-deps`)

## Environment
Copy the example file:
```bash
cp -n .env.example .env.local || true
```

## Public environment variables
NEXT_PUBLIC_API_URL — backend base URL (e.g. http://localhost:8080)
NEXT_PUBLIC_APP_NAME — display name (e.g. TechFactory)
NEXT_PUBLIC_ENVIRONMENT — development|staging|production
NEXT_PUBLIC_DEMO_MODE — true|false (optional)

## Local development
```bash
npm ci
npm run dev
# http://localhost:3000
```

## Health endpoint
- GET /api/health returns { "status": "ok" } (no-cache)

## Build
npm run build
npm run start

## Docker
```bash
docker build -t frontend:local .
docker run --rm -p 3000:3000 \
  -e NEXT_PUBLIC_API_URL="http://localhost:8080" \
  -e NEXT_PUBLIC_APP_NAME="TechFactory" \
  -e NEXT_PUBLIC_ENVIRONMENT="development" \
  frontend:local
```

## E2E smoke test (Playwright)
```bash
cd e2e
npm ci
npx playwright install --with-deps
npx playwright test
```

## Structure conventions
- app/ — App Router entrypoints (layout/page/global styles)
- src/config/flags.ts — feature flags (env first)
- src/modules/ — optional domain-oriented UI modules
- i18n/ — locale configuration and dictionaries
- src/pages/api/health/route.ts — health endpoint

## Security notes
- No secrets in frontend. Only NEXT_PUBLIC_* variables are allowed here.
- Use GitHub Secrets for CI/CD and inject env at deploy time.

## License

Proprietary / internal usage only.