#!/bin/bash
set -e
echo Load Variables
cp .env.template .env
source .env
echo Restore DB
pg_isready --host $POSTGRESQL_ADDRESS --port $POSTGRESQL_PORT --username $POSTGRESQL_USERNAME --dbname $POSTGRESQL_DATABASE
cp db/dump/content.dump.freeze db/dump/content.dump
bundle exec rake db:restore --verbose
bundle exec rake db:migrate --verbose
echo Preload es
bundle exec rake es:load --verbose
echo  Precompile Assets
bundle exec rake assets:precompile --verbose
echo Start Server
rails server -b 0.0.0.0 
