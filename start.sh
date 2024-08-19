#!/bin/sh

set -e

echo "add env data"

. /app/app.env

echo "run db migration"

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
