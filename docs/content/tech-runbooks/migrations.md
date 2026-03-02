# Migrations

## Goal
Apply database migrations safely.

## Principles
- Prefer backward-compatible migrations when possible
- Do not ship destructive migrations without a tested rollback plan
- Always take a backup before risky migrations

## Steps
1. Backup:
```bash
bash scripts/backup-database.sh --out ./backups --name appdb
```
2.	Run migrations:
```bash
bash scripts/db-migrate.sh --node
# or
bash scripts/db-migrate.sh --sql --dir path/to/migrations
```

## Verification
- service health ok
- key queries succeed
- no error spikes

## Rollback

If migration is reversible, follow rollback plan.
If not, restore backup (destructive, requires confirmation):
```bash
bash scripts/restore-database.sh --file ./backups/appdb_<ts>.dump --yes
```