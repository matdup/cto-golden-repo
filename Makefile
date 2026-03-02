.PHONY: help dev lint test build infra plan apply destroy docs

help:
	@echo "make dev        - run local compose"
	@echo "make lint       - lint all projects"
	@echo "make test       - run all tests"
	@echo "make build      - build apps"
	@echo "make infra-plan - terraform plan"
	@echo "make infra-apply- terraform apply"
	@echo "make docs       - build docs"

dev:
	docker compose -f infrastructure/docker-compose.yml up --build

lint:
	npm run lint --workspaces || true

test:
	npm run test --workspaces || true

infra-plan:
	cd infrastructure/terraform && terraform plan

infra-apply:
	cd infrastructure/terraform && terraform apply

docs:
	mkdocs serve