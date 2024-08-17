#!/bin/sh

set -e

echo "run db migration"

cat /app/app.env

. /app/app.env

echo "DB_SOURCE is set to: $DB_SOURCE"

source /app/app.env

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
