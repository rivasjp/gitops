#!/bin/bash
set -euo pipefail

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname "$POSTGRES_DB" <<EOSQL
CREATE ROLE ledger_migrator LOGIN PASSWORD '${LEDGER_MIGRATOR_PASSWORD}';
CREATE ROLE ledger_app      LOGIN PASSWORD '${LEDGER_APP_PASSWORD}';

REVOKE ALL ON DATABASE ledger FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT CONNECT ON DATABASE ledger TO ledger_migrator, ledger_app;

CREATE SCHEMA ledger AUTHORIZATION ledger_migrator;
GRANT USAGE ON SCHEMA ledger TO ledger_app;

ALTER ROLE ledger_migrator IN DATABASE ledger SET search_path = ledger, public;
ALTER ROLE ledger_app      IN DATABASE ledger SET search_path = ledger, public;

ALTER DEFAULT PRIVILEGES FOR ROLE ledger_migrator IN SCHEMA ledger
  GRANT SELECT, INSERT ON TABLES TO ledger_app;

ALTER DEFAULT PRIVILEGES FOR ROLE ledger_migrator IN SCHEMA ledger
  GRANT USAGE, SELECT ON SEQUENCES TO ledger_app;
EOSQL
