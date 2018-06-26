#!/bin/bash
set -e
echo Load Variables
cp .env.template .env
source .env
echo Restore DB
until echo '\q' | pg_isready --host $POSTGRESQL_ADDRESS --port $POSTGRESQL_PORT --username $POSTGRESQL_USERNAME --dbname $POSTGRESQL_DATABASE; do
	>&2 echo echo "Postgres is unavailable - sleeping"
	sleep 5
done
cp db/dump/content.dump.freeze db/dump/content.dump
psql postgresql://$POSTGRESQL_USERNAME:$POSTGRESQL_PASSWORD@$POSTGRESQL_ADDRESS/template1 << EOF
       CREATE EXTENSION IF NOT EXISTS hstore;
EOF
bundle exec rake db:restore --verbose
bundle exec rake db:migrate --verbose
echo Preload es
bundle exec rake es:load --verbose
echo Precompile Assets
bundle exec rake assets:precompile --verbose
echo Start Server
rails server -b 0.0.0.0 
