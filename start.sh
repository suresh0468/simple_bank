#!/bin/sh
set -e

set -a
source /app/app.env
set +a

echo "run db migration"
/app/migrate -path /app/db/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
