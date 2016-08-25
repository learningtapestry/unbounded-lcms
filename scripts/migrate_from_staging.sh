#!/bin/bash

#
# This script does two things:
#   1. Restore the unboundED database from staging into production.
#   2. Copies user-submitted application files from staging to production.
#
# It is designed to minimize application down time:
#
# The database is restored into a temp database, and once it is working,
# it switches places with the production database.
#
# Same thing applies to files.
#

CWD=$(pwd)

cd ~

# Backup the current database.

echo "-> Backing up current database."

BACKUP_FOLDER=database_backups/`date +%Y_%m_%d`
BACKUP_NAME=unbounded_`date +%s`.dump
BACKUP_PATH=$BACKUP_FOLDER/$BACKUP_NAME

mkdir -p $BACKUP_FOLDER

PGPASSWORD=$POSTGRESQL_PASSWORD pg_dump \
    -h $POSTGRESQL_ADDRESS \
    -U $POSTGRESQL_USERNAME \
    --no-owner \
    --no-acl \
    -n public \
    -F c \
    $POSTGRESQL_DATABASE \
    > $BACKUP_PATH

echo "-> Backup created in $BACKUP_PATH."

# Migrate the database.

echo "-> Migrating database."

# Dump the staging database.

echo "(1) Dumping the staging database."

PGPASSWORD=$POSTGRESQL_PASSWORD_STAGING pg_dump \
    -h $POSTGRESQL_ADDRESS_STAGING \
    -U $POSTGRESQL_USERNAME_STAGING \
    --no-owner \
    --no-acl \
    -n public \
    -F c \
    $POSTGRESQL_DATABASE_STAGING \
    > staging_dump.dump

# Create a temporary database.

echo "(2) Creating temporary database."

PGPASSWORD=$POSTGRESQL_PASSWORD psql \
    -h $POSTGRESQL_ADDRESS \
    -U $POSTGRESQL_USERNAME \
    postgres \
    -c "CREATE DATABASE ${POSTGRESQL_DATABASE}_restore OWNER ${POSTGRESQL_USERNAME}"

# Restore the staging database.

echo "(3) Restoring staging in temporary database."

PGPASSWORD=$POSTGRESQL_PASSWORD pg_restore \
    -h $POSTGRESQL_ADDRESS \
    -U $POSTGRESQL_USERNAME \
    --no-owner \
    --no-acl \
    -n public \
    -d "${POSTGRESQL_DATABASE}_restore" \
    staging_dump.dump

# Kill all connections, switch the databases, clean up.

echo "(4) Switching databases and cleaning up."

PGPASSWORD=$POSTGRESQL_PASSWORD psql \
    -h $POSTGRESQL_ADDRESS \
    -U $POSTGRESQL_USERNAME \
    postgres <<EOF
BEGIN;

SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = '$POSTGRESQL_DATABASE'
  AND pid <> pg_backend_pid();

ALTER DATABASE $POSTGRESQL_DATABASE RENAME TO ${POSTGRESQL_DATABASE}_old;

ALTER DATABASE ${POSTGRESQL_DATABASE}_restore RENAME TO $POSTGRESQL_DATABASE;

COMMIT;

DROP DATABASE ${POSTGRESQL_DATABASE}_old;
EOF

rm staging_dump.dump

cd $CWD

echo "-> Done."
