#!/usr/bin/env bash

# Disable "Shellcheck" checks until workaround will be found
# https://github.com/koalaman/shellcheck/issues/1119

# checking shell scripts
# shellcheck disable=SC2044
#for file in $(find . -name "*.sh"); do
#  if [[ "${file}" != *node_modules* ]]; then
#    if ! shellcheck "${file}"; then
#      exit 1
#    fi
#  fi
#done

# Checking gems for vulnerabilities
bundler audit check --update

# Checking Security with Brakeman
brakeman -zqA --summary --no-pager

# Setup environment
echo -e 'APPLICATION_DOMAIN=example.org' > .env
cp .codeship/database.yml config/database.yml


# Restore pre-filled database
cp db/dump/content.dump.freeze db/dump/content.dump

# Pg 9.6 is running on that port
psql -p 5436 -d template1 -c 'CREATE EXTENSION IF NOT EXISTS hstore;'

RAILS_ENV="test" bundle exec rake db:restore
RAILS_ENV="test" bundle exec rake db:migrate

# Generate translations file
bundle exec rake i18n:js:export

# Installing fresh PhantomJS
curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/phantomjs.sh | bash -s

# Precompiles assets for faster tests
RAILS_ENV="test" bundle exec rake assets:precompile
